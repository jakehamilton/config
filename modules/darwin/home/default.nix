{
  options,
  config,
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.home;
in
{
  # imports = with inputs; [
  #   home-manager.darwinModules.home-manager
  # ];

  options.${namespace}.home = with types; {
    file = mkOpt attrs { } "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile =
      mkOpt attrs { }
        "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    homeConfig = mkOpt attrs { } "Final config for home-manager.";
  };

  config = {
    plusultra.home.extraOptions = {
      home.stateVersion = mkDefault "22.11";
      home.file = mkAliasDefinitions options.${namespace}.home.file;
      xdg.enable = true;
      xdg.configFile = mkAliasDefinitions options.${namespace}.home.configFile;
    };

    snowfallorg.user.${config.${namespace}.user.name}.home.config =
      mkAliasDefinitions
        options.${namespace}.home.extraOptions;

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      # users.${config.${namespace}.user.name} = args:
      #   mkAliasDefinitions options.${namespace}.home.extraOptions;
    };
  };
}
