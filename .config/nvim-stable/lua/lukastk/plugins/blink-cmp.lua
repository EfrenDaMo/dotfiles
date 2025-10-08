return {
    {
        "xzbdmw/colorful-menu.nvim",
        lazy = false,

        config = function()
            require("colorful-menu").setup({
                ls = {
                    clangd = {
                        extra_info_hl = "@comment",
                        align_type_to_right = true,
                        import_dot_hl = "@comment",
                        preserve_type_when_truncate = true,
                    },
                    gopls = {
                        align_type_to_right = true,
                        add_colon_before_type = false,
                        preserve_type_when_truncate = true,
                    },
                    lua_ls = {
                        arguments_hl = "@variable.parameter",
                    },
                    ["rust-analyzer"] = {
                        extra_info_hl = "@comment",
                        align_type_to_right = true,
                        preserve_type_when_truncate = true,
                    },
                    ts_ls = {
                        extra_info_hl = "@comment",
                    },
                    zls = {
                        align_type_to_right = true,
                    },
                    basedpyright = {
                        extra_info_hl = "@comment",
                    },

                    fallback = true,
                    fallback_extra_info_hl = "@comment",
                },

                fallback_highlight = "@variable",
                max_width = 60,
            })
        end,
    },
    {
        'saghen/blink.cmp',
        after = "colorful-menu",
        version = '*',
        dependencies = { 'rafamadriz/friendly-snippets' },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = 'normal',
            },

            cmdline = {
                enabled = true,

                completion = {
                    menu = { auto_show = true },
                    ghost_text = { enabled = true }
                },

                keymap = {
                    preset = "default",

                    ["<M-p>"] = { "select_prev", "fallback" },
                    ["<M-n>"] = { "select_next", "fallback" },
                    ['<M-y>'] = { 'accept_and_enter', 'fallback' },

                    ["<S-Tab>"] = { "select_prev", "fallback" },
                    ["<Tab>"] = { "select_next", "fallback" },
                },
            },

            completion = {
                accept = { auto_brackets = { enabled = true } },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                    update_delay_ms = 50,
                    treesitter_highlighting = true,

                    window = { border = 'rounded' },
                },

                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },

                ghost_text = { enabled = true },

                menu = {
                    auto_show = true,
                    border = 'rounded',

                    draw = {
                        columns = {
                            { "kind_icon", "label",       gap = 1 },
                            { "kind",      "source_name", gap = 1 },
                        },

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

                                    return highlights
                                end,
                            },
                            source_name = {
                                width = { fill = false, max = 10 },
                                text = function(ctx)
                                    local source_map = {
                                        LSP = "[LSPs]",
                                        Path = "[PATH]",
                                        Buffer = "[BUFF]",
                                        Cmdline = "[CMD]",
                                        Snippets = "[SNIP]",
                                    }

                                    return source_map[ctx.source_name] or "[" .. ctx.source_name .. "]"
                                end,
                                highlight = "BlinkCmpSourceName"
                            }
                        },

                        treesitter = { 'lsp' },
                    },

                    scrollbar = false,
                },
            },

            fuzzy = { implementation = "prefer_rust_with_warning" },

            keymap = {
                preset = "default",

                ["<M-y>"] = { "select_and_accept" },
                ["<M-p>"] = { "select_prev", "fallback" },
                ["<M-n>"] = { "select_next", "fallback" },
            },

            signature = {
                enabled = true,

                window = { border = 'rounded' },
            },

            sources = {
                default = { 'lsp', 'path', 'buffer' },
            },

            term = {
                enabled = true,
            },
        },

        opts_extend = { "sources.default", "sources.completion.enabled_providers" },
    },
}
