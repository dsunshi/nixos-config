{
  programs.nixvim = {
    keymaps = [{
      options.desc = "Open parent directory";
      mode = "n";
      options.silent = true;
      key = "-";
      action = "<cmd>Oil<cr>";
    }];

    plugins.oil = {
      enable = true;
      settings.columns = [ "icon" "permissions" "mtime" ];
      settings.view_options.show_hidden = false;
      # My definition of what a hidden file is:
      # A file is hidden if it starts with a `.`, UNLESS
      # it is one of the following:
      #  - `..` (the parent directory)
      #  - `.gitignore`
      #  - `.envrc`
      #  - `.config`
      settings.view_options.is_hidden_file = # lua
        ''
          function(name, bufnr)
             return name ~= ".." and name ~= ".gitignore" and name ~= ".envrc" and name ~= ".config" and vim.startswith(name, ".")
          end
        '';
    };
  };
}
