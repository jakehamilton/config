{ writeShellApplication }:

writeShellApplication {
  name = "note";
  checkPhase = "";
  text = builtins.readFile ./note.sh;
}
