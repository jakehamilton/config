{ lib, runCommandNoCC, ... }:

let
  # Taken from https://docs.ubports.com/en/latest/userguide/install.html#missing-udev-rules
  rules = ./51-android.rules;
in
runCommandNoCC "ubports-udev-rules"
{
  meta = with lib; {
    description = "udev rules for the ubports installer to recognize android devices.";
    homepage = "https://docs.ubports.com/en/latest/userguide/install.html#missing-udev-rules";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
  ''
    cp ${rules} 51-ubports.rules

    mkdir -p $out/lib/udev/rules.d

    substituteInPlace 51-ubports.rules \
      --replace 'GROUP="plugdev"' 'GROUP="ubports"'

    cp 51-ubports.rules $out/lib/udev/rules.d/51-ubports.rules
  ''
