# Create a vertical split to show search & results to keep
# the content visible.
set -g @extrakto_split_direction "v"

# Override the way that Extrakto copies text. By default
# it was trying to use xclip and would not properly pick
# up on $XDG_SESSION_TYPE being wayland. Instead, use
# Tmux's built-in clipboard functionality.
set -g @extrakto_clip_tool_run "tmux_osc52"

# @FIXME(jakehamilton): The current version of Extrakto in
# NixPkgs is out of date and does not support wayland.
# This overrides the clipping tool to ensure that it works
# under wayland.
set -g @extrakto_clip_tool "wl-copy"
