{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.internal;
let cfg = config.plusultra.home;
in
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  options.plusultra.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    plusultra.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.plusultra.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.plusultra.home.configFile;
    };

    home-manager = {
      useUserPackages = true;

      users.${config.plusultra.user.name} =
        mkAliasDefinitions options.plusultra.home.extraOptions;
    };
  };
}
