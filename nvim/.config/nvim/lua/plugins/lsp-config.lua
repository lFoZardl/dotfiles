return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     config = function()
    --         require("mason-lspconfig").setup({
    --             ensure_installed = {"lua_ls", "glsl_analyzer", "cmake"}
    --         })
    --     end
    -- },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
        },
        config = function()
            -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
            })
            vim.lsp.enable("lua_ls")

            vim.lsp.config("cmake", {
                capabilities = capabilities,
            })
            vim.lsp.enable("cmake")

            vim.lsp.config("glsl_analyzer", {
                capabilities = capabilities,
            })
            vim.lsp.enable("glsl_analyzer")

            vim.lsp.config("clangd", {
                capabilities = capabilities,
                -- cmd = {
                --     "/usr/bin/clangd",
                -- }
            })
            vim.lsp.enable("clangd")

            vim.lsp.enable("zls")

            --vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set("n", "grd", vim.lsp.buf.definition, {})
        end,
    },
}
