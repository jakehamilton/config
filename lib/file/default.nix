{ lib, ... }:

rec {
  fileWithText = file: text: ''
    ${builtins.readFile file}
    ${text}'';

  fileWithText' = file: text: ''
    ${text}
    ${builtins.readFile file}'';
}
