{
  programs.nixvim = {
    keymaps = [
      {
        options.desc = "Open trouble workspace diagnostics";
        key = "<leader>xw";
        action = "<cmd>Trouble diagnostics toggle<CR>";
      }
      {
        options.desc = "Open trouble document diagnostics";
        key = "<leader>xd";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      }
      {
        options.desc = "Open trouble quickfix list";
        key = "<leader>xq";
        action = "<cmd>Trouble quickfix toggle<CR>";
      }
      {
        options.desc = "Open trouble location list";
        key = "<leader>xl";
        action = "<cmd>Trouble loclist toggle<CR>";
      }
      {
        options.desc = "Open todos in trouble";
        key = "<leader>xt";
        action = "<cmd>Trouble todo toggle<CR>";
      }
    ];

    plugins.trouble = { enable = true; };
  };
}
