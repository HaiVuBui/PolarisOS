{ config, lib, username, ... }:
{
  security.sudo = {
    enable = true;
    extraRules = lib.optionals config.polaris.nopasswdSudo [{
      users = [ username ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
