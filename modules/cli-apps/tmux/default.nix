{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.plusultra.cli-apps.tmux;
  configFiles = lib.snowfall.fs.get-files ./config;

  extrakto = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "extrakto";
    version = "unstable-2021-04-04";
    src = pkgs.fetchFromGitHub {
      owner = "laktak";
      repo = "extrakto";
      rev = "4ce105d42cdf5eb0ebf7287c2ad1a7c354b31498";
      sha256 = "0nkxcigk32r5z5yphzbcrs5fkd5p9y2wxgs4m15hzm07kcpzvm6h";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for f in extrakto.sh open.sh helpers.sh; do
        chmod +x $target/scripts/$f
        wrapProgram $target/scripts/$f \
          --prefix PATH : ${with pkgs; lib.makeBinPath (
            [ pkgs.fzf pkgs.python3 pkgs.xclip pkgs.wl-clipboard ]
          )}
      done
    '';
    meta = {
      homepage = "https://github.com/laktak/extrakto";
      description = "Fuzzy find your text with fzf instead of selecting it by hand ";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ kidd ];
    };
  };

  plugins = [ extrakto ] ++ (with pkgs.tmuxPlugins; [
    continuum
    nord
    tilish
    tmux-fzf
    vim-tmux-navigator
  ]);
in
{
  options.plusultra.cli-apps.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to enable tmux.";
  };

  config = mkIf cfg.enable {
    plusultra.home.extraOptions = {
      programs.tmux = {
        enable = true;
        terminal = "screen-256color-bce";
        clock24 = true;
        historyLimit = 2000;
        keyMode = "vi";
        newSession = true;
        extraConfig = builtins.concatStringsSep "\n"
          (builtins.map lib.strings.fileContents configFiles);

        inherit plugins;
      };
    };
  };
}
