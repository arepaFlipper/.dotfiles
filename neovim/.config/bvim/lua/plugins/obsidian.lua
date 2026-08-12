vim.api.nvim_set_keymap("n", "<leader>odl", "<CMD>ObsidianToday<CR>", { noremap = true })

local vault_root = vim.fn.expand("~/sync_repo/brain")

-- Open the current note in Obsidian at the line the cursor is on, in the given
-- view mode. Requires the "Advanced URI" community plugin, which supports the
-- `line` parameter; the plain `obsidian://open` URI (used by :ObsidianOpen)
-- cannot jump to a line.
--
-- `viewmode` should be one of:
--   "live"    -- Live Preview: rendered markdown that reliably lands on the exact
--                line (Advanced URI's `line` navigation drives `editor.setCursor`,
--                which needs a real editor). The cursor is editable.
--   "preview" -- Reading view: read-only, but the exact line jump is unreliable,
--                since the reading pane has no editor cursor and restores its own
--                remembered scroll position.
local function open_in_obsidian(viewmode)
	local vault_name = "brain"
	local vault_path = vim.fn.expand("~/sync_repo/brain")
	local filepath = vim.fn.expand("%:p")
	local line = vim.api.nvim_win_get_cursor(0)[1]

	if filepath:sub(1, #vault_path) == vault_path then
		local rel = filepath:sub(#vault_path + 2)
		local uri = string.format(
			"obsidian://advanced-uri?vault=%s&filepath=%s&viewmode=%s&line=%d",
			vim.uri_encode(vault_name),
			vim.uri_encode(rel),
			viewmode,
			line
		)
		vim.ui.open(uri)
	else
		-- Fall back for notes outside the configured vault.
		vim.cmd("ObsidianOpen")
	end
end

-- Close the currently active tab in Obsidian (built-in `workspace:close`
-- command). Used to drop a note's stale reading-view scroll position before
-- reopening it fresh.
local function close_active_obsidian_note()
	local vault_name = "brain"
	local uri = string.format(
		"obsidian://advanced-uri?vault=%s&commandid=%s",
		vim.uri_encode(vault_name),
		vim.uri_encode("workspace:close")
	)
	vim.ui.open(uri)
end

-- Open the current note in reading view on the cursor's line, working around the
-- fact that a reopened reading pane restores its own remembered scroll:
--   1. focus the note (source mode) so it's the active tab,
--   2. close it to discard any stale reading-view scroll position,
--   3. reopen fresh in source at the line,
--   4. switch to reading view -- with no stale position to restore, it stays put.
-- Each step is deferred so Obsidian finishes the previous one first; bump the
-- delays if it still misses on a cold open.
local function open_in_reading_on_line()
	close_active_obsidian_note()
	vim.defer_fn(function()
		open_in_obsidian("source")
		vim.defer_fn(function()
			open_in_obsidian("preview")
		end, 100)
	end, 100)
end

-- === Anchor a wiki link to the note that declares it =======================
--
-- `[[TCP]]` -> `[[tcp-ip-dns-nat-dhcp#TCP|TCP]]`
--
-- The vault keeps one note per topic and lists every sub-topic it covers as a
-- frontmatter alias, so a bare `[[TCP]]` resolves to the whole note instead of
-- the section about TCP. This rewrites the link to point at the `#TCP` anchor
-- inside the note that owns the alias, keeping `TCP` as the displayed text.

-- Strip surrounding YAML quotes and undo the escaping they imply.
local function yaml_unquote(value)
	value = vim.trim(value)
	local inner = value:match('^"(.*)"$')
	if inner then
		return (inner:gsub("\\(.)", "%1"))
	end
	inner = value:match("^'(.*)'$")
	if inner then
		return (inner:gsub("''", "'"))
	end
	return value
end

-- Split a YAML flow sequence body (`a, "b, c"`) on commas outside of quotes.
local function split_flow_seq(body)
	local items, buf, quote = {}, {}, nil
	local i = 1
	while i <= #body do
		local char = body:sub(i, i)
		if quote then
			if char == "\\" and quote == '"' then
				buf[#buf + 1] = body:sub(i, i + 1)
				i = i + 1
			else
				if char == quote then
					quote = nil
				end
				buf[#buf + 1] = char
			end
		elseif char == '"' or char == "'" then
			quote = char
			buf[#buf + 1] = char
		elseif char == "," then
			items[#items + 1] = table.concat(buf)
			buf = {}
		else
			buf[#buf + 1] = char
		end
		i = i + 1
	end
	items[#items + 1] = table.concat(buf)

	local out = {}
	for _, item in ipairs(items) do
		item = yaml_unquote(item)
		if item ~= "" then
			out[#out + 1] = item
		end
	end
	return out
end

-- Read the `id` and `aliases` of a note's YAML frontmatter. Returns nil when the
-- file has no frontmatter block at all. `aliases` is written either as a block
-- sequence (`aliases:` then `  - X` lines) or inline (`aliases: [X, Y]`).
local function read_frontmatter(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local first = file:read("*l")
	if first == nil or vim.trim(first) ~= "---" then
		file:close()
		return nil
	end

	local id, aliases, in_aliases = nil, {}, false
	for line in file:lines() do
		if vim.trim(line) == "---" or vim.trim(line) == "..." then
			break
		end
		-- Top-level keys are unindented, so anything indented while we are inside
		-- the `aliases:` key is one of its sequence entries.
		local key, value = line:match("^([%w_-]+):%s*(.-)%s*$")
		if key then
			in_aliases = false
			if key == "id" then
				id = yaml_unquote(value)
			elseif key == "aliases" or key == "alias" then
				local flow = value:match("^%[(.*)%]$")
				if flow then
					aliases = split_flow_seq(flow)
				elseif value ~= "" then
					aliases = { yaml_unquote(value) }
				else
					in_aliases = true
				end
			end
		elseif in_aliases then
			local item = line:match("^%s+-%s*(.-)%s*$")
			if item and item ~= "" then
				aliases[#aliases + 1] = yaml_unquote(item)
			end
		end
	end
	file:close()

	if id == "" then
		id = nil
	end
	return { id = id, aliases = aliases }
end

-- Escape a literal string for use inside a ripgrep (Rust regex) pattern.
local function escape_regex(text)
	return (text:gsub("[^%w%s_]", "\\%0"))
end

-- Cheap pre-filter: ask ripgrep for every note whose frontmatter *might* declare
-- `query`. Body bullets such as a plain `- TCP` slip through here on purpose;
-- read_frontmatter() is what decides whether a candidate really matches.
local function candidate_files(query)
	if vim.fn.executable("rg") == 0 then
		return vim.fn.globpath(vault_root, "**/*.md", false, true)
	end

	local pattern = escape_regex(query)
	local quoted = "['\"]?" .. pattern .. "['\"]?"
	local out = vim.fn.systemlist({
		"rg",
		"--ignore-case",
		"--files-with-matches",
		"--glob",
		"*.md",
		"--glob",
		"!.obsidian/**",
		"-e",
		"^\\s*-\\s*" .. quoted .. "\\s*$",
		"-e",
		"^id:\\s*" .. quoted .. "\\s*$",
		"-e",
		"^alias(es)?:\\s*\\[.*" .. pattern .. ".*\\]",
		vault_root,
	})
	if vim.v.shell_error > 1 then
		vim.notify("ripgrep failed while searching the vault", vim.log.levels.ERROR)
		return {}
	end
	return out
end

-- Every note whose frontmatter `id` or one of its aliases equals `query`
-- (case-insensitively). Notes without an explicit `id` fall back to the file stem.
local function find_notes_declaring(query)
	local wanted = query:lower()
	local matches = {}

	for _, path in ipairs(candidate_files(query)) do
		local note = read_frontmatter(path)
		if note then
			local hit = note.id ~= nil and note.id:lower() == wanted
			if not hit then
				for _, alias in ipairs(note.aliases) do
					if alias:lower() == wanted then
						hit = true
						break
					end
				end
			end
			if hit then
				matches[#matches + 1] = {
					id = note.id or vim.fn.fnamemodify(path, ":t:r"),
					path = path,
					rel = (path:gsub("^" .. vim.pesc(vault_root) .. "/", "")),
				}
			end
		end
	end

	table.sort(matches, function(a, b)
		return a.rel < b.rel
	end)
	return matches
end

-- Locate the `[[...]]` the cursor sits on, and take it apart into the link
-- target and the display text (`[[target|display]]`).
local function link_under_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1
	local init = 1

	while true do
		local s, e = line:find("%[%[.-%]%]", init)
		if not s then
			return nil
		end
		if col >= s and col <= e then
			local body = line:sub(s + 2, e - 2)
			local target, display = body:match("^(.-)|(.*)$")
			return {
				start_col = s,
				end_col = e,
				target = vim.trim(target or body),
				display = display and vim.trim(display) or nil,
			}
		end
		init = e + 1
	end
end

-- Swap the link for its anchored form, guarding against the line having changed
-- while a picker was open.
local function replace_link(bufnr, row, original_line, link, note)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end
	local current = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
	if current ~= original_line then
		vim.notify("Line changed since the link was picked; aborting", vim.log.levels.WARN)
		return
	end

	local anchored = string.format("[[%s#%s|%s]]", note.id, link.target, link.display or link.target)
	local new_line = current:sub(1, link.start_col - 1) .. anchored .. current:sub(link.end_col + 1)
	vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { new_line })
	vim.notify("Linked to " .. note.rel, vim.log.levels.INFO)
end

-- Telescope list of the notes that declare the alias, so a link like `[[JSON]]`
-- (declared by two notes) can be pointed at the right one. Falls back to
-- vim.ui.select when Telescope is not loaded.
local function pick_note(link, matches, on_choice)
	local ok, pickers = pcall(require, "telescope.pickers")
	if not ok then
		vim.ui.select(matches, {
			prompt = "Notes declaring " .. link.target,
			format_item = function(item)
				return item.id .. "  " .. item.rel
			end,
		}, function(choice)
			if choice then
				on_choice(choice)
			end
		end)
		return
	end

	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local previewers = require("telescope.previewers")

	pickers
		.new({}, {
			prompt_title = "Notes declaring " .. link.target,
			finder = finders.new_table({
				results = matches,
				entry_maker = function(entry)
					return {
						value = entry,
						display = string.format("%-40s %s", entry.id, entry.rel),
						ordinal = entry.id .. " " .. entry.rel,
						path = entry.path,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = previewers.vim_buffer_cat.new({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						on_choice(selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

local function anchor_link_under_cursor()
	local link = link_under_cursor()
	if not link then
		vim.notify("No [[link]] under the cursor", vim.log.levels.WARN)
		return
	end
	if link.target:find("#", 1, true) then
		vim.notify("Link is already anchored: " .. link.target, vim.log.levels.WARN)
		return
	end

	local matches = find_notes_declaring(link.target)
	if #matches == 0 then
		vim.notify("No note declares '" .. link.target .. "' as an id or alias", vim.log.levels.WARN)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local original_line = vim.api.nvim_get_current_line()

	if #matches == 1 then
		replace_link(bufnr, row, original_line, link, matches[1])
		return
	end

	pick_note(link, matches, function(note)
		replace_link(bufnr, row, original_line, link, note)
	end)
end

return {
	-- "obsidian-nvim/obsidian.nvim",
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- keys = { "<leader>m", "<leader>j", "<leader>s" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		workspaces = {
			{
				name = "general_vault",
				path = "~/sync_repo/brain",
			},
		},
		daily_notes = {
			folder = "2-Areas/Journalist/Daily",
			date_format = "V-%Y_%m_%d",
			alias_format = "%A, %dth %B, %Y",
			default_tags = { "daily-notes" },
			template = "Templates/Daily Template.md",
		},
		mappings = {
			["gd"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["gi"] = {
				action = function()
					vim.cmd("ObsidianBacklinks")
				end,
				opts = { buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			-- Reading view on the exact line: close the note first to clear its
			-- stale reading-view scroll, then reopen and switch to reading view.
			["<leader>oo"] = {
				action = function()
					open_in_reading_on_line()
				end,
				opts = { buffer = true },
			},
			-- Live Preview (editable). Reliably lands on the exact line.
			["<leader>oO"] = {
				action = function()
					open_in_obsidian("live")
				end,
				opts = { buffer = true },
			},
			-- Rewrite the [[link]] under the cursor as [[<note id>#<text>|<text>]],
			-- pointing at whichever note declares that text as an id or alias.
			["<leader>ol"] = {
				action = function()
					anchor_link_under_cursor()
				end,
				opts = { buffer = true },
			},
		},
		notes_subdir = "0-Inbox",
		new_notes_location = "notes_subdir",
		templates = {
			subdir = "Templates",
			date_format = "YYYY_MM_DD",
		},
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^a-zA-Z0-9-]", ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
	},
}
