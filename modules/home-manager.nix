inputs@{ lib, home-manager, ... }:

{
    imports = [
        home-manager.nixosModules.home-manager
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPkgs = true;
}
