{ lib
, writeShellApplication
, python311
, venvDir ? "$HOME/.proton-up-venv"
, ...
}:

writeShellApplication
{
  name = "nix-get-protonup";
  checkPhase = "";
  runtimeInputs = [
    python311
  ];
  text = ''
    venv="${venvDir}"

    python -m venv "$venv"

    source "$venv/bin/activate"

    python -m pip install --upgrade pip

    pip install protonup-ng

    protonup
  '';
} 
