# Taken from https://github.com/LunNova/nixos-configs
# 💖 Thank you!

# Use your own electron to run discord
# Nix version of https://aur.archlinux.org/packages/discord_arch_electron/
# TODO: Remove most of these deps
{ discord-canary, pname ? discord-canary.pname, version ? discord-canary.version
, src ? discord-canary.src, meta ? discord-canary.meta
, binaryName ? "DiscordCanary", desktopName ? "Discord Canary", autoPatchelfHook
, makeDesktopItem, lib, stdenv, wrapGAppsHook, electron_15
, electron ? electron_15, alsa-lib, at-spi2-atk, at-spi2-core, atk, cairo, cups
, dbus, expat, ffmpeg-full, ffmpeg ? ffmpeg-full, fontconfig, freetype
, gdk-pixbuf, glib, gtk3, libatomic_ops, libcxx, libdrm, libnotify
, libpulseaudio, libuuid, libX11, libXScrnSaver, libXcomposite, libXcursor
, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst, libxcb
, libxshmfence, mesa, nspr, nss, pango, systemd, libappindicator-gtk3
, libdbusmenu, writeScript, common-updater-scripts, nodePackages, ... }:

let
  inherit (nodePackages) asar;
  libPath = lib.makeLibraryPath [
    libcxx
    systemd
    libpulseaudio
    libdrm
    mesa
    stdenv.cc.cc
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libatomic_ops
    libnotify
    libX11
    libXcomposite
    libuuid
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    nspr
    nss
    libxcb
    pango
    libXScrnSaver
    libappindicator-gtk3
    libdbusmenu
  ];

  desktopItem = makeDesktopItem {
    name = pname;
    exec = binaryName;
    icon = pname;
    inherit desktopName;
    genericName = meta.description;
    categories = "Network;InstantMessaging;";
    mimeType = "x-scheme-handler/discord;";
  };
in stdenv.mkDerivation {
  inherit pname version src;
  meta = meta // { mainProgram = binaryName; };

  nativeBuildInputs = [
    alsa-lib
    cups
    libdrm
    libuuid
    libXdamage
    libX11
    libXScrnSaver
    libXtst
    libxcb
    libxshmfence
    mesa
    nss
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/{bin,opt/${binaryName},share/pixmaps}
    ls
    rm -rf *.so ${binaryName} chrome-sandbox swiftshader
    # HACKS FOR SYSTEM ELECTRON
    ${asar}/bin/asar e resources/app.asar resources/app
    ls resources
    rm resources/app.asar
    sed -i "s|process.resourcesPath|'$out/opt/${binaryName}/resources/'|" resources/app/app_bootstrap/buildInfo.js
    sed -i "s|exeDir,|'$out/share/pixmaps/',|" resources/app/app_bootstrap/autoStart/linux.js
    ${asar}/bin/asar p resources/app resources/app.asar --unpack-dir '**'
    rm -rf resources/app
    ls resources
    mv * $out/opt/${binaryName}

    makeWrapper ${electron}/bin/electron $out/opt/${binaryName}/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --add-flags $out/opt/${binaryName}/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" \
        --run "cd $out/opt/${binaryName}/resources/" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/${binaryName}

    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
    # Without || true the install would fail on case-insensitive filesystems
    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${
      lib.strings.toLower binaryName
    } || true
    ln -s $out/opt/${binaryName}/discord.png $out/share/pixmaps/${pname}.png
    ln -s "${desktopItem}/share/applications" $out/share/
  '';

  passthru.updateScript = writeScript "discord-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnugrep common-updater-scripts
    set -eou pipefail;
    url=$(curl -sI "https://discordapp.com/api/download/${
      builtins.replaceStrings [ "discord-" "discord" ] [ "" "stable" ] pname
    }?platform=linux&format=tar.gz" | grep -oP 'location: \K\S+')
    version=''${url##https://dl*.discordapp.net/apps/linux/}
    version=''${version%%/*.tar.gz}
    update-source-version ${pname} "$version" --file=./pkgs/applications/networking/instant-messengers/discord/default.nix
  '';
}
