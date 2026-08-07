{
  lib,
  config,
  pkgs,
  project,
  ...
}:
let
  cfg = config.plusultra.nix;
in
{
  imports = [
    project.modules.nixos.lix
  ];

  options.plusultra.nix = {
    enable = lib.mkEnableOption "Nix";
  };

  config = lib.mkIf cfg.enable {
    documentation.nixos.enable = false;

    environment.systemPackages = [
      project.packages.nixos-revision.result.${pkgs.stdenv.hostPlatform.system}
      (project.packages.nixos-hosts.result.${pkgs.stdenv.hostPlatform.system}.override {
        hosts = project.systems.nixos;
      })
      (project.inputs.nilla-cli.result.packages.nilla-cli.result.${pkgs.stdenv.hostPlatform.system})
      (project.inputs.nilla-nixos.result.packages.nilla-nixos.result.${pkgs.stdenv.hostPlatform.system})
      (import project.inputs.npins.src {
        inherit pkgs;
      })
    ]
    ++ (with pkgs; [
      deploy-rs
      nixfmt
      nix-index
      nix-prefetch-git
      nix-output-monitor
      colmena
    ]);

    nix =
      let
        users = [
          "root"
          config.plusultra.user.name
        ];
      in
      {
        settings = {
          experimental-features = "nix-command flakes";
          http-connections = 50;
          warn-dirty = false;
          log-lines = 50;
          sandbox = "relaxed";
          auto-optimise-store = true;
          trusted-users = users;
          allowed-users = users;
          accept-flake-config = false;
        }
        // (lib.optionalAttrs config.plusultra.tools.direnv.enable {
          keep-outputs = true;
          keep-derivations = true;
        });

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };
  };
}
