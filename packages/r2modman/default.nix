{
  pkgs,
  lib,
  writeShellScriptBin,
  curl,
  jq,
  gnused,
  namespace,
  ...
}:
let
  pname = "r2modman";
  version = "3.1.48";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://github.com/ebkr/r2modmanPlus/releases/download/v${version}/${name}.AppImage";
    sha256 = "/eXPmeS/cO3zn8WaJ4s+yowWtXKPa0qdANW82ANmD1M=";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
in
pkgs.appimageTools.wrapType2 rec {
  inherit name src version;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop

    ${pkgs.imagemagick}/bin/convert ${appimageContents}/${pname}.png -resize 512x512 ${pname}_512.png

    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
    	--replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
  '';

  meta = with lib; {
    description = "A simple and easy to use mod manager for several games using Thunderstore.";
    homepage = "https://github.com/ebkr/r2modmanPlus";
    license = licenses.mit;
    maintainers = with maintainers; [ jakehamilton ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "r2modman";
  };

  passthru = {
    # NOTE: `appimageTools` doesn't pass through the version of the package to the resulting
    # derivation. We need this for Drift to be able to swap out the previous version with the
    # latest one.
    inherit version;

    update = writeShellScriptBin "r2modman-update" ''
      set -euo pipefail

      latest="$(${curl}/bin/curl -s "https://api.github.com/repos/ebkr/r2modmanPlus/releases?per_page=1" | ${jq}/bin/jq -r ".[0].tag_name" | ${gnused}/bin/sed 's/^v//')"

      drift rewrite --auto-hash --new-version "$latest"
    '';
  };
}
