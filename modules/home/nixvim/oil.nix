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
      settings = {
        columns = [ "icon" "permissions" "mtime" ];
        view_options.show_hidden = false;
        skip_confirm_for_simple_edits = true;
        keymaps = { "y." = "actions.copy_entry_path"; };
        # My definition of what a hidden file is:
        # A file is hidden if it starts with a `.`, UNLESS
        # it is one of the following:
        #  - `..` (the parent directory)
        #  - `.gitignore`
        #  - `.envrc`
        #  - `.config`
        view_options.is_hidden_file = # lua
          ''
            function(name, bufnr)
               return name ~= ".." and name ~= ".gitignore" and name ~= ".envrc" and name ~= ".config" and vim.startswith(name, ".")
            end
          '';
      };
    };
  };
}
