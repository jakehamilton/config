{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.cli-apps.neovim;
  vimFiles = getFilesRec ./vim;
  luaFiles = getFilesRec ./lua;
in {
  options.plusultra.cli-apps.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ page nodePackages.eslint ];
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

    plusultra.home.file.".npm-global/bin/eslint".source =
      "${pkgs.nodePackages.eslint}/bin/eslint";
    plusultra.home.file.".npm-global/lib/node_modules/eslint".source =
      "${pkgs.nodePackages.eslint}/lib/node_modules/eslint";

    plusultra.home.extraOptions = {
      programs.neovim = {
        enable = true;
        package = pkgs.neovim-unwrapped;

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
          nodePackages.vscode-langservers-extracted
          nodePackages.eslint
          gopls
          rust-analyzer
          nixfmt
          sumneko-lua-language-server
          lua5_2
          ripgrep
        ];

        plugins = with pkgs.vimPlugins; [
          direnv-vim
          editorconfig-nvim
          vim-polyglot
          nvim-lspconfig
          lsp-colors-nvim
          vim-illuminate
          (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))

          telescope-nvim
          telescope-symbols-nvim
          telescope-project-nvim

          # nerdtree
          nvim-tree-lua
          nvim-web-devicons
          vim-nerdtree-syntax-highlight

          nord-nvim
          lualine-nvim
          lualine-lsp-progress
          bufferline-nvim

          delimitMate
          nvim-ts-rainbow
          which-key-nvim

          vim-nix

          twilight-nvim
          trouble-nvim

          vim-gitgutter
          vim-fugitive
          git-messenger-vim
          gitsigns-nvim

          todo-comments-nvim

          vim-easymotion
          vim-surround
          vim-commentary

          nvim-jdtls

          vim-markdown
          markdown-preview-nvim
          vim-markdown-toc
        ];

        extraConfig = let
          vimConfig = builtins.map lib.strings.fileContents vimFiles;
          luaConfig = builtins.map lib.strings.fileContents luaFiles;
          vim = builtins.concatStringsSep "\n" vimConfig;
          lua = ''
            lua << EOF
            ${builtins.concatStringsSep "\n" luaConfig}
            EOF
          '';
        in ''
          " Custom VIML Config.
          ${vim}

          " Custom Lua Config.
          ${lua}
        '';
      };
    };
  };
}
