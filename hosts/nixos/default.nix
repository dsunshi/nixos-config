{ config, myUser, mySystem, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../modules/yubikey.nix
    ./../../modules/games.nix
    ./../../modules/nvidia.nix
    ./../../modules/sh.nix
    ./../../modules/wm.nix
    ./../../modules/display-manager.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

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

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables.EDITOR = "nvim";
  environment.localBinInPath = true; # add ~/.local/bin to PATH

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${myUser.username} = {
    isNormalUser = true;
    description = myUser.name;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ firefox tor-browser ];

  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  system.stateVersion = "24.05"; # Did you read the comment?
}
