{
  lib,
  config,
  options,
  project,
  ...
}:
let
  cfg = config.plusultra.home;
in
{
  imports = [
    project.inputs.home-manager.result.nixosModules.home-manager
  ];

  options.plusultra.home = {
    file = lib.mkOption {
      description = "A set of files to be managed by homemanager's `home.file`.";
      type = lib.types.attrs;
      default = { };
    };

    configFile = lib.mkOption {
      description = "A set of files to be managed by homemanager's `xdg.configFile`.";
      type = lib.types.attrs;
      default = { };
    };

    extraOptions = lib.mkOption {
      description = "Options to pass directly to home-manager.";
      type = lib.types.attrs;
      default = { };
    };
  };

  config = {
    plusultra.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = lib.mkAliasDefinitions options.plusultra.home.file;
      xdg.enable = true;
      xdg.configFile = lib.mkAliasDefinitions options.plusultra.home.configFile;

      home.enableNixpkgsReleaseCheck = lib.mkDefault false;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = ".backup";

      users.${config.plusultra.user.name} = lib.mkAliasDefinitions options.plusultra.home.extraOptions;

      extraSpecialArgs = {
        inherit project;
      };

      sharedModules = [
        project.inputs.stylix.result.homeModules.stylix
        ../../../homes/modules
      ];
    };
  };
}
