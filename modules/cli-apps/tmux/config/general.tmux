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

# Fix colors being wrong in programs like Neovim.
set-option -ga terminal-overrides ",xterm-256color:Tc"

# Expand the left status to accomodate longer session names.
set-option -g status-left-length 20

# One of the plugins binds C-l, make sure we have accces to it.
unbind C-l
bind -n C-l send-keys C-l

# Don't require a prompt to detach from the current session.
unbind -n M-E
bind -n M-E detach-client

# Reload tmux configuration from ~/.config/tmux/tmux.conf instead
# of Tilish's default of ~/.tmux.conf.
unbind -n M-C
bind -n M-C source-file "~/.config/tmux/tmux.conf"

# Use M-z to zoom and unzoom panes.
bind -n M-z resize-pane -Z
