{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
with lib;
with lib.plusultra; {
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  virtualisation.digitalOcean = {
    rebuildFromUserData = false;
  };

  boot.loader.grub = enabled;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services = {
    discourse = {
      enable = true;
      hostname = "forum.aux.computer";

      admin = {
        # We only want to create the admin account on the initial deployment. Now that one
        # exists, we can skip this step.
        skipCreate = true;

        email = "jake.hamilton@hey.com";
        username = "admin";
        fullName = "Administrator";
        passwordFile = "/var/lib/secrets/discourse-admin-password";
      };

      mail = {
        outgoing = {
          username = "mail@forum.aux.computer";
          passwordFile = "/var/lib/secrets/discourse-smtp-password";

          serverAddress = "smtp.mailgun.org";
          port = 587;
        };
      };

      plugins =
        (with config.services.discourse.package.plugins; [
          discourse-canned-replies
          discourse-checklist
          discourse-assign
          discourse-voting
          discourse-spoiler-alert
          discourse-solved
        ])
        ++ [
          # (config.services.discourse.package.mkDiscoursePlugin {
          #   name = "discourse-user-notes";
          #   src = pkgs.fetchFromGitHub {
          #     owner = "discourse";
          #     repo = "discourse-user-notes";
          #     rev = "e50c9d37f191e3f2f6564311abfa559f9f11f4a6";
          #     sha256 = "0jqrih7cqz7a8ap15vf20yjw81bpm07zg6dzsfwcpdpf8yj3cdak";
          #   };
          # })
        ];
    };
  };

  plusultra = {
    nix = enabled;

    cli-apps = {
      tmux = enabled;
      neovim = enabled;
    };

    tools = {
      git = enabled;
    };

    security = {
      doas = enabled;
      acme = enabled;
    };

    services = {
      openssh = enabled;
      tailscale = enabled;

      websites = {
        aux = enabled;
      };
    };

    system = {
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  system.stateVersion = "21.11";
}
