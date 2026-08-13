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
--
-- When no note declares the text, we fall back to searching the vault for a
-- `# <text>` heading: the section exists, it just was never registered as an
-- alias. The link is anchored to that heading and the text is appended to the
-- note's frontmatter aliases, so the next lookup takes the fast path above.

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

-- === Heading fallback: notes that only *document* the text =================

-- Every note holding a `# <query>` heading (at any level), keyed by file: the
-- anchor Obsidian resolves is the heading text, so a second identical heading in
-- the same note would produce the very same link.
local function find_notes_with_heading(query)
	local wanted = query:lower()
	local matches, seen = {}, {}

	local function record(path, lnum, heading)
		if seen[path] then
			return
		end
		seen[path] = true
		local note = read_frontmatter(path)
		matches[#matches + 1] = {
			id = (note and note.id) or vim.fn.fnamemodify(path, ":t:r"),
			path = path,
			rel = (path:gsub("^" .. vim.pesc(vault_root) .. "/", "")),
			lnum = lnum,
			anchor = heading,
		}
	end

	if vim.fn.executable("rg") == 0 then
		for _, path in ipairs(vim.fn.globpath(vault_root, "**/*.md", false, true)) do
			for lnum, line in ipairs(vim.fn.readfile(path)) do
				local heading = line:match("^#+%s*(.-)%s*$")
				if heading and heading:lower() == wanted then
					record(path, lnum, heading)
					break
				end
			end
		end
	else
		local out = vim.fn.systemlist({
			"rg",
			"--ignore-case",
			"--line-number",
			"--no-heading",
			"--with-filename",
			"--glob",
			"*.md",
			"--glob",
			"!.obsidian/**",
			"-e",
			"^#+\\s*" .. escape_regex(query) .. "\\s*$",
			vault_root,
		})
		if vim.v.shell_error > 1 then
			vim.notify("ripgrep failed while searching the vault", vim.log.levels.ERROR)
			return {}
		end
		for _, hit in ipairs(out) do
			local path, lnum, text = hit:match("^(.-):(%d+):(.*)$")
			if path then
				local heading = text:match("^#+%s*(.-)%s*$")
				if heading then
					record(path, tonumber(lnum), heading)
				end
			end
		end
	end

	table.sort(matches, function(a, b)
		return a.rel < b.rel
	end)
	return matches
end

-- Render a string as a YAML scalar, quoting only when the plain form would be
-- ambiguous (leading `-`, a `:` separator, a `#` comment, ...).
local function yaml_scalar(value)
	if value:match("^[%w][%w%s_%-%.%(%)%+/]*$") and not value:match("%s$") then
		return value
	end
	local escaped = value:gsub("\\", "\\\\"):gsub('"', '\\"')
	return '"' .. escaped .. '"'
end

-- Index of the frontmatter's closing `---`, or nil when the note has none.
local function frontmatter_end(lines)
	if vim.trim(lines[1] or "") ~= "---" then
		return nil
	end
	for i = 2, #lines do
		local trimmed = vim.trim(lines[i])
		if trimmed == "---" or trimmed == "..." then
			return i
		end
	end
	return nil
end

-- Work out the smallest edit that appends `alias` to a note's frontmatter
-- aliases, without rewriting the rest of the file. Returns the replaced range as
-- 0-indexed `start, stop` (nvim_buf_set_lines semantics) plus the new lines, or
-- nil and a reason.
local function plan_alias_edit(lines, alias)
	local fm_end = frontmatter_end(lines)
	if not fm_end then
		return nil, "note has no YAML frontmatter"
	end

	-- Locate the `aliases:` key, its inline value, and the last entry of its
	-- block sequence (indented `- X` lines that follow it).
	local key_name, key_line, key_value, last_item, in_aliases = nil, nil, nil, nil, false
	local existing = {}
	for i = 2, fm_end - 1 do
		local key, value = lines[i]:match("^([%w_-]+):%s*(.-)%s*$")
		if key then
			in_aliases = key == "aliases" or key == "alias"
			if in_aliases then
				key_name, key_line, key_value, last_item = key, i, value, nil
			end
		elseif in_aliases then
			local item = lines[i]:match("^%s+-%s*(.-)%s*$")
			if item and item ~= "" then
				last_item = i
				existing[#existing + 1] = yaml_unquote(item)
			end
		end
	end

	if key_value then
		local flow = key_value:match("^%[(.*)%]$")
		if flow then
			existing = split_flow_seq(flow)
		elseif key_value ~= "" then
			existing = { yaml_unquote(key_value) }
		end
	end
	for _, item in ipairs(existing) do
		if item:lower() == alias:lower() then
			return nil, "alias already present"
		end
	end

	local scalar = yaml_scalar(alias)

	if not key_line then
		-- No aliases key at all: start one below `id:`, or at the top of the block.
		local at = 1
		for i = 2, fm_end - 1 do
			if lines[i]:match("^id:") then
				at = i
				break
			end
		end
		return at, at, { "aliases:", "  - " .. scalar }
	end

	local flow = key_value:match("^%[(.*)%]$")
	if flow then
		local body = vim.trim(flow)
		local joined = body == "" and scalar or (body .. ", " .. scalar)
		return key_line - 1, key_line, { key_name .. ": [" .. joined .. "]" }
	end

	if key_value ~= "" then
		-- Single inline value (`aliases: Foo`): expand it into a block sequence.
		local only = yaml_scalar(yaml_unquote(key_value))
		return key_line - 1, key_line, { key_name .. ":", "  - " .. only, "  - " .. scalar }
	end

	if last_item then
		local indent = lines[last_item]:match("^(%s*)")
		return last_item, last_item, { indent .. "- " .. scalar }
	end
	return key_line, key_line, { "  - " .. scalar }
end

-- The loaded buffer holding `path`, if the note is already open.
local function loaded_buf_for(path)
	local target = vim.fn.fnamemodify(path, ":p")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local name = vim.api.nvim_buf_get_name(buf)
			if name ~= "" and vim.fn.fnamemodify(name, ":p") == target then
				return buf
			end
		end
	end
	return nil
end

-- Register `alias` in the note's frontmatter so later lookups resolve it
-- directly. Edits the open buffer when the note is loaded (and saves it, unless
-- it already had unsaved changes) so the two copies cannot diverge.
local function add_alias_to_note(note, alias)
	local buf = loaded_buf_for(note.path)
	local lines = buf and vim.api.nvim_buf_get_lines(buf, 0, -1, false) or vim.fn.readfile(note.path)

	local start, stop, new_lines = plan_alias_edit(lines, alias)
	if not start then
		if stop ~= "alias already present" then
			vim.notify("Could not add alias to " .. note.rel .. ": " .. stop, vim.log.levels.WARN)
		end
		return
	end

	if buf then
		local dirty = vim.bo[buf].modified
		vim.api.nvim_buf_set_lines(buf, start, stop, false, new_lines)
		if dirty then
			vim.notify("Added alias to the open (unsaved) " .. note.rel, vim.log.levels.INFO)
			return
		end
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent noautocmd write")
		end)
	else
		for _ = start + 1, stop do
			table.remove(lines, start + 1)
		end
		for i, line in ipairs(new_lines) do
			table.insert(lines, start + i, line)
		end
		if vim.fn.writefile(lines, note.path) ~= 0 then
			vim.notify("Failed to write " .. note.rel, vim.log.levels.ERROR)
			return
		end
	end
	vim.notify("Added alias '" .. alias .. "' to " .. note.rel, vim.log.levels.INFO)
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
-- while a picker was open. `note.anchor` overrides the anchor text, so a heading
-- match keeps the heading's own casing. Returns true when the line was rewritten.
local function replace_link(bufnr, row, original_line, link, note)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	local current = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
	if current ~= original_line then
		vim.notify("Line changed since the link was picked; aborting", vim.log.levels.WARN)
		return false
	end

	local anchor = note.anchor or link.target
	local anchored = string.format("[[%s#%s|%s]]", note.id, anchor, link.display or link.target)
	local new_line = current:sub(1, link.start_col - 1) .. anchored .. current:sub(link.end_col + 1)
	vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, { new_line })
	vim.notify("Linked to " .. note.rel, vim.log.levels.INFO)
	return true
end

-- Telescope list of the candidate notes, so a link like `[[JSON]]` (declared by
-- two notes) can be pointed at the right one. Heading matches carry a line
-- number, which the preview jumps to. Falls back to vim.ui.select when Telescope
-- is not loaded.
local function pick_note(title, matches, on_choice)
	local located = matches[1] ~= nil and matches[1].lnum ~= nil

	local ok, pickers = pcall(require, "telescope.pickers")
	if not ok then
		vim.ui.select(matches, {
			prompt = title,
			format_item = function(item)
				return item.id .. "  " .. item.rel .. (item.lnum and (":" .. item.lnum) or "")
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
			prompt_title = title,
			finder = finders.new_table({
				results = matches,
				entry_maker = function(entry)
					return {
						value = entry,
						display = string.format(
							"%-40s %s",
							entry.id,
							entry.rel .. (entry.lnum and (":" .. entry.lnum) or "")
						),
						ordinal = entry.id .. " " .. entry.rel,
						path = entry.path,
						lnum = entry.lnum,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = located and previewers.vim_buffer_vimgrep.new({}) or previewers.vim_buffer_cat.new({}),
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

	local bufnr = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local original_line = vim.api.nvim_get_current_line()

	local matches = find_notes_declaring(link.target)
	if #matches > 0 then
		if #matches == 1 then
			replace_link(bufnr, row, original_line, link, matches[1])
		else
			pick_note("Notes declaring " .. link.target, matches, function(note)
				replace_link(bufnr, row, original_line, link, note)
			end)
		end
		return
	end

	-- Nothing declares it: fall back to the notes that merely have a section
	-- about it, and promote that heading to an alias on the way out.
	local headings = find_notes_with_heading(link.target)
	if #headings == 0 then
		vim.notify(
			"No note declares '" .. link.target .. "' as an id or alias, nor has a '# " .. link.target .. "' heading",
			vim.log.levels.WARN
		)
		return
	end

	local function anchor_and_register(note)
		if replace_link(bufnr, row, original_line, link, note) then
			add_alias_to_note(note, note.anchor)
		end
	end

	if #headings == 1 then
		anchor_and_register(headings[1])
		return
	end

	pick_note("Notes with a '# " .. link.target .. "' heading", headings, anchor_and_register)
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
			-- pointing at whichever note declares that text as an id or alias --
			-- or, failing that, at the note whose `# <text>` heading covers it,
			-- adding the text to that note's aliases.
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
