vim.opt.expandtab = true
vim.opt.scrolloff = 8

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.number = true
vim.opt.numberwidth = 4

vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "81"

vim.opt.termguicolors = true
vim.opt.winblend = 20
vim.opt.winborder = "rounded"

--vim.opt.list = true
vim.opt.listchars = "space:·"

vim.diagnostic.config({
    virtual_text = true,
    --virtual_lines = true,
    -- signs = {
    --     active = true,
    --     text = {
    --         [vim.diagnostic.severity.ERROR] = "",
    --         [vim.diagnostic.severity.WARN] = "",
    --         [vim.diagnostic.severity.HINT] = "󰟃",
    --         [vim.diagnostic.severity.INFO] = "",
    --     },
    -- },
    severity_sort = true, --{reverse = true}
})
--vim.keymap.set("n", "<C-n>", ":Ex<CR>", {})


vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
