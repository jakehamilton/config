{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "jakehamilton";
  repo = "firefox-nordic-theme";
  rev = "a3069796a1e6ec4166adf4d3dbb887da206fef97";
  sha256 = "07f790xbfxixsxb2c7nfn7zlqipzrkgxsqsf41jfafmapswh31f1";
  name = "firefox-nordic-theme";
}
