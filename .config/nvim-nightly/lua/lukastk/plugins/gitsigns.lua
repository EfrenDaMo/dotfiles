vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" }
})

require("gitsigns").setup({
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        untracked    = { text = '*' },
        changedelete = { text = '~' },
    },
    signs_staged = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        untracked    = { text = '*' },
        changedelete = { text = '~' },
    },
    signs_staged_enable = true,
})
