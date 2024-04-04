{
  mkShell,
  nodejs,
  ags,
  sassc,
}:
mkShell {
  packages = [
    nodejs
    ags
    sassc
  ];
}
