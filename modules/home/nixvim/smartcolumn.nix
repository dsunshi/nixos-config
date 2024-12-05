{
  programs.nixvim = {
    plugins.smartcolumn = {
      enable = true;
      settings = {
        colorcolumn = "120";
        disabled_filetypes = [ "markdown" "startup" ];
      };
    };
  };
}
