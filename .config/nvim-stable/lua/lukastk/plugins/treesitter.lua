return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    name = "treesitter",
    build = ":TSUpdate",
    branch = "master",

    config = function()
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
            "json",
            "lua",
            "nix",
            "ocaml",
            "odin",
            "php",
            "python",
            "rust",
            "templ",
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
            }
        })

        vim.api.nvim_set_hl(0, "@variable", { bold = true })
        vim.api.nvim_set_hl(0, "BlinkCmpSourceName", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "@lsp.type.modifier.java", { link = "@keyword" })
    end,
}
