{ ... }:
{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Force Bluetooth headphones to use A2DP (disable headset/HFP profiles).
  environment.etc."wireplumber/wireplumber.conf.d/50-bluez-a2dp.conf".text = ''
    monitor.bluez.rules = [
      {
        matches = [
          { device.name = "~bluez_card.*"; }
        ];
        actions = {
          update-props = {
            bluez5.profile = "a2dp-sink";
            bluez5.roles = [ "a2dp_sink" ];
            bluez5.auto-connect = [ "a2dp_sink" ];
          };
        };
      }
    ]
  '';
}
