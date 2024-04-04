import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";

const workspaces = Variable(Hyprland.workspaces, {});

Hyprland.connect("workspace-added", (...args) => {
	workspaces.value = Hyprland.workspaces;
});

Hyprland.connect("workspace-removed", (...args) => {
	workspaces.value = Hyprland.workspaces;
});

export default function Workspaces(vertical = false) {
	return Widget.EventBox({
		className: "workspaces",
		child: Widget.Box({
			className: "workspaces-container",
			vertical,
			hpack: "center",
			spacing: 8,
			children: Array.from({ length: 10 }, (_, i) => i + 1)
				// workspaces
				.map((id) =>
					Widget.Button({
						className: `workspace workspace-${id}`,
						child: Widget.Box({
							vpack: "fill",
						}),
						onClicked: () => {
							Hyprland.messageAsync(`dispatch workspace ${id}`);
						},
						setup: (self) => {
							self.hook(Hyprland, () => {
								self.toggleClassName(
									"active",
									Hyprland.active.workspace.id === id,
								);

								self.toggleClassName(
									"occupied",
									(Hyprland.getWorkspace(id)?.windows ?? 0) > 0,
								);
							});
						},
					}),
				),
		}),
	});
}
