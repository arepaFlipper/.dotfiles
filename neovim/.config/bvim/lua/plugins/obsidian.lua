vim.api.nvim_set_keymap("n", "<leader>odl", "<CMD>ObsidianToday<CR>", { noremap = true })

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
