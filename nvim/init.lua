-- Options
vim.g.mapleader = " "
local map = vim.keymap.set

local function resize_vertical_splits()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
end

if vim.g.vscode then
    map('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
    map('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

    map('n', 'gd', "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", { noremap = true, silent = true })
    map('n', 'gD', "<Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>", { noremap = true, silent = true })
    map('n', '<leader>ff', "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", { noremap = true, silent = true })
    map('n', '<leader>fg', "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>",
        { noremap = true, silent = true })
    map('n', '<leader>zz', "<Cmd>call VSCodeNotify('workbench.action.toggleZenMode')<CR>",
        { noremap = true, silent = true })
    map('n', '-', "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>",
        { noremap = true, silent = true })
else
    vim.wo.wrap = true
    vim.opt.cursorline = true
    vim.opt.ignorecase = true
    vim.opt.mouse = ""
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.hlsearch = false
    vim.opt.clipboard = "unnamedplus"
    vim.opt.signcolumn = "number"
    vim.opt.hidden = true

    -- General settings
    vim.opt.backup = false
    vim.opt.swapfile = false
    vim.opt.writebackup = false
    vim.opt.fileformat = "unix"

    -- vim.opt.colorcolumn = "80"
    vim.opt.cursorline = true
    vim.opt.linebreak = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.diffopt:append({ "indent-heuristic", "algorithm:patience" })
    vim.opt.termguicolors = true
    vim.opt.formatoptions:append("ro")
    vim.opt.foldmethod = "manual"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevel = 1
    vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }
    vim.opt.laststatus = 3
    vim.opt.mouse = ""
    vim.opt.scrolloff = 999

    -- Indentation settings
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.opt.autoindent = true
    vim.opt.cindent = true
    vim.opt.smartindent = true

    -- Disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Restore cursor position
    vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
            local line = vim.fn.line("'\"")
            if line >= 1 and line <= vim.fn.line("$") then
                vim.cmd('normal! g`"')
            end
        end
    })

    -- Basic mappings
    map("n", "<C-H>", "<C-W><C-H>", { noremap = true, silent = true })
    map("n", "<C-J>", "<C-W><C-J>", { noremap = true, silent = true })
    map("n", "<C-K>", "<C-W><C-K>", { noremap = true, silent = true })
    map("n", "<C-L>", "<C-W><C-L>", { noremap = true, silent = true })
    map("n", "<C-S>", ":%s/", { noremap = true, silent = true })
    map("n", "vs", ":vs<CR>", { noremap = true, silent = true })
    map('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
    map('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })


    -- Setup lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath, })
    end

    vim.opt.rtp:prepend(lazypath)

    -- Install plugins
    require("lazy").setup({

        -- File explorer
        {
            "echasnovski/mini.files",
            -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
            config = function() require("mini.files") end,
        },

        -- colors
        {
            "norcalli/nvim-colorizer.lua",
            config = function()
                require 'colorizer'.setup()
            end
        },
        -- Auto completion
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
            },
        },

        { 'VidocqH/lsp-lens.nvim' },
        { 'mg979/vim-visual-multi' },

        -- Lsp
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "jay-babu/mason-nvim-dap.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },

        -- Status
        {
            'echasnovski/mini.statusline',
            version = false,
            config = function()
                require('mini.statusline').setup({})
            end
        },

        --csv
        { "chrisbra/csv.vim",                ft = "csv" },

        -- Sudo write/read
        { "lambdalisue/vim-suda" },

        -- Focus
        { "folke/zen-mode.nvim" },

        { "echasnovski/mini.jump2d",         config = function() require("mini.jump2d").setup() end },

        -- Colorscheme
        {"vague2k/vague.nvim"},
{
  "candle-grey",
  dir = "~/Projects/candle-grey", -- Path to your Lua theme
},
 --       {"aditya-azad/candle-grey"},
        { "nyoom-engineering/oxocarbon.nvim" },
        { "Verf/deepwhite.nvim" },

        -- Debugger
        { "leoluz/nvim-dap-go",              ft = "go" },
        {
            "mfussenegger/nvim-dap",
            dependencies = { "nvim-neotest/nvim-nio", "theHamsta/nvim-dap-virtual-text", "rcarriga/nvim-dap-ui" },
            ft = "go",
        },

        -- Go
        { "fatih/vim-go", ft = "go" },

        -- Fuzzy finder
        {
            "nvim-telescope/telescope.nvim",
            event = "VeryLazy",
            opts = {
                pickers = {
                    git_branches = { previewer = true, theme = "dropdown", show_remote_tracking_branches = true },
                    git_commits = { previewer = true, theme = "dropdown" },
                    grep_string = { previewer = true, theme = "dropdown" },
                    diagnostics = { previewer = true, theme = "dropdown" },
                    find_files = { previewer = true, theme = "dropdown" },
                    buffers = { previewer = true, theme = "dropdown" },
                    current_buffer_fuzzy_find = { theme = "dropdown" },
                    resume = { previewer = true, theme = "dropdown" },
                    live_grep = { previewer = true, theme = "dropdown" },
                },
                defaults = {
                    layout_config = {
                        -- vertical = { width = 0.5 },
                        -- prompt_position = "bottom",
                    },
                },
            },
            dependencies = { "nvim-lua/plenary.nvim" },
        },

    })


    -- Plugin Settings
    -- Explorer
    map("n", "-", function() require("mini.files").open(vim.fn.expand('%')) end, { noremap = true, silent = true })


    -- Focus
    map("n", "<Leader>zz", function() require("zen-mode").toggle() end, { noremap = true, silent = true })
    map("n", "<Leader>zl", function()
        require("zen-mode").toggle({
            window = {
                width = 1,
                height = 1,
                options = {
                    number = true,
                    relativenumber = false
                },
            },
        })
    end, { noremap = true, silent = true })

    -- Lsp

    map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            local opts = { buffer = ev.buf }
            map("n", "gd", vim.lsp.buf.definition, opts)
            map("n", "gD", vim.lsp.buf.type_definition, opts)
            map("n", "K", vim.lsp.buf.hover, opts)
            map("n", "<space>rn", vim.lsp.buf.rename, opts)
            map({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, opts)
            map("n", "gr", vim.lsp.buf.references, opts)
            map("n", "<leader>f", vim.lsp.buf.format, opts)
        end,
    })

    require 'mason'.setup()
    require 'mason-lspconfig'.setup {}


    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    require("lspconfig").gopls.setup({
        capabilities = capabilities,
        flags = { debounce_text_changes = 200 },
        settings = {
            gopls = {
                usePlaceholders = true,
                analyses = {
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                },
                codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                experimentalPostfixCompletions = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-node_modules" },
                semanticTokens = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    })

    local runtime_path = vim.split(package.path, ';')

    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    require 'lspconfig'.lua_ls.setup {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        vim.fn.expand('$VIMRUNTIME/lua'),
                        vim.fn.stdpath('config') .. '/lua'
                    }
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }

    require 'lspconfig'.bashls.setup {
        filetypes = { "sh", "zsh" },
    }

    require 'lspconfig'.docker_compose_language_service.setup {}
    require 'lspconfig'.dockerls.setup {}
    require 'lspconfig'.jqls.setup {}
    require 'lspconfig'.jsonls.setup {}
    require 'lspconfig'.marksman.setup {}
    require 'lspconfig'.taplo.setup {}
    require 'lspconfig'.yamlls.setup {}

    vim.api.nvim_create_augroup('MyJqGroup', {})
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        group = 'MyJqGroup',
        pattern = { '*.jq' },
        command = 'set filetype=jq',
    })

    -- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local cmp = require 'cmp'
    --    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    local luasnip = require 'luasnip'
    local SymbolKind = vim.lsp.protocol.SymbolKind
    cmp.setup({
        window = {
            completion = cmp.config.window.bordered(),    -- Adds borders to the completion menu
            documentation = cmp.config.window.bordered(), -- Adds borders to the documentation window
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = {
            { name = "nvim_lsp", max_item_count = 5 },
            { name = "buffer",   max_item_count = 5 },
            { name = "path",     max_item_count = 5 },
            { name = "luasnip",  max_item_count = 3 },
        },
        formatting = {
            format = function(_, vim_item)
                vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
                return vim_item
            end,
        },
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded", -- Options: 'none', 'single', 'double', 'rounded', 'solid', 'shadow'
    })

    -- Customize the signature help window (optional)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded", -- Same border options
    })
    require 'lsp-lens'.setup({
        enable = true,
        include_declaration = false, -- Reference include declaration
        sections = {                 -- Enable / Disable specific request, formatter example looks 'Format Requests'
            definition = false,
            references = true,
            implements = true,
            git_authors = true,
        },
        ignore_filetype = {},
        -- Target Symbol Kinds to show lens information
        target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
        -- Symbol Kinds that may have target symbol kinds as children
        wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
    })
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<space><space>',
            },
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]a"] = "@parameter.inner",
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]A"] = "@parameter.inner",
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[a"] = "@parameter.inner",
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[A"] = "@parameter.inner",
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
            lsp_interop = {
                enable = true,
                border = 'none',
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer",
                },
            },
        },
    }


   -- {
   -- "rcarriga/nvim-dap-ui",
   -- dependencies = {
   -- 	"jay-babu/mason-nvim-dap.nvim",
   -- 	"mfussenegger/nvim-dap",
   -- 	"nvim-neotest/nvim-nio",
   -- 	"williamboman/mason.nvim",
   -- },
   -- },
		local mason = require("mason")
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		local ui = require("dapui")

		dap.set_log_level("TRACE")

		-- ╭──────────────────────────────────────────────────────────╮
		-- │ Debuggers                                                │
		-- ╰──────────────────────────────────────────────────────────╯
		-- We need the actual programs to connect to running instances of our code.
		-- Debuggers are installed via https://github.com/jayp0521/mason-nvim-dap.nvim
		mason.setup()
		mason_dap.setup({
			ensure_installed = {
				--"delve@v1.20.2",
				-- "js@v1.77.0",
				-- "node2@v1.43.0", TODO: Not working
			},
			automatic_installation = true,
		})

		dap.configurations.go = {
			{
				type = "go",
				name = "Attach",
				request = "attach",
				mode = "remote",
				host = "127.0.0.1",
				port = 8498,
				showLog = true,
				apiVersion = 2,
				trace = "verbose",
				dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
			},
			{
				type = "go",
				name = "Run (and debug)",
				request = "launch",
				showLog = false,
				program = "${file}",
				dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
			},
		}

		dap.adapters.go = {
			type = "executable",
			command = "node",
			args = { "/home/me/Projects/vscode-go/extension/dist/debugAdapter.js" },
		}

		-- ╭──────────────────────────────────────────────────────────╮
		-- │ Keybindings + UI                                         │
		-- ╰──────────────────────────────────────────────────────────╯
		vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "🟠", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })

		-- Opens up the debugger tab if it's not currently active
		local function dap_start_debugging()
			local has_dap_repl = false
			for _, buf in ipairs(vim.fn.tabpagebuflist()) do
				if vim.bo[buf].filetype == "dap-repl" then
					has_dap_repl = true
					break
				end
			end

			if not has_dap_repl then
				vim.cmd("tabedit %")
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", false, true, true), "n", false)
				ui.toggle({})
			end
			dap.continue({})
		end
		vim.keymap.set("n", "<leader>ds", dap_start_debugging)

		-- Detaches the debugger
		local function dap_end_debug()
			dap.disconnect({ terminateDebuggee = false }, function()
				vim.notify("Debugger detached", vim.log.levels.INFO)
                vim.cmd("tabclose")
			end)
		end
		vim.keymap.set("n", "<leader>dc", dap_end_debug)

		-- Kills the debug process
		local function dap_kill_debug_process()
			dap.clear_breakpoints()
			dap.terminate({}, { terminateDebuggee = true }, function()
				vim.cmd.bd()
				resize_vertical_splits()
				vim.notify("Debug process killed", vim.log.levels.WARN)
			end)
		end
		vim.keymap.set("n", "<leader>dk", dap_kill_debug_process)

		-- Bulk clear all breakpoints
		local function dap_clear_breakpoints()
			dap.clear_breakpoints()
			vim.notify("Breakpoints cleared", vim.log.levels.WARN)
		end

		vim.keymap.set("n", "<leader>dC", dap_clear_breakpoints)

		-- Other keybindings
		vim.keymap.set("v", "K", require("dap.ui.widgets").hover)
		vim.keymap.set("n", "<F4>", dap.continue)
		vim.keymap.set("n", "<F3>", dap.toggle_breakpoint)
		vim.keymap.set("n", "<F9>", dap.step_over)
		vim.keymap.set("n", "<F10>", dap.step_into)
		vim.keymap.set("n", "<F11>", dap.step_out)
		vim.keymap.set("n", "<leader>dr", function()
			require("dap").run_last()
		end) -- Repeat last command, e.g. attach to PID

		-- UI Settings
		ui.setup({
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "",
					pause = "",
					play = "",
					run_last = "",
					step_back = "",
					step_into = "",
					step_out = "",
					step_over = "",
					terminate = "",
				},
			},
			element_mappings = {},
			expand_lines = true,
			floating = {
				border = "single",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			force_buffers = true,
			icons = {
				collapsed = "",
				current_frame = "",
				expanded = "",
			},
			layouts = {
				{
					elements = {
						"scopes",
					},
					size = 0.3,
					position = "bottom",
				},
				{
					elements = {
						"repl",
						"breakpoints",
					},
					size = 0.3,
					position = "right",
				},
			},
			mappings = {
				edit = "e",
				expand = { "t", "<2-LeftMouse>" },
				remove = "d",
				repl = {},
				open = {},
				toggle = {},
			},
			render = {
				indent = 1,
				max_value_lines = 100,
			},
		})

    -- Fuzzy finder
    local builtin = require("telescope.builtin")

    map("n", "<leader>z", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { noremap = true, silent = true })
    map("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", { noremap = true, silent = true })
    map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { noremap = true, silent = true })
    map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { noremap = true, silent = true })
    map("n", "<leader>fg", builtin.live_grep, { noremap = true, silent = true })
    map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true <cr>", { noremap = true, silent = true })
    map("n", "<leader>c", "<cmd>Telescope resume<cr>", { noremap = true, silent = true })
    map("n", "<leader>b", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
    map("n", "<leader>oc", builtin.lsp_outgoing_calls, { noremap = true, silent = true })
    map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
    map("n", "<leader>ic", builtin.lsp_incoming_calls, { noremap = true, silent = true })
    map("n", "<leader>im", builtin.lsp_implementations, { noremap = true, silent = true })
    map("n", "<leader>re", builtin.lsp_references, { noremap = true, silent = true })
    map("n", "<leader>sy", builtin.lsp_document_symbols, { noremap = true, silent = true })
    map('n', '<leader>ref', require('telescope.builtin').lsp_references, { noremap = true, silent = true })
    map('n', '<leader>si', ':!kill -SIGINT $(pgrep __debug) <CR>', { noremap = true, silent = true })

    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            if vim.bo.filetype == "dap-repl" then
                vim.opt_local.wrap = true
            end
        end
    })

    vim.cmd [[
         set background=dark
         colorscheme oxocarbon
    ]]
end

