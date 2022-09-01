# Integrate Tmux and Neovim movement.
set -g @tilish-navigator "on"

# Default to splitting once vertically and then splitting horizontally
# after that.
select-layout "main-vertical"
select-layout -E
set -g @tilish-default "main-vertical"


bind-key -n "M-q" kill-pane

