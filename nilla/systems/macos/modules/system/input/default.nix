{
  config,
  lib,
  project,
  ...
}:
let
  cfg = config.plusultra.system.input;

  hm = project.inputs.home-manager.result.lib.hm;
in
{
  options.plusultra.system.input = {
    enable = lib.mkEnableOption "macOS input";
  };

  config = lib.mkIf cfg.enable {
    system = {
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      defaults = {
        ".GlobalPreferences" = {
          "com.apple.mouse.scaling" = 1.0;
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

    plusultra.home.extraOptions = {
      home.activation = {
        # Disable special keys when using Option as a modifier.
        # https://superuser.com/questions/941286/disable-default-option-key-binding
        disableSpecialKeys = hm.dag.entryAfter [ "writeBoundary" ] ''
          set +e
          $DRY_RUN_CMD /usr/bin/sudo mkdir -p $HOME/Library/KeyBindings
          $DRY_RUN_CMD /usr/bin/sudo cp '${builtins.toPath ./DefaultKeyBinding.dict}' "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
          set -e
        '';
      };
    };
  };
}
