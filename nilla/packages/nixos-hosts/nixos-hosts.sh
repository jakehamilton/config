#!/usr/bin/env bash

#==============================#
#           Global             #
#==============================#

DEBUG=${DEBUG:-"false"}

#==============================#
#          Injected            #
#==============================#

hosts="@hosts@"
help_root="@help@"

#==============================#
#           Logging            #
#==============================#

text_reset="\e[m"
text_bold="\e[1m"
text_dim="\e[2m"
text_italic="\e[3m"
text_underline="\e[4m"
text_blink="\e[5m"
text_highlight="\e[7m"
text_hidden="\e[8m"
text_strike="\e[9m"

text_fg_red="\e[38;5;1m"
text_fg_green="\e[38;5;2m"
text_fg_yellow="\e[38;5;3m"
text_fg_blue="\e[38;5;4m"
text_fg_magenta="\e[38;5;5m"
text_fg_cyan="\e[38;5;6m"
text_fg_white="\e[38;5;7m"
text_fg_dim="\e[38;5;8m"

text_bg_red="\e[48;5;1m"
text_bg_green="\e[48;5;2m"
text_bg_yellow="\e[48;5;3m"
text_bg_blue="\e[48;5;4m"
text_bg_magenta="\e[48;5;5m"
text_bg_cyan="\e[48;5;6m"
text_bg_white="\e[48;5;7m"
text_bg_dim="\e[48;5;8m"

# Usage: log_info <message>
log_info() {
	echo -e "${text_fg_blue}info${text_reset}  $1"
}

# Usage: log_todo <message>
log_todo() {
	echo -e "${text_bg_magenta}${text_fg_white}todo${text_reset}  $1"
}

# Usage: log_debug <message>
log_debug() {
	if [[ $DEBUG == true ]]; then
		echo -e "${text_fg_dim}debug${text_reset} $1"
	fi
}

# Usage: log_warn <message>
log_warn() {
	echo -e "${text_fg_yellow}warn${text_reset}  $1"
}

# Usage: log_error <message>
log_error() {
	echo -e "${text_fg_red}error${text_reset} $1"
}

# Usage: log_fatal <message> [exit-code]
log_fatal() {
	echo -e "${text_fg_white}${text_bg_red}fatal${text_reset} $1"

	if [ -z ${2:-} ]; then
		exit 1
	else
		exit $2
	fi
}

# Usage: clear_previous_line [number]
clear_line() {
	echo -e "\e[${1:-"1"}A\e[2K"
}

# Usage:
# 	rewrite_line <message>
# 	rewrite_line <number> <message>
rewrite_line() {
	if [[ $# == 1 ]]; then
		echo -e "\e[1A\e[2K${1}"
	else
		echo -e "\e[${1}A\e[2K${2}"
	fi
}

#==============================#
#           Options            #
#==============================#
positional_args=()

opt_help=false
opt_pick=false
opt_list=false

# Usage: missing_value <option>
missing_opt_value() {
	log_fatal "Option $1 requires a value"
}

# shellcheck disable=SC2154
while [[ $# > 0 ]]; do
	case "$1" in
		-h|--help)
			opt_help=true
			shift
			;;
		-p|--pick)
			opt_pick=true
			shift
			;;
		-l|--list)
			opt_list=true
			shift
			;;
		--show-trace)
			opt_show_trace=true
			shift
			;;
		--debug)
			DEBUG=true
			shift
			;;
		--)
			shift
			break
			;;
		-*|--*)
			echo "Unknown option $1"
			exit 1
			;;
		*)
			positional_args+=("$1")
			shift
			;;
	esac
done

passthrough_args=($@)
show_trace=""

#==============================#
#          Helpers             #
#==============================#

# Usage: split <string> <delimiter>
split() {
	IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
	printf '%s\n' "${arr[@]}"
}

# Usage: lstrip <string> <pattern>
lstrip() {
	printf '%s\n' "${1##$2}"
}

# Usage: show_help <path>
show_help() {
	log_debug "Showing help: ${text_bold}$1${text_reset}"
	source "${help_root}/$1.sh"
}

# Usage: require_flake_nix
require_flake_nix() {
	if ! [ -f ./flake.nix ]; then
		log_fatal "This command requires a flake.nix file, but one was not found in the current directory."
	fi
}

# Usage: get_flake_attributes <output> <flake-uri>
get_flake_attributes() {
		local outputs=""

		# NOTE: Some flakes may not contain the values we're looking for. In
		# which case, we swallow errors here to keep the output clean.
		set +e
		outputs=$(nix eval --impure --raw --expr "\
			let
					flake = builtins.getFlake \"$2\";
					outputs =
						if builtins.elem \"$1\" [ \"packages\" \"devShells\" \"apps\" ] then
							builtins.attrNames (flake.\"$1\".\${builtins.currentSystem} or {})
						else
							builtins.attrNames (flake.\"$1\" or {});
					names = builtins.map (output: \"$2#\" + output) outputs;
			in
			builtins.concatStringsSep \" \" names
		" 2>/dev/null)
		set -e

		echo "$outputs"
}

# Usage: replace_each <pattern> <text> <data>
replace_each() {
	local results=()

	for item in $3; do
		if [[ "$item" == $1* ]]; then
			results+=("$2$(lstrip $item $1)")
		else
			results+=("$item")
		fi
	done

	echo "${results[*]}"
}

# Usage: prefix_each <prefix> <data>
prefix_each() {
	local results=()

	for item in $2; do
		results+=("$1 $item")
	done

	echo "${results[*]}"
}

# Usage: join_by <delimiter> <data> <data> [...<data>]
join_by() {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

# Usage: privileged <command>
privileged() {
	cmd="$@"
	if command -v sudo >/dev/null; then
		log_debug "sudo $cmd"
		sudo $cmd
	elif command -v doas >/dev/null; then
		log_debug "doas $cmd"
		doas $cmd
	else
		log_warn "Could not find ${text_bold}sudo${text_reset} or ${text_bold}doas${text_reset}. Executing without privileges."
		log_debug "$cmd"
		eval "$cmd"
	fi
}


#==============================#
#          Commands            #
#==============================#

nixos_hosts_all() {
	if [[ $opt_help == true ]]; then
		show_help nixos-hosts
		exit 0
	fi

	if [[ -z "${hosts}" ]]; then
		log_error "To use this program, override it with your nixosConfigurations:"
		log_error ""
		log_error "  nixos-hosts.override {"
		log_error "    hosts = self.nixosConfigurations;"
		log_error "  }"
		log_error ""
		log_fatal "No hosts configured."
	fi

	if [ "${opt_list}" == "true" ]; then
		local csv=$(cat "${hosts}")

		local csv_data=$(echo -n "$csv" | tail +2)

		while read -r line; do
			local name=$(split "${line}" "," | head -n 1)

			echo "${name}"
		done <<< "${csv_data}"

		exit 0
	fi

	host=$(gum table --selected.foreground="4" --widths=32,20 < "${hosts}")

	if [ -z "${host}" ]; then
		exit 0
	else
		local name=$(split "${host}" "," | head -n 1)

		echo $name
	fi
}

#==============================#
#          Execute             #
#==============================#

if [ -z "${positional_args:-}" ]; then
	if [[ $opt_help == true ]]; then
		show_help "nixos-hosts"
		exit 0
	else
		log_debug "Running subcommand: ${text_bold}nixos_hosts_all${text_reset}"
		nixos_hosts_all
		exit 0
	fi
fi

case ${positional_args[0]} in
	*)
		log_fatal "Unknown subcommand: ${text_bold}${positional_args[0]}${text_reset}"
		;;
esac
