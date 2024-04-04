import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import { view, viewMonitor } from "./vertical-panel.js";
import { getWindow } from "../util/node.js";

export default function TogglePanel() {
  const widget = Widget.Box({
    className: "toggle-panel",
    child: Widget.Button({
      className: "toggle-panel-button",
      vpack: "center",
      hpack: "center",
      child: Widget.Icon({
        className: "toggle-panel-icon",
        icon: "avalancheOS",
      }),
      onClicked: () => {
        const window = getWindow(widget);
        const monitor = window.hyprlandMonitor;

        if (viewMonitor.value !== monitor.name) {
          view.setValue("");
          viewMonitor.setValue(monitor.name);
        }

        if (view.value === "apps") {
          view.value = "";
        } else {
          view.value = "apps";
        }
      },
    }),
  });

  return widget;
}
