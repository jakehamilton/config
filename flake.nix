{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs (nixos-22.05)
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=1f8d88087a3753e55a29b5207f7f0997f7c813fa";

    # NixPkgs Unstable (nixos-unstable)
    nixpkgs-unstable.url = "github:nixos/nixpkgs";

    # Home Manager (release-22.05)
    home-manager.url =
      "github:nix-community/home-manager?rev=ac2287df5a2d6f0a44bbcbd11701dbbf6ec43675";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # macOS Support (master)
    darwin.url =
      "github:lnl7/nix-darwin?rev=9a388b6b56d079090ff8e9998e2d4a63e6886f01";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Utils
    utils.url =
      "github:gytis-ivaskevicius/flake-utils-plus?rev=f8d6d1f87b6177e3bc674c29f247bdbf897ba274";

    # Hardware Configuration
    nixos-hardware.url =
      "github:nixos/nixos-hardware?rev=0cab18a48de7914ef8cad35dca0bb36868f3e1af";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # NMD
    nmd.url = "gitlab:rycee/nmd?rev=527245ff605bde88c2dd2ddae21c6479bb7cf8aa";
    nmd.flake = false;

    # Generate System Images
    nixos-generators.url =
      "github:nix-community/nixos-generators?rev=fb3ee0f618b8c80dea1239691b15dfeb4bb46331";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Powercord (modded Discord)
    powercord-overlay.url =
      "github:LavaDesu/powercord-overlay?rev=cea1348777740f02ba58e8712ca6aaf8f295b469";
    powercord-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Comma
    comma.url =
      "github:nix-community/comma?rev=034a9ca440370fc1eccbed43ff345fb6ea1f0d27";
    comma.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, utils
    , nixos-hardware, darwin, nmd, nixos-generators, powercord-overlay, ... }:
    let
      lib = import ./lib inputs;
      inherit (self.sourceInfo) rev;
    in utils.lib.mkFlake {
      inherit self inputs lib;

      channelsConfig = { allowUnfree = true; };

      channels.nixpkgs.overlaysBuilder = lib.mkOverlays { src = ./overlays; };

      hosts = lib.mkHosts {
        inherit self;
        src = ./machines;
      };

      overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; };

      outputsBuilder = channels:
        let
          pkgs = channels.nixpkgs;
          system = pkgs.system;
          nmd' = import nmd { inherit lib pkgs; };
          modules = lib.getModuleFilesWithoutDefaultRec
            (lib.getPathFromRoot "/modules");
          mockNixos = with lib; {
            options = {
              environment = mkSinkUndeclaredOptions { };
              systemd = mkSinkUndeclaredOptions { };
              system = mkSinkUndeclaredOptions { };
              users = mkSinkUndeclaredOptions { };
              home-manager = mkSinkUndeclaredOptions { };
              programs = mkSinkUndeclaredOptions { };
              boot = mkSinkUndeclaredOptions { };
              console = mkSinkUndeclaredOptions { };
              fonts = mkSinkUndeclaredOptions { };
              hardware = mkSinkUndeclaredOptions { };
              i18n = mkSinkUndeclaredOptions { };
              networking = mkSinkUndeclaredOptions { };
              nix = mkSinkUndeclaredOptions { };
              security = mkSinkUndeclaredOptions { };
              services = mkSinkUndeclaredOptions { };
              time = mkSinkUndeclaredOptions { };
              xdg = mkSinkUndeclaredOptions { };
            };
          };
          scrubbedPkgsModule = {
            imports = [{
              _module.args = {
                pkgs = lib.mkForce (nmd'.scrubDerivations "pkgs" pkgs);
                pkgs_i686 = lib.mkForce { };
              };
            }];
          };
          evaluatedModules = lib.evalModules {
            modules = modules ++ [
              mockNixos
              scrubbedPkgsModule
              ({ ... }: {
                _module.args = {
                  check = false;
                  pkgs = lib.mkDefault pkgs;
                  pkgsPath = lib.mkDefault pkgs.path;
                  baseModules = modules;
                };
              })
            ];
          };
          fullDocList = lib.optionAttrSetToDocList evaluatedModules.options;
          visibleDocList =
            lib.filter (opt: opt.visible && !opt.internal) fullDocList;
          targetedDocList = lib.map (doc:
            doc // {
              declarations = lib.map' doc.declarations (path:
                let parts = builtins.split "/nix/store/[^/]+" path;
                in if (builtins.length parts) == 3 then
                  builtins.elemAt parts 2
                else
                  path);
            }) visibleDocList;
          docList = targetedDocList;
        in {
          packages = let
            pkgsFromOverlays =
              (utils.lib.exportPackages self.overlays channels);
            plusultraPackages = let
              fn = import (lib.getOverlayPath "plusultra");
              overlay = fn (inputs // { inherit lib; });
              packages = overlay pkgs pkgs;
            in packages;

          in pkgsFromOverlays // plusultraPackages
          // plusultraPackages.plusultra // {
            wallpapers = pkgs.callPackage (lib.getPackagePath "/wallpapers")
              (inputs // { inherit pkgs lib; });
            docs = {
              json = pkgs.stdenvNoCC.mkDerivation {
                name = "plusultra-docs-json";
                src = builtins.toFile "docs.json" (builtins.toJSON docList);

                dontUnpack = true;

                installPhase = ''
                  cp $src $out
                '';
              };
            };
          };
        };
    };
}
