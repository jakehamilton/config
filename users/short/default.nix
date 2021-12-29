{ ... }:

{
    users.users.short = {
        isNormalUser = true;
        # Only useful for `nixos-rebuild build-vm --flake .`
        # Since users are mutable, this should be changed after installation.
        initialPassword = "password";
        extraGroups = [ "wheel" "networkmanager" ];
    };
}