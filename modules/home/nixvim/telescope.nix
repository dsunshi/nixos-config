{
  programs.nixvim = {
    keymaps = [
      {
        options.desc = "Find files";
        mode = "n";
        options.silent = true;
        key = "<leader>ff";
        action =
          "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>";
      }
      {
        options.desc = "Find by grep";
        mode = "n";
        options.silent = true;
        key = "<leader>fg";
        action = ":Telescope live_grep<cr>";
      }
      {
        options.desc = "Find buffer";
        mode = "n";
        options.silent = true;
        key = "<leader><space>";
        action = ":Telescope buffers<cr>";
      }
    ];

    keymapsOnEvents = {
      LspAttach = [
        {
          options.desc = "View references";
          key = "<leader>lr";
          action.__raw = "require('telescope.builtin').lsp_references";
        }
        {
          options.desc = "View document symbols";
          key = "<leader>ld";
          action.__raw = "require('telescope.builtin').lsp_document_symbols";
        }
        {
          options.desc = "View workspace symbols";
          key = "<leader>lw";
          action.__raw = "require('telescope.builtin').lsp_workspace_symbols";
        }
      ];
    };

    plugins.telescope = {
      enable = true;
      extensions = {
        fzy-native = {
          enable = true;
          settings = {
            override_generic_sorter = true;
            override_file_sorter = false;
          };
        };
        media-files.enable = true;
        ui-select.enable = true;
        frecency.enable = true;
        file-browser = {
          enable = true;
          settings.hijack_netrw = true;
        };
      };
    };
  };
}
