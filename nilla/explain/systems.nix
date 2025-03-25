{ config, lib }:
let
  nixosNames = builtins.attrNames config.systems.nixos;

  nixosSystems = builtins.foldl'
    (systems: name:
      let
        system = config.systems.nixos.${name};
        node = config.colmena.nodes.${name} or { };
        tags = builtins.concatStringsSep ", " (node.deployment.tags or [ ]);
      in
      systems // {
        "systems.nixos.${name}" = {
          inherit name;
          description = "A NixOS system configuration.";

          data = {
            columns = [ "System" "Tags" ];
            rows = [ [ system.pkgs.system tags ] ];
          };
        };
      })
    { }
    nixosNames;

  nixos = {
    name = "NixOS Systems";
    description = "NixOS system configurations.";

    data = {
      columns = [ "Name" "System" "Tags" ];
      rows = builtins.map
        (name:
          let
            system = config.systems.nixos.${name};
            node = config.colmena.nodes.${name} or { };
            tags = builtins.concatStringsSep ", " (node.deployment.tags or [ ]);
          in
          [ name system.pkgs.system tags ])
        nixosNames;
    };
  };
in
{
  config.explain = nixosSystems // {
    "systems.nixos" = nixos;

    systems = {
      name = "Systems";
      description = "System configurations.";

      entries = [ nixos ];
    };
  };
}
