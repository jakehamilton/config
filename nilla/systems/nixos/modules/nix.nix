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
    environment.systemPackages =
      [
        project.packages.nixos-revision.build.${pkgs.system}
        (project.packages.nixos-hosts.build.${pkgs.system}.override { hosts = project.systems.nixos; })
        (project.inputs.nilla-cli.loaded.packages.nilla.build.${pkgs.system})
      ]
      ++ (with pkgs; [
        deploy-rs
        nixfmt-rfc-style
        nix-index
        nix-prefetch-git
        nix-output-monitor
        npins
      ]);

    nix =
      let
        users = [
          "root"
          config.plusultra.user.name
        ];
      in
      {
        package = pkgs.lix;

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
