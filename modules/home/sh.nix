{ myUser, pkgs, ... }:
let
  myAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    ":q" = "exit";
    "cd.." = "cd ..";
    c = "cabal";
    cat = "bat";
    e = "nvim";
    fehs = ''feh --info "echo %wx%h"'';
    g = "lazygit";
    htop = "btm";
    ll = "exa --icons -l -T -L=1";
    ls = "exa";
    nixhash = "nix-hash --flat --base64 --type sha256";
    og = "git";
    q = "exit";
    rmempty = "find . -type d -empty -delete";
    rungame = "gamemoderun steam-run";
    sync = "rsync -aP";
    tree = "exa --tree";
    vim = "nvim";
    vimdiff = "nvim -d";
  };
in {
  home-manager.users.${myUser.username} = {

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    # Fish as the main shell
    programs.fish = {
      enable = true;
      shellAliases = myAliases;
      interactiveShellInit = # fish
        ''
          fish_vi_key_bindings
          set fish_greeting # Disable greeting
        '';
      functions = {
        haskellEnv = # fish
          ''
            nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])"
          '';
        rmempty = # fish
          ''
            find $argv -type d -empty -delete
          '';
        # This y shell wrapper that provides the ability to change the current working directory when exiting Yazi.
        # Then use y instead of yazi to start, and press q to quit, you'll see the CWD changed.
        # Sometimes, you don't want to change, press Q to quit.
        y = # fish
          ''
            set tmp (mktemp -t "yazi-cwd.XXXXXX")
            	yazi $argv --cwd-file="$tmp"
            	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            		builtin cd -- "$cwd"
            	end
            	rm -f -- "$tmp"
          '';
      };
      plugins = [
        {
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];
    };

    home = {
      # TODO: What is the difference here?
      shellAliases = myAliases;
    };
  };

  # nix-shell
  programs.bash = {
    completion.enable = true;
    shellAliases = myAliases;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.enableFishIntegration = true; # Should be automatic via direnv
}
