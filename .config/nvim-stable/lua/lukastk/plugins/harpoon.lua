return {
    "ThePrimeagen/harpoon",
    lazy = false,
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({})

        local function generate_harpoon_picker()
            local file_paths = {}

            for _, item in ipairs(harpoon:list().items) do
                table.insert(file_paths, {
                    text = item.value,
                    file = item.value,
                })
            end

            return file_paths
        end

        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
        end, { desc = "Add to harpoon" })

        vim.keymap.set("n", "<leader>he", function()
            Snacks.picker({
                finder = generate_harpoon_picker,

                win = {
                    input = {
                        keys = {
                            ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
                        },
                    },

                    list = {
                        keys = {
                            ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
                        },
                    },
                },

                actions = {
                    harpoon_delete = function(picker, item)
                        local to_remove = item or picker:selected()

                        table.remove(harpoon:list().items, to_remove.idx)

                        picker:find({
                            refresh = true,
                        })
                    end,
                },

                layout = {
                    preview = false,

                    layout = {
                        backdrop = true,

                        width = 0.5,
                        min_width = 80,
                        height = 0.4,
                        min_height = 3,
                        box = "vertical",
                        border = "rounded",
                        title = "{title}",
                        title_pos = "center",

                        { win = "list",    border = "none" },
                        { win = "preview", title = "{preview}", height = 0.4,  border = "bottom" },
                        { win = "input",   height = 1,          border = "top" },
                    },
                },

                files = {
                    on_show = function()
                        vim.cmd.stopinsert()
                    end,
                },
            })
        end, { desc = "Open Harpoon in picker" })

        -- Plenary keys
        vim.keymap.set("n", "<leader>hE", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Open Harpoon in plenary" })

        vim.keymap.set("n", "<leader>hp", function()
            harpoon:list():prev()
        end, { desc = "Toggle to previous harpoon file" })

        vim.keymap.set("n", "<leader>hn", function()
            harpoon:list():next()
        end, { desc = "Toggle to next harpoon file" })
    end
}
