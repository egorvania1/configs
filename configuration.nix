# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      #<catppuccin/modules/nixos>
      ./hardware-configuration.nix
      <home-manager/nixos>
      #inputs.catppuccin.homeManagerModules.catppuccin
    ];
  
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1" ];

  systemd.services.sleepFix = {
    wantedBy = [ "multi-user.target" ];
    description = "Workaround for Gigabyte B550 F13 bios sleep/wakeup bug";
    enable = true;
    serviceConfig = {
       Type = "oneshot";
       ExecStart = ''/bin/sh -c "echo GPP0 > /proc/acpi/wakeup"'';
    };
  };

  fileSystems."/media/data" = 
  {
    device = "/dev/disk/by-uuid/6842070B4206DE26";
    fsType = "ntfs";
    options = [ "nofail" "big_writes" "allow_other" "uid=1000" "gid=1000" "rw" "user" "exec" "umask=000" ];
  };

  fileSystems."/media/windows" = 
  {
    device = "/dev/disk/by-uuid/AE589E8D589E53C5";
    fsType = "ntfs";
    options = [ "nofail" "big_writes" "allow_other" "uid=1000" "gid=1000" "rw" "user" "exec" "umask=000" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "beefpc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
        fcitx5-mozc
        kdePackages.fcitx5-qt
    ];
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  #services.xserver.displayManagers.sddm.wayland.enable = true;

  # Remember passwords
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.dbus.enable = true;

  programs.dconf.enable = true;

  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      qtile-extras
    ];
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.allowed-rates = [ 44100 48000 96000 ];
      default.clock.quantum = 32;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 1024;
    };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.swankycentaur33 = {
    isNormalUser = true;
    description = "SwankyCentaur33";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  home-manager.backupFileExtension = "backup";
  home-manager.users.swankycentaur33 = { pkgs, ... }: {
    programs.home-manager.enable = true;
    services.dunst = {
      enable = true;
    };
    programs = {
      rofi.enable = true;
    };
   # The state version is required and should stay at the version you
   # originally installed.
    home.stateVersion = "24.05";
  };

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "swankycentaur33";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    thunderbird
    steam
    vlc
    libsForQt5.kdeconnect-kde
    telegram-desktop
    librewolf
    discord
    #audacious
    nvidia-vaapi-driver
    #filelight
    #catppuccin
    lutris
    git
    tauon
    xboxdrv
    kitty
    alsa-utils
    pulseaudio
    dunst
    rofi
    rofi-wayland
    pavucontrol
    unzip
    mate.caja
    mate.engrampa
    mate.pluma
    mate.eom
    mate.atril
    temurin-bin-8
    appimage-run
    keepassxc
    hackneyed
    apple-cursor
    lxappearance
  ];

  environment.sessionVariables = rec {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
    XMODIFIERS = "@im=fcitx";
    PATH = [
      "$PATH:/home/swankycentaur33/.local/share/rofi-sound"
    ];
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    #driSupport = true;
    enable32Bit = true;
  };


  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "56374ac9a498572e"
    ];
  };

  # Open ports in the firewall
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
