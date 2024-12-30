local ls = require("luasnip")
local s = ls.s
local t = ls.t

local d = ls.dynamic_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Python Snippets", { clear = true })
local file_pattern = "*.py"

local function cs(trigger, nodes, opts) --{{{
	local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}

	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end

		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end

		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(keymaps) do
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end

	table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

-- Start Refactoring --

cs(
	"pdb",
	fmt(
		[[
  __import__('pdb').set_trace() ##DELETEME:
]],
		{}
	)
)

local print_fmt_str = [[
    print("""{1} {2}:""") ## DELETEME:
    print({3}) ## DELETEME:
    print('\x1b[0m') ## DELETEME:
    ]]

local black_red = "ptba_r"
local black_green = "ptba_gre"
local black_yellow = "ptba_y"
local black_purple = "ptba_pu"
local black_cyan = "ptba_cy"
local black_white = "ptba_wh"
local white_red = "ptwh_r"
local white_green = "ptwh_gre"
local white_blue = "ptwh_bu"
local white_purple = "ptwh_pu"
local white_cyan = "ptwh_cy"
local red_black = "ptr"
local green_black = "ptgre"
local yellow_black = "pty"
local blue_black = "ptbu"
local purple_black = "ptpu"
local cyan_black = "ptcy"
local gray_black = "ptgray"
local cyan_red = "ptcy_red"
function Table_of_nodes(trig)
	local styles_code = "  \\x1b[1;32;40m"
	if trig == black_red then
		styles_code = "  \\x1b[1;30;41m"
	end
	if trig == black_green then
		styles_code = "  \\x1b[1;30;42m"
	end
	if trig == black_yellow then
		styles_code = "  \\x1b[1;30;43m"
	end
	if trig == black_purple then
		styles_code = "  \\x1b[1;30;45m"
	end
	if trig == black_cyan then
		styles_code = "  \\x1b[1;30;46m"
	end
	if trig == black_white then
		styles_code = "  \\x1b[1;30;47m"
	end
	if trig == white_red then
		styles_code = "  \\x1b[1;37;41m"
	end
	if trig == white_green then
		styles_code = "  \\x1b[1;37;42m"
	end
	if trig == white_blue then
		styles_code = "  \\x1b[1;37;44m"
	end
	if trig == white_purple then
		styles_code = "  \\x1b[1;37;45m"
	end
	if trig == white_cyan then
		styles_code = "  \\x1b[1;37;46m"
	end
	if trig == red_black then
		styles_code = "  \\x1b[1;31;40m"
	end
	if trig == green_black then
		styles_code = "  \\x1b[1;32;40m"
	end
	if trig == yellow_black then
		styles_code = "  \\x1b[1;33;40m"
	end
	if trig == blue_black then
		styles_code = "  \\x1b[1;34;40m"
	end
	if trig == purple_black then
		styles_code = "  \\x1b[1;35;40m"
	end
	if trig == cyan_black then
		styles_code = "  \\x1b[1;36;40m"
	end
	if trig == gray_black then
		styles_code = "  \\x1b[1;37;40m"
	end
	if trig == cyan_red then
		styles_code = "  \\x1b[1;31;46m"
	end
	return {
		d(1, function()
      local emojis_path = vim.fn.expand("~/.dotfiles/neovim/.config/snippets_lua/emojis.lua")
      local M = dofile(emojis_path)
      local Emojis = M.Emojis
			local emoji_selected = Emojis[math.random(#Emojis)]
			emoji_selected = sn(1, t(emoji_selected))
			return sn(1, emoji_selected)
		end),
		d(2, function(_, snip)
			local v = snip.env
			local my_clipboard = vim.fn.getreg('"', 1, true)[1]
			my_clipboard:gsub("%$", "")
			if string.match(my_clipboard, "'") then
				my_clipboard = my_clipboard:gsub("%'", "")
			end
			if string.match(my_clipboard, '"') then
				my_clipboard = my_clipboard:gsub('%"', "")
			end
			if string.match(my_clipboard, "`") then
				my_clipboard = my_clipboard:gsub("%`", "")
			end
			local ms = styles_code .. v.TM_FILENAME .. ":" .. v.TM_LINE_NUMBER .. "\t"
			ms = ms .. my_clipboard
			return sn(1, t(ms))
			-- return sn(1, t("world"))
		end),
		d(3, function()
			local my_clipboard = vim.fn.getreg('"', 1, true)[1]
			return sn(1, t(my_clipboard))
		end),
	}
end

-- fontColor_backgroundColor

cs({ trig = black_red }, fmt(print_fmt_str, Table_of_nodes(black_red)))
cs({ trig = black_green }, fmt(print_fmt_str, Table_of_nodes(black_green)))
cs({ trig = black_yellow }, fmt(print_fmt_str, Table_of_nodes(black_yellow)))
cs({ trig = black_purple }, fmt(print_fmt_str, Table_of_nodes(black_purple)))
cs({ trig = black_cyan }, fmt(print_fmt_str, Table_of_nodes(black_cyan)))
cs({ trig = black_white }, fmt(print_fmt_str, Table_of_nodes(black_white)))
cs({ trig = white_red }, fmt(print_fmt_str, Table_of_nodes(white_red)))
cs({ trig = white_green }, fmt(print_fmt_str, Table_of_nodes(white_green)))
cs({ trig = white_blue }, fmt(print_fmt_str, Table_of_nodes(white_blue)))
cs({ trig = white_purple }, fmt(print_fmt_str, Table_of_nodes(white_purple)))
cs({ trig = white_cyan }, fmt(print_fmt_str, Table_of_nodes(white_cyan)))
cs({ trig = red_black }, fmt(print_fmt_str, Table_of_nodes(red_black)))
cs({ trig = green_black }, fmt(print_fmt_str, Table_of_nodes(green_black)))
cs({ trig = yellow_black }, fmt(print_fmt_str, Table_of_nodes(yellow_black)))
cs({ trig = blue_black }, fmt(print_fmt_str, Table_of_nodes(blue_black)))
cs({ trig = purple_black }, fmt(print_fmt_str, Table_of_nodes(purple_black)))
cs({ trig = cyan_black }, fmt(print_fmt_str, Table_of_nodes(cyan_black)))
cs({ trig = gray_black }, fmt(print_fmt_str, Table_of_nodes(gray_black)))
cs({ trig = cyan_red }, fmt(print_fmt_str, Table_of_nodes(cyan_red)))
-- End Refactoring --

return snippets, autosnippets
