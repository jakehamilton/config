{
  lib,
  runCommandNoCC,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) override-meta;

  # Taken from https://docs.ubports.com/en/latest/userguide/install.html#missing-udev-rules
  rules = ./51-android.rules;

  new-meta = with lib; {
    description = "A helper to list all of the NixOS hosts available from your flake.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakehamilton ];
  };

  package =
    runCommandNoCC "ubports-udev-rules"
      {
        meta = with lib; {
          description = "udev rules for the ubports installer to recognize android devices.";
          homepage = "https://docs.ubports.com/en/latest/userguide/install.html#missing-udev-rules";
          license = licenses.gpl3;
          maintainers = with maintainers; [ jakehamilton ];
          platforms = [ "x86_64-linux" ];
        };
      }
      ''
        cp ${rules} 51-ubports.rules

        mkdir -p $out/lib/udev/rules.d

        substituteInPlace 51-ubports.rules \
          --replace 'GROUP="plugdev"' 'GROUP="ubports"'

        cp 51-ubports.rules $out/lib/udev/rules.d/51-ubports.rules
      '';
in
override-meta new-meta package
