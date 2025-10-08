vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
})

local ensure_installed = {
    "asm",
    "bash",
    "c",
    "c_sharp",
    "cpp",
    "dart",
    "elixir",
    "erlang",
    "fish",
    "gleam",
    "go",
    "java",
    "javascript",
    "lua",
    "nix",
    "ocaml",
    "odin",
    "php",
    "python",
    "rust",
    "typescript",
    "vimdoc",
    "zig"
}

require("nvim-treesitter.configs").setup({
    ensure_installed = ensure_installed,

    sync_install = false,
    auto_install = true,

    indent = {
        enable = true,
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
    },
})

local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
treesitter_parser_config.templ = {
    install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
    },
}

vim.treesitter.language.register("templ", "templ")
vim.api.nvim_set_hl(0, "@variable", { bold = true })
vim.api.nvim_set_hl(0, "CmpNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "NONE" })

vim.api.nvim_create_autocmd('PackChanged', {
    desc = "Handle nvim-treesitter updates",
    group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
    callback = function(event)
        if event.data.kind == 'update' and event.data.spec.name == 'nvim-treesitter' then
            vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)

            --@diagnostic disable-next-line: param-type-mismatch
            local ok = pcall(vim.cmd, 'TSUpdate')
            if ok then
                vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
            else
                vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
            end
        end
    end
})
