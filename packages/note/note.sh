set -euo pipefail

root=$HOME/work/notes
target=${1:-}

if ! [[ -d $root ]]; then
	mkdir -p $root
fi

if [[ -z $target ]]; then
	target=$root/$(date "+%Y-%m-%d").md
else
	target=$root/$target.md
fi

exec nvim $target
