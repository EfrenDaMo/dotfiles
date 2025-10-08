vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" }
})

require("snacks").setup({
    indent = {
        indent = {
            enabled = true,
        },
        scope = {
            enabled = true,
        },
    }
})
