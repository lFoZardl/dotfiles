return {
	--[[
    {
        "3rd/image.nvim",
        config = function()
            require("image").setup({
                backend = "kitty", -- ou "ueberzug" ou "sixel"
                integrations = {
                    markdown = {
                        enabled = true,
                    },
                    neorg = {
                        enabled = true,
                    },
                },
            })
        end,
    },
    ]]
}
