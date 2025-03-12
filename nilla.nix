let
  pins = import ./npins;

  nilla = import pins.nilla;
in
nilla.create ({ config }:
let
  loaders = {
    nixpkgs = "legacy";
    nixpkgs-unstable = loaders.nixpkgs;

    home-manager = "legacy";
  };

  settings = {
    nixpkgs = {
      args = {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };
    };

    nixpkgs-unstable = settings.nixpkgs;

    home-manager = {
      args = {
        pkgs = config.inputs.nixpkgs.loaded;
      };
    };
  };
in
{
  config = {
    inputs = builtins.mapAttrs
      (name: pin: {
        src = pin;

        loader = loaders.${name} or (config.lib.modules.never { });
        settings = settings.${name} or (config.lib.modules.never { });
      })
      pins;
  };

  includes = [
    ./nilla
  ];
})
