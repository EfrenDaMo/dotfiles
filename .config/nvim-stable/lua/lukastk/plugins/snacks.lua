return {
    "folke/snacks.nvim",
    lazy = false,
    name = "snacks",

    opts = {
        indent = {
            indent = {
                enabled = true,
            },
            scope = {
                enabled = true,
            },
        },

        picker = {
            enabled = true,

            layout = {
                cycle = true,
                reverse = true,
                layout = {
                    box = "horizontal",
                    title = "Picker for {title}",
                    backdrop = false,
                    width = 0.9,
                    height = 0.75,
                    border = "rounded",

                    {
                        box = "vertical",
                        { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
                        {
                            win = "input",
                            height = 1,
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                        },
                    },

                    {
                        win = "preview",
                        title = "{preview:Preview}",
                        width = 0.5,
                        border = "rounded",
                        title_pos = "center",
                    },
                },
            },

            matcher = {
                cwd_bonus = true,
                frecency = true,
            },
        },
    },

    keys = {
        -- Main pickers
        { "<leader>sg", function() Snacks.picker.grep() end,                 desc = "Grep Picker" },
        { "<leader>pf", function() Snacks.picker.files() end,                desc = "File Picker" },
        { "<leader>sm", function() Snacks.picker.marks() end,                desc = "Marks Picker" },
        { "<leader>sk", function() Snacks.picker.keymaps() end,              desc = "Keymaps Picker" },

        -- Lsp implementations
        { "gd",         function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
        { "gD",         function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declaration" },
        { "gr",         function() Snacks.picker.lsp_references() end,       nowait = true,                  desc = "References" },
        { "gI",         function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
        { "gy",         function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    }
}
