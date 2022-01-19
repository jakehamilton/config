{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs
    nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # macOS Support
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Utils
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # Extras
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # NMD
    nmd.url = "gitlab:rycee/nmd";
    nmd.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, utils
    , nixos-hardware, darwin, nmd, ... }:
    let lib = import ./lib inputs;
    in utils.lib.mkFlake {
      inherit self inputs lib;

      channelsConfig = { allowUnfree = true; };

      channels.nixpkgs.overlaysBuilder = lib.mkOverlays { src = ./overlays; };

      hosts = lib.mkHosts { src = ./machines; };

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
