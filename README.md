# Plus Ultra

> ✨ Go even farther beyond.

## Foreword

Welcome, this is my repository for configuration and packages that I use on my machines. Here you will find all the
declarative code I manage my laptops, desktops, and servers with. Originally, this repository began with a single
`default.nix` file declaring a single system configuration for my desktop computer. Over time I wanted to bring Nix
to more machines and needed to grow the configuration in a maintainable way. At the time, Nix Flakes seemed like the
solution, but there were still issues. One issue was boilerplate, some of which libraries like `flake-utils` and
`flake-utils-plus`. I wanted something more "automatic" and didn't personally like the direction that `flake-parts`
was going (though I do think it is a good project), so I build out [Snowfall Lib](https://snowfall.org) to solve this
problem. Snowfall Lib was used for my projects for quite some time, saving me headaches by letting me avoid all the
normal wiring that one needs to do for complex Nix projects. However, over time
[Nix Flakes' troubles became more and more clear to me](https://kilo.bytesize.xyz/flakes-have-failed). Thanks to
another project completing, Aux Lib gave me the opportunity to try to build a new, standalone solution for Nix
projects. At the time of writing, this new solution is still in early development and should not be considered stable.
However, I have been using it for well over a year now for all of my systems and projects with great success. If this
repository looks different than other Nix configuration repositories and projects, that is because it is. Instead of
the usual ecosystem solutions, here I am using [Nilla](https://nilla.dev).

## Usage

So long as you adhere to the license of this repository, you are welcome to use it in any way you see fit. You can
use the configuration as it exists by default, but unless you share the same names as me and my devices, you'll
probably want to customize the settings applied to different modules. There is one hard boundary that exists in this
repository which separates [Aux Lib](https://git.auxolotl.org/auxolotl/lib) modules and NixOS modules. Aux Lib
modules are used for the Nilla project at the top level while NixOS modules are used for NixOS configuration, macOS
configuration, and Home Manager configuration. The two module systems are not compatible, so you must use the
appropriate helpers when creating options for each. For example, NixOS modules use `lib.mkOption` from Nixpkgs'
library while Aux Lib modules use `lib.options.create` from Aux Lib.

### Use As A Dependency

If you want to pull in this repository as a Nix dependency so you can include its modules or packages in your own
configuration, you can do so easily.

#### Fetching

You can use any fetcher that you prefer for pulling this repository into your project. This includes `npins`, Nix
Flakes, `builtins.fetchTarball`, and others.

##### Fetch With `npins`

Add a new pin for this repository's main branch, giving it whatever name you want.

```bash
npins add github jakehamilton config --branch main --name jakehamilton-nix
```

##### Fetch With Flakes

Add this repository as an input.

```nix
{
	inputs = {
		jakehamilton-nix = {
			url = "github:jakehamilton/config";
			flake = false;
		};
	};

	outputs = inputs:
		let
			# This repository is not a Nix Flake so it needs to be imported manually.
			jakehamilton-nix = import inputs.jakehamilton-nix;
		in
		{
			# ...
		};
}
```

##### Fetch With Builtin

If you prefer to fetch this repository manually, you can directly call one of the Nix builtins.

```nix
builtins.fetchTarball {
	url = "https://github.com/jakehamilton/config/archive/main.tar.gz";
	sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
};
```

#### Importing

To import this project, you can do so within another Nilla project, using a helper, or manually.

##### Import With Nilla

Add the fetched repository as an input in your project and it will be automatically imported.

```nix
let
	pins = import ./npins;
in
{
	config = {
		inputs.jakehamilton-nix = {
			src = pins.jakehamilton-nix;
		};
	};
}
```

##### Import With `idc`.

Ask `idc` to import the fetched repository.

```nix
let
	idc = import ./idc.nix;
	pins = import ./npins;
in
	idc {
		src = pins.jakehamilton-nix;
	}
```

##### Import Manually

You can also import and manipulate the project manually by referencing the `nilla.nix` entrypoint directly.

```nix
let
	pins = import ./npins;
in
	builtins.import "${pins.jakehamilton-nix}/nilla.nix";
```

### Use As A Copy

If you want to make direct changes to modules or packages in this repository, it may be necessary to fork this project
and make it your own. To do so, you can [fork it on GitHub](https://github.com/jakehamilton/config/fork) or clone it
for your own local use.

```bash
git clone git@github.com:jakehamilton/config.git jakehamilton-nix
```

Once done, you can directly modify any configuration necessary. Have fun!
