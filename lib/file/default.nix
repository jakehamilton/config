{ lib, ... }:

rec {
  ## Append text to the contents of a file
  ##
  ## ```nix
  ## fileWithText ./some.txt "appended text"
  ## ```
  ##
  #@ Path -> String -> String
  fileWithText = file: text: ''
    ${builtins.readFile file}
    ${text}'';

  ## Prepend text to the contents of a file
  ##
  ## ```nix
  ## fileWithText' ./some.txt "prepended text"
  ## ```
  ##
  #@ Path -> String -> String
  fileWithText' = file: text: ''
    ${text}
    ${builtins.readFile file}'';
}
