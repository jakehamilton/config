{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.input;
in
{
  options.${namespace}.system.input = with types; {
    enable = mkEnableOption "macOS input";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      system = {
        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };

        defaults = {
          ".GlobalPreferences" = {
            "com.apple.mouse.scaling" = "1";
          };

          NSGlobalDomain = {
            AppleKeyboardUIMode = 3;
            ApplePressAndHoldEnabled = false;

            KeyRepeat = 2;
            InitialKeyRepeat = 15;

            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
          };
        };
      };

      snowfallorg.user.${config.${namespace}.user.name}.home.config = {
        home.activation = {
          # Disable special keys when using Option as a modifier.
          # https://superuser.com/questions/941286/disable-default-option-key-binding
          disableSpecialKeys = lib.home-manager.hm.dag.entryAfter [ "writeBoundary" ] ''
            set +e
            $DRY_RUN_CMD /usr/bin/sudo mkdir -p $HOME/Library/KeyBindings
            $DRY_RUN_CMD /usr/bin/sudo cp '${builtins.toPath ./DefaultKeyBinding.dict}' "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
            set -e
          '';
        };
      };
    }
  ]);
}
