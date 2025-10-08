return {
    "folke/todo-comments.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },

    opts = {
        keywords = {
            HACK = { icon = " ", color = "#FB7C24" },
            NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
    },
    --[[
    keys = {
        {
            "<leader>st",
            function()
                Snacks.picker.todo_comments()
            end,
            desc = "Todo",
        },
        {
            "<leader>sT",
            function()
                Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
            end,
            desc = "Todo/Fix/Fixme",
        },
    },
    ]] --
}
