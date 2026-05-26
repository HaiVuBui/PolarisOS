{...} : {
  security = {
    rtkit.enable = true;
    polkit = {
      enable = true;
      # extraConfig = ''
      #   polkit.addRule(function(action, subject) {
      #     if ( subject.isInGroup("users") && (
      #      action.id == "org.freedesktop.login1.reboot" ||
      #      action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
      #      action.id == "org.freedesktop.login1.power-off" ||
      #      action.id == "org.freedesktop.login1.power-off-multiple-sessions"
      #     ))
      #     { return polkit.Result.YES; }
      #   })
      # '';
    };
    pam.services.hyprlock = {};
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.login.enableGnomeKeyring = true;
  };
}

