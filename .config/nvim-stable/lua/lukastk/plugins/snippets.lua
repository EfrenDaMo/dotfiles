return {
    "L3MON4D3/LuaSnip",
    lazy = false,
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
        "rafamadriz/friendly-snippets"
    },

    config = function()
        local luasnip = require("luasnip")

        luasnip.setup({
            enable_autosnippets = true,
        })

        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim-stable/snippets/" })

        vim.keymap.set("i", "<C-e>", function()
            luasnip.expand_or_jump(1)
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-J>", function()
            luasnip.jump(1)
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-K>", function()
            luasnip.jump(-1)
        end, { silent = true })
    end
}
