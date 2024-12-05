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
          rev = "fe1002fddc61207e4ef4325d4bc0ca33697bbc7a"; # 7.3.0 release
          hash = "sha256-n/sMiz6ztfzAwidL7CaRaUW5m07i9i6cemthE1L4Pes=";
        };
      })
    ];
  };
}
