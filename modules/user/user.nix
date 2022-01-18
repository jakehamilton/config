{ options, config, pkgs, lib, ... }:

with lib;
let cfg = config.plusultra.user;
in {
  options.plusultra.user = with types; {
    name = mkOpt str "short" "The name to use for the user account.";
    fullName = mkOpt str "Jake Hamilton" "The full name of the user.";
    email = mkOpt str "jake.hamilton@hey.com" "The email of the user.";
    initialPassword = mkOpt str "password"
      "The initial password to use when the user is first created.";
    icon = mkOpt path ./profile.jpg "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { }
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    plusultra.home.file.".face/${builtins.baseNameOf cfg.icon}".source = cfg.icon;

    environment.systemPackages = with pkgs; [
      starship
    ];

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      histFile = "$XDG_CACHE_HOME/zsh.history";

      # @NOTE(jakehamilton): This may be useful if we want to
      # support multiple users with the exact same shell config.
      # However, right now this is a single user system so instead
      # of configuring this system-wide, we can just do so with
      # homemanager.

      # promptInit = ''
      #   eval $(starship init zsh)
      # '';
    };

    plusultra.home.configFile."starship.toml".source = ./starship.toml;

    plusultra.home.extraOptions.programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;

      initExtra = builtins.concatStringsSep "\n" [
        "eval $(starship init zsh)"
      ];

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
        }
      ];
    };

    users.users.${cfg.name} = {
      isNormalUser = true;

      name = cfg.name;
      home = "/home/${cfg.name}";
      group = "users";

      shell = pkgs.zsh;

      # Arbitrary user ID to use for the user. Since I only
      # have a single user on my machines this won't ever collide.
      # However, if you add multiple users you'll need to change this
      # so each user has their own unique uid (or leave it out for the
      # system to select).
      uid = 1000;

      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
