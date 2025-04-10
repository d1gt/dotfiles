-- General Settings
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true

-- Configure `completeopt` and `shortmess`
vim.o.completeopt = "menu,menuone,noselect"
vim.o.shortmess = vim.o.shortmess .. "c"

-- Enable LSP and Auto-Completion
local function setup_lsp(client_name, config)
    vim.lsp.config(client_name, config)
    vim.lsp.enable(client_name)
end

-- Lua LSP
setup_lsp('lua_ls', {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    filetypes = { "lua" },
})

-- Go LSP
setup_lsp('gopls', {
    cmd = { "gopls" },
    root_markers = { "go.mod", ".git" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
})

-- Enable LSP-based completions
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        -- Enable LSP completions
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })

        -- Set `omnifunc` to LSP omnifunc
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Set up keybindings for LSP
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
        vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code Action" })
        vim.keymap.set("n", "<leader>re", vim.lsp.buf.references, { buffer = ev.buf, desc = "References" })
        vim.keymap.set("n", "<leader>im", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Implementation" })
        vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, { buffer = ev.buf, desc = "Document Symbol" })
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition , { buffer = ev.buf, desc = "Definition" })
        vim.keymap.set("n", "<leader>gD", vim.lsp.buf.type_definition , { buffer = ev.buf, desc = "Type Definition" })
        vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature Help" })
    end,
})

-- Trigger completions with <Tab>
vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    else
        return "<Tab>"
    end
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-p>"
    else
        return "<S-Tab>"
    end
end, { expr = true })

-- TreeSitter Setup
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end
})

-- Builtin Folding
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Builtin Commenting
vim.o.commentstring = "// %s"  -- Adjust according to your language

-- Builtin File Tree (Netrw)
vim.g.netrw_list_style = 3

-- Additional Keymaps for Netrw
vim.api.nvim_set_keymap('n', '-', ':Explore<CR>', { noremap = true, silent = true })
