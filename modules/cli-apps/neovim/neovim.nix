{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.cli-apps.neovim;
  vimFiles = getFilesRec ./vim;
  luaFiles = getFilesRec ./lua;
in
{
  options.plusultra.cli-apps.neovim = with types; {
    enable = mkBoolOpt false "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Page is removed currently due to conflicts with toggleterm.
      page
      nodePackages.eslint
    ];
    environment.variables = {
      PAGER = "page";
      # MANPAGER = "page -t man";
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
      file = {
        ".npm-global/bin/eslint".source =
          "${pkgs.nodePackages.eslint}/bin/eslint";
        ".npm-global/lib/node_modules/eslint".source =
          "${pkgs.nodePackages.eslint}/lib/node_modules/eslint";
      };

      extraOptions = {
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
            nodePackages.tailwindcss
            gopls
            rust-analyzer
            sumneko-lua-language-server
            nixfmt
            ripgrep
            lua5_1
            rnix-lsp
          ];

          extraLuaPackages = with pkgs.lua51Packages; [
            plenary-nvim
            gitsigns-nvim
          ];

          plugins = with pkgs.vimPlugins; [
            plenary-nvim

            direnv-vim
            editorconfig-nvim
            vim-polyglot
            nvim-lspconfig
            lsp-colors-nvim
            vim-illuminate
            (nvim-treesitter.withPlugins
              (plugins: pkgs.tree-sitter.allGrammars))

            telescope-nvim
            telescope-symbols-nvim
            telescope-project-nvim

            nvim-tree-lua
            nvim-web-devicons

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

            # vim-gitgutter
            # vim-fugitive
            # git-messenger-vim
            gitsigns-nvim

            todo-comments-nvim

            hop-nvim
            vim-repeat
            vim-surround
            vim-commentary

            nvim-jdtls

            vim-markdown
            markdown-preview-nvim
            vim-markdown-toc

            vim-bufkill
            toggleterm-nvim

            lua-dev-nvim

            dashboard-nvim
            vim-tmux-navigator
          ];

          extraConfig =
            let
              vimImports = builtins.map (file: "source ${file}") vimFiles;
              vim = builtins.concatStringsSep "\n" vimImports;
              luaImports = builtins.map (file: "luafile ${file}") luaFiles;
              lua = builtins.concatStringsSep "\n" luaImports;
            in
            ''
              lua <<EOF
                -- Allow imports from common locations for some packages.
                -- This is required for things like sumneko_lua to work.
                local runtime_path = vim.split(package.path, ";")
                table.insert(runtime_path, "lua/?.lua")
                table.insert(runtime_path, "lua/?/init.lua")
              EOF

              " Custom VIML Config.
              ${vim}

              " Custom Lua Config.
              ${lua}
            '';
        };
      };
    };
  };
}
