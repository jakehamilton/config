{ lib }:

rec {
  ## Renames an alsa device from a given `name` using the new `description`.
  ##
  #@ { name: String, description: String } -> { matches: List, apply_properties: Attrs }
  mkAlsaRename =
    { name, description }:
    {
      matches = [
        [
          [
            "device.name"
            "matches"
            name
          ]
        ]
      ];
      # actions = { "update-props" = { "node.description" = description; }; };
      apply_properties = {
        "device.description" = description;
      };
    };

  ## Create a pipewire audio node.
  ##
  #@ { name: String, factory: String ? "adapter", ... } -> { factory: String, args: Attrs }
  mkAudioNode =
    args@{
      name,
      factory ? "adapter",
      ...
    }:
    {
      inherit factory;
      args =
        (builtins.removeAttrs args [
          "name"
          "description"
        ])
        // {
          "node.name" = name;
          "node.description" = args.description or args."node.description";
          "factory.name" = args."factory.name" or "support.null-audio-sink";
        };
    };

  ## Create a virtual pipewire audio node.
  ##
  #@ { name: String, ... } -> { factory: "adapter", args: Attrs }
  mkVirtualAudioNode =
    args@{ name, ... }:
    mkAudioNode (
      args
      // {
        name = "virtual-${lib.toLower name}-audio";
        description = "${name} (Virtual)";
        "media.class" = args.class or args."media.class" or "Audio/Duplex";
        "object.linger" = args."object.linger" or true;
        "audio.position" =
          args."audio.position" or [
            "FL"
            "FR"
          ];
        "monitor.channel-volumes" = args."monitor.channel-volumes" or true;
      }
    );

  ## Connect two pipewire audio nodes
  ##
  #@ { name: String?, from: String, to: String, ... } -> { name: "libpipewire-module-loopback", args: Attrs }
  mkBridgeAudioModule =
    args@{ from, to, ... }:
    {
      name = "libpipewire-module-loopback";
      args =
        (builtins.removeAttrs args [
          "from"
          "to"
          "name"
        ])
        // {
          "node.name" =
            if args ? name then "${args.name}-bridge" else "${lib.toLower from}-to-${lib.toLower to}-bridge";
          "audio.position" =
            args."audio.position" or [
              "FL"
              "FR"
            ];
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
