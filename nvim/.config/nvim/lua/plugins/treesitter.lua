return {{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "asm", "c", "lua", "cmake", "cpp", "make", "zig",
                "javascript", "ini", "json", "jsonc", "markdown"
            },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}}

