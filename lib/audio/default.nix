{ lib }:

rec {
  mkAlsaRename = { name, description }: {
    matches = [{ "node.name" = name; }];
    actions = { "update-props" = { "node.description" = description; }; };
  };
  mkAudioNode = args@{ name, factory ? "adapter", ... }: {
    inherit factory;
    args = (builtins.removeAttrs args [ "name" "description" ]) // {
      "node.name" = name;
      "node.description" = args.description or args."node.description";
      "factory.name" = args."factory.name" or "support.null-audio-sink";
    };
  };
  mkVirtualAudioNode = args@{ name, ... }:
    mkAudioNode (args // {
      name = "virtual-${lib.toLower name}-audio";
      description = "${name} (Virtual)";
      "media.class" = args.class or args."media.class" or "Audio/Duplex";
      "object.linger" = args."object.linger" or true;
      "audio.position" = args."audio.position" or [ "FL" "FR" ];
      "monitor.channel-volumes" = args."monitor.channel-volumes" or true;
    });
  mkBridgeAudioModule = args@{ from, to, ... }: {
    name = "libpipewire-module-loopback";
    args = (builtins.removeAttrs args [ "from" "to" "name" ]) // {
      "node.name" =
        if args ? name then
          "${args.name}-bridge"
        else
          "${lib.toLower from}-to-${lib.toLower to}-bridge";
      "audio.position" = args."audio.position" or [ "FL" "FR" ];
      "capture.props" = {
        "node.target" = from;
      } // (args."capture.props" or { });
      "playback.props" = {
        "node.target" = to;
        "monitor.channel-volumes" = true;
      } // (args."playback.props" or { });
    };
  };
}
