return {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    name = "tmux-navigator",

    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        { "<M-k>",  "<cmd>TmuxNavigateUp<cr>",       desc = "Move to up tmux pane" },
        { "<M-h>",  "<cmd>TmuxNavigateLeft<cr>",     desc = "Move to left tmux pane" },
        { "<M-j>",  "<cmd>TmuxNavigateDown<cr>",     desc = "Move to down tmux pane" },
        { "<M-l>",  "<cmd>TmuxNavigateRight<cr>",    desc = "Move to right tmux pane" },
        { "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Move to previous tmux pane" },
    },
}
