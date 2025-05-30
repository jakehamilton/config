{ lib
, config
, pkgs
, project
, ...
}:
let
  cfg = config.plusultra.nix;
in
{
  options.plusultra.nix = {
    enable = lib.mkEnableOption "Nix";
  };

  config = lib.mkIf cfg.enable {
    documentation.nixos.enable = false;

    environment.systemPackages =
      [
        project.packages.nixos-revision.result.${pkgs.system}
        (project.packages.nixos-hosts.result.${pkgs.system}.override { hosts = project.systems.nixos; })
        (project.inputs.nilla-cli.result.packages.nilla-cli.result.${pkgs.system})
        (project.inputs.nilla-nixos.result.packages.nilla-nixos.result.${pkgs.system})
      ]
      ++ (with pkgs; [
        deploy-rs
        nixfmt-rfc-style
        nix-index
        nix-prefetch-git
        nix-output-monitor
        npins
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
        package = pkgs.lix.override {
          aws-sdk-cpp = null;
        };

        settings =
          {
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
