# Create a vertical split to show search & results to keep
# the content visible.
set -g @extrakto_split_direction "v"

# Override the way that Extrakto copies text. By default
# it was trying to use xclip and would not properly pick
# up on $XDG_SESSION_TYPE being wayland. Instead, use
# Tmux's built-in clipboard functionality.
set -g @extrakto_clip_tool_run "tmux_osc52"
