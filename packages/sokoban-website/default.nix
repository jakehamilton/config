{ lib, runCommandNoCC, inputs, ... }:

runCommandNoCC "sokoban-website"
{ src = inputs.sokoban-app-website.outPath; }
  ''
    ln -s $src $out 
  ''
