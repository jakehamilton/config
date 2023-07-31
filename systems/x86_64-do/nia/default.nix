{ lib, pkgs, ... }:

with lib;
with lib.internal;
{
  virtualisation.digitalOcean = {
    rebuildFromUserData = false;
  };

  boot.loader.grub = enabled;

  environment.systemPackages = with pkgs; [
    neovim
  ];

  plusultra = {
    user = {
      name = "nia";
      fullName = "nia";
      email = "nianeyna@gmail.com";
    };

    nix = enabled;

    tools = {
      git = enabled;
    };

    security = {
      doas = enabled;
    };

    services = {
      openssh = {
        enable = true;
        manage-other-hosts = false;
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7nx6qwuLjF5jDm7dUb8ZBu/AlswvPmkaGQHMx9kEO0"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGM/Z+COXn4/e4UEXWcMRbkNOGYcFEr9woEI1PaDiZjN"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMi9VzNIP/BSliI6R+iuoScOtlvLop6XkWIVYbCK5iH"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRm5+zDQrf/0f20gHCHoZrMt9B8CjApTpk7r92Wq7Qm"
        ];
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
