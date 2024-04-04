import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Gdk from "../types/@girs/gdk-3.0/gdk-3.0.js";

export const known = {
  "framework-builtin": {
    make: "BOE",
    model: "0x095F",
  },
};

export const getMonitors = () => {
  return Hyprland.monitors;
};

export const getMonitorName = (monitor) => {
  for (const [name, { make, model }] of Object.entries(known)) {
    if (monitor.make === make && monitor.model === model) {
      return name;
    }
  }

  return `unknown-${monitor.make}-${monitor.model}`;
};

export const getGdkMonitorFromHyprlandId = (id) => {
  const target = Hyprland.monitors.find((monitor) => monitor.id === id);

  const monitor = target
    ? Gdk.Display.get_default()?.get_monitor_at_point(target.x, target.y) ?? 1
    : 1;

  return monitor;
};
