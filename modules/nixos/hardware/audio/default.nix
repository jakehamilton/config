{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
# FIXME: The transition to wireplumber from media-session has completely
# broken my setup. I'll need to invest some time to figure out how to override Alsa things
# again...
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.audio;

  lua-format = {
    type =
      with lib.types;
      let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Lua value";
          };
      in
      valueType;

    generate =
      name: value:
      let
        toLuaValue =
          value:
          if value == null then
            "null"
          else if value == true then
            "true"
          else if value == false then
            "false"
          else if builtins.isInt value || builtins.isFloat value then
            builtins.toString value
          else if builtins.isString value then
            toLuaString value
          else if builtins.isAttrs value then
            toLuaTable value
          else if builtins.isList value then
            toLuaList value
          else
            builtins.abort "Unsupported value used with formats.lua.generate: ${value}";

        toLuaString = value: "\"${builtins.toString value}\"";

        toLuaTable =
          value:
          let
            pairs = mapAttrsToList (name: value: "[${toLuaString name}] = ${toLuaValue value}") value;
            content = concatStringsSep ", " pairs;
          in
          "{ ${content} }";

        toLuaList =
          value:
          let
            parts = builtins.map toLuaValue value;
            content = concatStringsSep ", " parts;
          in
          "{ ${content} }";
      in
      toLuaValue value;
  };

  pipewire-config = {
    "context.objects" = cfg.nodes ++ [ ];
    "context.modules" = [
      {
        name = "libpipewire-module-rtkit";
        args = { };
        flags = [
          "ifexists"
          "nofail"
        ];
      }
      { name = "libpipewire-module-protocol-native"; }
      { name = "libpipewire-module-profiler"; }
      # {
      #   name = "libpipewire-module-metadata";
      #   flags = [ "ifexists" "nofail" ];
      # }
      { name = "libpipewire-module-spa-device-factory"; }
      { name = "libpipewire-module-spa-node-factory"; }
      # {
      #   name = "libpipewire-module-client-node";
      #   flags = [ "ifexists" "nofail" ];
      # }
      # {
      #   name = "libpipewire-module-client-device";
      #   flags = [ "ifexists" "nofail" ];
      # }
      {
        name = "libpipewire-module-portal";
        flags = [
          "ifexists"
          "nofail"
        ];
      }
      {
        name = "libpipewire-module-access";
        args = { };
      }
      { name = "libpipewire-module-adapter"; }
      { name = "libpipewire-module-link-factory"; }
      { name = "libpipewire-module-session-manager"; }
    ] ++ cfg.modules;
    "context.components" = [
      {
        name = "libwireplumber-module-lua-scripting";
        type = "module";
      }
      {
        name = "config.lua";
        type = "config/lua";
      }
    ];
  };

  alsa-config = {
    alsa_monitor = cfg.alsa-monitor;
  };
in
{
  options.${namespace}.hardware.audio = with types; {
    enable = mkBoolOpt false "Whether or not to enable audio support.";
    alsa-monitor = mkOpt attrs { } "Alsa configuration.";
    nodes = mkOpt (listOf attrs) [ ] "Audio nodes to pass to Pipewire as `context.objects`.";
    modules = mkOpt (listOf attrs) [ ] "Audio modules to pass to Pipewire as `context.modules`.";
    extra-packages = mkOpt (listOf package) [
      pkgs.qjackctl
      pkgs.easyeffects
    ] "Additional packages to install.";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;
    };

    environment.etc = {
      # "pipewire/pipewire.conf.d/10-pipewire.conf".source =
      #   pkgs.writeText "pipewire.conf" (builtins.toJSON pipewire-config);
      # "pipewire/pipewire.conf.d/21-alsa.conf".source =
      #   pkgs.writeText "pipewire.conf" (builtins.toJSON alsa-config);

      #       "wireplumber/wireplumber.conf".source =
      #         pkgs.writeText "pipewire.conf" (builtins.toJSON pipewire-config);

      # "wireplumber/scripts/config.lua.d/alsa.lua".text = ''
      #   local input = ${lua-format.generate "sample.lua" cfg.alsa-monitor}

      #   if input.rules == nil then
      #    input.rules = {}
      #   end

      #   local rules = input.rules

      #   for _, rule in ipairs(input.rules) do
      #     table.insert(alsa_monitor.rules, rule)
      #   end
      # '';
    };

    hardware.pulseaudio.enable = mkForce false;

    environment.systemPackages =
      with pkgs;
      [
        pulsemixer
        pavucontrol
      ]
      ++ cfg.extra-packages;

    plusultra.user.extraGroups = [ "audio" ];

    plusultra.home.extraOptions = {
      systemd.user.services.mpris-proxy = {
        Unit.Description = "Mpris proxy";
        Unit.After = [
          "network.target"
          "sound.target"
        ];
        Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
