inputs@{ lib, pkgs, nixpkgs, ... }:

let
  steam' = (pkgs.steamPackages.steam.overrideAttrs (oldAttrs:
    builtins.trace oldAttrs.postInstall {
      postInstall = oldAttrs.postInstall + ''
        substituteInPlace $out/share/applications/steam.desktop \
            --replace "Exec=steam" "Exec=env GDK_SCALE=2 steam"
      '';
    }));
in {
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;

  # environment.systemPackages = with pkgs; [
  #     # steam'
  #     (builtins.trace "stage: a" steam.override {
  #         inherit steam;
  #         buildFHSUserEnv = args@{ targetPkgs, ... }:
  #             let args' = builtins.removeAttrs args ["unshareIpc" "unsharePid"]; in
  #             builtins.trace "stage: b"
  #             pkgs.buildFHSUserEnv (args' // {
  #                 targetPkgs = pkgs':
  #                     let
  #                         targets = targetPkgs pkgs';
  #                         targets' = builtins.filter
  #                             (target:
  #                                 if builtins.hasAttr "pname" target then
  #                                     target.pname != "steam-original"
  #                                 else
  #                                     true
  #                             )
  #                             targets;
  #                     in
  #                         lib.traceSeq (builtins.map (target:
  #                             let x = if builtins.hasAttr "pname" target then target.pname else "unknown";
  #                             in builtins.trace x x
  #                             ) targets')
  #                         targets' ++ [
  #                             steam
  #                             # (pkgs'.steamPackages.steam.overrideAttrs (oldAttrs: builtins.trace oldAttrs {
  #                             #     postInstall = oldAttrs.postInstall or "" + ''
  #                             #     substituteInPlace $out/share/applications/steam.desktop \
  #                             #         --replace "Exec=steam" "Exec=env GDK_SCALE=2 steam"
  #                             #     '';
  #                             # }))
  #                         ];
  #         });
  #     })
  # #     # (steamPackages.steam.overrideAttrs (oldAttrs: {
  # #     #     postInstall = oldAttrs.postInstall or "" + ''
  # #     #     substituteInPlace $out/share/applications/steam.desktop \
  # #     #         --replace "Exec=steam" "Exec=env GDK_SCALE=2 steam"
  # #     #     '';
  # #     # }))
  # ];
}
