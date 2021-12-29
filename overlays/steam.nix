{ channels, lib, ... }:

final: prev:
let
  steam = prev.steamPackages.steam.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall or "" + ''
      substituteInPlace steam.desktop \
        --replace "Exec=steam" "Exec=env GDK_SCALE=2 steam"
    '';
  });

in {
  steamPackages = prev.steamPackages // { inherit steam; };

  # Even tried overriding the main steam package and proxying the build of steamPackages.

  # steam = prev.steam.override {
  #     buildFHSUserEnv = args@{ targetPkgs, ... }:
  #         let args' = builtins.removeAttrs args ["unshareIpc" "unsharePid"]; in
  #         prev.buildFHSUserEnv (args' // {
  #             targetPkgs = pkgs':
  #                 let
  #                     targets = targetPkgs pkgs';
  #                     targets' = builtins.filter (
  #                         target:
  #                             (target.drvPath != pkgs'.steamPackages.steam.drvPath)
  #                     ) targets;
  #                 in
  #                     builtins.trace "overlay # buildFHSUserEnv"
  #                     targets' ++ [ steam ];
  #         });
  # };
}
