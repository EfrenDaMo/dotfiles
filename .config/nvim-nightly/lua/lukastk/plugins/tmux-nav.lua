vim.pack.add({
    {
        src = "https://github.com/christoomey/vim-tmux-navigator",
        name = "tmux-navigator"
    }
})

vim.keymap.set("n", "<M-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "" })
vim.keymap.set("n", "<M-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "" })
vim.keymap.set("n", "<M-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "" })
vim.keymap.set("n", "<M-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "" })
vim.keymap.set("n", "<M-/>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "" })
