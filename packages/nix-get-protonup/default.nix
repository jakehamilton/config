{
  lib,
  writeShellApplication,
  python311,
  venvDir ? "$HOME/.proton-up-venv",
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) override-meta;

  nix-get-proton-up = writeShellApplication {
    name = "nix-get-protonup";
    checkPhase = "";
    runtimeInputs = [ python311 ];
    text = ''
      venv="${venvDir}"

      python -m venv "$venv"

      source "$venv/bin/activate"

      python -m pip install --upgrade pip

      pip install protonup-ng

      protonup
    '';
  };

  new-meta = with lib; {
    description = "A helper for installing protonup on NixOS.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakehamilton ];
  };
in
override-meta new-meta nix-get-proton-up
