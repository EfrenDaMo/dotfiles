vim.pack.add({
    { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("*")
    }
})

require("colorful-menu").setup({
    ls = {
        lua_ls = {
            arguments_hl = "@variable.parameter",
        },

        fallback = true,
        fallback_extra_info_hl = "@comment",
    },
    fallback_highlight = "@variable",
    max_width = 60,
})

require("blink.cmp").setup({
    keymap = {
        preset = "default",

        ["<M-y>"] = { "select_and_accept" },
        ["<M-k>"] = { "select_prev", "fallback" },
        ["<M-j>"] = { "select_next", "fallback" },
        ["<M-p>"] = { "select_prev", "fallback" },
        ["<M-n>"] = { "select_next", "fallback" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },

    cmdline = {
        enabled = true,

        completion = {
            menu = { auto_show = true },
        },

        keymap = {
            preset = "default",

            ["<M-y>"] = { "select_and_accept" },
            ["<M-k>"] = { "select_prev", "fallback" },
            ["<M-j>"] = { "select_next", "fallback" },
            ["<M-p>"] = { "select_prev", "fallback" },
            ["<M-n>"] = { "select_next", "fallback" },
        },
    },

    term = {
        enabled = true,
    },

    completion = {
        accept = {
            auto_brackets = {
                enabled = true,
            },
        },
        menu = {
            auto_show = true,
            border = "rounded",
            winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
            draw = {
                treesitter = { "lsp" },
                columns = { { "kind_icon", gap = 1 }, { "label", gap = 1 }, { gap = 1, "kind" } },
                components = {
                    label = {
                        width = { fill = false, max = 60 },
                        text = function(ctx)
                            local highlights_info = require("colorful-menu").blink_highlights(ctx)
                            if highlights_info ~= nil then
                                return highlights_info.label
                            else
                                return ctx.label
                            end
                        end,
                        highlight = function(ctx)
                            local highlights = {}
                            local highlights_info = require("colorful-menu").blink_highlights(ctx)
                            if highlights_info ~= nil then
                                highlights = highlights_info.highlights
                            end
                            for _, idx in ipairs(ctx.label_matched_indices) do
                                table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                            end
                            -- Do something else
                            return highlights
                        end,
                    },
                },
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,

            window = {
                border = "rounded",
                winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
            },
        },
    },

    signature = {
        enabled = true,

        window = {
            border = "rounded",
        },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
})

opts_extend = { "sources.default" }
