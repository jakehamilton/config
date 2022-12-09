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
  - [`doukutsu-rs`](#doukutsu-rs)
  - [`discord-chromium`](#discord-chromium)
  - [`logseq`](#logseq)
  - [`kalidoface-2d`](#kalidoface-2d)
  - [`kalidoface-3d`](#kalidoface-3d)
  - [`kubecolor`](#kubecolor)
  - [`frappe-books`](#frappe-books)
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
				plusultra.overlays."nixpkgs/chromium"
				plusultra.overlays."nixpkgs/comma"
				plusultra.overlays."nixpkgs/discord"
				plusultra.overlays."nixpkgs/discord-chromium"
				plusultra.overlays."nixpkgs/discord-firefox"
				plusultra.overlays."nixpkgs/flyctl"
				plusultra.overlays."nixpkgs/freetube"
				plusultra.overlays."nixpkgs/gnomeExtensions"
				plusultra.overlays."nixpkgs/kubecolor"
				plusultra.overlays."nixpkgs/linuxPackages_latest"
				plusultra.overlays."nixpkgs/lutris"
				plusultra.overlays."nixpkgs/nordic"
				plusultra.overlays."nixpkgs/obs-studio"
				plusultra.overlays."nixpkgs/obs-studio-plugins"
				plusultra.overlays."nixpkgs/pocketcasts"
				plusultra.overlays."nixpkgs/prismlauncher"
				plusultra.overlays."nixpkgs/tmuxPlugins"
				plusultra.overlays."nixpkgs/wrapOBS"
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
            discord-chromium
            kubecolor
            logseq;
        in {
          # ...
        };
    };
}
```

### [`doukutsu-rs`](https://github.com/doukutsu-rs/doukutsu-rs)

A fully playable re-implementation of Cave Story (Doukutsu Monogatari) engine written in Rust.

### `discord-chromium`

A chromium window that opens Discord under Wayland
with Pipewire support enabled.

### `logseq`

An updated version of Logseq that fixes wayland
and Git support.

### `kalidoface-2d`

Runs [Kalidoface](https://kalidoface.com/) in chromium.

### `kalidoface-3d`

Runs [Kalidoface 3D](https://3d.kalidoface.com/) in chromium.

### `frappe-books`

The AppImage build of [Frappe Books](https://frappebooks.com).

### Unstable

The following packages are pulled in from the unstable channel and
passed through.

- `chromium`
- `discord`
- `gopls`
- `kubecolor`
- `neovim-remote`
- `neovim-unwrapped`
- `obs-studio`
- `prismlauncher`
- `rust-analyzer`
- `sumneko-lua-language-server`
- `tree-sitter`

## Options

> _options documentation in progress._
