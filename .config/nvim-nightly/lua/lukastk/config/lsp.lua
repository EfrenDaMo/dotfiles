local lsps = {
    "asm_lsp",
    "basedpyright",
    "bashls",
    "clangd",
    "cssls",
    "denols",
    "elixirls",
    "elp",
    "fish_lsp",
    "gleam",
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

vim.lsp.enable(lsps)

vim.diagnostic.config {
    severity_sort = true,
    virtual_text = {
        current_line = false,
    },
    virtual_lines = {
        current_line = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.HINT] = '󰋖',
            [vim.diagnostic.severity.INFO] = ' ',
        }
    },
}
