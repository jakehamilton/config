{ channels, ... }:

final: prev: {
  kalidoface-2d = prev.makeDesktopItem {
    name = "Kalidoface 2D";
    desktopName = "Kalidoface 2D";
    genericName = "Animate Live2D characters using just your browser webcam!";
    exec = ''${final.chromium}/bin/chromium --app="https://kalidoface.com/"'';
    icon = ./icon-2d.svg;
    type = "Application";
    categories = "Network;";
    terminal = "false";
  };
  kalidoface-3d = prev.makeDesktopItem {
    name = "Kalidoface 3D";
    desktopName = "Kalidoface 3D";
    genericName =
      "Animate character faces, poses and fingers in 3D using just your browser webcam!";
    exec =
      ''${final.chromium}/bin/chromium --app="https://3d.kalidoface.com/"'';
    icon = ./icon-3d.svg;
    type = "Application";
    categories = "Network;";
    terminal = "false";
  };
}
