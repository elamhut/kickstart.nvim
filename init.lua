vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.mouse = 'a'
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.confirm = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.timeoutlen = 500

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'no'
vim.o.splitright = true
vim.o.splitbelow = false
vim.o.scrolloff = 10

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Use Space instead of tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.breakindent = true
vim.o.smartindent = true

-- Preview substitutions live, as you type! (used for %s substitutions)
vim.o.inccommand = 'split'

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Removing Shift L and Shift R (alias for G and gg)
vim.keymap.set('n', '<S-h>', '<Nop>')
vim.keymap.set('n', '<S-l>', '<Nop>')

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Prime's Keybind to move up and down in the editor
vim.keymap.set('n', '<C-j>',      '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', '<PageDown>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', '<C-k>',      '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', '<PageUp>',   '<C-u>zz', { desc = 'Scroll up and center' })

-- Move lines up and down with Alt+Shift+j/k in normal, insert, and visual modes
vim.keymap.set('n', '<A-J>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-K>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('i', '<A-J>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-K>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })
vim.keymap.set('v', '<A-J>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-K>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Delete and Paste without adding stuff to the register
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- Keybinds to move the caret in insert mode using Ctrl+h/j/k/l
vim.keymap.set('i', '<C-h>', '<Left>',  { desc = 'Move caret left in insert mode' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move caret right in insert mode' })
vim.keymap.set('i', '<C-j>', '<Down>',  { desc = 'Move caret down in insert mode' })
vim.keymap.set('i', '<C-k>', '<Up>',    { desc = 'Move caret up in insert mode' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)


-- NOTE: Here is where you install your plugins.
require('lazy').setup({

  {
    'numToStr/Comment.nvim',
    opts = {
      padding = true
    },
    config = function()
      require('Comment').setup()
      vim.keymap.set('n', '<C-/>', 'gcc', { desc = 'Toggle line comment' })
      vim.keymap.set('v', '<C-/>', 'gc',  { desc = 'Toggle line comment' })
    end,
  },

  {
    'smoka7/hop.nvim',
    version = '*',
    opts = {
      keys = 'etovxqpdygfblzhckisuran',
      uppercase_labels = true,
      multi_windows = true,
    },
    config = function()
      local hop = require 'hop'
      hop.setup()
      vim.keymap.set('n', '<leader><leader>', hop.hint_char2, { desc = 'Hop 2 Chars' })
      vim.keymap.set('n', '<leader>w', hop.hint_words, { desc = 'Hop in Words' })
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },

    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>se', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>/', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>ss', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[S]earch Fuzzily  in current buffer' })

      vim.keymap.set('n', '<leader>so', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = '[S]earch Live Grep in [O]pen Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      local actions = require 'telescope.actions'
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
        },
      }
      require('telescope').load_extension 'ui-select'
    end,
  },

  -- Change from Header to CPP Plugin
  {
    'jakemason/ouroboros',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp' },
        callback = function()
          vim.keymap.set('n', '<C-e>', ':Ouroboros<CR>', { buffer = true, desc = 'Ouroboros: switch header/source' })

          vim.keymap.set('n', '<leader>sv', ':vsplit | Ouroboros<CR>', { buffer = true, desc = 'Ouroboros: vertical split' })
          vim.keymap.set('n', '<leader>sh', ':split | Ouroboros<CR>', { buffer = true, desc = 'Ouroboros: horizontal split' })
        end,
      })
    end,
  },

  -- -- LSP Plugins
  -- {
  --   -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  --   -- used for completion, annotations and signatures of Neovim apis
  --   'folke/lazydev.nvim',
  --   ft = 'lua',
  --   opts = {
  --     library = {
  --       -- Load luvit types when the `vim.uv` word is found
  --       { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  --     },
  --   },
  -- },
  -- {
  --   -- Main LSP Configuration
  --   'neovim/nvim-lspconfig',
  --   dependencies = {
  --     -- Automatically install LSPs and related tools to stdpath for Neovim
  --     -- Mason must be loaded before its dependents so we need to set it up here.
  --     -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
  --     { 'mason-org/mason.nvim', opts = {} },
  --     'mason-org/mason-lspconfig.nvim',
  --     'WhoIsSethDaniel/mason-tool-installer.nvim',
  --
  --     -- Useful status updates for LSP.
  --     { 'j-hui/fidget.nvim', opts = {} },
  --
  --     -- Allows extra capabilities provided by blink.cmp
  --     'saghen/blink.cmp',
  --   },
  --   config = function()
  --     -- Brief aside: **What is LSP?**
  --     --
  --     -- LSP is an initialism you've probably heard, but might not understand what it is.
  --     --
  --     -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  --     -- and language tooling communicate in a standardized fashion.
  --     --
  --     -- In general, you have a "server" which is some tool built to understand a particular
  --     -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  --     -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  --     -- processes that communicate with some "client" - in this case, Neovim!
  --     --
  --     -- LSP provides Neovim with features like:
  --     --  - Go to definition
  --     --  - Find references
  --     --  - Autocompletion
  --     --  - Symbol Search
  --     --  - and more!
  --     --
  --     -- Thus, Language Servers are external tools that must be installed separately from
  --     -- Neovim. This is where `mason` and related plugins come into play.
  --     --
  --     -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  --     -- and elegantly composed help section, `:help lsp-vs-treesitter`
  --
  --     --  This function gets run when an LSP attaches to a particular buffer.
  --     --    That is to say, every time a new file is opened that is associated with
  --     --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --     --    function will be executed to configure the current buffer
  --     vim.api.nvim_create_autocmd('LspAttach', {
  --       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  --       callback = function(event)
  --         -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  --         -- to define small helper and utility functions so you don't have to repeat yourself.
  --         --
  --         -- In this case, we create a function that lets us more easily define mappings specific
  --         -- for LSP related items. It sets the mode, buffer and description for us each time.
  --         local map = function(keys, func, desc, mode)
  --           mode = mode or 'n'
  --           vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  --         end
  --
  --         -- Rename the variable under your cursor.
  --         --  Most Language Servers support renaming across files, etc.
  --         map('<A-r>', vim.lsp.buf.rename, '[R]e[n]ame')
  --
  --         -- Execute a code action, usually your cursor needs to be on top of an error
  --         -- or a suggestion from your LSP for this to activate.
  --         map('<A-a>', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
  --
  --         -- Find references for the word under your cursor.
  --         map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  --
  --         -- Jump to the implementation of the word under your cursor.
  --         --  Useful when your language has ways of declaring types without an actual implementation.
  --         map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  --
  --         -- Jump to the definition of the word under your cursor.
  --         --  This is where a variable was first declared, or where a function is defined, etc.
  --         --  To jump back, press <C-t>.
  --         map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  --
  --         -- WARN: This is not Goto Definition, this is Goto Declaration.
  --         --  For example, in C this would take you to the header.
  --         map('<A-d>', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  --
  --         -- Fuzzy find all the symbols in your current document.
  --         --  Symbols are things like variables, functions, types, etc.
  --         map('<leader>sy', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
  --
  --         -- Fuzzy find all the symbols in your current workspace.
  --         --  Similar to document symbols, except searches over your entire project.
  --         map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
  --
  --         -- Jump to the type of the word under your cursor.
  --         --  Useful when you're not sure what type a variable is and you want to see
  --         --  the definition of its *type*, not where it was *defined*.
  --         map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
  --
  --         -- Go to next diagnostic
  --         map('<leader>e', vim.diagnostic.goto_next, '[N]ext [D]iagnostic')
  --
  --         -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
  --         ---@param client vim.lsp.Client
  --         ---@param method vim.lsp.protocol.Method
  --         ---@param bufnr? integer some lsp support methods only in specific files
  --         ---@return boolean
  --         local function client_supports_method(client, method, bufnr)
  --           if vim.fn.has 'nvim-0.11' == 1 then
  --             return client:supports_method(method, bufnr)
  --           else
  --             return client.supports_method(method, { bufnr = bufnr })
  --           end
  --         end
  --
  --         -- The following two autocommands are used to highlight references of the
  --         -- word under your cursor when your cursor rests there for a little while.
  --         --    See `:help CursorHold` for information about when this is executed
  --         --
  --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
  --         local client = vim.lsp.get_client_by_id(event.data.client_id)
  --         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
  --           local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
  --           vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.document_highlight,
  --           })
  --
  --           vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  --             buffer = event.buf,
  --             group = highlight_augroup,
  --             callback = vim.lsp.buf.clear_references,
  --           })
  --
  --           vim.api.nvim_create_autocmd('LspDetach', {
  --             group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
  --             callback = function(event2)
  --               vim.lsp.buf.clear_references()
  --               vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
  --             end,
  --           })
  --         end
  --
  --         -- The following code creates a keymap to toggle inlay hints in your
  --         -- code, if the language server you are using supports them
  --         --
  --         -- This may be unwanted, since they displace some of your code
  --         if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
  --           map('<leader>th', function()
  --             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
  --           end, '[T]oggle Inlay [H]ints')
  --         end
  --       end,
  --     })
  --
  --     -- Diagnostic Config
  --     -- See :help vim.diagnostic.Opts
  --     vim.diagnostic.config {
  --       severity_sort = true,
  --       float = { border = 'rounded', source = 'if_many' },
  --       underline = false,
  --       signs = vim.g.have_nerd_font and {
  --         text = {
  --           [vim.diagnostic.severity.ERROR] = '󰅚 ',
  --           [vim.diagnostic.severity.WARN] = '󰀪 ',
  --           [vim.diagnostic.severity.INFO] = '󰋽 ',
  --           [vim.diagnostic.severity.HINT] = '󰌶 ',
  --         },
  --       } or {},
  --       virtual_text = false,
  --     }
  --
  --     -- LSP servers and clients are able to communicate to each other what features they support.
  --     --  By default, Neovim doesn't support everything that is in the LSP specification.
  --     --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
  --     --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
  --     local capabilities = require('blink.cmp').get_lsp_capabilities()
  --
  --     -- Enable the following language servers
  --     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --     --
  --     --  Add any additional override configuration in the following tables. Available keys are:
  --     --  - cmd (table): Override the default command used to start the server
  --     --  - filetypes (table): Override the default list of associated filetypes for the server
  --     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --     --  - settings (table): Override the default settings passed when initializing the server.
  --     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  --     local servers = {
  --       clangd = {},
  --       -- gopls = {},
  --       -- pyright = {},
  --       -- rust_analyzer = {},
  --       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --       --
  --       -- Some languages (like typescript) have entire language plugins that can be useful:
  --       --    https://github.com/pmizio/typescript-tools.nvim
  --       --
  --       -- But for many setups, the LSP (`ts_ls`) will work just fine
  --       -- ts_ls = {},
  --       --
  --
  --       lua_ls = {
  --         -- cmd = { ... },
  --         -- filetypes = { ... },
  --         -- capabilities = {},
  --         settings = {
  --           Lua = {
  --             completion = {
  --               callSnippet = 'Replace',
  --             },
  --             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
  --             -- diagnostics = { disable = { 'missing-fields' } },
  --           },
  --         },
  --       },
  --     }
  --
  --     -- Ensure the servers and tools above are installed
  --     --
  --     -- To check the current status of installed tools and/or manually install
  --     -- other tools, you can run
  --     --    :Mason
  --     --
  --     -- You can press `g?` for help in this menu.
  --     --
  --     -- `mason` had to be setup earlier: to configure its options see the
  --     -- `dependencies` table for `nvim-lspconfig` above.
  --     --
  --     -- You can add other tools here that you want Mason to install
  --     -- for you, so that they are available from within Neovim.
  --     local ensure_installed = vim.tbl_keys(servers or {})
  --     vim.list_extend(ensure_installed, {
  --       'stylua', -- Used to format Lua code
  --     })
  --     require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  --
  --     require('mason-lspconfig').setup {
  --       ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
  --       automatic_installation = false,
  --       handlers = {
  --         function(server_name)
  --           local server = servers[server_name] or {}
  --           -- This handles overriding only values explicitly passed
  --           -- by the server configuration above. Useful when disabling
  --           -- certain features of an LSP (for example, turning off formatting for ts_ls)
  --           server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  --           require('lspconfig')[server_name].setup(server)
  --         end,
  --       },
  --     }
  --   end,
  -- },

-- Treesitter
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

 -- Autocompletion
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      'folke/lazydev.nvim',
    },
    opts = {

      keymap = {
        preset = 'none',

        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-y>'] = { 'select_and_accept' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<CR>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<C-.>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 10 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },

      signature = { enabled = true },
    },
  },

  {
    'kylechui/nvim-surround',
    version = '^3.0.0', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
      }
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('kanagawa').setup {
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = 'wave',
        background = {
          dark = 'wave',
          light = 'lotus',
        },
      }

      vim.cmd.colorscheme 'kanagawa'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

    end,
  },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

