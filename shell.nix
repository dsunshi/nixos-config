{ nixpkgs ? import <nixpkgs> { }, compiler ? "ghc98" }:
let
  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskell.packages.${compiler}.ghcWithPackages (ps:
    with ps; [
      # libraries
      xmonad_0_18_0
      xmonad-utils
      xmonad-extras
      xmonad-contrib_0_18_1
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
