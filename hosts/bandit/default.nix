{ myUser, mySystem, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/yubikey.nix
    ./../../modules/games.nix
    ./../../modules/nvidia.nix
    ./../../modules/sh.nix
    ./../../modules/wm.nix
    # ./../../modules/vm.nix
    ./../../modules/autorandr.nix
    ./../../modules/display-manager.nix
    ./../../modules/vpn.nix
    ./../../modules/printing.nix
    ./../../modules/agenix.nix
    ./../../modules/thunar.nix
    ./../../modules/laptop.nix
    ./../../modules/ios.nix
    ./../../modules/ollama.nix
    ./../../modules/common.nix
  ];

  options = {
    wsl.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  # TODO: Restic and server examples: https://github.com/pceiley/nix-config/tree/60848e0d38330f4d9c00683799c57e59a1cf4daa
  # Restic is a service and **not** part of home-manager
  # Another restic example: https://github.com/teto/home/blob/315ec23bc5ee54cde0db4b2b2098e86f2728218c/nixos/profiles/restic.nix#L11

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
      extraConfig.pipewire = {
        "99-disable-bell" = {
          "context.properties" = { "module.x11.bell" = false; };
        };
      };
    };

    # Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    environment.localBinInPath = true; # add ~/.local/bin to PATH

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${myUser.username} = {
      isNormalUser = true;
      description = myUser.name;
      extraGroups = [ "networkmanager" "wheel" "users" ];
      uid = 1000;
    };

    users.groups.users.gid = 100;

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
      libfaketime
      appimage-run
      ptouch-print
    ];

    hardware.keyboard.qmk.enable = true;

    services.udev.extraRules = ''
      # Enable non-root access for P-touch PT-P710BT
      SUBSYSTEM == "usb", ATTRS{idVendor} == "04f9", ATTRS{idProduct} == "20af", MODE = "0666"
      # QMK
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="df11", TAG+="uaccess"
    '';

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      openssl_1_1
      libdrm
      xorg.libX11
      xorg.libXext
      stdenv.cc.cc
      libva
      stdenv.cc.cc.lib
      libGL
    ];
    nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];
    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
