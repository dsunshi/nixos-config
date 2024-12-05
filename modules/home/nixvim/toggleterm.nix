{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      settings = {
        shade_terminals = false;
        open_mapping = "[[<c-\\>]]";
      };
    };
  };
}
