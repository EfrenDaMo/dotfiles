vim.pack.add({
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/stevearc/conform.nvim" },
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
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
})

require("fidget").setup({})
