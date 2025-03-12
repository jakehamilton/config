{ lib, config, pkgs, project, host, ... }:
let
  cfg = config.plusultra.services.openssh;

  user = config.users.users.${config.plusultra.user.name};
  user-id = builtins.toString user.uid;

  # TODO: This is a hold-over from an earlier Snowfall Lib version which used
  # the specialArg `name` to provide the host name.
  name = host;

  default-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwaaCUq3Ooq1BaHbg5IwVxWj/xmNJY2dDthHKPZefrHXv/ksM/IREgm38J0CdoMpVS0Zp1C/vFrwGfaYZ2lCF5hBVdV3gf+mvj8Yb8Xpm6aM4L5ig+oBMp/3cz1+g/I4aLMJfCKCtdD6Q2o4vtkTpid6X+kL3UGZbX0HFn3pxoDinzOXQnVGSGw+pQhLASvQeVXWTJjVfIWhj9L2NRJau42cBRRlAH9kE3HUbcgLgyPUZ28aGXLLmiQ6CUjiIlce5ee16WNLHQHOzVfPJfF1e1F0HwGMMBe39ey3IEQz6ab1YqlIzjRx9fQ9hQK6Du+Duupby8JmBlbUAxhh8KJFCJB2cXW/K5Et4R8GHMS6MyIoKQwFUXGyrszVfiuNTGZIkPAYx9zlCq9M/J+x1xUZLHymL85WLPyxhlhN4ysM9ILYiyiJ3gYrPIn5FIZrW7MCQX4h8k0bEjWUwH5kF3dZpEvIT2ssyIu12fGzXkYaNQcJEb5D9gT1mNyi2dxQ62NPZ5orfYyIZ7fn22d1P/jegG+7LQeXPiy5NLE6b7MP5Rq2dL8Y9Oi8pOBtoY9BpLh7saSBbNFXTBtH/8OfAQacxDsZD/zTFtCzZjtTK6yiAaXCZTvMIOuoYGZvEk6zWXrjVsU8FlqF+4JOTfePqr/SSUXNJyKnrvQJ1BfHQiYsrckw==";

  other-hosts = lib.filterAttrs
    (
      key: host: key != name && (host.build.config.plusultra.user.name or null) != null
    )
    ((project.systems.nixos or { }) // (project.systems.macos or { }));

  other-hosts-config = lib.concatMapStringsSep "\n"
    (
      name:
      let
        remote = other-hosts.${name}.build;
        remote-user-name = remote.config.plusultra.user.name;
        remote-user-id = builtins.toString remote.config.users.users.${remote-user-name}.uid;

        forward-gpg =
          lib.optionalString (config.programs.gnupg.agent.enable && remote.config.programs.gnupg.agent.enable)
            ''
              RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent /run/user/${user-id}/gnupg/S.gpg-agent.extra
              RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent.ssh /run/user/${user-id}/gnupg/S.gpg-agent.ssh
            '';
      in
      ''
        Host ${name}
          User ${remote-user-name}
          ForwardAgent yes
          Port ${builtins.toString cfg.port}
          ${forward-gpg}
      ''
    )
    (builtins.attrNames other-hosts);
in
{
  options.plusultra.services.openssh = {
    enable = lib.mkEnableOption "OpenSSH";

    authorizedKeys = lib.mkOption {
      description = "The public keys to allow.";
      type = lib.types.listOf lib.types.str;
      default = [ default-key ];
    };

    port = lib.mkOption {
      description = "The port to listen on (in addition to 22).";
      type = lib.types.port;
      default = 2222;
    };

    manage-other-hosts = lib.mkOption {
      description = "Whether or not to add other host configurations to SSH config.";
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };

      extraConfig = ''
        StreamLocalBindUnlink yes
      '';

      ports = [
        22
        cfg.port
      ];
    };

    programs.ssh.extraConfig = ''
      Host *
        HostKeyAlgorithms +ssh-rsa

      ${lib.optionalString cfg.manage-other-hosts other-hosts-config}
    '';

    plusultra.user.extraOptions.openssh.authorizedKeys.keys = cfg.authorizedKeys;

    plusultra.home.extraOptions = {
      programs.zsh.shellAliases = lib.foldl
        (
          aliases: system: aliases // { "ssh-${system}" = "ssh ${system} -t tmux a"; }
        )
        { }
        (builtins.attrNames other-hosts);
    };
  };
}
