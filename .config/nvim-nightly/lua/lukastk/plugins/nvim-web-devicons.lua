vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require'nvim-web-devicons'.setup {
    override = {
        zon = {
            icon = "",
            name = "Zon",
            color = "#f69a1b",
        },
    },
}
