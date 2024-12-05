{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
      settings = {
        messages = { enabled = true; };
        notify = { enabled = false; };
        lsp = {
          message = { enabled = true; };
          progress = {
            enabled = false;
            view = "mini";
          };
        };
        popupmenu = {
          enabled = true;
          backend = "nui";
        };
        format = {
          filter = {
            pattern = [
              ":%s*%%s*s:%s*"
              ":%s*%%s*s!%s*"
              ":%s*%%s*s/%s*"
              "%s*s:%s*"
              ":%s*s!%s*"
              ":%s*s/%s*"
            ];
            icon = "";
          };
        };
      };
    };
  };
}
