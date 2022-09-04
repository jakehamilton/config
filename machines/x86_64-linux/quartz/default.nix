{ pkgs, config, lib, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  networking.firewall.allowedTCPPorts = [ 5357 ];
  networking.firewall.allowedUDPPorts = [ 3702 ];

  services.samba-wsdd = {
    enable = true;
    discovery = true;
    workgroup = "WORKGROUP";
  };

  services.samba = {
    enable = true;
    openFirewall = true;

    extraConfig = ''
      browseable = yes
    '';

    # For configuration options, see: man 5 smb.conf
    shares = {
      depth = {
        comment = "Depth";
        path = "/persist/share/depth";
        public = "no";
        browseable = "yes";
        "write list" = "short";
        "read list" = "short";
        "create mask" = "0755";
      };
      audio = {
        comment = "Audio";
        path = "/persist/share/audio";
        browseable = "yes";
        public = "yes";
        "write list" = "short";
        "read list" = "guest, nobody";
        "create mask" = "0755";
      };
      video = {
        comment = "Video";
        path = "/persist/share/video";
        browseable = "yes";
        public = "yes";
        "write list" = "short";
        "read list" = "guest, nobody";
        "create mask" = "0755";
      };
      documents = {
        path = "/persist/share/documents";
        browseable = "yes";
        public = "no";
        "write list" = "short";
        "read list" = "short";
        "create mask" = "0755";
      };
      homes = {
        comment = "Home";
        path = "/persist/share/homes/%S";
        browseable = "no";
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };

    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };

  services.minio = {
    enable = true;

    region = "us-west-1";

    dataDir = [ "/persist/apps/minio/data" ];
    configDir = "/persist/apps/minio/config";

    rootCredentialsFile = "/persist/apps/minio/credentials";
  };

  plusultra = {
    nix = enabled;

    cli-apps = {
      neovim = enabled;
      tmux = enabled;
    };

    tools = {
      git = enabled;
      misc = enabled;
      fup-repl = enabled;
      comma = enabled;
      nix-ld = enabled;
    };

    hardware = {
      networking = enabled;
    };

    services = {
      openssh = enabled;
      tailscale = enabled;
    };

    security = {
      doas = enabled;
    };

    system = {
      boot = enabled;
      fonts = enabled;
      locale = enabled;
      time = enabled;
      xkb = enabled;
    };
  };

  system.stateVersion = "21.11";
}
