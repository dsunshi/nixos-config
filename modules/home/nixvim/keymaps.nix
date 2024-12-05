{
  programs.nixvim = {
    # Keymaps not directly related to specific plugins
    keymaps = [
      # Make
      {
        options.desc = "Run make";
        mode = "n";
        options.silent = true;
        key = "<leader>mm";
        action = "<cmd>make -j`nproc`<CR>";
      }
      {
        options.desc = "Run make clean";
        mode = "n";
        options.silent = true;
        key = "<leader>mc";
        action = "<cmd>make clean<CR>";
      }
      # Window management
      {
        options.desc = "Split window vertically";
        mode = "n";
        options.silent = true;
        key = "<leader>sv";
        action = "<C-w>v";
      }
      {
        options.desc = "Split window horizontally";
        mode = "n";
        options.silent = true;
        key = "<leader>sh";
        action = "<C-w>s";
      }
      {
        options.desc = "Close current split";
        mode = "n";
        options.silent = true;
        key = "<leader>sx";
        action = "<cmd>close<CR>";
      }
      {
        options.desc = "Toggle background transparency";
        mode = "n";
        options.silent = true;
        key = "<leader>cl";
        action = "<cmd>TransparentToggle<CR>";
      }
    ] ++ (builtins.map (key: { # Disable 15 ;)
      inherit key;
      options.desc = "F15 NOP";
      mode = [ "n" "i" "v" "s" "t" "x" "o" "!" "l" "c" ];
      options.silent = true;
      action = "<Nop>";
    }) [ "<F15>" "<S-F15>" "<C-F15>" "<A-F15>" "<D-F15>" ]);

    keymapsOnEvents = {
      TermOpen = [{
        options.desc = "ESC to normal mode";
        mode = "t";
        key = "<esc>";
        action = "<C-\\><C-n>";
      }];
    };
  };
}
