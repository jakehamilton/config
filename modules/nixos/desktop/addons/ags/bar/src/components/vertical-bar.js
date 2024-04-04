import VerticalBarTop from "./vertical-bar-top.js";
import VerticalBarBottom from "./vertical-bar-bottom.js";
import { VerticalPanel } from "./vertical-panel.js";
import { getGdkMonitorFromHyprlandId } from "../util/monitors.js";

export default function VerticalBar(monitor) {
	const name = `bar-vertical-${monitor.name}`;
	const maybeMonitor = getGdkMonitorFromHyprlandId(monitor.id);
	const monitorId = typeof maybeMonitor === "number" ? maybeMonitor : undefined;
	const gdkMonitor =
		typeof maybeMonitor === "number" ? undefined : maybeMonitor;

	const bar = Widget.Window({
		name: name,
		monitor: monitorId,
		gdkmonitor: gdkMonitor,
		anchor: ["top", "left", "bottom"],
		exclusivity: "ignore",
		className: "vertical-bar bar",
		keymode: "exclusive",
		widthRequest: 48,
		child: Widget.Box({
			children: [
				Widget.CenterBox({
					className: "vertical-bar-content",
					vertical: true,
					start_widget: VerticalBarTop(),
					end_widget: VerticalBarBottom(),
				}),
				VerticalPanel(),
			],
		}),
		setup: (self) => {
			self.keybind("Escape", () => {
				App.quit();
			});

			self.hook(App, () => {
				const exists = App.windows.some((w) => w.name === name);

				if (!exists) {
					App.removeWindow(reservation);
				}
			});
		},
	});
	// @ts-expect-error
	bar.hyprlandMonitor = monitor;

	const reservation = Widget.Window({
		name: `bar-vertical-reservation-${monitor.name}`,
		monitor: monitorId,
		gdkmonitor: gdkMonitor,
		layer: "bottom",
		anchor: ["top", "left", "bottom"],
		exclusivity: "exclusive",
		widthRequest: 48,
		// parent: self,
		// destroyWithParent: true,
		keymode: "none",
		clickThrough: true,
		visible: true,
	});

	// @ts-expect-error
	reservation.hyprlandMonitor = monitor;

	return [bar, reservation];
}
