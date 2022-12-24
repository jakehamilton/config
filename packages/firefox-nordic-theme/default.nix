{ pkgs, lib, ... }:

pkgs.fetchFromGitHub {
  owner = "jakehamilton";
  repo = "firefox-nordic-theme";
  rev = "4f9d6967671a8a193fa20438cc11c728da2b8e4c";
  sha256 = "018scrxxp83cwchspimrfx0r1vyly0s4g1sshzl2abfbcjan2q96";
  name = "firefox-nordic-theme";
}
