{
  description = "Flake-exposed systems and packages from my Nilla project.";

  inputs = { };

  outputs =
    { ... }:
    let
      project = import ./nilla.nix;
    in
    {
      darwinConfigurations = builtins.mapAttrs (_name: system: system.result) project.systems.macos;
    };
}
