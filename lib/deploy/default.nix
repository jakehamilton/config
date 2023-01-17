{ lib, inputs }:

let
  inherit (inputs) deploy-rs;
in
rec {
  mkDeploy = { self, overrides ? { } }:
    let
      hosts = self.nixosConfigurations or { };
      names = builtins.attrNames hosts;
      nodes = lib.foldl
        (result: name:
          let
            host = hosts.${name};
            user = host.config.plusultra.user.name or null;
            inherit (host.pkgs) system;
          in
          result // {
            ${name} = (overrides.${name} or { }) // {
              hostname = overrides.${name}.hostname or "${name}";
              profiles = (overrides.${name}.profiles or { }) // {
                system = (overrides.${name}.profiles.system or { }) // {
                  path = deploy-rs.lib.${system}.activate.nixos host;
                } // lib.optionalAttrs (user != null) {
                  user = "root";
                  sshUser = user;
                } // lib.optionalAttrs
                  (host.config.plusultra.security.doas.enable or false)
                  {
                    sudo = "doas -u";
                  };
              };
            };
          })
        { }
        names;
    in
    { inherit nodes; };
}
