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
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, utils
    , nixos-hardware, darwin, ... }:
    let lib = import ./lib inputs;
    in utils.lib.mkFlake {
      inherit self inputs lib;

      channelsConfig = { allowUnfree = true; };

      channels.nixpkgs.overlaysBuilder = lib.mkOverlays { src = ./overlays; };

      hosts = lib.mkHosts { src = ./machines; };
    };
}
