{ pkgs, ... }:
pkgs.fetchFromGitHub {
  owner = "EliverLara";
  repo = "firefox-nordic-theme";
  rev = "287c6b4a94361a038d63f2fa7b62f9adfc08fe02";
  sha256 = "1bh7jslgscfn84bblsjixrywvpb6bdmdqk5y8aaisvbclmj33iz9";
  name = "firefox-nordic-theme";
}
