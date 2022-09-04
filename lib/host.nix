inputs@{ lib, darwin, nixpkgs, home-manager, nixos-generators, nix-ld, ... }:

rec {
  virtualSystems = [
    "amazon"
    "azure"
    "cloudstack"
    "do"
    "gce"
    "hyperv"
    "install-iso-hyperv"
    "install-iso"
    "iso"
    "kexec"
    "kexec-bundle"
    "kubevirt"
    "lxc"
    "lxc-metadata"
    "openstack"
    "proxmox"
    "qcow"
    "raw"
    "raw-efi"
    "sd-aarch64-installer"
    "sd-aarch64"
    "vagrant-virtualbox"
    "virtualbox"
    "vm-bootloader"
    "vm-nogui"
    "vmware"
    "vm"
  ];

  isDarwin = lib.hasInfix "darwin";
  isVirtual = system:
    lib.foldl
      (exists: virtualSystem: exists || lib.hasInfix virtualSystem system)
      false
      virtualSystems;

  getVirtual = system:
    lib.foldl
      (result: virtualSystem:
        if lib.not null result then
          result
        else if lib.hasInfix virtualSystem system then
          virtualSystem
        else
          null)
      null
      virtualSystems;

  getDynamicConfig = system:
    if lib.isVirtual system then
      let
        format = getVirtual system;
        system' = builtins.replaceStrings [ format ] [ "linux" ] system;
      in
      {
        output = "${format}Configurations";
        system = system';
        builder = args:
          nixos-generators.nixosGenerate (args // {
            inherit format;
            modules = args.modules ++ [{
              imports = [
                home-manager.nixosModules.home-manager
                nix-ld.nixosModules.nix-ld
              ];
            }];
          });
      }
    else if lib.isDarwin system then {
      output = "darwinConfigurations";
      builder = args:
        darwin.lib.darwinSystem (builtins.removeAttrs args [ "system" ]);
    } else {
      builder = args:
        nixpkgs.lib.nixosSystem (args // {
          modules = args.modules ++ [{
            imports = [
              home-manager.nixosModules.home-manager
              nix-ld.nixosModules.nix-ld
            ];
          }];
        });
    };

  withDynamicConfig = lib.composeAll [ lib.merge' getDynamicConfig ];

  # Pass through all inputs except `self` and `utils` due to them breaking
  # the module system or causing recursion.
  mkSpecialArgs = args:
    (builtins.removeAttrs inputs [ "self" "utils" ]) // {
      inherit lib;
    } // args;

  mkHost =
    { self ? { }
    , system
    , path
    , name ? lib.getFileName (builtins.baseNameOf path)
    , modules ? [ ]
    , specialArgs ? { }
    , channelName ? "nixpkgs"
    }: {
      "${name}" = withDynamicConfig system {
        inherit system channelName;
        modules =
          (lib.getModuleFilesWithoutDefaultRec (lib.getPathFromRoot "/modules"))
          ++ [
            ({ config, ... }:
              let revision = self.sourceInfo.rev or "dirty";
              in
              {
                # Thanks to Xe for this.
                # https://tulpa.dev/cadey/nixos-configs/src/commit/f53891121ce4204f57409cbe9e6fcee3b030a350/flake.nix#L50
                system.configurationRevision = revision;
                services.getty.greetingLine =
                  "<<< Welcome to NixOS ${config.system.nixos.label} @ ${revision} >>>";
              })
          ] ++ [ path ] ++ modules;
        specialArgs = mkSpecialArgs (specialArgs // { inherit system name; hosts = self.nixosConfigurations; });
      };
    };

  mkHosts = { self ? { }, src, hostOptions ? { } }:
    let
      systems = lib.getDirs src;
      hosts = builtins.concatMap
        (systemPath:
          let
            system = builtins.baseNameOf systemPath;
            modules = lib.getDirs systemPath;
          in
          builtins.map
            (path:
              let
                name = lib.getFileName (builtins.baseNameOf path);
                options = lib.optionalAttrs (builtins.hasAttr name hostOptions)
                  hostOptions.${name};
                host = mkHost ({ inherit self system path name; } // options);
              in
              host)
            modules)
        systems;
    in
    lib.foldl lib.merge { } hosts;
}
