{ ... }:

{
  services.printing.enable = true;

  services.pulseaudio.enable = false;

  services.openssh.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;

    wireplumber.enable = true;
  };
}
