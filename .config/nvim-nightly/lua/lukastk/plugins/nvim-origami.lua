vim.pack.add({
    { src = "https://github.com/chrisgrieser/nvim-origami" },
})

require("origami").setup({
    useLspFoldsWithTreesitterFallback = true,
    pauseFoldsOnSearch = true,
    foldtext = {
        enabled = true,
        padding = 3,
        lineCount = {
            template = "󰁂 %d",
            hlgroup = "",
        },
        diagnosticsCount = true,
        gitsignsCount = true,
    },
    autoFold = {
        enabled = true,
        kinds = { "comments", "imports" }
    },
    foldKeymaps = {
        setup = false,
        hOnlyOpensOnFirstColumn = false,
    }
})
