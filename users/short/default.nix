{ ... }:

{
    users.users.short = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
    };
}