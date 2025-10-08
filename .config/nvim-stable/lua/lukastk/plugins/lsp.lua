return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        "saghen/blink.cmp",
        "j-hui/fidget.nvim",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "stevearc/conform.nvim",
    },

    config = function()
        local servers = {
            "asm_lsp",
            "basedpyright",
            "bashls",
            "clangd",
            "cssls",
            "denols",
            "elixirls",
            "elp",
            "fish_lsp",
            "gopls",
            "html",
            "intelephense",
            "jdtls",
            "lua_ls",
            "ocamllsp",
            "ols",
            "ruff",
            "rust_analyzer",
            "ts_ls",
            "zls",
        }
        require("fidget").setup({})

        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = servers,
            automatic_installation = true,
        })

        require("conform").setup({
            formatters_by_ft = {
                c = { "clang-format" },
                go = { "goimports-reviser" },
                html = { "html-beautify" },
                lua = { "stylua" },
                php = { "intelephense" },
                python = { "ruff_format" },
                zig = { "zigfmt" },
            },

            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },

            formatters = {
                ["html-beautify"] = {
                    command = "html-beautify",
                    args = { "--indent-size", "4", "-I", "-E", "body" },
                },
            },
        })
    end,
}
