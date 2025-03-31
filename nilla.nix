let
  pins = import ./npins;

  nilla = import pins.nilla;
in
nilla.create ({ config }:
let
  loaders = {
    home-manager = "flake";
  };

  settings = {
    nixpkgs = {
      configuration = {
        allowUnfree = true;
      };
    };

    nixpkgs-unstable = settings.nixpkgs;
  };
in
{
  includes = [
    ./nilla

    "${pins.nilla-nixos}/modules/nixos.nix"
  ];

  config = {
    inputs = builtins.mapAttrs
      (name: pin: {
        src = pin;

        loader = loaders.${name} or (config.lib.modules.never { });
        settings = settings.${name} or (config.lib.modules.never { });
      })
      pins;
  };
})
