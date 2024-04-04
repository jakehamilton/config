import TogglePanel from "./toggle-panel.js";
import Workspaces from "./workspaces.js";

export default function VerticalBarTop() {
  return Widget.Box({
    className: "vertical-bar-top",
    vertical: true,
    vpack: "start",
    spacing: 8,
    children: [TogglePanel(), Workspaces(true)],
  });
}
