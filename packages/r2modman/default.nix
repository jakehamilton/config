{
  pkgs,
  lib,
  ...
}: let
  pname = "r2modman";
  version = "3.1.45";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://github.com/ebkr/r2modmanPlus/releases/download/v${version}/${name}.AppImage";
    sha256 = "15gj6yp29hbc2p2safnps12cwxl1l12lgw9z93nvxwn2q8h83lks";
  };

  appimageContents = pkgs.appimageTools.extractType2 {inherit name src;};
in
  pkgs.appimageTools.wrapType2 rec {
    inherit name src;

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
      maintainers = with maintainers; [jakehamilton];
      platforms = ["x86_64-linux"];
      mainProgram = "r2modman";
    };
  }
