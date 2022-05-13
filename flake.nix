{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs (nixos-21.11)
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=aa2f845096f72dde4ad0c168eeec387cbd2eae04";

    # NixPkgs Unstable (nixos-unstable)
    nixpkgs-unstable.url = "github:nixos/nixpkgs";

    # Home Manager (release-21.11)
    home-manager.url =
      "github:nix-community/home-manager?rev=697cc8c68ed6a606296efbbe9614c32537078756";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # macOS Support (master)
    darwin.url =
      "github:lnl7/nix-darwin?rev=9a388b6b56d079090ff8e9998e2d4a63e6886f01";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Utils
    utils.url =
      "github:gytis-ivaskevicius/flake-utils-plus?rev=be1be083af014720c14f3b574f57b6173b4915d0";

    # Hardware Configuration
    nixos-hardware.url =
      "github:nixos/nixos-hardware?rev=feceb4d24f582817d8f6e737cd40af9e162dee05";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # NMD
    nmd.url = "gitlab:rycee/nmd?rev=527245ff605bde88c2dd2ddae21c6479bb7cf8aa";
    nmd.flake = false;

    # Generate System Images
    nixos-generators.url =
      "github:nix-community/nixos-generators?rev=296067b9c7a172d294831dec89d86847f30a7cfc";
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
          in pkgsFromOverlays // {
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
