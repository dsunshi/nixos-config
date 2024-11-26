{ nixpkgs ? import <nixpkgs> { }, compiler ? "ghc965" }:
let
  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages (ps:
    with ps; [
      # libraries
      xmonad
      xmonad-utils
      xmonad-extras
      xmonad-contrib
      xmobar
      hint
      # "tools"
      haskell-language-server # This must match the GHC version in order to work
    ]);
in pkgs.stdenv.mkDerivation {
  name = "NixOS development environment";
  buildInputs = with pkgs; [
    ghc
    gnumake
    haskellPackages.hoogle
    cabal-install # https://github.com/NixOS/nixpkgs/issues/321569
  ];
  shellHook = "eval $(egrep ^export ${ghc}/bin/ghc)";
  env = { FLAKE = builtins.getEnv "PWD"; };
}
