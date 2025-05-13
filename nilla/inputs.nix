{ config }:
let
  pins = import ../npins;

  nixpkgs-flake = config.inputs.flake-compat.result.load {
    src = config.inputs.nixpkgs.src;
  };

  nixpkgs-unstable-flake = config.inputs.flake-compat.result.load {
    src = config.inputs.nixpkgs-unstable.src;
  };

  loaders = {
    home-manager = "flake";

    lix = "raw";
    lix-src = "raw";
  };

  settings = {
    nixpkgs = {
      configuration = {
        allowUnfree = true;
      };
    };

    nixpkgs-unstable = settings.nixpkgs;

    comma = {
      inputs = {
        nixpkgs = nixpkgs-unstable-flake;
      };
    };

    cowsay = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    fht-compositor = {
      inputs = {
        nixpkgs = nixpkgs-unstable-flake;
      };
    };

    home-manager = {
      inputs = {
        nixpkgs = nixpkgs-unstable-flake;
      };
    };

    icehouse = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    lasersandfeelings-website = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    neovim = {
      inputs = {
        nixpkgs = nixpkgs-unstable-flake;
        unstable = nixpkgs-unstable-flake;
      };
    };

    nixos-generators = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    nixpkgs-news-website = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    noop-ai-website = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    pungeonquest-website = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    retrospectacle-website = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    scrumfish-website = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    snowfall-website = {
      inputs = {
        nixpkgs = nixpkgs-flake;
      };
    };

    tmux = {
      inputs = {
        nixpkgs = nixpkgs-unstable-flake;
        unstable = nixpkgs-unstable-flake;
      };
    };

    yubikey-guide = {
      inputs = {
        nixpkgs = nixpkgs-unstable-flake;
      };
    };
  };
in
{
  config = {
    inputs = builtins.mapAttrs
      (name: pin: {
        src = pin;

        loader = loaders.${name} or (config.lib.modules.never { });
        settings = settings.${name} or (config.lib.modules.never { });
      })
      pins;
  };
}
