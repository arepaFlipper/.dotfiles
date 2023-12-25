# Neorg - An organized Future

Neorg (Neo- new, org- organization) is a Neovim plugin designed to reimagine organization as you know it.
Grab some coffee, start writhing some notes, let your editor handle the rest.

## What is Neorg?
Neorg is an all-encompassing tool based around structured note taking, project and task management, time
tracking, slideshows, writing typeset documents and much more. The premise is that all of these features are
built on top of a simple base file format (`*.norg`), which the user only has to learn once to gain access to all of
Neorg's functionality.

Not only does this yield a low barrier for entry for new users it also ensures that all features are integrated
with each other and speak the same underlying language. The file format is built to be expressive and easy to
parse, which also makes `*.norg` files easily usable anywhere outside of Neorg itself.

**NOTE:** Neorg is young software. We consider it stable however be prepared for occasional breaking workflow
changes. Make sure to pin the version of Neorg you'd like to use and only update when you are ready.
## Using Neorg
Neorg depends on a number of other technologies, all of which have to be correctly configured to keep Neorg running
smoothly. For some help on understanding how your terminal, Neovim, color-schemes*fixtypo* tree-sitter and more come
together to produce your Neorg experience ( Neorg problems).

At first configuring Neorg might be rather scary. I have to define what modules I want to use in the
`require("neorg").setup()` function? Don't worry an installation guide is here

## Installation/Quickstart
**Neorg requires at least Neovim 0.8+ to operate.**

### TL;DR
For Neovim beginners who don't want to tinker with the configurations:
1. Install [Meslo Nerd Font](https://github.com/ryanoasis/nerd-fonts/)
2. Set your terminal font to "MesloLGM Nerd Font Mono".
3. Make sure you have git by running `git --version`.
4. Paste the sample `init.lua` below to `~/.config/nvim/init.lua`.
5. Start taking notes by `nvim test.norg`.

<details>
  <summary>sample `init.lua`</summary>

  ```lua
  -- adapted from https://github.com/folke/lazy.nvim#-installation
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    print(vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath}))
  end
  vim.opt.rtp:prepend(lazypath)

  vim.g.mapleader = " "

  require("lazy").setup({
    "repelot/kanagawa.nvim",
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      opts = { highlight = { enable = true }},
      config = function(_,opts)
        require("nvim-treesitter.configs").setup(opts)
      end,
    },
    {
      "nvim-neorg/neorg",
      build = ":Neorg sync-parsers",
      dependencies = {"nvim-lua/plenary.nvim"},
      config = function()
        require("neorg").setup {
          load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
            ["core.dirman"] = {
              config = {
                workspaces = {
                  notes = "~/notes",
                },
                default_workspace = "notes",
              }
            }
          }
        }
        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
      end
    }
  })

  vim.cmd.colorscheme('kanagawa')
  ```
</details>

## Installation
You can install it through your favorite plugin manager:

<details>
  <summary>[lazy.nvim](https://github.com/folke/lazy.nvim)</summary>

  ```lua
  -- paste into `~/.config/LazyVim/lua/plugins/neorg.lua`
  return {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim"},
    config= function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {}, -- Adds pretty icons to your files
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
              }
            }
          }
        }
      }
    end,
  }
  ```
</details>

### Treesitter
_Be sure to have `nvim-treesitter` installed on your system for this step_
Neorg will automatically attempt to install the parsers for you upon entering a `.norg` file if you have 
`core.defaaults`  loaded. A command is also exposed to reinstall and/or update these parsers: `:Neorg sync-parsers`.

It is important to note that installation via this command isn't reproducible, There are a few ways to make it
reproducible, but the recommended way is to set up an **update flag** for your plugin manager of choice. In
packer, your configuration may look something like this:
```lua
use {
  "nvim-neorg/neorg",
  run = ":Neorg sync-parsers", -- This is the important hit!
  config = function()
    require("neorg").setup {
      -- configuration here
    }
  end,
}
```

With the above `run` key set, every time you update Neorg the internal parsers will also be updated to the
correct revision.

## Setup
You've got the basic stuff out the way now, but wait! That's not all, You've installed Neorg - great! Now you
have to configure it. By default, Neorg does nothing, and gives you nothing. You must tell it what you care about!

### Default modules
Neorg runs on modules, which are discussed and explained in more depth later on. Each module provides a
single bit of functionality - they can then be stacked together to form the entire Neorg environment.

The most common module you'll find is the `core.defaults` module, which is basically a "load all features"
switch. It gives you the full experience out of the box.

The code snippet to enable all defailt modules is very straightforward:

```lua
require('neorg').setup {
  load = {
    ["core.defaults"] = {}
  }
}
```

### Usage
A new and official specification is in the works, we recommend reading it. 

* [ ] Install taskswiki:  #27b88518
  * [ ] hello  #fbf58ebb
