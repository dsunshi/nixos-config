{ nixpkgs ? import <nixpkgs> { }, ghcVersion ? "98" }:
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
      xmonad_0_18_0
      xmonad-utils
      xmonad-extras
      xmonad-contrib_0_18_1
      xmobar
      hint
      # "tools"
      # haskell-language-server # This must match the GHC version in order to work
      implicit-hie
      ghcid
    ]));
  # Wrap Stack to work with our Nix integration. We don't want to modify
  # stack.yaml so non-Nix users don't notice anything.
  # - no-nix:           We don't want Stack's way of integrating Nix.
  # --system-ghc      # Use the existing GHC on PATH (will come from this Nix file)
  # --no-install-ghc  # Don't try to install GHC if no matching GHC found on PATH
  stack-wrapped = pkgs.symlinkJoin {
    name = "stack"; # will be available as the usual `stack` in terminal
    paths = [ pkgs.stack ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = # bash
      ''
        wrapProgram $out/bin/stack \
          --add-flags "\
            --system-ghc \
            --no-install-ghc \
          "
      '';
  };
in pkgs.stdenv.mkDerivation {
  name = "NixOS development environment";
  nativeBuildInputs = with pkgs;
    [ gnumake ] ++ (if !isWSL then [
      # Only include ghc if we will develop XMonad on actual NixOS 
      ghc
      # stack-wrapped
      # haskellPackages.hoogle
      (haskell-language-server.override {
        supportedGhcVersions = [ "${ghcVersion}" ];
      })
      cabal-install # https://github.com/NixOS/nixpkgs/issues/321569
    ] else
      [ ]);
  shellHook = # bash
    ''
      eval $(egrep ^export ${ghc}/bin/ghc)
      cabal v2-update
    '';
  # env = { FLAKE = builtins.getEnv "PWD"; };
}
