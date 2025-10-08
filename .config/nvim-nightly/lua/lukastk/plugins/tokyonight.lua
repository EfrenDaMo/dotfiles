vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight" },
})

require("tokyonight").setup({
    style = "moon",
    terminal_colors = true,
    styles = {},
})

vim.cmd("colorscheme tokyonight")
