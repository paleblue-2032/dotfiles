{ config, pkgs, ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/networking.nix
   ];

  # Bootloader
  boot.loader.systemd-boot.enable = false;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;

    splashImage = "/home/paleblue_2032/Pictures/Nixos-ThinkPad_blue.png";

    useOSProber = true;
  };

  boot.loader.timeout = 10;

  networking.hostName = "Liberty-pad";
  networking.networkmanager.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];

  time.timeZone = "Asia/Tokyo";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      qt6Packages.fcitx5-configtool
    ];

    fcitx5.waylandFrontend = true;
  };

  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "jp";
    options = "ctrl:swapcaps";
  };

  console.useXkbConfig = true;

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

  users.users.paleblue_2032 = {
    isNormalUser = true;
    description = "paleblue_2032";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.git.enable = true;
  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-ld.enable = true;

  programs.dconf.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Instant Shutdown";
          command = "gnome-session-quit --power-off";
          binding = "<Ctrl><Alt>End";
        };
      };
    }
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    emacs
    gcc
    git
    github-cli
    vim
    fastfetch

    python3
    uv

    nh
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
