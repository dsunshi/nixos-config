{ myUser, mySystem, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/yubikey.nix
    ./../../modules/games.nix
    ./../../modules/nvidia.nix
    ./../../modules/sh.nix
    ./../../modules/wm.nix
    ./../../modules/vm.nix
    ./../../modules/autorandr.nix
    ./../../modules/display-manager.nix
    ./../../modules/vpn.nix
    ./../../modules/thunar.nix
    ./../../modules/ios.nix
    ./../../modules/common.nix
  ];

  options = {
    wsl.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = {
    # Bootloader.
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = true;
    boot.loader.grub.devices = [ "nodev" ];
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;
    distro-grub-themes = {
      enable = true;
      theme = "nixos"; # or 'asus-rog'
    };

    # https://discourse.nixos.org/t/drm-kernel-driver-nvidia-drm-in-use-nvk-requires-nouveau/42222/19
    boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

    # Might be needed for hyprland
    # https://wiki.hyprland.org/Nvidia/
    # boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

    networking.hostName = "bandit";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "America/Detroit";

    # Select internationalisation properties.
    i18n.defaultLocale = mySystem.locale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = mySystem.locale;
      LC_IDENTIFICATION = mySystem.locale;
      LC_MEASUREMENT = mySystem.locale;
      LC_MONETARY = mySystem.locale;
      LC_NAME = mySystem.locale;
      LC_NUMERIC = mySystem.locale;
      LC_PAPER = mySystem.locale;
      LC_TELEPHONE = mySystem.locale;
      LC_TIME = mySystem.locale;
    };

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    environment.localBinInPath = true; # add ~/.local/bin to PATH

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${myUser.username} = {
      isNormalUser = true;
      description = myUser.name;
      extraGroups = [ "networkmanager" "wheel" ];
    };

    # https://discourse.nixos.org/t/enabling-fixing-touch-gestures-in-nix-24-05/48784/2

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [ firefox tor-browser ];

    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
