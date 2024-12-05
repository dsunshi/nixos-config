{
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "spell"; }
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "treesitter"; }
            { name = "luasnip"; }
          ];

          # Tab style snippet mapping, where by default nothing
          # is selected. Tab cycles through completions, while
          # automatically applying them, however snippets require
          # enter to expand.
          snippet.expand = # lua
            "function(args) require'luasnip'.lsp_expand(args.body); end";
          mapping = {
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-Space>" = # lua
              ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    if require("luasnip").expandable_or_jumpable() then
                      require("luasnip").expand_or_jump()
                    else
                      cmp.confirm({
                          select = true,
                          behavior = cmp.ConfirmBehavior.Insert
                      })
                    end
                  else
                    fallback()
                  end
                end)'';
            "<Tab>" = # lua
              ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require("luasnip").locally_jumpable(1) then
                    require("luasnip").jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" })'';

            "<S-Tab>" = # lua
              ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require("luasnip").locally_jumpable(-1) then
                    require("luasnip").jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" })'';
          };
        };
      };
      luasnip.enable = true; # only for cmp - does not auto enable
    };
  };
}
