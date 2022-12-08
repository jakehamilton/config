#!/usr/bin/env nix-shell
#! nix-shell -i bash -p node2nix

node2nix -i ./node-packages.json -c ./create-node-packages.nix
