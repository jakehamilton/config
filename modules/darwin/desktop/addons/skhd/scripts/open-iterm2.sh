# Detects if iTerm2 is running
if ! pgrep -f "iTerm" > /dev/null 2>&1; then
    open -a "/Applications/Nix Apps/iTerm2.app"
else
    # Create a new window
    script='tell application "iTerm2" to create window with default profile'
    ! osascript -e "${script}" > /dev/null 2>&1 && {
        # Get pids for any app with "iTerm" and kill
        while IFS="" read -r pid; do
            kill -15 "${pid}"
        done < <(pgrep -f "iTerm")
        open -a "/Applications/Nix Apps/iTerm2.app"
    }
fi
