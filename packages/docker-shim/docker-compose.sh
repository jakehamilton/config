subcommand=${1:-}

if [[ "$subcommand" = "rm" ]]; then
	args=()

	while [[ $# > 0 ]]; do
		case "$1" in
			-*|--*)
				shift
				;;
			*)
				args+=("$1")
				shift
				;;
		esac
	done

	podman-compose stop "${args[@]}"
	exec podman-compose down "${args[@]}"
fi

exec podman-compose "$@"
