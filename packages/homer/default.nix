{
  yarn2nix-moretea,
  fetchFromGitHub,
  lib,
  ...
}: let
  homer = yarn2nix-moretea.mkYarnPackage rec {
    pname = "homer";
    version = "unstable-2023-06-23";

    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    src = fetchFromGitHub {
      owner = "bastienwirtz";
      repo = "homer";
      rev = "df903a2c048d5addee00d1d840ca64a181a3adc9";
      sha256 = "1nbc3dhl7giimn4ln1vljwznxbp8g2apbhzxcbr0g8m3rdjcnf59";
    };

    meta = with lib; {
      description = "A very simple static homepage for your server.";
      homepage = "https://github.com/bastienwirtz/homer";
      license = licenses.asl20;
      maintainers = with maintainers; [
        jakehamilton
      ];
    };

    doDist = false;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      yarn build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/${pname}

      cp -r deps/${pname}/dist/* $out/share/${pname}/

      runHook postInstall
    '';
  };
in
  homer
