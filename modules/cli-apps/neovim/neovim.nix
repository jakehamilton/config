inputs@{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.cli-apps.neovim;
  vimConfig = import ./vim inputs;
  luaConfig = import ./lua inputs;

  icon-picker = pkgs.vimUtils.buildNeovimPluginFrom2Nix {
    pname = "icon-picker.nvim";
    version = "2022-09-03";
    src = pkgs.fetchFromGitHub {
      owner = "ziontee113";
      repo = "icon-picker.nvim";
      rev = "0f3b2648f6f8e788bc8dfe37bc9bb18b565cfc3c";
      sha256 = "15zygdg8g8jf1n75nclrbddvp9fz8k4jiczv0amgc7x1dy46cbvy";
    };
  };
in
{
  options.plusultra.cli-apps.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      page
    ];

    environment.variables = {
      PAGER = "page";
      MANPAGER =
        "page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    plusultra.home = {
      configFile = {
        "dashboard-nvim/.keep".text = "";
      };

      extraOptions = {
        programs.neovim = {
          enable = true;
          package = pkgs.neovim-unwrapped;

          # Use Neovim as a replacement for Vi, Vim, and Vimdiff.
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;

          # Enable ecosystem plugins.
          withNodeJs = true;
          withPython3 = true;
          withRuby = true;

          extraPackages = with pkgs; [
            # Grammar
            tree-sitter

            # Language Servers
            sqls
            gopls
            rnix-lsp
            rust-analyzer
            sumneko-lua-language-server

            # Language Server Dependencies
            nodePackages.pyright
            nodePackages.tailwindcss

            # Formatters
            nixfmt
            rustfmt
            nodePackages.prettier

            # Utility
            ripgrep

            # Misc
            lua5_1
          ];

          extraLuaPackages = with pkgs.lua51Packages; [
            plenary-nvim
            gitsigns-nvim
          ];

          plugins = with pkgs.vimPlugins; [
            # Icons
            nvim-web-devicons

            # Syntax
            vim-nix
            nvim-ts-rainbow
            (nvim-treesitter.withPlugins
              (plugins: pkgs.tree-sitter.allGrammars))

            # Utility
            plenary-nvim
            vim-bufkill
            lua-dev-nvim
            dressing-nvim

            # Telescope
            telescope-nvim
            telescope-symbols-nvim
            telescope-project-nvim

            # Language Server
            nvim-lspconfig
            lsp-colors-nvim
            nvim-jdtls
            trouble-nvim

            # Autocomplete
            nvim-cmp
            cmp-nvim-lsp

            # Snippets
            luasnip
            cmp_luasnip

            # Direnv
            direnv-vim

            # Text Manipulation
            vim-repeat
            vim-surround
            vim-commentary

            # Movement
            hop-nvim
            neoscroll-nvim

            # File Browser
            nvim-tree-lua

            # Editor Configuration
            editorconfig-nvim

            # Highlighting & View Augmentation
            vim-illuminate
            todo-comments-nvim
            delimitMate
            twilight-nvim

            # Theme
            nord-nvim

            # Status Line & Buffer Line
            lualine-nvim
            lualine-lsp-progress
            bufferline-nvim

            # Termianl
            toggleterm-nvim

            # Git
            gitsigns-nvim
            # vim-gitgutter
            # vim-fugitive
            # git-messenger-vim

            # Which Key
            which-key-nvim

            # Dashboard
            dashboard-nvim

            # Markdown
            markdown-preview-nvim
            vim-markdown
            vim-markdown-toc

            # Tmux
            vim-tmux-navigator

            # Icon Picker
            icon-picker
          ];

          extraConfig =
            ''
              lua <<EOF
                -- Allow imports from common locations for some packages.
                -- This is required for things like sumneko_lua to work.
                local runtime_path = vim.split(package.path, ";")
                table.insert(runtime_path, "lua/?.lua")
                table.insert(runtime_path, "lua/?/init.lua")
              EOF

              " Custom VIML Config.
              ${vimConfig}

              " Custom Lua Config.
              ${luaConfig}
            '';
        };
      };
    };
  };
}
