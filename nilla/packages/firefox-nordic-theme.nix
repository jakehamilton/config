{
  config.packages.firefox-nordic-theme = {
    systems = [ "x86_64-linux" ];

    package = { fetchFromGitHub, ... }:
      fetchFromGitHub {
        owner = "EliverLara";
        repo = "firefox-nordic-theme";
        rev = "21b79cca716af87b8a2b9e420c0e1d3d08b67414";
        sha256 = "0pgxrjqqsabnhsq21cgnzdwyfwc4ah06qk0igzwwsf56f2sgs4yv";
        name = "firefox-nordic-theme";
      };
  };
}
