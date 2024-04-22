# Plus Ultra

<a href="https://nixos.wiki/wiki/Flakes" target="_blank"><img alt="Nix Flakes Ready" src="https://img.shields.io/static/v1?logo=nixos&logoColor=d8dee9&label=Nix%20Flakes&labelColor=5e81ac&message=Ready&color=d8dee9&style=for-the-badge"></a>
<a href="https://github.com/snowfallorg/lib" target="_blank"><img alt="Built With Snowfall" src="https://img.shields.io/static/v1?logoColor=d8dee9&label=Built%20With&labelColor=5e81ac&message=Snowfall&color=d8dee9&style=for-the-badge"></a>
<a href="https://jakehamilton.github.io/config" target="_blank"><img alt="Frost Documentation" src="https://img.shields.io/static/v1?logoColor=d8dee9&label=Frost&labelColor=5e81ac&message=Documentation&color=d8dee9&style=for-the-badge"></a>

&nbsp;

> ✨ Go even farther beyond.

- [Screenshots](#screenshots)
- [Overlays](#overlays)

## Screenshots

![clean](./assets/clean.png)

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
				plusultra.overlays.default

				# Individual overlays can be accessed from
				# `plusultra.overlays.<name>`.

				# These overlays pull packages from nixos-unstable or other sources.
				plusultra.overlays.bibata-cursors
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
				plusultra.overlays.top-bar-organizer
				plusultra.overlays.yt-music

				# Individual overlays for each package in this flake
				# are available for convenience.
				plusultra.overlays."package/at"
				plusultra.overlays."package/bibata-cursors"
				plusultra.overlays."package/cowsay-plus"
				plusultra.overlays."package/doukutsu-rs"
				plusultra.overlays."package/firefox-nordic-theme"
				plusultra.overlays."package/frappe-books"
				plusultra.overlays."package/hey"
				plusultra.overlays."package/infrared"
				plusultra.overlays."package/kalidoface"
				plusultra.overlays."package/list-iommu"
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
