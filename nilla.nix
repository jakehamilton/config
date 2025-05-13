let
  pins = import ./npins;

  nilla = import pins.nilla;
in
nilla.create {
  includes = [
    ./nilla

    "${pins.nilla-nixos}/modules/nixos.nix"
  ];
}
