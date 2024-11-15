{ myUser, pkgs, ... }:
let
  myAliases = {
    ".." = "cd ..";
    cat = "bat";
    e = "nvim";
    g = "lazygit";
    htop = "btm";
    ll = "exa --icons -l -T -L=1";
    ls = "exa";
    og = "git";
    q = "exit";
    ":q" = "exit";
    tree = "exa --tree";
    vim = "nvim";
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
    enableCompletion = true;
    shellAliases = myAliases;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.enableFishIntegration = true; # Should be automatic via direnv
}
