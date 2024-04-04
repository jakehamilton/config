import { getGdkMonitorFromHyprlandId } from "../util/monitors.js";
import { getWindow } from "../util/node.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";

const hours = Variable("");
const minutes = Variable("");

const update = () => {
  let [h = "", m = ""] = Utils.exec('date +"%H %M"').split(" ");

  hours.value = h;
  minutes.value = m;
};

update();
setInterval(update, 1000);

export default function VerticalTime() {
  const widget = Widget.Box({
    className: "vertical-time",
    vertical: true,
    children: [
      Widget.Label({
        className: "hours",
        label: hours.bind(),
      }),
      Widget.Label({
        className: "minutes",
        label: minutes.bind(),
      }),
    ],
  });

  return widget;
}
