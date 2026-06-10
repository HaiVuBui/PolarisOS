{ ... }:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprlock = { };
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.login.enableGnomeKeyring = true;
  };
}

