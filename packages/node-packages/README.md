# node-packages

To modify packages, change `node-packages.json`.

Example:

```json
["prettier", { "@jakehamilton/titan": "5.x" }]
```

Then rebuild the generated nix files usuing:

```shell
nix run nixpkgs#nodePackages.node2nix -- -i ./node-packages.json -c ./create-node-packages.nix
```
