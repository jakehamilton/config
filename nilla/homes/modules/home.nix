{ lib, osConfig ? { }, ... }:
{
  config = {
    home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "23.11");
  };
}
