{ options, config, pkgs, lib, home-manager, ... }:

with lib;
let cfg = config.ultra.home;
in {
  imports = [ home-manager.nixosModules.home-manager ];

  options.ultra.home = with types; {
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
  };

  config = {
    ultra.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.ultra.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.ultra.home.configFile;
    };

    home-manager = {
      useUserPackages = true;

      users.${config.ultra.user.name} =
        mkAliasDefinitions options.ultra.home.extraOptions;
    };
  };
}
