return {
	"chrisgrieser/nvim-origami",
    event = "VeryLazy",
    name = "origami",
	opts = {
        useLspFoldsWithTreesitterFallback = true,
        pauseFoldsOnSearch = true,
        foldtext = {
            enabled = true,
            padding = 1,
            lineCount = {
                template = " %d",
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
    },
}
