{ config, myUser, mySystem, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../modules/yubikey.nix
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

  # TODO: nvidia.nix
  services.xserver.videoDrivers = [ "nvidia" "displaylink" ];
  # services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl.enable = true;
    nvidia = {
      # open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
    };
  };

  # TODO: wm.nix
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # TODO: Disabling this seems to prevent external monitors from working,
  # therefore for now we keep gnome enabled for simplicity :(
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh_ortho";
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
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # TODO: What is this for?
  # services.libinput.enable = true;

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
  environment.systemPackages = with pkgs; [
    firefox
    tor-browser
    nvidia-offload
  ];

  # TODO: Does this have to be at the system level?
  # If so, then games.nix
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Use fish as the main system shell
  programs.fish = { enable = true; };

  # It is not possible on Nix to have fish be the login shell. Therefore ...
  # as per: https://fishshell.com/docs/current/index.html#default-shell
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  system.stateVersion = "24.05"; # Did you read the comment?
}
