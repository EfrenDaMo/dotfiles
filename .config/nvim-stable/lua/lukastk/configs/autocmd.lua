vim.api.nvim_create_autocmd('TextYankPost', {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = "Set the shiftwidth to 2 with js/ts files", -- THIS HAS BEEN DRIVING ME CRAZY
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = "Add a couple of things when lsp attaches to buffer",
    group = vim.api.nvim_create_augroup('lsp-attached-keybinds', { clear = true }),

    callback = function(event)
        local mkbind = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        mkbind("<leader>rn", vim.lsp.buf.rename, "Rename")
        mkbind("<leader>li", "<CMD>LspInfo<CR>", "Show active lsp info")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then -- fixed typo here too
            -- Check if client supports document highlighting
            if client.server_capabilities.documentHighlightProvider then
                local highlight_augroup = vim.api.nvim_create_augroup('lsp-attached-highlights', { clear = false })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                })
            end

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = 'lsp-attached-highlights', buffer = event2.buf })
                end
            })
        end
    end,
})
