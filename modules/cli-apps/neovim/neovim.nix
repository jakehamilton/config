{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.cli-apps.neovim;
  vimlFiles = [ ./init.vim ];
  luaFiles = [ ./lua/theme.lua ./lua/lualine.lua ./lua/twilight.lua ];
in {
  options.plusultra.cli-apps.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ page ];
    environment.variables = {
      PAGER = "page";
      MANPAGER =
        "page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p|set ft=man'";
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    plusultra.home.extraOptions = {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = true;

        extraPackages = with pkgs; [
          tree-sitter
          nodePackages.typescript
          nodePackages.typescript-language-server
          nodePackages.pyright
          gopls
          rust-analyzer
          nixfmt
        ];

        plugins = with pkgs.vimPlugins; [
          vim-polyglot
          nvim-lspconfig
          nvim-treesitter

          telescope-nvim
          telescope-symbols-nvim
          telescope-project-nvim

          # nerdtree
          nvim-tree-lua
          vim-devicons
          vim-nerdtree-syntax-highlight

          nord-nvim
          lualine-nvim
          lualine-lsp-progress
          bufferline-nvim

          delimitMate
          nvim-ts-rainbow
          nvim-whichkey-setup-lua

          vim-nix

          twilight-nvim
          trouble-nvim

          vim-gitgutter
          vim-fugitive
          git-messenger-vim
          gitsigns-nvim

          vim-easymotion
          vim-surround
        ];

        extraConfig = let
          vimlConfig = builtins.map lib.strings.fileContents vimlFiles;
          luaConfig = builtins.map lib.strings.fileContents luaFiles;
          viml = builtins.concatStringsSep "\n" vimlConfig;
          lua = ''
            lua << EOF
            ${builtins.concatStringsSep "\n" luaConfig}
            EOF
          '';
        in ''
          " Custom VIML Config.
          ${viml}

          " Custom Lua Config.
          ${lua}
        '';
      };
    };
  };
}
