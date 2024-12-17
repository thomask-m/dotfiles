require("lspconfig").rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                enable = false;
            }
        }
    }
})

-- map gd to Goto
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
