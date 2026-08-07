{ config, lib }:
let
  nixosNames = builtins.attrNames config.systems.nixos;
  macosNames = builtins.attrNames config.systems.macos;

  nixosSystems = builtins.foldl' (
    systems: name:
    let
      system = config.systems.nixos.${name};
      node = config.colmena.nodes.${name} or { };
      tags = builtins.concatStringsSep ", " (node.deployment.tags or [ ]);
    in
    systems
    // {
      "systems.nixos.${name}" = {
        inherit name;
        description = "A NixOS system configuration.";

        data = {
          columns = [
            "System"
            "Tags"
          ];
          rows = [
            [
              system.pkgs.stdenv.hostPlatform.system
              tags
            ]
          ];
        };
      };
    }
  ) { } nixosNames;

  macosSystems = builtins.foldl' (
    systems: name:
    let
      system = config.systems.nixos.${name};
      node = config.colmena.nodes.${name} or { };
      tags = builtins.concatStringsSep ", " (node.deployment.tags or [ ]);
    in
    systems
    // {
      "systems.nixos.${name}" = {
        inherit name;
        description = "A NixOS system configuration.";

        data = {
          columns = [
            "System"
            "Tags"
          ];
          rows = [
            [
              system.pkgs.stdenv.hostPlatform.system
              tags
            ]
          ];
        };
      };
    }
  ) { } macosNames;

  nixos = {
    name = "NixOS Systems";
    description = "NixOS system configurations.";

    data = {
      columns = [
        "Name"
        "System"
        "Tags"
      ];
      rows = builtins.map (
        name:
        let
          system = config.systems.nixos.${name};
          node = config.colmena.nodes.${name} or { };
          tags = builtins.concatStringsSep ", " (node.deployment.tags or [ ]);
        in
        [
          name
          system.pkgs.stdenv.hostPlatform.system
          tags
        ]
      ) nixosNames;
    };
  };

  macos = {
    name = "macOS Systems";
    description = "macOS system configurations.";

    data = {
      columns = [
        "Name"
        "System"
        "Tags"
      ];
      rows = builtins.map (
        name:
        let
          system = config.systems.macos.${name};
          node = config.colmena.nodes.${name} or { };
          tags = builtins.concatStringsSep ", " (node.deployment.tags or [ ]);
        in
        [
          name
          system.pkgs.stdenv.hostPlatform.system
          tags
        ]
      ) macosNames;
    };
  };
in
{
  config.explain =
    nixosSystems
    // macosSystems
    // {
      "systems.nixos" = nixos;
      "systems.macos" = macos;

      systems = {
        name = "Systems";
        description = "System configurations.";

        entries = [
          nixos
          macos
        ];
      };
    };
}
