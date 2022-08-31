# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'M-\\' if-shell \"$is_vim\" 'send-keys M-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'M-\\' if-shell \"$is_vim\" 'send-keys M-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'M-h' select-pane -L
bind-key -T copy-mode-vi 'M-j' select-pane -D
bind-key -T copy-mode-vi 'M-k' select-pane -U
bind-key -T copy-mode-vi 'M-l' select-pane -R
bind-key -T copy-mode-vi 'M-p' select-pane -l

