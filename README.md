# Plus Ultra

<a href="https://nixos.wiki/wiki/Flakes" target="_blank">
	<img alt="Nix Flakes Ready" src="https://img.shields.io/static/v1?logo=nixos&logoColor=d8dee9&label=Nix%20Flakes&labelColor=5e81ac&message=Ready&color=d8dee9&style=for-the-badge">
</a>
<a href="https://github.com/snowfallorg/lib" target="_blank">
	<img alt="Built With Snowfall" src="https://img.shields.io/static/v1?logoColor=d8dee9&label=Built%20With&labelColor=5e81ac&message=Snowfall&color=d8dee9&style=for-the-badge">
</a>

<p>
<!--
	This paragraph is not empty, it contains an em space (UTF-8 8195) on the next line in order
	to create a gap in the page.
-->
  
</p>

> ✨ Go even farther beyond.

- [Screenshots](#screenshots)
- [Overlays](#overlays)
- [Packages](#packages)
  - [`at`](#at)
  - [`cowsay-plus`](#cowsay-plus)
  - [`discord-canary`](#discord-canary)
  - [`doukutsu-rs`](#doukutsu-rs)
  - [`firefox-nordic-theme`](#firefox-nordic-theme)
  - [`frappe-books`](#frappe-books)
  - [`hey`](#hey)
  - [`infrared`](#infrared)
  - [`kalidoface`](#kalidoface)
  - [`list-iommu`](#list-iommu)
  - [`nix-get-protonup`](#nix-get-protonup)
  - [`nix-update-index`](#nix-update-index)
  - [`nixos-option`](#nixos-option)
  - [`nixos-revision`](#nixos-revision)
  - [`steam`](#steam)
  - [`titan`](#titan)
  - [`twitter`](#twitter)
  - [`wallpapers`](#wallpapers)
  - [`xdg-open-with-portal`](#xdg-open-with-portal)
- [Options](#options)

## Screenshots

![clean](./assets/clean.png)

![launcher](./assets/launcher.png)

![busy](./assets/busy.png)

![firefox](./assets/firefox.png)

## Overlays

See the following example for how to apply overlays from this flake.

```nix
{
	description = "";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
		unstable.url = "github:nixos/nixpkgs";

		snowfall-lib = {
			url = "github:snowfallorg/lib";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		plusultra = {
			url = "github:jakehamilton/config";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.unstable.follows = "unstable";
		};
	};

	outputs = inputs:
		inputs.snowfall-lib.mkFlake {
			inherit inputs;

			src = ./.;

			overlays = with inputs; [
				# Get all of the packages from this flake by using the main overlay.
				plusultra.overlay

        # Individual overlays can be accessed from
        # `plusultra.overlays.<name>`.
				plusultra.overlays."nixpkgs/at"
				plusultra.overlays."nixpkgs/chromium"
				plusultra.overlays."nixpkgs/comma"
				plusultra.overlays."nixpkgs/cowsay-plus"
				plusultra.overlays."nixpkgs/deploy-rs"
				plusultra.overlays."nixpkgs/discord"
				plusultra.overlays."nixpkgs/discord-canary"
				plusultra.overlays."nixpkgs/doukutsu-rs"
				plusultra.overlays."nixpkgs/firefox"
				plusultra.overlays."nixpkgs/firefox-nordic-theme"
				plusultra.overlays."nixpkgs/flyctl"
				plusultra.overlays."nixpkgs/frappe-books"
				plusultra.overlays."nixpkgs/freetube"
				plusultra.overlays."nixpkgs/gamescope"
				plusultra.overlays."nixpkgs/gnome"
				plusultra.overlays."nixpkgs/hey"
				plusultra.overlays."nixpkgs/infrared"
				plusultra.overlays."nixpkgs/kalidoface"
				plusultra.overlays."nixpkgs/kubecolor"
				plusultra.overlays."nixpkgs/linux"
				plusultra.overlays."nixpkgs/list-iommu"
				plusultra.overlays."nixpkgs/lutris"
				plusultra.overlays."nixpkgs/minecraft-forge"
				plusultra.overlays."nixpkgs/nix-get-protonup"
				plusultra.overlays."nixpkgs/nix-update-index"
				plusultra.overlays."nixpkgs/nixos-option"
				plusultra.overlays."nixpkgs/nixos-revision"
				plusultra.overlays."nixpkgs/nordic"
				plusultra.overlays."nixpkgs/obs"
				plusultra.overlays."nixpkgs/pocketcasts"
				plusultra.overlays."nixpkgs/prismlauncher"
				plusultra.overlays."nixpkgs/steam"
				plusultra.overlays."nixpkgs/titan"
				plusultra.overlays."nixpkgs/tmux"
				plusultra.overlays."nixpkgs/twitter"
				plusultra.overlays."nixpkgs/wallpapers"
				plusultra.overlays."nixpkgs/xdg-open-with-portal"
				plusultra.overlays."nixpkgs/yt-music"
			];
		};
}
```

## Packages

Packages can be used directly from the flake.

```nix
{
	description = "";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
		unstable.url = "github:nixos/nixpkgs";

		snowfall-lib = {
			url = "github:snowfallorg/lib";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		plusultra = {
			url = "github:jakehamilton/config";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.unstable.follows = "unstable";
		};
	};

  outputs = inputs:
		inputs.snowfall-lib.mkFlake {
			inherit inputs;

			src = ./.;

			outputs-builder = channels:
				let
					inherit (channels.nixpkgs) system;
					inherit (plusultra.packages.${system})
						hey
						titan
						nixos-option
						nixos-revision
						xdg-open-with-portal;
				in {
					# ...
				};
		};
}
```

### [`at`](./packages/at/default.nix)

[`@`](https://npm.im/@suchipi/at-js) - JavaScript stdio transformation tool.

### [`cowsay-plus`](./packages/cowsay-plus/default.nix)

A cowsay wrapper that loads random cows.

### [`discord-canary`](./packages/discord-canary/default.nix)

The canary version of [Discord](https://discord.com).

### [`doukutsu-rs`](./packages/doukutsu-rs/default.nix)

[`doukutsu-rs`](https://github.com/doukutsu-rs/doukutsu-rs) - A fully playable re-implementation of Cave Story (Doukutsu Monogatari) engine written in Rust.

### [`firefox-nordic-theme`](./packages/firefox-nordic-theme/default.nix)

[A dark theme for Firefox](https://github.com/EliverLara/firefox-nordic-theme) created using the [Nord](https://github.com/arcticicestudio/nord) color palette.

### [`frappe-books`](./packages/frappe-books/default.nix)

The AppImage build of [Frappe Books](https://frappebooks.com).

### [`hey`](./packages/hey/default.nix)

A Firefox wrapper for [HEY](https://hey.com).

### [`infrared`](./packages/infrared/default.nix)

A Minecraft [reverse proxy](https://github.com/haveachin/infrared).

### [`kalidoface`](./packages/kalidoface/default.nix)

Runs [Kalidoface](https://kalidoface.com) in Firefox.

### [`list-iommu`](./packages/list-iommu/default.nix)

A helper script to list IOMMU devices.

### [`nix-get-protonup`](./packages/nix-get-protonup/default.nix)

A helper script to install [Proton GE](https://github.com/GloriousEggroll/proton-ge-custom).

### [`nix-update-index`](./packages/nix-update-index/default.nix)

A helper script to fetch the latest index for nix-locate.

### [`nixos-option`](./packages/nixos-option/default.nix)

A flake-enabled version of `nixos-option`.

### [`nixos-revision`](./packages/nixos-revision/default.nix)

A helper script to get the configuration revision of the current system.

### [`steam`](./packages/steam/default.nix)

Extra desktop items for Steam to launch the application in Pipewire mode
or enable the gamepad UI.

### [`titan`](./packages/titan/default.nix)

A JavaScript [monorepo management tool](https://npm.im/@jakehamiton/titan).

### [`twitter`](./packages/twitter/default.nix)

A Firefox wrapper for Twitter.

### [`wallpapers`](./packages/wallpapers/default.nix)

A collection of wallpapers.

### [`xdg-open-with-portal`](./packages/xdg-open-with-portal/default.nix)

A replacement for `xdg-open` that fixes issues when using xwayland.

## Options

> _options documentation in progress._
