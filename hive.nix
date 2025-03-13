let
  project = import ./nilla.nix;

  systems = builtins.mapAttrs
    (name: value: value.build)
    project.config.systems.nixos;

  nodes = builtins.mapAttrs
    (name: value: {
      imports = value._module.args.modules ++ (
        if custom ? name then [ custom.${name} ] else [ ]
      );
    })
    systems;

  custom = {
    bismuth = {
      deployment.tags = [ "workstation" "gaming" "desktop" "home" ];
    };

    jasper = {
      deployment.tags = [ "workstation" "laptop" "mobile" ];
    };

    quartz = {
      deployment.tags = [ "server" "nas" "desktop" "home" ];
    };

    adamite = {
      deployment.tags = [ "server" "cloud" "digitalocean" ];
    };

    agate = {
      deployment.tags = [ "server" "cloud" "digitalocean" ];
    };

    albite = {
      deployment.tags = [ "server" "cloud" "digitalocean" ];
    };
  };
in
{
  meta = {
    description = "Deployment configuration for the Plus Ultra repository.";

    nixpkgs = project.config.inputs.nixpkgs.loaded;

    nodeNixpkgs = builtins.mapAttrs
      (name: value: value.pkgs)
      systems;

    nodeSpecialArgs = builtins.mapAttrs
      (name: value: value._module.specialArgs)
      systems;
  };
} // nodes
