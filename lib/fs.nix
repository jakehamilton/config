inputs@{ lib, ... }:

let
  # Matches a file's name and its file extension (after the last period).
  fileNameRegex = "(.*)\\.(.*)$";
in rec {
  # Common assertions for files.
  isFileKind = lib.is "regular";
  isSymLinkKind = lib.is "symlink";
  isDirectoryKind = lib.is "directory";
  isUnknownKind = lib.is "unknown";

  hasFileExtension = file:
    lib.not null (builtins.match fileNameRegex (builtins.toString file));

  splitFileExtension = file:
    let match = (builtins.match fileNameRegex (builtins.toString file));
    in assert lib.assertMsg (lib.not null match)
      "File name must match file regex.";
    match;

  getFileName = file:
    if hasFileExtension file then
      builtins.concatStringsSep "" (lib.init (splitFileExtension file))
    else
      file;

  getFileExtension = file:
    if hasFileExtension file then lib.last (splitFileExtension file) else "";

  # Test whether or not a path refers to a *.nix file.
  isNixFile = path: lib.is "nix" (getFileExtension path);

  # Get a list of directory paths in a directory.
  getDirs = path:
    lib.mapAttrNames (name: path + "/${name}")
    (lib.filterAttrs (lib.only isDirectoryKind) (builtins.readDir path));

  # Get a list of file paths in a directory.
  getFiles = path:
    lib.mapAttrNames (name: path + "/${name}")
    (lib.filterAttrs (lib.only isFileKind) (builtins.readDir path));

  # Get a list of *.nix files in a directory.
  getModuleFiles = path: builtins.filter (isNixFile) (getFiles path);

  # Get a list of *.nix files in a directory *excluding* "default.nix".
  getModuleFilesWithoutDefault = path:
    builtins.filter (file: lib.not "default.nix" (builtins.baseNameOf file))
    (getModuleFiles path);
}
