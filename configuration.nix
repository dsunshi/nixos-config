# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

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
    ./yubikey.nix
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

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

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.ly.enable = true;
  # services.xserver.displayManager.ly.settings = {
  #   load = false;
  #   save = false;
  # };
  services.displayManager.defaultSession = "none+xmonad";
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.mini = {
      enable = true;
      user = "david";

      extraConfig = ''
        [greeter]
        show-password-label = true
        password-label-text = password
        invalid-password-text = try again
        show-input-cursor = false
        password-alignment = right

        [greeter-theme]
        font = "Iosevka"
        font-size = 14pt
        text-color = "#DCD7BA"
        error-color = "#C4746E"
        background-image = ""
        background-color = "#1F1F28"
        window-color = "#1F1F28"
        border-color = "#363646"
        border-width = 1px
        layout-space = 14
        password-color = "#54546D"
        password-background-color = "#2A2A37"
      '';
    };
  };
  # services.xserver.displayManager.gdm.enable = true;
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables.EDITOR = "nvim";
  environment.localBinInPath = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    isNormalUser = true;
    description = "David Sunshine";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    firefox
    tor-browser
    nvidia-offload
    sops
    # Games
    legendary-gl
    rare # GUI for ledendary
    (dwarf-fortress-packages.dwarf-fortress-full.override {
      enableIntro = false;
      enableFPS = true;
      theme = dwarf-fortress-packages.themes.vettlingr;
    })
    makeDesktopItem
    {
      name = "dwarf-fortress";
      desktopName = "Dwarf Fortress";
      exec = "${dwarf-fortress-packages.dwarf-fortress-full}/bin/dfhack";
      terminal = false;
    }
  ];

  # Games
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.fish = {
    enable = true;
    # enable fish when using `nix-shell`
    # interactiveShellInit = ''
    #   ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    # '';
  };

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

  # List services that you want to enable:

  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  system.stateVersion = "24.05"; # Did you read the comment?

}
