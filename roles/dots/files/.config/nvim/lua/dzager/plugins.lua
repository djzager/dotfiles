-- Automatically run :PackerCompile whenever plugins.lua is updated with an autocommand:
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('PACKER', { clear = true }),
  pattern = 'plugins.lua',
  command = 'source <afile> | PackerSync',
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
  end
})

return require('packer').startup({
  function(use)
    --------------
    -- Required --
    --------------
    use('wbthomason/packer.nvim')
    use('nvim-lua/plenary.nvim')

    -- Colorscheme
    use('shaunsingh/nord.nvim')

    ----------------
    -- LSP Config --
    ----------------
    use({
      {
        'neovim/nvim-lspconfig',
        config = function()
          -- Configuring native diagnostics
          vim.diagnostic.config({
            virtual_text = {
              source = 'always',
            },
            float = {
              source = 'always',
            },
          })

          -- Mappings.
          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          local opts = { noremap = true, silent = true }
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

          -- Use an on_attach function to only map the following keys
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
          end

          local lsp_flags = {
            -- This is the default in Nvim 0.7+
            debounce_text_changes = 150,
          }

          local lsp = require('lspconfig')

          lsp.lua_ls.setup({
            on_attach = on_attach,
            flags = lsp_flags,
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                  enable = false,
                },
              },
            }
          })

          -- Loop through the rest
          local servers = {
            "ansiblels",
            "rust_analyzer",
            "gopls",
            "bashls",
            "yamlls",
            "jsonls",
            "tsserver",
          }
          for _, server in ipairs(servers) do
            lsp[server].setup({
              flags = lsp_flags,
              on_attach = on_attach,
            })
          end
        end,
      },
      {
        'williamboman/mason.nvim',
        after = 'nvim-lspconfig',
        config = function()
          require('mason').setup()
        end,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        after = 'mason.nvim',
        config = function()
          require('mason-lspconfig').setup({
            ensure_installed = {
              "ansiblels",
              "lua_ls",
              "rust_analyzer",
              "gopls",
              "bashls",
              "yamlls",
              "jsonls",
              "tsserver",
            },
            automatic_installation = false,
          })
        end,
      },
    })

    ----------------
    -- Treesitter --
    ----------------
    use({
      {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
          require('nvim-treesitter.configs').setup({
            ensure_installed = { "go", "javascript", "lua", "rust", "tsx" },

            highlight = {
              -- `false` will disable the whole extension
              enable = true,

              -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
              -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
              -- the name of the parser)
              -- list of language that will be disabled
              disable = { "c", "rust" },

              -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
              -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
              -- Using this option may slow down your editor, and you may see some duplicate highlights.
              -- Instead of true it can also be a list of languages
              additional_vim_regex_highlighting = false,
            },

            -- set foldmethod=expr
            -- set foldexpr=nvim_treesitter#foldexpr()
          })
        end,
      },
      { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' },
    })

    --------------
    -- TMUX nav --
    --------------
    use({
      'alexghergh/nvim-tmux-navigation',
      config = function()
        local nvim_tmux_nav = require('nvim-tmux-navigation')

        nvim_tmux_nav.setup {
          disable_when_zoomed = true,
          keybindings = {
            left = "<C-h>",
            down = "<C-j>",
            up = "<C-k>",
            right = "<C-l>",
            last_active = "<C-\\>",
            next = "<C-Space>",
          }
        }
      end,
    })

    ----------------------
    -- Markdown preview --
    ----------------------
    use({
      'iamcco/markdown-preview.nvim',
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
    })

    ---------------------------
    -- Code formatting/Style --
    ---------------------------
    use({
      {
        'numToStr/Comment.nvim',
        config = function()
          require('Comment').setup()
        end
      },
      {
        'windwp/nvim-autopairs',
        event = 'InsertCharPre',
        config = function()
          require('nvim-autopairs').setup()
        end,
      },
      {
        'lewis6991/gitsigns.nvim',
        config = function()
          require('gitsigns').setup({
            signs = {
              add = { text = '+' },
              change = { text = '~' },
              changedelete = { text = '=' },
            },
          })
        end,
      },
      {
        'norcalli/nvim-colorizer.lua',
        config = function()
          require('colorizer').setup()
        end,
      }
    })

    ---------------
    -- Telescope --
    ---------------
    use({
      {
        'nvim-telescope/telescope.nvim',
        -- event = 'CursorHold',
        config = function()
          local actions = require('telescope.actions')

          require('telescope').setup({
            defaults = {
              prompt_prefix = ' ❯ ',
              initial_mode = 'insert',
              sorting_strategy = 'ascending',
              layout_config = {
                prompt_position = 'top',
              },
              mappings = {
                i = {
                  ['<ESC>'] = actions.close,
                  ['<C-j>'] = actions.move_selection_next,
                  ['<C-k>'] = actions.move_selection_previous,
                  ['<TAB>'] = actions.toggle_selection + actions.move_selection_next,
                  ['<C-s>'] = actions.send_selected_to_qflist,
                  ['<C-q>'] = actions.send_to_qflist,
                },
              },
            },
            extensions = {
              fzf = {
                fuzzy = true,
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = 'smart_case', -- "smart_case" | "ignore_case" | "respect_case"
              },
            },
          })

          local find_files_cmd = ':Telescope find_files hidden=true<cr>'
          vim.keymap.set('n', '<leader>ff', find_files_cmd, { noremap = true })
          vim.keymap.set('n', '<C-o>', find_files_cmd, { noremap = true })
          vim.keymap.set('n', '<leader>fg', ':Telescope live_grep hidden=true<cr>', { noremap = true })
          vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>', { noremap = true })
          vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<cr>', { noremap = true })

          vim.keymap.set('n', '<leader>gs', ':Telescope git_status<cr>', { noremap = true, silent = true })
        end,
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        after = 'telescope.nvim',
        run = 'make',
        config = function()
          require('telescope').load_extension('fzf')
        end,
      },
      {
        'nvim-telescope/telescope-github.nvim',
        after = 'telescope.nvim',
        config = function()
          require('telescope').load_extension('gh')
        end,
      },
    })

    ------------------------
    -- Status line config --
    ------------------------
    use({
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require('lualine').setup {
          options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
              statusline = {},
              winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
              statusline = 1000,
              tabline = 1000,
              winbar = 1000,
            }
          },
          sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = {}
        }
      end
    })

    -----------------------------
    -- Snippets and completion --
    -----------------------------
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
        { "hrsh7th/cmp-path", after = "nvim-cmp" },
        { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
        { "hrsh7th/cmp-calc", after = "nvim-cmp" },
        { "lukas-reineke/cmp-rg", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
        { "L3MON4D3/LuaSnip", requires = "rafamadriz/friendly-snippets" },
        { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
      },
      config   = function()
        ---@diagnostic disable
        local cmp = require("cmp")
        local compare = require("cmp.config.compare")
        local ok, ls = pcall(require, "luasnip")
        if not ok then
          return
        end

        --               ⌘  ⌂              ﲀ  練  ﴲ    ﰮ    
        --       ﳤ          ƒ          了    ﬌      <    >  ⬤      襁
        --                                                 
        -- stylua: ignore
        local kind_icons = { --{{{
          Buffers       = " ",
          Class         = " ",
          Color         = " ",
          Constant      = " ",
          Constructor   = " ",
          Enum          = " ",
          EnumMember    = " ",
          Event         = " ",
          Field         = "ﰠ ",
          File          = " ",
          Folder        = " ",
          Function      = "ƒ ",
          Interface     = " ",
          Keyword       = " ",
          Method        = " ",
          Module        = " ",
          Operator      = " ",
          Property      = " ",
          Reference     = " ",
          Snippet       = " ",
          Struct        = " ",
          TypeParameter = " ",
          Unit          = "塞 ",
          Value         = " ",
          Variable      = " ",
          Text          = " ",
        } --}}}


        cmp.setup({
          snippet = {
            expand = function(args)
              ls.lsp_expand(args.body)
            end,
          },

          preselect = cmp.PreselectMode.None,

          mapping = cmp.mapping.preset.insert({ --{{{
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.close(),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
            ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select, }),
            ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select, }),
          }), --}}}

          sources = cmp.config.sources({ --{{{
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "path", max_item_count = 4 },
            { name = "calc" },
            { name = "nvim_lsp_signature_help" },
            { name = "dap" },
            { name = "neorg", keyword_length = 1 },
            {
              name = "buffer",
              priority = 5,
              keyword_length = 3,
              max_item_count = 5,
              option = {
                get_bufnrs = function()
                  return vim.api.nvim_list_bufs()
                end,
              },
            },
            { name = "rg", keyword_length = 3, max_item_count = 10, priority = 1 },
          }), --}}}

          formatting = { --{{{
            fields = { "abbr", "kind", "menu" },
            format = function(entry, vim_item)
              local client_name = ""
              if entry.source.name == "nvim_lsp" then
                client_name = "/" .. entry.source.source.client.name
              end

              vim_item.menu = string.format("[%s%s]", ({
                buffer = "Buffer",
                nvim_lsp = "LSP",
                luasnip = "LuaSnip",
                vsnip = "VSnip",
                nvim_lua = "Lua",
                latex_symbols = "LaTeX",
                path = "Path",
                rg = "RG",
                omni = "Omni",
                copilot = "Copilot",
                dap = "DAP",
                neorg = "ORG",
              })[entry.source.name] or entry.source.name, client_name)

              vim_item.kind = string.format("%s %-9s", kind_icons[vim_item.kind], vim_item.kind)
              vim_item.dup = {
                buffer = 1,
                path = 1,
                nvim_lsp = 0,
                luasnip = 1,
              }
              return vim_item
            end,
          }, --}}}

          view = {
            max_height = 20,
          },

          sorting = { --{{{
            comparators = {
              function(...)
                return require("cmp_buffer"):compare_locality(...)
              end,
              compare.offset,
              compare.exact,
              compare.score,
              compare.recently_used,
              compare.kind,
              compare.sort_text,
              compare.length,
              compare.order,
            },
          }, --}}}
        })
      end,
    })

  end
})
