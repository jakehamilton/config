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

  getParentDir = file: builtins.baseNameOf (builtins.dirOf file);

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

  # Get a list of file paths in a directory recursively.
  getFilesRec = path:
    let
      entries = builtins.readDir path;
      filteredEntries =
        lib.filterAttrs (lib.only (lib.or' isFileKind isDirectoryKind)) entries;
      files = lib.mapConcatAttrsToList' filteredEntries (name: kind:
        let path' = "${path}/${name}";
        in if isFileKind kind then path' else getFilesRec path');
    in files;

  # Get a list of *.nix files in a directory.
  getModuleFiles = path: builtins.filter (isNixFile) (getFiles path);

  # Get a list of *.nix files in a directory recursively.
  getModuleFilesRec = path: builtins.filter (isNixFile) (getFilesRec path);

  # Get a list of *.nix files in a directory matching "default.nix".
  getModuleFilesDefault = path:
    builtins.filter (file: lib.is "default.nix" (builtins.baseNameOf file))
    (getModuleFiles path);

  # Get a list of *.nix files in a directory *excluding* "default.nix".
  getModuleFilesWithoutDefault = path:
    builtins.filter (file: lib.not "default.nix" (builtins.baseNameOf file))
    (getModuleFiles path);

  # Get a list of *.nix files in a directory recursively matching "default.nix".
  getModuleFilesDefaultRec = path:
    builtins.filter (file: lib.is "default.nix" (builtins.baseNameOf file))
    (getModuleFilesRec path);

  # Get a list of *.nix files in a directory recursively *excluding* "default.nix".
  getModuleFilesWithoutDefaultRec = path:
    builtins.filter (file: lib.not "default.nix" (builtins.baseNameOf file))
    (getModuleFilesRec path);

  getPathFromRoot = path:
    ../. + (if lib.hasPrefix "/" path then path else "/${path}");

  getSuitePath = name: getPathFromRoot "/suites/${name}.nix";

  getPresetPath = name: getPathFromRoot "/presets/${name}.nix";

  getModulePath = name: getPathFromRoot "/modules/${name}.nix";

  getUserPath = name: getPathFromRoot "/users/${name}";

  getOverlayPath = name: getPathFromRoot "/overlays/${name}.nix";

  getPackagePath = name: getPathFromRoot "/packages/${name}";
}
