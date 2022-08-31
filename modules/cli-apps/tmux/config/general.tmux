# Lower delay waiting for chord after escape key press.
set -g escape-time 0

# Change the prefix from C-b to C-s to make it easier to type.
set -g prefix C-s
unbind C-b
bind C-s send-prefix

# Start window numbers at 1 rather than 0.
set -g base-index 1

# Use h, j, k, l for movement between panes.
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# @NOTE(jakehamilton): This is now handled by Tilish.
# The same as above, but don't require the prefix first.
# bind -n M-h select-pane -L
# bind -n M-j select-pane -D
# bind -n M-k select-pane -U
# bind -n M-l select-pane -R

# Fix colors being wrong in programs like Neovim.
set-option -ga terminal-overrides ",xterm-256color:Tc"

# Expand the left status to accomodate longer session names.
set-option -g status-left-length 20
