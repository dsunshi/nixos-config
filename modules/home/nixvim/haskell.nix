{ pkgs, ... }: {
  programs.nixvim = {
    keymaps = [
      {
        options.desc = "Toggle GHCi repl for the current buffer";
        mode = "n";
        options.silent = true;
        key = "<leader>rr";
        action.__raw = "require('haskell-tools').repl.toggle";
      }
      {
        options.desc =
          "Hoogle search for the type signature of the definition under the cursor";
        mode = "n";
        options.silent = true;
        key = "<leader>hs";
        action.__raw = "require('haskell-tools').hoogle.hoogle_signature";
      }
    ];

    extraPlugins = with pkgs; [
      vimPlugins.haskell-tools-nvim
      vimPlugins.nvim-dap
    ];
  };
}
