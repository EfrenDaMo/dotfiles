local home = os.getenv 'HOME'
local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, 'jdtls')

if not status then
    return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
    cmd = {
        'java',
        '--add-modules=ALL-SYSTEM',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '--enable-native-access=ALL-UNNAMED',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/lombok*.jar'),
        '-jar', vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration',
        home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
        '-data',
        workspace_dir,
    },

    root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.xml', 'src' },

    settings = {
        java = {
            signatureHelp = { enabled = true },
            extendedClientCapabilities = extendedClientCapabilities,
        },

        format = {
        }
    },

    init_options = {
        bundles = {}
    },
}

local jdtlsI = require('jdtls')
jdtlsI.start_or_attach(config)

vim.keymap.set("n", "<leader>oi", function()
    jdtlsI.organize_imports()
end, { desc = "Organize Imports" })

vim.keymap.set("n", "<leader>ev", function()
    jdtlsI.extract_variable()
end, { desc = "Extract Variables" })

vim.keymap.set("v", "<leader>ev", function()
    jdtlsI.extract_variable(true)
end, { desc = "Extract Variables in visual" })

vim.keymap.set("n", "<leader>ec", function()
    jdtlsI.extract_constant(true)
end, { desc = "Extract Constants" })

vim.keymap.set("v", "<leader>ec", function()
    jdtlsI.extract_constant(true)
end, { desc = "Extract Constants in visual" })

vim.keymap.set("v", "<leader>em", function()
    jdtlsI.extract_method(true)
end, { desc = "Extract Method in visual" })
