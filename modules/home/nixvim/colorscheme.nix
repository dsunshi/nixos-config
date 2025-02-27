{ pkgs, ... }: {
  programs.nixvim = {
    colorscheme = "kanagawa-paper";
    plugins.transparent = {
      enable = true;
      # settings = {
      #   exclude_groups = [ ];
      #   extra_groups = [
      #     "BufferLineBackground"
      #     "BufferLineBufferSelected"
      #     "BufferLineFill"
      #     "BufferLineIndicatorSelected"
      #     "BufferLineSeparator"
      #     "BufferLineTabClose"
      #     "Comment"
      #     "Conditional"
      #     "Constant"
      #     "CursorLine"
      #     "CursorLineNr"
      #     "EndOfBuffer"
      #     "Function"
      #     "Identifier"
      #     "LineNr"
      #     "NonText"
      #     "Normal"
      #     "NormalNC"
      #     "Operator"
      #     "PreProc"
      #     "Repeat"
      #     "SignColumn"
      #     "Special"
      #     "Statement"
      #     "StatusLine"
      #     "StatusLineNC"
      #     "String"
      #     "Structure"
      #     "Todo"
      #     "Type"
      #     "Underlined"
      #   ];
      # };
    };
    extraPlugins = with pkgs;
      [
        (vimUtils.buildVimPlugin {
          name = "kanagawa-paper.nvim";
          src = fetchFromGitHub {
            owner = "thesimonho";
            repo = "kanagawa-paper.nvim";
            rev = "9531cc6d16f99a5cf3522208c07937c7d5771ffc"; # 1.8.0 release
            hash = "sha256-QkSULcnLOiF1w/iAuPK0CCvHsKrY24jBGNFHnd0aaj0=";
            # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };
        })
      ];
  };
}
