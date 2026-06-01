{ ... }:

# Fixes for the Chicony webcam on MovingCastle.
#
# The RGB webcam (04f2:b614) reports broken YUYV colorimetry, so browsers using
# the raw V4L2 path render green noise. Routing them through PipeWire/libcamera
# (browser needs the "WebRTC PipeWire camera" flag) decodes it correctly.
{
  # Disable the V4L2 camera nodes so apps using the PipeWire camera portal get
  # the libcamera node (correct colorimetry) instead of the green V4L2 one.
  services.pipewire.wireplumber.extraConfig."10-use-libcamera" = {
    "monitor.v4l2.rules" = [{
      matches = [{ "device.name" = "~v4l2_device.*"; }];
      actions.update-props."device.disabled" = true;
    }];
  };

  # Deauthorize the unused IR camera (04f2:b615). Biometric auth is fingerprint,
  # and it otherwise shows up as a duplicate grayscale "camera" that apps may
  # default to. WirePlumber's libcamera monitor ignores device.disabled, so drop
  # it at the USB layer instead.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="04f2", ATTR{idProduct}=="b615", ATTR{authorized}="0"
  '';
}
