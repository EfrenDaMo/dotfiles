return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    name = "tokyonight",

    config = function()
        require("tokyonight").setup({
            style = "moon",
            terminal_colors = true,
            styles = {
                keywords = { italic = false }
            },
        })
        vim.cmd("colorscheme tokyonight")
    end,
}
