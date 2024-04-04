export default function Apps() {
  const entry = Widget.Entry({
    className: "apps-search-entry",
    hexpand: true,
    placeholder_text: "Type to search...",
    focusOnClick: true,
    onChange: (event) => {},
    setup: (self) => {
      self.has_focus = true;
    },
  });

  return Widget.Box({
    className: "apps",
    vertical: true,
    children: [
      Widget.Box({
        className: "apps-search",
        children: [
          entry,
          Widget.Label({
            className: "apps-search-icon icon-font",
            label: "󱁴",
          }),
        ],
        setup: (self) => {
          self.hook(App, (_, __, visible) => {
            if (visible) {
              entry.text = "";
              entry.grab_focus();
            }
          });
        },
      }),
    ],
  });
}
