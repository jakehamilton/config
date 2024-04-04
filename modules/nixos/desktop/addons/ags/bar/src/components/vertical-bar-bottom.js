import Network from "./wifi.js";
import VerticalTime from "./vertical-time.js";

export default function VerticalBarBottom() {
  return Widget.Box({
    className: "vertical-bar-bottom",
    vertical: true,
    vpack: "end",
    spacing: 4,
    children: [Network(), VerticalTime()],
  });
}
