{ lib, ... }:

rec {
  fileWithText = file: text:
    "${builtins.readFile file}\n${text}";

  fileWithText' = file: text:
    "${text}\n${builtins.readFile file}";
}
