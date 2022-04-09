{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs (release-21.11)
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=2fcd36b9c96f7fe38fd6c66e874a62570c45cd15";

    # NixPkgs Unstable (nixos-unstable)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # Extras
    nixos-hardware.url =
      "github:nixos/nixos-hardware?rev=87a35a0d58f546dc23f37b4f6af575d0e4be6a7a";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # NMD
    nmd.url = "gitlab:rycee/nmd?rev=527245ff605bde88c2dd2ddae21c6479bb7cf8aa";
    nmd.flake = false;

    # Generate System Images
    nixos-generators.url =
      "github:nix-community/nixos-generators?rev=296067b9c7a172d294831dec89d86847f30a7cfc";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, utils
    , nixos-hardware, darwin, nmd, nixos-generators, ... }:
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
          packages = (utils.lib.exportPackages self.overlays channels) // {
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
