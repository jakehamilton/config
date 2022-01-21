{ channels, ... }:

final: prev:

{
  # The version in unstable appears to be broken right now.
  # Uncomment this when it is fixed.
  # inherit (channels.nixpkgs-unstable) logseq;
  logseq = prev.logseq.overrideAttrs (oldAttrs:
    let
      version = "0.5.8";
      inherit (oldAttrs) pname;
      src = prev.fetchurl {
        url =
          "https://github.com/logseq/logseq/releases/download/${version}/Logseq-linux-x64-${version}.AppImage";
        sha256 = "1vblav210gf55vim3ani4aqdiss6i9lbrl4690914mlb58l731ss";
        name = "${pname}-${version}";
      };
      appimageContents = prev.appimageTools.extract {
        name = "${pname}-${version}";
        inherit src;
      };
    in {
      inherit version src appimageContents;

      buildInputs = oldAttrs.buildInputs or [ ] ++ [ prev.makeWrapper ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/share/${pname} $out/share/applications
        cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
        cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace Exec=Logseq Exec=${pname} \
          --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png
        runHook postInstall
      '';

      # The original fixup was using `electron_16` which fails for this project.
      postFixup = ''
        # @NOTE(jakehamilton): Logseq doesn't render properly
        # on Wayland by default. We need to pass two params
        # to make it render correctly in addition to running the
        # app with electron.
        makeWrapper ${prev.electron_15}/bin/electron $out/bin/${pname} \
          --add-flags $out/share/${pname}/resources/app \
          --add-flags "--enable-features=UseOzonePlatform" \
          --add-flags "--ozone-platform=wayland" \
          --suffix PATH : ${prev.lib.makeBinPath [ prev.git ]}


        # By default Logseq has issues running Git. It looks for it in the
        # `dugite` module, but since Nix doesn't link things there it won't find it.
        # So instead we link the package ourselves.
        rm -r $out/share/logseq/resources/app/node_modules/dugite/git
        ln -s ${prev.git} $out/share/logseq/resources/app/node_modules/dugite/git
      '';
    });
}
