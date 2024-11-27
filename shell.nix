{ nixpkgs ? import <nixpkgs> { }, compiler ? "ghc98" }:
let
  isWSL = if builtins.pathExists /etc/wsl.conf then true else false;
  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages (ps:
    with ps; (if isWSL then [] else [
      # libraries
      xmonad_0_18_0
      xmonad-utils
      xmonad-extras
      xmonad-contrib_0_18_1
      xmobar
      hint
      # "tools"
      haskell-language-server # This must match the GHC version in order to work
    ]));
in pkgs.stdenv.mkDerivation {
  name = "NixOS development environment";
  buildInputs = with pkgs; [
    gnumake
    ] ++ (if !isWSL then [
      # Only include ghc if we will develop XMonad on actual NixOS 
      ghc
      haskellPackages.hoogle
      cabal-install # https://github.com/NixOS/nixpkgs/issues/321569
    ] else []);
  shellHook = "eval $(egrep ^export ${ghc}/bin/ghc)";
  env = { FLAKE = builtins.getEnv "PWD"; };
}
