{ runCommand, lib, ... }:

let
  defaultMinecraftVersion = "1.19.2";
  defaultForgeVersion = "43.1.25";

  mkForgeInstaller = args@{ minecraft ? defaultMinecraftVersion, forge ? defaultForgeVersion, ... }:
    let
      version = "${minecraft}-${forge}";
      options = builtins.removeAttrs args [ "minecraft" "forge" ] // {
        inherit version;
      };

      installer = builtins.fetchurl {
        url = "https://maven.minecraftforge.net/net/minecraftforge/forge/${minecraft}-${forge}/forge-${minecraft}-${forge}-installer.jar";
        sha256 = "0slxcbd2p7hm01sy8miww9pjx32qw2g8cgl6a5705bf4lidza8xa";
      };
    in
    runCommand "minecraft-forge-installer" options
      ''
        mkdir -p $out/libexec

        ln -s ${installer} $out/libexec/installer.jar
      '';
in
(mkForgeInstaller { }) // {
  # Pass the `mkForgeInstaller` helper through so others can easily construct their own
  # package versions.
  inherit mkForgeInstaller;
}
