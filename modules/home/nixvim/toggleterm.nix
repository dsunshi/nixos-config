{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      settings = {
        shade_terminals = false;
        direction = "float";
        float_opts = {
          border = "curved";
          height = 30;
          width = 130;
        };
        open_mapping = "[[<c-\\>]]";
      };
    };
  };
}
