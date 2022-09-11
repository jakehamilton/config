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
    snowfall-lib.url = "github:snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim
    neovim.url = "github:jakehamilton/neovim";
    neovim.inputs.nixpkgs.follows = "unstable";
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
      };
    in
    lib.mkFlake {
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

      deploy = lib.mkDeploy { inherit (inputs) self; };
    };
}
