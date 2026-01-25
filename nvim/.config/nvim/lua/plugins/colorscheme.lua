return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false, -- charge immédiatement au démarrage
        priority = 1000, -- charge avant les autres plugins
        config = function()
            local vscode = require("vscode")

            vscode.setup({
                -- style options
                italic_comments = true,
                disable_nvimtree_bg = true,
            })

            vscode.load()
        end,
    },
}
