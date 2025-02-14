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
            owner = "sho-87";
            repo = "kanagawa-paper.nvim";
            rev = "40da69c1a6a92264cfc2aa9cc62ac9faa69e19dd"; # 1.6.0 release
            hash = "sha256-mq1Mn7ZrERmf4I2AR7GF3rWG6br5LrS8t1VnBqmjGco=";
          };
        })
      ];
  };
}
