import Net from "resource:///com/github/Aylur/ags/service/network.js";

const wireless = Utils.merge(
  [
    Net.wifi.bind("enabled"),
    Net.wifi.bind("internet"),
    Net.wifi.bind("state"),
    Net.wifi.bind("strength"),
    Net.wifi.bind("ssid"),
  ],
  (enabled, internet, state, strength, ssid) => {
    return {
      enabled,
      internet,
      state,
      strength,
      ssid,
    };
  },
);

const wired = Utils.merge(
  [
    Net.wired.bind("state"),
    Net.wired.bind("internet"),
    Net.wired.bind("icon_name"),
    // Network.wired.bind("speed"),
  ],
  (state, internet) => {
    return {
      state,
      internet,
    };
  },
);

const getWifiIcon = (strength) => {
  if (strength === "bad") {
    return "󰤯";
  }
  if (strength === "weak") {
    return "󰤟";
  }
  if (strength === "good") {
    return "󰤢";
  }
  if (strength === "strong") {
    return "󰤥";
  }
  return "󰤨";
};

const getWifiStrength = (strength) => {
  if (strength < 20) {
    return "bad";
  }
  if (strength < 40) {
    return "weak";
  }
  if (strength < 60) {
    return "good";
  }
  if (strength < 80) {
    return "strong";
  }
  return "excellent";
};

const network = Utils.merge(
  [Net.bind("primary"), wireless, wired],
  (primary, wireless, wired) => {
    if (primary === "wired") {
      // Wired connection
      return {
        type: "wired",
        connected: wired.internet === "connected",
        icon: wired.internet === "connected" ? "󰈀" : "󱘖",
      };
    } else if (primary === "wifi") {
      // Wireless connection
      const strength = getWifiStrength(wireless.strength);
      return {
        type: "wireless",
        connected: wireless.internet === "connected",
        icon: getWifiIcon(strength),
        strength,
      };
    } else {
      // No wireless and currently disconnected
      return {
        type: "wired",
        connected: false,
        icon: "󱘖",
      };
    }
  },
);

export default function Network() {
  let strength = "";

  return Widget.Box({
    className: "network icon-font",
    hpack: "center",
    child: Widget.Label({
      label: network.as((network) => network.icon),
      setup: (self) => {
        self.hook(network.emitter, () => {
          const n = network.emitter.value;

          switch (n.type) {
            case "wired":
              self.class_name = `wired ${
                n.connected ? "connected" : "disconnected"
              }`;
              break;
            case "wireless":
              break;
          }
        });
      },
    }),
    // Widget.Icon({
    // iconName: Network.wifi.icon_name,
    // css: "font-size: 30px;",
    // }),
  });
}
