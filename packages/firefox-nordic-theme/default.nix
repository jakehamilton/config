{ pkgs, ... }:

pkgs.fetchFromGitHub {
  owner = "glasket";
  repo = "firefox-nordic-theme";
  rev = "8e5c529bc30072b0bebe4cbe540c8a4f2d4180a0";
  sha256 = "1m5d804yqc17q3cnfb315gn518yik78xz47igr83p4c999w9078i";
  name = "firefox-nordic-theme";
}
