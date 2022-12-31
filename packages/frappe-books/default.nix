{ pkgs, lib, ... }:

let
  pname = "frappe-books";
  version = "0.4.3-beta.0";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url =
      "https://github.com/frappe/books/releases/download/v${version}/Frappe-Books-${version}.AppImage";
    sha256 = "03c8xxlzdiy7jinijds6mxyar6xr29zvf2kqanz9l24wc3pj28yj";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit name src; };
in
pkgs.appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/frappe-books.desktop $out/share/applications/${pname}.desktop

    ${pkgs.imagemagick}/bin/convert ${appimageContents}/frappe-books.png -resize 512x512 ${pname}_512.png

    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
    	--replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
  '';

  meta = with lib; {
    description =
      "Free Desktop Accounting Software for small-businesses and freelancers.";
    homepage = "https://frappebooks.com/";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
