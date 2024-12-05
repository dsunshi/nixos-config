{
  programs.nixvim = {
    plugins.web-devicons = { enable = true; };
    # or
    # plugins.mini.modules.icons with plugins.mini.mockDevIcons
  };
}
