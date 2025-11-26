{ lib, username, host, ... }:
let
  vars = import ../../hosts/${host}/variables.nix;
  nopassEnabled = vars.nopasswdSudo or false;
in
{
  security.sudo = {
    enable = true;
    extraRules =
      lib.optionals nopassEnabled [
        {
          users = [ username ];
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
  };
}
