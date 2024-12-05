{
  programs.nixvim = {
    keymaps = [
      {
        options.desc = "Restore last workspace session for current directory";
        mode = "n";
        options.silent = true;
        key = "<leader>wr";
        action = "<cmd>SessionRestore<CR>";
      }
      {
        options.desc = "Save workspace session for current working directory";
        mode = "n";
        options.silent = true;
        key = "<leader>ws";
        action = "<cmd>SessionSave<CR>";
      }
    ];

    plugins.auto-session = { enable = true; };
  };
}
