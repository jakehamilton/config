# Plus Ultra

> ✨ Go even farther beyond.

- [Screenshots](#screenshots)
- [Installation](#installation)
  - [Nix Flakes](#nix-flakes)
  - [Cloning Directly](#cloning-directly)
- [Hosts](#hosts)
  - [Alternate Hosts](#alternate-hosts)
    - [Supported Targets](#supported-targets)
- [Overlays](#overlays)
- [Packages](#packages)
  - [`discord-chromium`](#discord-chromium)
  - [`logseq`](#logseq)
  - [`kubecolor`](#kubecolor)
- [Options](#options)

## Screenshots

![clean](./assets/clean.png)

![launcher](./assets/launcher.png)

![busy](./assets/busy.png)

![firefox](./assets/firefox.png)

## Installation

There are multiple ways to install and configure your
system using this repository.

- [Nix Flakes](#nix-flakes)
- [Cloning Directly](#cloning-directly)

### Nix Flakes

Add this flake as an input for yours.

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    plusultra = {
      url = "github:jakehamilton/config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Then create your flake output.

```nix
{
  # ...

  outputs = inputs@{ self, nixpkgs, utils, plusultra }:
    utils.lib.mkFlake {
      inherit self inputs lib;
    };
}
```

Next, configure your channels and overlays.

```nix
{
  # ...

  outputs = inputs@{ self, nixpkgs, utils, plusultra }:
    utils.lib.mkFlake {
      # ...

      # You probably want unfree software 😦.
      channelsConfig = { allowUnfree = true; };

      channels.nixpkgs.overlaysBuilder = channels: [
        # Add packages from Plus Ultra.
        plusultra.overlays."nixpkgs/plusultra"
        plusultra.overlays."nixpkgs/logseq"
        plusultra.overlays."nixpkgs/kubecolor"
        plusultra.overlays."nixpkgs/discord-chromium"
      ]
        # If you want all overlays from Plus Ultra
        # replace the above lines with this one.
        ++ (plusultra.lib.mkOverlays {} channels)

        # If you have a directory of overlays.
        # See the "Overlays" section for more information.
        ++ (plusultra.lib.mkOverlays { src = ./overlays; } channels);
    };
}
```

Finally, add your hosts.

```nix
{
  # ...

  outputs = inputs@{ self, nixpkgs, utils, plusultra }:
    utils.lib.mkFlake {
      # ...

      # See the "Hosts" section for more information.
      hosts = plusultra.lib.mkHosts {
        src = ./machines;

        # Optionally add extra configuration based on machine name.
        hostOptions = {
          "my-hostname" = {
            modules = [ ./my-special-module.nix ];
          };
        };
      };
    };
}
```

Now you can build your new system configuration.

```shell
# On NixOS
sudo nixos-rebuild switch --flake .#my-hostname

# On macOS
sudo darwin-rebuild switch --flake .#my-hostname
```

Done! 🥳

### Cloning Directly

```shell
git clone git@github.com:jakehamilton/config.git
```

Now you can build your new system configuration.

```shell
# On NixOS
sudo nixos-rebuild switch --flake .#my-hostname

# On macOS
sudo darwin-rebuild switch --flake .#my-hostname
```

While this method may be faster, it makes you
responsible for updating versions and fixing conflicts
that will only occur when working off of the
same repository. I heavily recommend using
[Nix Flakes](#nix-flakes) in your own project.

## Hosts

Host machines can be configured using the directory
naming structure `machines/<arch>/<name>` where
`<arch>` is the system architecture (eg. `x86_64-linux`)
and `<name>` is the hostname of the system.

The `lib.mkHost` utility can be used to create system
configuration using the above structure.

```nix
{
  # ...

  outputs = inputs@{ self, nixpkgs, utils, plusultra }:
    utils.lib.mkFlake {
      # ...

      # The output of `mkHosts` is set directly on
      # the `hosts` attribute.
      hosts = plusultra.lib.mkHosts {
        # The `src` directory is your machines directory.
        # If your folder structure is `machines/<arch>/<name>`
        # then the `src` here is `./machines`.
        src = ./machines;
      }
    };
}
```

Each host is expected to have a `default.nix` file
in its directory. This is the only file that will be
imported for the host, so you can safely have other
files in the directory. Hardware configuration is a
good example of a second config file to have co-located.

The overall structure may look like the following.

```
. (root)
|
|-- machines/
|   |-- x86_64-linux/ (or the name of your arch)
|       |-- jasper/ (or the name of your system)
|           |-- default.nix
|           |-- hardware.nix (this, and all files other than default.nix, are optional)
```

The `default.nix` file is a standard NixOS
(or nix-darwin) configuration file.

### Alternate Hosts

The `mkHosts` helper supports extended system types using
[nixos-generators](https://github.com/nix-community/nixos-generators).
Using a supported format in the system type will produce a
build artifact for the target.

For example, to build a Virtualbox ova file, create the
the path `machines/x86_64-virtualbox/<name>/default.nix`.

Then build the system.

```shell
nix build .#virtualboxConfigurations.<name>
```

All alternate host targets are added to the flake at:
`<format>Configurations.<name>` where `<format>` is the
system type (eg. `virtualbox`) and `<name>` is the name
of the folder your configuration lives in (eg.
`machines/x86_64-iso/my-name`).

#### Supported Targets

| format               | description                                                                              |
| -------------------- | ---------------------------------------------------------------------------------------- |
| amazon               | Amazon EC2 image                                                                         |
| azure                | Microsoft azure image (Generation 1 / VHD)                                               |
| cloudstack           | qcow2 image for cloudstack                                                               |
| do                   | Digital Ocean image                                                                      |
| gce                  | Google Compute image                                                                     |
| hyperv               | Hyper-V Image (Generation 2 / VHDX)                                                      |
| install-iso          | Installer ISO                                                                            |
| install-iso-hyperv   | Installer ISO with enabled hyper-v support                                               |
| iso                  | ISO                                                                                      |
| kexec                | kexec tarball (extract to / and run /kexec_nixos)                                        |
| kexec-bundle         | same as before, but it's just an executable                                              |
| kubevirt             | KubeVirt image                                                                           |
| lxc                  | create a tarball which is importable as an lxc container, use together with lxc-metadata |
| lxc-metadata         | the necessary metadata for the lxc image to start                                        |
| openstack            | qcow2 image for openstack                                                                |
| proxmox              | [VMA](https://pve.proxmox.com/wiki/VMA) file for proxmox                                 |
| qcow                 | qcow2 image                                                                              |
| raw                  | raw image with bios/mbr                                                                  |
| raw-efi              | raw image with efi support                                                               |
| sd-aarch64           | Like sd-aarch64-installer, but does not use default installer image config.              |
| sd-aarch64-installer | create an installer sd card for aarch64                                                  |
| vagrant-virtualbox   | VirtualBox image for [Vagrant](https://www.vagrantup.com/)                               |
| virtualbox           | virtualbox VM                                                                            |
| vm                   | only used as a qemu-kvm runner                                                           |
| vm-bootloader        | same as vm, but uses a real bootloader instead of netbooting                             |
| vm-nogui             | same as vm, but without a GUI                                                            |
| vmware               | VMWare image (VMDK)                                                                      |

## Overlays

Overlays can be created with the `mkOverlays` helper.
Place overlays in a directory such as `./overlays` and
provide the folder to the `mkOverlays` helper.

**NOTE**: All `*.nix` files within `src` named
`default.nix` will be imported.

```nix
{
  # ...

  outputs = inputs@{ self, nixpkgs, utils, plusultra }:
    utils.lib.mkFlake {
      # ...

      channels.nixpkgs.overlaysBuilder = channels: [
        # Individual overlays can be accessed from
        # `plusultra.overlays.<name>`.
        plusultra.overlays."nixpkgs/plusultra"
        plusultra.overlays."nixpkgs/logseq"
        plusultra.overlays."nixpkgs/kubecolor"
        plusultra.overlays."nixpkgs/discord-chromium"
      ]
        # To apply all overlays from Plus Ultra.
        ++ (plusultra.lib.mkOverlays {} channels)

        # To add your own overlays, pass the directory
        # where your overlays are. All `*.nix` that are **not**
        # named `default.nix` will be imported.
        ++ (plusultra.lib.mkOverlays { src = ./overlays; } channels);
    };
}
```

Overlays for use with `mkOverlay` are designed to take
three arguments: `inputs`, `final`, `prev`. The `inputs`
argument can be particularly useful for getting access to
other channels or flake inputs.

```nix
# `inputs` contains the raw flake inputs, `channels` which
# contains the input channels for the system's architecture,
# `lib` which is the same as `plusultra.lib`, and `pkgs` which
# is the default channel (typically `nixpkgs`).
inputs@{ lib, pkgs, channels, ... }:

final: prev: {
  my-package = pkgs.runCommand "my-package" {} ''
    echo "my cool package" > $out
  '';
}
```

## Packages

Packages can be used directly from the flake.

```nix
{
  # ...
  outputs = { self, nixpkgs, plusultra }:
    utils.lib.mkFlake {
      inherit inputs self;

      outputsBuilder = channels:
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

### `discord-chromium`

A chromium window that opens Discord under Wayland
with Pipewire support enabled.

### `logseq`

An updated version of Logseq that fixes wayland
and Git support.

### `kubecolor`

Pulls in `kubecolor` from the unstable channel.

## Options

> _options documentation in progress._
