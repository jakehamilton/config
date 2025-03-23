let
  project = import ./nilla.nix;

  systems = builtins.mapAttrs
    (name: value: value.result)
    project.systems.nixos;

  nodes = builtins.mapAttrs
    (name: value: {
      imports = value._module.args.modules ++ (
        if custom ? ${name} then [ custom.${name} ] else [ ]
      );
    })
    systems;

  custom = {
    bismuth = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "workstation" "gaming" "desktop" "home" ];
      };
    };

    jasper = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "workstation" "laptop" "mobile" ];
      };
    };

    quartz = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "nas" "desktop" "home" ];
      };
    };

    adamite = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "cloud" "digitalocean" ];
      };
    };

    agate = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "cloud" "digitalocean" ];
      };
    };

    albite = {
      deployment = {
        targetUser = "short";
        privilegeEscalationCommand = [ "doas" ];

        tags = [ "server" "cloud" "digitalocean" ];
      };
    };
  };
in
{
  meta = {
    description = "Deployment configuration for the Plus Ultra repository.";

    nixpkgs = project.inputs.nixpkgs.result;

    nodeNixpkgs = builtins.mapAttrs
      (name: value: value.pkgs)
      systems;

    nodeSpecialArgs = builtins.mapAttrs
      (name: value: value._module.specialArgs)
      systems;
  };
} // nodes
