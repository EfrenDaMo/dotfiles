vim.pack.add({
    { src = "https://github.com/mbbill/undotree" },
})

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle Undo Tree" })
