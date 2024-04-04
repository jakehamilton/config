import { getWindow } from "../util/node.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Apps from "./panels/apps.js";

export const view = Variable("");
export const viewMonitor = Variable("");

export function VerticalPanel() {
  const widget = Widget.Revealer({
    revealChild: view.bind().as((v) => {
      const window = getWindow(widget);
      const monitor = window.hyprlandMonitor;
      const active = Hyprland.active.monitor;

      return active.name === monitor?.name && v !== "";
    }),
    transition: "slide_right",
    transitionDuration: 250,
    vexpand: true,
    child: Widget.Box({
      className: "vertical-panel panel",
      vexpand: true,
      child: view.bind().as((v) => {
        switch (v) {
          default:
          case "apps":
            return Apps();
        }
      }),
    }),
  });

  return widget;
}
