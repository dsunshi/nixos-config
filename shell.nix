{ nixpkgs ? import <nixpkgs> { }, ghcVersion ? "984" }:
let
  isWSL = if builtins.pathExists /etc/wsl.conf then true else false;
  inherit (nixpkgs) pkgs;
  # "ghc${ghcVersion} needs to macth Stackage LTS versionm
  # from stack.yaml snapshot
  ghc = pkgs.haskell.packages."ghc${ghcVersion}".ghcWithPackages (ps:
    with ps;
    (if isWSL then
      [ ]
    else [
      # libraries
      xmonad
      xmonad-utils
      xmonad-extras
      xmonad-contrib
      xmobar
      hint
      # "tools"
      # haskell-language-server # This must match the GHC version in order to work
      implicit-hie
      ghcid
    ]));
in pkgs.stdenv.mkDerivation {
  name = "NixOS development environment";
  nativeBuildInputs = with pkgs;
    [ gnumake ] ++ (if !isWSL then [
      # Only include ghc if we will develop XMonad on actual NixOS 
      ghc
      (haskell-language-server.override {
        supportedGhcVersions = [ "${ghcVersion}" ];
      })
      cabal-install # https://github.com/NixOS/nixpkgs/issues/321569
    ] else
      [ ]);
  shellHook = # bash
    ''
      eval $(egrep ^export ${ghc}/bin/ghc)
      # cabal v2-update
      cd modules/home/xmonad/
      gen-hie > hie.yaml
    '';
  # env = { FLAKE = builtins.getEnv "PWD"; };
}
