vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "110"

vim.opt.splitright = false
vim.opt.splitbelow = false
vim.opt.inccommand = "split"

vim.opt.wrap = false
vim.opt.fixendofline = false
vim.opt.termguicolors = true
vim.opt.smartindent = true
vim.opt.updatetime = 50
vim.opt.showmode = false
vim.opt.winborder = 'rounded'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"

vim.opt.fillchars = {
    foldopen = "",
    foldclose = "",
    foldsep = " "
}

local fcs = vim.opt.fillchars:get()

local function get_fold(lnum)
    if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then return ' ' end
    return vim.fn.foldclosed(lnum) == -1 and fcs.foldopen or fcs.foldclose
end

_G.get_statuscol = function()
    return "%s%l " .. get_fold(vim.v.lnum) .. " "
end

vim.o.statuscolumn = "%!v:lua.get_statuscol()"

vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)
