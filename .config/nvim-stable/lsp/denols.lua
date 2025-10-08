local function is_deno_project()
    local deno_files = { 'deno.json', 'deno.jsonc', 'deno.lock' }

    for _, filepath in ipairs(deno_files) do
        filepath = table.concat({ vim.fn.getcwd(), filepath }, '/')

        if vim.uv.fs_stat(filepath) ~= nil then return true end
    end

    return false
end

return {
    cmd = { "deno", "lsp" },
    cmd_env = { NO_COLOR = true },

    filetypes = {
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "typescript.tsx",
        "javascript.jsx",
    },

    root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
    workspace_required = true,

    settings = {
        deno = {
            enable = is_deno_project(),
            lint = true,
            unstable = true,
            suggest = {
                imports = {
                    hosts = {
                        ["https://deno.land"] = true
                    }
                }
            }
        }
    },

    single_file_support = false,
}
