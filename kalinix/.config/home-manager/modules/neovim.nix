{ config, pkgs, inputs, lib, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  
  nixvimConfig = {
    # Reduce closure size (optional)
    enableMan = false;
    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      # LazyVim
      lua-language-server
      stylua
      # Telescope
      ripgrep
    ];

    extraPlugins = [ pkgs.vimPlugins.lazy-nvim ];

    extraConfigLua =
      let
        plugins = with pkgs.vimPlugins; [
          # LazyVim
          LazyVim
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          grug-far-nvim
          indent-blankline-nvim
          lazydev-nvim
          lualine-nvim
          luvit-meta
          neo-tree-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-snippets
          nvim-treesitter
          nvim-treesitter-textobjects
          nvim-ts-autotag
          persistence-nvim
          plenary-nvim
          snacks-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          trouble-nvim
          ts-comments-nvim
          which-key-nvim
					catppuccin-nvim
          { name = "catppuccin"; path = catppuccin-nvim; }
          { name = "mini.ai"; path = mini-nvim; }
          { name = "mini.icons"; path = mini-nvim; }
          { name = "mini.pairs"; path = mini-nvim; }
        ];
        
        mkEntryFromDrv = drv:
          if lib.isDerivation drv then
            { name = "${lib.getName drv}"; path = drv; }
          else
            drv;
            
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "" },
            -- fallback to download
            fallback = true,
          },
          spec = {
            { 
              "LazyVim/LazyVim", 
              import = "lazyvim.plugins", 
              opts = {
                colorscheme = "catppuccin"
              },
            },
            -- The following configs are needed for fixing lazyvim on nix
            -- force enable telescope-fzf-native.nvim
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- disable mason.nvim, use config.extraPackages
            { "williamboman/mason-lspconfig.nvim", enabled = true },
            { "williamboman/mason.nvim", enabled = true },
            -- uncomment to import/override with your plugins
            -- { import = "plugins" },
            -- put this line at the end of spec to clear ensure_installed
            { "nvim-treesitter/nvim-treesitter",
              opts = function(_, opts) 
                opts.ensure_installed = {} 
              end 
            },
            {
              "nvim-neo-tree/neo-tree.nvim",
              opts = {
                window = {
                    position = "right"
                },
                filesystem = {
                  bind_to_cwd = false,
                  follow_current_file = {
                    enabled = true,
                  },
                  filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                  },
                },
              },
            },
          },
        })
      '';
  };

  # Create the nixvim neovim package
  nixvim-neovim = inputs.nixvim.legacyPackages.${system}.makeNixvim nixvimConfig;

in
{
  # Install the custom nixvim neovim
  home.packages = [
    nixvim-neovim
  ];

  # Optional: Set up shell aliases
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  # Optional: Set as default editor
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
