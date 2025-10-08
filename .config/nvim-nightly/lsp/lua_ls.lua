return {
    cmd = { 'lua-language-server' },
    filetype = { 'lua' },

	root_markers = {
        { '.luarc.json', '.luarc.jsonc' },
		'.luacheckrc',
        { '.stylua.toml', 'stylua.toml' },
		'.git',
	},

    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
                globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
            },
        },
    },
}
