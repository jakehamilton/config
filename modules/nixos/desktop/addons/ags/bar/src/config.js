import App from "resource:///com/github/Aylur/ags/app.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";

import { getMonitors, getMonitorName } from "./util/monitors.js";
import VerticalBar from "./components/vertical-bar.js";

App.config({
  style: `${App.configDir}/css/index.css`,
});

App.addIcons(`${App.configDir}/assets`);

const bars = new Map();
const reservations = new Map();

const create = (monitor) => {
  const name = getMonitorName(monitor);

  let bar;
  let reservation;

  switch (name) {
    default:
    case "framework-builtin":
      [bar, reservation] = VerticalBar(monitor);
      break;
  }

  if (reservation) {
    reservations.set(monitor.name, reservation);
    App.addWindow(reservation);
  }

  bars.set(monitor.name, bar);

  bar.show_all();
  App.addWindow(bar);
};

const createAll = () => {
  for (const monitor of getMonitors()) {
    create(monitor);
  }
};

const destroyAll = () => {
  for (const [name, bar] of bars) {
    bars.delete(name);
    App.removeWindow(bar);
  }

  for (const [name, reservation] of reservations) {
    reservations.delete(name);
    App.removeWindow(reservation);
  }
};

// HACK: For some reason only removing the windows on non-existent monitors is broken
// and results in all bars displaying on a single monitor.
const updateAll = () => {
  destroyAll();
  createAll();
};

createAll();

Hyprland.connect("monitor-added", updateAll);
Hyprland.connect("monitor-removed", updateAll);
