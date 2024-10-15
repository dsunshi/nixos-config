# { lib, pkgs, ... }: {
#   home = {
#     packages = with pkgs; [
#       hello
#       # Doesn't matter if they're on new lines or not,
#       # they just need whitespace between them
#       cowsay
#       lolcat
#     ];
#
#     # This needs to actually be set to your username
#     username = "david";
#     homeDirectory = "/home/david";
#
#     # Don't ever change this after the first build.  Don't ask questions.
#     stateVersion = "24.05";
#   };
# }

{ config, inputs, lib, pkgs, ... }: {
  # imports = [ inputs.nix-colors.homeManagerModules.default ];

  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;
  # catppuccin = { flavor = "macchiato"; };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      david = { ... }: {
        # imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
        home = {
          stateVersion = "24.05";
          packages = with pkgs; [ cowsay ];
        };
        # catppuccin = {
        #   flavor = "macchiato";
        #   accent = "peach";
        # };
      };
      root = _: { home.stateVersion = "24.05"; };
    };
  };
}

