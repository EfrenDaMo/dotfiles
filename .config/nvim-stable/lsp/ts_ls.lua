local function is_deno_project()
    local deno_files = { 'deno.json', 'deno.jsonc', 'deno.lock' }

    for _, filepath in ipairs(deno_files) do
        filepath = table.concat({ vim.fn.getcwd(), filepath }, '/')

        if vim.uv.fs_stat(filepath) ~= nil then return true end
    end

    return false
end

local function stop_in_deno_project()
    if is_deno_project() then
        vim.cmd [[LspStop ts_ls]]
    end
end

vim.keymap.set("n", "<leader>st", stop_in_deno_project, { desc = "STOP TS_LS IF IN DENO PROJECT" })

return {
    root_markers = {
        "package.json",
        "tsconfig.json"
    },

    settings = {
        ts_ls = {
            enable = not is_deno_project(),
        }
    },

    single_file_support = false,
}
