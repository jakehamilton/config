{
  lib,
  plusultra,
  fetchFromGitHub,
  runCommandNoCC,
  callPackage,
  unzip,
  favicon ? "light",
  namespace,
  ...
}:
let
  homer = plusultra.homer;

  is-valid-favicon = favicon == "light" || favicon == "dark";

  flavors = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];

  stylesheet = flavor: "assets/catppuccin-${flavor}.css";

  catppuccin-raw = fetchFromGitHub {
    owner = "mrpbennett";
    repo = "catppucin-homer";
    rev = "b1d081ec58f0769a19d462c650d3243c5c718b95";
    sha256 = "1rs77kn2iyp3hdbq7r6skzj2lg1cjhiiifnw8zvplwp7avrf8i4p";
  };

  catppuccin =
    runCommandNoCC "catpuccin"
      {
        src = catppuccin-raw;
        buildInputs = [ unzip ];
      }
      (
        ''
          mkdir $out

          cp -r --no-preserve=mode $src/assets $out/

          mv $out/assets/images/backgrounds/* $out/assets/images/
          rm -rf $out/assets/images/backgrounds
          rm -rf $out/assets/images/examples

          rm -rf $out/assets/palette

          cp $src/flavours/* $out/assets/
        ''
        + lib.optionalString is-valid-favicon ''
          mkdir -p $out/assets/icons

          unzip $out/assets/favicons/${favicon}_favicon.zip -d $out/assets/icons/

        ''
        + ''
          rm -rf $out/assets/favicons
        ''
      );

  homer-catppuccin = homer.overrideAttrs (prevAttrs: {
    inherit catppuccin;

    passthru = (prevAttrs.passthru or { }) // {
      stylesheets = builtins.foldl' (
        stylesheets: flavor: stylesheets // { ${flavor} = stylesheet flavor; }
      ) { } flavors;

      logos = {
        dark = "assets/logos/dark_circle.png";
        light = "assets/logos/light_circle.png";
      };
    };

    postBuild = ''
      dist="deps/${homer.pname}/dist"

      files=($(find $catppuccin/** -type f -exec echo {} \;))

      strip() {
        printf '%s\n' "''${1/$2}"
      }

      for file in "''${files[@]}"; do
        relative_file="$(strip "$file" "$catppuccin/")"
        dist_file="$dist/$relative_file"

        mkdir -p "$(dirname "$dist_file")"
        cp -f "$file" "$dist_file"
      done
    '';
  });
in
homer-catppuccin
