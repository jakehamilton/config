{
  description = "Plus Ultra";

  inputs = {
    # NixPkgs (nixos-22.05)
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=72783a2d0dbbf030bff1537873dd5b85b3fb332f";
    # "github:nixos/nixpkgs/nixos-22.05";

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
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Generate System Images
    nixos-generators.url =
      "github:nix-community/nixos-generators?rev=adccd191a0e83039d537e021f19495b7bad546a1";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Discord Replugged
    replugged.url = "github:LunNova/replugged-nix-flake";
    replugged.inputs.nixpkgs.follows = "unstable";

    # Discord Replugged plugins / themes
    discord-tweaks = {
      url = "github:NurMarvin/discord-tweaks";
      flake = false;
    };
    discord-nord-theme = {
      url = "github:DapperCore/NordCord";
      flake = false;
    };


    # Comma
    comma.url =
      "github:nix-community/comma?rev=034a9ca440370fc1eccbed43ff345fb6ea1f0d27";
    comma.inputs.nixpkgs.follows = "unstable";

    # System Deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "unstable";

    # Run unpatched dynamically compiled binaries
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall
    snowfall-lib.url = "github:snowfallorg/lib/dev";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim
    neovim.url = "github:jakehamilton/neovim";
    neovim.inputs.nixpkgs.follows = "unstable";
    neovim.inputs.snowfall-lib.follows = "snowfall-lib";

    # Dex Tailscale Auth
    tailscale-authproxy.url = "path:/home/short/work/tailscale-authproxy";
    tailscale-authproxy.inputs.nixpkgs.follows = "unstable"; # Required for go 1.19
    tailscale-authproxy.inputs.snowfall-lib.follows = "snowfall-lib";
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
        neovim.overlays."nixpkgs/neovim"
        tailscale-authproxy.overlays."nixpkgs/tailscale-authproxy"
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
        nix-ld.nixosModules.nix-ld
      ];

      systems.hosts.jasper.modules = with inputs; [
        nixos-hardware.nixosModules.framework
      ];

      deploy = lib.mkDeploy { inherit (inputs) self; };
    };
}
