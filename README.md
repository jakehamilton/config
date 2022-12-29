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
				plusultra.overlays.chromium
				plusultra.overlays.comma
				plusultra.overlays.default
				plusultra.overlays.deploy-rs
				plusultra.overlays.discord
				plusultra.overlays.firefox
				plusultra.overlays.flyctl
				plusultra.overlays.freetube
				plusultra.overlays.gamescope
				plusultra.overlays.gnome
				plusultra.overlays.kubecolor
				plusultra.overlays.linux
				plusultra.overlays.lutris
				plusultra.overlays.nordic
				plusultra.overlays.obs
				plusultra.overlays.pocketcasts
				plusultra.overlays.prismlauncher
				plusultra.overlays.tmux
				plusultra.overlays.yt-music

				# Individual overlays for each package in this flake
				# are available for convenience.
				plusultra.overlays."package/at"
				plusultra.overlays."package/cowsay-plus"
				plusultra.overlays."package/discord-canary"
				plusultra.overlays."package/doukutsu-rs"
				plusultra.overlays."package/firefox-nordic-theme"
				plusultra.overlays."package/frappe-books"
				plusultra.overlays."package/hey"
				plusultra.overlays."package/infrared"
				plusultra.overlays."package/kalidoface"
				plusultra.overlays."package/list-iommu"
				plusultra.overlays."package/minecraft-forge"
				plusultra.overlays."package/nix-get-protonup"
				plusultra.overlays."package/nix-update-index"
				plusultra.overlays."package/nixos-option"
				plusultra.overlays."package/nixos-revision"
				plusultra.overlays."package/steam"
				plusultra.overlays."package/titan"
				plusultra.overlays."package/twitter"
				plusultra.overlays."package/wallpapers"
				plusultra.overlays."package/xdg-open-with-portal"
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
