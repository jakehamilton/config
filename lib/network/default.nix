{
  lib,
  inputs,
  snowfall-inputs,
}:

let
  inherit (inputs.nixpkgs.lib) assertMsg last;
in
{
  network = {
    # Split an address to get its host name or ip and its port.
    # Type: String -> Attrs
    # Usage: get-address-parts "bismuth:3000"
    #   result: { host = "bismuth"; port = "3000"; }
    get-address-parts =
      address:
      let
        address-parts = builtins.split ":" address;
        ip = builtins.head address-parts;
        host = if ip == "" then "127.0.0.1" else ip;
        port = if builtins.length address-parts != 3 then "" else last address-parts;
      in
      {
        inherit host port;
      };

    ## Create proxy configuration for NGINX virtual hosts.
    ##
    ## ```nix
    ## services.nginx.virtualHosts."example.com" = lib.network.create-proxy {
    ##   port = 3000;
    ##   host = "0.0.0.0";
    ##   proxy-web-sockets = true;
    ##   extra-config = {
    ##     forceSSL = true;
    ##   };
    ## }
    ## ``
    ##
    #@ { port: Int ? null, host: String ? "127.0.0.1", proxy-web-sockets: Bool ? false, extra-config: Attrs ? { } } -> Attrs
    create-proxy =
      {
        port ? null,
        host ? "127.0.0.1",
        proxy-web-sockets ? false,
        extra-config ? { },
      }:
      assert assertMsg (port != "" && port != null) "port cannot be empty";
      assert assertMsg (host != "") "host cannot be empty";
      extra-config
      // {
        locations = (extra-config.locations or { }) // {
          "/" = (extra-config.locations."/" or { }) // {
            proxyPass = "http://${host}${if port != null then ":${builtins.toString port}" else ""}";

            proxyWebsockets = proxy-web-sockets;
          };
        };
      };
  };
}
