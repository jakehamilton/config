echo -e "
${text_bold}${text_fg_blue}nixos-hosts${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Show NixOS hosts from your flake.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}nixos-hosts${text_reset} [options]

${text_bold}OPTIONS${text_reset}

  --list, -l                Print all hosts
  --pick, -p                Select a host
  --debug                   Enable debug messages

  --help, -h                Show this help message
  --debug                   Show debug messages
"
