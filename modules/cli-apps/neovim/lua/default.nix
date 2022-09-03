{ config, lib, pkgs, ... }:

with lib;
let
  # Usage:
  # mkLuaConfig ./some-file.lua {
  #   MY_ARG = "hello-world";
  # }
  mkLuaConfig = file: args:
    let module =
      pkgs.substituteAll
        (args // {
          src = file;
        });
    in
    "luafile ${module}";

  # Usage:
  # mkLuaConfigs [
  #   ./some-file.lua
  #   { file = ./some-other.lua; options = { MY_ARG = "hello-world"; }; }
  # ]
  mkLuaConfigs = files:
    lib.concatMapStringsSep "\n"
      (file:
        if builtins.isAttrs file then
          mkLuaConfig file.file file.options
        else
          mkLuaConfig file { }
      )
      files;

  eslintModules = pkgs.symlinkJoin {
    name = "neovim-eslint-modules";
    paths = with pkgs.nodePackages; [ eslint ];
  };

  # The ESLint Language Server isn't able to find the eslint library by default, so we have
  # to wrap the executable to set a custom NPM prefix. This will make sure that when it tries
  # to load the package from the global location it is actually directed to ${eslintModules} in
  # the Nix Store.
  wrappedESLintLanguageServer = pkgs.runCommand "neovim-wrapped-eslint-language-server"
    {
      src = pkgs.nodePackages.vscode-langservers-extracted;
      buildInputs = [ pkgs.makeWrapper ];
    }
    ''
      makeWrapper $src/bin/vscode-eslint-language-server $out/bin/vscode-eslint-language-server \
        --set NPM_CONFIG_PREFIX ${eslintModules}
    '';
in
mkLuaConfigs [
  ./bufferline.lua
  ./dashboard.lua
  ./fzf.lua
  ./git.lua
  ./gitsigns.lua
  ./hop.lua
  ./keys.lua
  {
    file = ./lspconfig.lua;
    options = {
      typescript = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript";
      typescriptLanguageServer = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
      eslintLanguageServer = "${wrappedESLintLanguageServer}/bin/vscode-eslint-language-server";
      htmlLanguageServer = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server";
      cssLanguageServer = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
      jsonLanguageServer = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server";
      dockerLanguageServer = "${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-langserver";
    };
  }
  ./lualine.lua
  ./neoscroll.lua
  ./nord.lua
  ./telescope.lua
  ./tmux-navigator.lua
  ./todo-comments.lua
  ./toggleterm.lua
  ./tree-sitter.lua
  ./tree.lua
  ./trouble.lua
  ./twilight.lua
  ./vim.lua
  ./which-key.lua
]

