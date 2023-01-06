{ pkgs, config, lib, ... }:

with lib;
{
  imports = [ ./hardware.nix ];

  services.zfs = {
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
      weekly = 3;
      daily = 3;
      hourly = 0;
      frequent = 0;
      monthly = 2;
    };

    autoScrub = {
      enable = true;
      pools = [ "rpool" ];
    };
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
      books = {
        comment = "Books";
        path = "/persist/share/books";
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

  services.navidrome = {
    enable = true;

    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/persist/share/audio/music";
      EnableGravatar = "true";
    };
  };

  services.jellyfin.enable = true;

  services.vault = {
    enable = true;

    # Use the version of Vault built with support for the UI.
    package = pkgs.vault-bin;

    storageBackend = "file";
    extraConfig = ''
      ui = true
    '';
  };

  networking.firewall.allowedTCPPorts = [
    # Samba
    5357

    # Navidrome
    4533

    # Jellyfin
    8096
  ];
  networking.firewall.allowedUDPPorts = [
    # Samba
    3702

    # Jellyfin
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
      cowsay-mastodon-poster = {
        enable = true;
        short = true;
      };
    };

    security = {
      doas = enabled;
      gpg = enabled;
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
          { port ? null
          , host ? "127.0.0.1"
          , proxy-web-sockets ? false
          , extra-config ? { }
          }:
            assert port != "";
            assert host != "";
            extra-config // {
              sslCertificate = "${config.security.acme.certs."quartz.hamho.me".directory}/fullchain.pem";
              sslCertificateKey = "${config.security.acme.certs."quartz.hamho.me".directory}/key.pem";

              forceSSL = true;

              locations = (extra-config.locations or { }) // {
                "/" = (extra-config.locations."/" or { }) // {
                  proxyPass =
                    "http://${host}${if port != null then ":${builtins.toString port}" else ""}";

                  proxyWebsockets = proxy-web-sockets;
                };
              };
            };
      in
      {
        "minio.quartz.hamho.me" =
          create-proxy
            (lib.network.get-address-parts config.services.minio.consoleAddress);

        "jellyfin.quartz.hamho.me" = create-proxy {
          # https://jellyfin.org/docs/general/networking/index.html#static-ports
          port = 8096;

          # This is required to support sync play.
          proxy-web-sockets = true;
        };

        "navidrome.quartz.hamho.me" = create-proxy {
          # https://www.navidrome.org/docs/usage/configuration-options/#available-options
          port = 4533;
        };

        "vault.quartz.hamho.me" = create-proxy
          (lib.network.get-address-parts config.services.vault.address);
      };
  };

  system.stateVersion = "21.11";
}
