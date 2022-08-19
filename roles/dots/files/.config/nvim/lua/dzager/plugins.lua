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
    ---------------------
    -- Package Manager --
    ---------------------
    use('wbthomason/packer.nvim')

    --------------
    -- The Rest --
    --------------
    use('nvim-lua/plenary.nvim')
    use('shaunsingh/nord.nvim')
    use('L3MON4D3/LuaSnip')

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
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
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

          lsp.sumneko_lua.setup({
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
              "sumneko_lua",
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
    use({
      'iamcco/markdown-preview.nvim',
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
    })
    use({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    })
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
          vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>', { noremap = true })
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
    use({
      'windwp/nvim-autopairs',
      event = 'InsertCharPre',
      config = function()
        require('nvim-autopairs').setup()
      end,
    })
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })
    use({
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
    })
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

  end
})
