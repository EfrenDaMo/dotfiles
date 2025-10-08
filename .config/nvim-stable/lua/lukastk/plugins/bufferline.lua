return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',

    config = function()
        local bufferline = require("bufferline")

        bufferline.setup {
            options = {
                always_show_bufferline = false,

                style_preset = {
                    bufferline.style_preset.default,
                    bufferline.style_preset.no_italic,
                },

                separator_style = "thin",

                indicator = {
                    icon = '█',
                },

                buffer_close_icon = '',

                tab_size = 18,

                diagnostics = "nvim_lsp",
            }
        }

        vim.keymap.set("n", "<leader>BH", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
        vim.keymap.set("n", "<leader>BL", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
        vim.keymap.set("n", "<leader>BD", "<cmd>bdelete<cr>", { desc = "Next Buffer" })
    end
}
