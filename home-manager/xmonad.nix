{ config, inputs, lib, pkgs, ... }: {
  home-manager.users.david = {
    # TODO: At lest on my first attempt, this did not work ..
    # Is this path not "absolute" enough?
    # xsession.windowManager.xmonad.config = ./xmonad/xmonad.hs;
    xsession.enable = true;
    xsession.initExtra = ''
      feh --bg-scale ~/Pictures/nix.png
    '';
    services.picom.enable = true;
    services.picom.settings = {
      backend = "glx";
      blur = {
        method = "gaussian";
        size = 5;
        deviation = 2.0;
      };
    };
    home = {
      packages = with pkgs; [
        xmobar
        feh
        rofi-wayland
        picom
        # (picom.overrideAttrs (oldAttrs: rec {
        #   src = fetchFromGitHub {
        #     owner = "pijulius";
        #     repo = "picom";
        #     rev = "da21aa8ef70f9796bc8609fb495c3a1e02df93f9";
        #     hash = "sha256-rxGWAot+6FnXKjNZkMl1uHHHEMVSxm36G3VoV1vSXLA=";
        #   };
        # }))
      ];
      # TODO: See above
      file.".xmonad/xmonad.hs".source = ./xmonad/xmonad.hs;
      file.".xmobarrc".source = ./xmonad/xmobarrc;
    };
  };
}
