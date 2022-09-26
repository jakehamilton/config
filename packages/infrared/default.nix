{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "infrared";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "haveachin";
    repo = "infrared";
    rev = "v${version}";
    sha256 = "2DkPGq7/9Ow/c4GP8Ca9gzKmSWMot7G+BaGDhUJfNHI=";
  };

  vendorSha256 = "vUKz+Y2ekOGgDROkoSch+feXZhFOvs6hQgR8LIjCkNY=";

  meta = with lib; {
    description = "An ultra lightweight minecraft reverse proxy and idle placeholder";
    homepage = "https://github.com/haveachin/infrared";
    license = licenses.asl20;
  };
}
