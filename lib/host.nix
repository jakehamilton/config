inputs@{ lib, darwin, nixpkgs, home-manager, ... }:

rec {
  isDarwin = lib.hasInfix "darwin";

  getDynamicConfig = system:
    if lib.isDarwin system then {
      output = "darwinConfigurations";
      builder = args:
        darwin.lib.darwinSystem (builtins.removeAttrs args [ "system" ]);
    } else {
      builder = args:
        nixpkgs.lib.nixosSystem (args // {
          modules = args.modules
            ++ [{ imports = [ home-manager.nixosModules.home-manager ]; }];
        });
    };

  withDynamicConfig = lib.composeAll [ lib.merge getDynamicConfig ];

  # Pass through all inputs except `self` and `utils` due to them breaking
  # the module system or causing recursion.
  mkSpecialArgs = args:
    (builtins.removeAttrs inputs [ "self" "utils" ]) // {
      inherit lib;
    } // args;

  mkHost = { system, path, name ? lib.getFileName (builtins.baseNameOf path)
    , modules ? [ ], specialArgs ? { }, channelName ? "nixpkgs" }: {
      "${name}" = withDynamicConfig system {
        inherit system channelName;
        modules =
          (lib.getModuleFilesWithoutDefaultRec (lib.getPathFromRoot "/modules"))
          ++ [ path ] ++ modules;
        specialArgs = mkSpecialArgs (specialArgs // { inherit system name; });
      };
    };

  mkHosts = { src, hostOptions ? { } }:
    let
      systems = lib.getDirs src;
      hosts = builtins.concatMap (systemPath:
        let
          system = builtins.baseNameOf systemPath;
          modules = lib.getDirs systemPath;
        in builtins.map (path:
          let
            name = lib.getFileName (builtins.baseNameOf path);
            options = lib.optionalAttrs (builtins.hasAttr name hostOptions)
              hostOptions.${name};
            host = mkHost ({ inherit system path name; } // options);
          in host) modules) systems;
    in lib.foldl lib.merge { } hosts;
}
