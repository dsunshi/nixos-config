{
  programs.nixvim = {
    plugins = {
      lsp-lines.enable = true;
      lsp-format.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          hls = {
            enable = true;
            # Do not install ghc via Nixvim. We will prefer to use flakes or 
            # shell.nix which will give us ghc (with a matching hls of the same version).
            installGhc = true;
          };
          clangd.enable = true;
          openscad_lsp.enable = true;
          pylsp.enable = true;
          marksman.enable = true;
          nil_ls = {
            enable = true;
            settings.formatting.command = [ "nixfmt" ];
          };
        };
      };
    };
  };
}
