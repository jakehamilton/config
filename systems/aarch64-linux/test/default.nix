{ pkgs, config, lib, modulesPath, inputs, ... }:

with lib;
let
  steam-pi-setup = pkgs.writeShellApplication {
    name = "steam-pi-setup";
    checkPhase = "";
    runtimeInputs = with pkgs; [ slides ];
    text = ''
      slides ${./slides.md}
    '';
  };

  start-steam = pkgs.writeShellApplication {
    name = "start-steam";
    checkPhase = "";
    runtimeInputs = with pkgs; [ gamescope ];
    text = ''
      if ! [ -d ~/.local/share/Steam ]; then
        xterm "${steam-pi-setup}/bin/steam-pi-setup" &
        steam
      fi

      gamescope -f -- steam -gamepadui
    '';
  };
in
{
  imports = with inputs.nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    raspberry-pi-4
  ];

  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.crossSystem.system = "aarch64-linux";

  # high-resolution display
  hardware.video.hidpi.enable = true;
  hardware.opengl.driSupport32Bit = mkForce false;

  services.xserver = {
    enable = true;

    windowManager = {
      openbox = enabled;
    };

    displayManager = {
      defaultSession = "none+openbox";
      autoLogin.user = config.plusultra.user.name;

      lightdm = {
        enable = true;
        greeters.tiny = enabled;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gamescope
    numix-gtk-theme
  ];

  plusultra = {
    suites = {
      common = enabled;
    };

    hardware = {
      audio.extra-packages = [ ];
    };

    services = {
      printing = {
        enable = mkForce false;
      };
    };

    apps = {
      steam = enabled;
    };

    home = {
      configFile = {
        "openbox/rc.xml".source = ./rc.xml;

        "openbox/autostart".text = ''
          ${start-steam}/bin/start-steam &
        '';
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
