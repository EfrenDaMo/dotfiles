return {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
        default_file_explorer = true,

        columns = {
            "icon",
        },

        view_options = {
            show_hidden = true,
        }
    },

    vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open oil file explorer" })
}
