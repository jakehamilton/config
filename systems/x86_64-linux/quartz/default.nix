{ pkgs, config, lib, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    weekly = 4;
  };

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
      vault = {
        comment = "Vault";
        path = "/persist/share/vault";
        browseable = "yes";
        public = "no";
        "create mask" = "0755";
        "write list" = "short";
        "read list" = "short";
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
        comment = "Documents";
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

  services.jellyfin.enable = true;

  networking.firewall.allowedTCPPorts = [
    # Samba
    5357
  ];
  networking.firewall.allowedUDPPorts = [
    # Samba
    3702

    # Jellyfin
    # We only want to open Jellyfin's UDP ports since HTTP will be proxied with nginx.
    1900
    7359
  ];

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
      bottom = enabled;
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

  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsProvider = "digitalocean";
      dnsPropagationCheck = true;
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      email = config.plusultra.user.email;
      credentialsFile = "/var/lib/acme-secrets/digitalocean";
      group = "nginx";
    };

    certs."quartz.hamho.me" = {
      domain = "*.quartz.hamho.me";
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts =
      let
        create-proxy =
          { port
          , host ? "127.0.0.1"
          }: {
            sslCertificate = "${config.security.acme.certs."quartz.hamho.me".directory}/fullchain.pem";
            sslCertificateKey = "${config.security.acme.certs."quartz.hamho.me".directory}/key.pem";

            forceSSL = true;

            locations."/".proxyPass = "http://${host}:${builtins.toString port}";
          };
      in
      {
        "minio.quartz.hamho.me" =
          # The MinIO module is a bit non-standard and uses the default value ":9001". If customized,
          # that value can be of the form "<ip>:<port>". So we have to split the values out, defaulting
          # the ip to "127.0.0.1".
          let
            address-parts = builtins.split ":" config.services.minio.consoleAddress;
            ip = builtins.head address-parts;
            host = if ip == "" then "127.0.0.1" else ip;
            port = last address-parts;
          in
          create-proxy { inherit host port; };

        "jellyfin.quartz.hamho.me" = create-proxy {
          # https://jellyfin.org/docs/general/networking/index.html#static-ports
          port = 8096;
        };
      };
  };

  system.stateVersion = "21.11";
}
