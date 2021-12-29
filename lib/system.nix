inputs@{ lib, ... }:

rec {
  mkSystem = { hardware ? null, suites ? [ ], presets ? [ ], modules ? [ ]
    , users ? [ ], config ? { }, }:
    let
      suitePaths = lib.map lib.getSuitePath suites;
      presetPaths = lib.map lib.getPresetPath presets;
      modulePaths = lib.map lib.getModulePath modules;
      userPaths = lib.map lib.getUserPath users;
      imports = (lib.optional (lib.not null hardware) hardware)
        ++ (lib.optional (builtins.hasAttr "imports" config) config.imports)
        ++ suitePaths ++ presetPaths ++ modulePaths ++ userPaths;
    in config // { inherit imports; };
}
