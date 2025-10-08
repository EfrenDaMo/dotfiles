return {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    name = "gitsigns",

    opts = {
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
    },
}
