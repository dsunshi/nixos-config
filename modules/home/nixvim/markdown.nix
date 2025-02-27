{ pkgs, ... }: {
  programs.nixvim = {
    plugins.markdown-preview = { enable = true; };
    extraPlugins = with pkgs; [
      vimPlugins.vim-table-mode
      (vimUtils.buildVimPlugin {
        name = "render-markdown.nvim";
        src = fetchFromGitHub {
          owner = "MeanderingProgrammer";
          repo = "render-markdown.nvim";
          rev = "f2bdf9f866671456f7a6119cc94501048d9d172c"; # 8.0.0 release
          hash = "sha256-1GbjWHfcC6TIQM1zPnybKs0fcNbQjJJcb6Rb4R9T3nc=";
          # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };
      })
    ];
  };
}
