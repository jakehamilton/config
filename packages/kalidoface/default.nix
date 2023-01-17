{ lib, makeDesktopItem, firefox, symlinkJoin, ... }:

let
  with-meta = lib.internal.override-meta {
    platforms = lib.platforms.linux;
    broken = firefox.meta.broken;
  };

  kalidoface-2d = with-meta (makeDesktopItem {
    name = "Kalidoface 2D";
    desktopName = "Kalidoface 2D";
    genericName = "Animate Live2D characters using just your browser webcam!";
    exec = ''
      ${firefox}/bin/firefox "https://kalidoface.com/?plusultra.app=true"'';
    icon = ./icon-2d.svg;
    type = "Application";
    categories = [ "Network" ];
    terminal = false;
  });
  kalidoface-3d = with-meta (makeDesktopItem {
    name = "Kalidoface 3D";
    desktopName = "Kalidoface 3D";
    genericName =
      "Animate character faces, poses and fingers in 3D using just your browser webcam!";
    exec = ''
      ${firefox}/bin/firefox "https://3d.kalidoface.com/?plusultra.app=true"'';
    icon = ./icon-3d.svg;
    type = "Application";
    categories = [ "Network" ];
    terminal = false;
  });
in
with-meta (
  symlinkJoin {
    name = "kalidoface-desktop-items";
    paths = [ kalidoface-2d kalidoface-3d ];
  }
)
