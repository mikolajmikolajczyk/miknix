{wifiSecretsFile, ...}: {
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [wifiSecretsFile];
    profiles = {
      home = {
        connection = {
          id = "home";
          type = "wifi";
          autoconnect = true;
          autoconnect-priority = 100;
        };
        wifi = {
          mode = "infrastructure";
          ssid = "$HOME_WIFI_SSID";
          hidden = false;
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$HOME_WIFI_PSK";
        };
        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    };
  };
}
