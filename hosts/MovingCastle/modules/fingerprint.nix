{ inputs, ... }:
{
  imports = [
    inputs.fingerprint-06cb-009a.nixosModules."06cb-009a-fingerprint-sensor"
  ];

  # python-validity backend pulls in open-fprintd (a fprintd-compatible dbus
  # service) and downloads the sensor firmware at runtime. pam_fprintd talks to
  # it unchanged, so greetd just needs fprintAuth.
  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "python-validity";
  };

  security.pam.services.greetd.fprintAuth = true;
}
