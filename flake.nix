{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs (nixos-22.05)
    nixpkgs.url =
      "github:nixos/nixpkgs/nixos-22.05";

    # NixPkgs Unstable (nixos-unstable)
    unstable.url =
      "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager (release-22.05)
    home-manager.url =
      "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # macOS Support (master)
    darwin.url =
      "github:lnl7/nix-darwin?rev=9a388b6b56d079090ff8e9998e2d4a63e6886f01";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url =
      "github:nixos/nixos-hardware?rev=0cab18a48de7914ef8cad35dca0bb36868f3e1af";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # # NMD
    # nmd.url = "gitlab:rycee/nmd?rev=527245ff605bde88c2dd2ddae21c6479bb7cf8aa";
    # nmd.flake = false;

    # Generate System Images
    nixos-generators.url =
      "github:nix-community/nixos-generators?rev=adccd191a0e83039d537e021f19495b7bad546a1";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Powercord (modded Discord)
    powercord-overlay.url =
      "github:LavaDesu/powercord-overlay?rev=cea1348777740f02ba58e8712ca6aaf8f295b469";
    powercord-overlay.inputs.nixpkgs.follows = "unstable";

    # Comma
    comma.url =
      "github:nix-community/comma?rev=034a9ca440370fc1eccbed43ff345fb6ea1f0d27";
    comma.inputs.nixpkgs.follows = "unstable";

    # System Deployment
    deploy-rs.url =
      "github:serokell/deploy-rs?rev=41f15759dd8b638e7b4f299730d94d5aa46ab7eb";
    deploy-rs.inputs.nixpkgs.follows = "unstable";

    # Run unpatched dynamically compiled binaries
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall
    snowfall-lib.url = "path:/home/short/work/@snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim
    neovim.url = "path:/home/short/work/@jakehamilton/neovim";
    neovim.inputs.nixpkgs.follows = "unstable";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      overlay-package-namespace = "plusultra";

      channels-config.allowUnfree = true;

      overlays = with inputs; [
        nix-alien.overlay
        powercord-overlay.overlay
        neovim.overlays."nixpkgs/plusultra"
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
        nix-ld.nixosModules.nix-ld
      ];
    };
  # let
  #   lib = import ./lib inputs;
  #   hosts = lib.mkHosts {
  #     inherit self;
  #     src = ./machines;
  #   };
  # in
  # utils.lib.mkFlake {
  #   inherit self inputs lib hosts;

  #   channelsConfig = { allowUnfree = true; };

  #   channels.nixpkgs.overlaysBuilder = lib.mkOverlays { src = ./overlays; };

  #   overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; };

  #   deploy = lib.mkDeploy { inherit self; };

  #   checks = builtins.mapAttrs
  #     (system: deployLib: deployLib.deployChecks self.deploy)
  #     deploy-rs.lib;

  #   outputsBuilder = channels:
  #     let
  #       pkgs = channels.nixpkgs;
  #       system = pkgs.system;
  #       nmd' = import nmd { inherit lib pkgs; };
  #       modules = lib.getModuleFilesWithoutDefaultRec
  #         (lib.getPathFromRoot "/modules");
  #       mockNixos = with lib; {
  #         options = {
  #           assertions = mkSinkUndeclaredOptions { };
  #           environment = mkSinkUndeclaredOptions { };
  #           systemd = mkSinkUndeclaredOptions { };
  #           system = mkSinkUndeclaredOptions { };
  #           users = mkSinkUndeclaredOptions { };
  #           home-manager = mkSinkUndeclaredOptions { };
  #           programs = mkSinkUndeclaredOptions { };
  #           boot = mkSinkUndeclaredOptions { };
  #           console = mkSinkUndeclaredOptions { };
  #           fonts = mkSinkUndeclaredOptions { };
  #           hardware = mkSinkUndeclaredOptions { };
  #           i18n = mkSinkUndeclaredOptions { };
  #           networking = mkSinkUndeclaredOptions { };
  #           nix = mkSinkUndeclaredOptions { };
  #           security = mkSinkUndeclaredOptions { };
  #           services = mkSinkUndeclaredOptions { };
  #           time = mkSinkUndeclaredOptions { };
  #           virtualisation = mkSinkUndeclaredOptions { };
  #           xdg = mkSinkUndeclaredOptions { };
  #         };
  #       };
  #       scrubbedPkgsModule = {
  #         imports = [{
  #           _module.args = {
  #             pkgs = lib.mkForce (nmd'.scrubDerivations "pkgs" pkgs);
  #             pkgs_i686 = lib.mkForce { };
  #           };
  #         }];
  #       };
  #       evaluatedModules = lib.evalModules {
  #         modules = modules ++ [
  #           mockNixos
  #           scrubbedPkgsModule
  #           ({ ... }: {
  #             _module.args = {
  #               check = false;
  #               pkgs = lib.mkDefault pkgs;
  #               pkgsPath = lib.mkDefault pkgs.path;
  #               baseModules = modules;
  #             };
  #           })
  #         ];
  #       };
  #       fullDocList = lib.optionAttrSetToDocList evaluatedModules.options;
  #       visibleDocList =
  #         lib.filter (opt: opt.visible && !opt.internal) fullDocList;
  #       targetedDocList = lib.map
  #         (doc:
  #           doc // {
  #             declarations = lib.map' doc.declarations (path:
  #               let parts = builtins.split "/nix/store/[^/]+" path;
  #               in
  #               if (builtins.length parts) == 3 then
  #                 builtins.elemAt parts 2
  #               else
  #                 path);
  #           })
  #         visibleDocList;
  #       docList = targetedDocList;
  #     in
  #     {
  #       packages =
  #         let
  #           pkgsFromOverlays =
  #             (utils.lib.exportPackages self.overlays channels);
  #           plusultraPackages =
  #             let
  #               fn = import (lib.getOverlayPath "plusultra");
  #               overlay = fn (inputs // { inherit lib; });
  #               packages = overlay pkgs pkgs;
  #             in
  #             packages;

  #         in
  #         pkgsFromOverlays // plusultraPackages.plusultra // {
  #           wallpapers = pkgs.callPackage (lib.getPackagePath "/wallpapers")
  #             (inputs // { inherit pkgs lib; });

  #           jsonDocs = pkgs.stdenvNoCC.mkDerivation {
  #             name = "plusultra-docs-json";
  #             src = builtins.toFile "docs.json" (builtins.toJSON docList);

  #             dontUnpack = true;

  #             installPhase = ''
  #               cp $src $out
  #             '';
  #           };
  #         };
  #     };
  # };
}
