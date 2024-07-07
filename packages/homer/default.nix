{
  writeShellScriptBin,
  yarn2nix-moretea,
  fetchFromGitHub,
  coreutils,
  curl,
  gnused,
  jq,
  lib,
  namespace,
  # ...
  ...
}:
let
  version = "23.10.1";

  homer = yarn2nix-moretea.mkYarnPackage rec {
    pname = "homer";
    inherit version;

    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    src = fetchFromGitHub {
      owner = "bastienwirtz";
      repo = "homer";
      rev = "v${version}";
      sha256 = "uVSZCn8XhCraiLDfNRUqGhlMtT1W2PEWXbjiSeADa8s=";
    };

    meta = with lib; {
      description = "A very simple static homepage for your server.";
      homepage = "https://github.com/bastienwirtz/homer";
      license = licenses.asl20;
      maintainers = with maintainers; [ jakehamilton ];
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

    passthru = {
      update = writeShellScriptBin "update-homer" ''
        set -euo pipefail

        latest="$(${curl}/bin/curl -s "https://api.github.com/repos/bastienwirtz/homer/releases?per_page=1" | ${jq}/bin/jq -r ".[0].tag_name" | ${gnused}/bin/sed 's/^v//')"

        drift rewrite --auto-hash --new-version "$latest"
      '';
    };
  };
in
homer
