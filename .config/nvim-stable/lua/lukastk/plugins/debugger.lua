return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "Weissle/persistent-breakpoints.nvim",
            "Carcuis/dap-breakpoints.nvim",
        },

        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dap.set_log_level("DEBUG")

            require("persistent-breakpoints").setup({
                load_breakpoints_event = { "BufReadPost" },
                save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
            })
            require("dap-breakpoints").setup({
            })

            require("dapui").setup()
            require("dap-go").setup()
            require("nvim-dap-virtual-text").setup()

            vim.keymap.set("n", "<leader>do", dapui.open, { desc = "Debug: Open dapui" })
            vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "Debug: Close dapui" })
            vim.keymap.set("n", "<leader>dt", dapui.toggle, { desc = "Debug: Toggle dapui" })

            vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
            vim.keymap.set("n", "<F9>", dap.step_over, { desc = "Debug: Step Over" })
            vim.keymap.set("n", "<F10>", dap.step_into, { desc = "Debug: Step Into" })
            vim.keymap.set("n", "<F11>", dap.step_out, { desc = "Debug: Step Out" })

            -- breakpoint specific keymaps
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })

            -- Auto open and close stuff
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Define side bar icons
            vim.fn.sign_define('DapBreakpoint', { text = '󰄯 ', texthl = 'DiagnosticError', linehl = '', numhl = '' })
            vim.fn.sign_define('DapBreakpointCondition',
                { text = ' ', texthl = 'DiagnosticError', linehl = '', numhl = '' })
            vim.fn.sign_define('DapLogPoint', { text = '󰰍 ', texthl = 'DiagnosticError', linehl = '', numhl = '' })
            vim.fn.sign_define('DapStopped', { text = '󰳟 ', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "neovim/nvim-lspconfig",
        },

        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "delve",
                    "debugpy",
                    "codelldb",
                },

                automatic_installation = true,

                handlers = {},
            })
        end
    },
}
