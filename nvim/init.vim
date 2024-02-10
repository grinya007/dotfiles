" Based on
"   - https://github.com/nikvdp/nvim-lsp-config
"   - https://sharksforarms.dev/posts/neovim-rust/

call system("mkdir -p $HOME/.vim/{backup,plugin,undo}")
" >> load plugins
call plug#begin(stdpath('data') . 'vimplug')
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer', { 'branch': 'main' }
    Plug 'kien/ctrlp.vim'

    " To enable more of the features of rust-analyzer, such as inlay hints and more!
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'simrat39/rust-tools.nvim'
    Plug 'rust-lang/rust.vim'
    Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }

    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'

    " Plug 'hrsh7th/nvim-compe'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'

    Plug 'grinya007/vim-airline'

    Plug 'nikvdp/neomux'

    Plug 'tpope/vim-ragtag'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'

    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-fugitive'

    Plug 'grinya007/melange-nvim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'scrooloose/nerdtree'
    Plug 'simrat39/symbols-outline.nvim'
    Plug 'bbrtj/vim-jsonviewer'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'pest-parser/pest.vim'
    Plug 'stevearc/vim-arduino'
call plug#end()



" >> basic settings
syntax on
set nocompatible
set number
" set relativenumber    " this is nuts
set ignorecase        " ignore case
set smartcase         " but don't ignore it, when search string contains uppercase letters
set incsearch         " do incremental searching
set visualbell
set expandtab
set tabstop=4
set ruler
set smartindent
set shiftwidth=4
set hlsearch
" set virtualedit=all  " this is weird when cursor can go beyond end of line
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent
" set mouse=a  " mouse support
set mouse=     " no

set cursorline                              " hilight cursor line
set noshowmode                              " hide mode, got powerline
set cursorcolumn
set nostartofline                           " keep cursor column pos
set background=dark                         " we're using a dark bg
set termguicolors
colorscheme melange
highlight Normal ctermbg=NONE               " use terminal background
highlight nonText ctermbg=NONE              " use terminal background

if has('persistent_undo') && exists("&undodir")
    set undodir=$HOME/.vim/undo/            " where to store undofiles
    set undofile                            " enable undofile
    set undolevels=500                      " max undos stored
    set undoreload=10000                    " buffer stored undos
endif
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal! g`\"" |
    \ endif

autocmd FileType perl setlocal shiftwidth=2 softtabstop=2 expandtab

let g:mapleader=","

" >> CtrlP
let g:ctrlp_working_path_mode = 0
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_files = 10000
let g:ctrlp_max_depth = 12
nmap <leader>l :CtrlPBuffer<CR>
nmap <leader>; :CtrlPMRUFiles<CR>
nmap <leader>' :CtrlP<CR>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.git|node_modules|target)$',
    \ }


" jsonviewer
nnoremap <Leader>j <cmd>call jsonviewer#init()<CR>

" >> Airline
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.notexists = ''
let g:airline_symbols.dirty=''

" >> NERDCommenter
let g:NERDDefaultAlign = 'left'
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
map <leader>. <Plug>NERDCommenterToggle

" >> NERDTree
map <F2> :NERDTreeToggle<CR>
map <leader>r :NERDTreeFind<cr>
nmap <leader>= :vertical resize +10<CR>
nmap <leader>- :vertical resize -10<CR>

set pastetoggle=<F5>

" >> Lsp key bindings
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.format(nil, 200)<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
autocmd BufWritePre *.rs lua vim.lsp.buf.format(nil, 200)


" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>
" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes


" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local function on_attach(client, buffer)
    client.server_capabilities.semanticTokensProvider = nil
end

local opts = {
    tools = { -- rust-tools options
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = " <- ",
            other_hints_prefix = " -> ",
        },
    },
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                },
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_self",
                },
                procMacro = {
                    enable = true
                },
            }
        }
    },
}

require'lspconfig'.tsserver.setup {}
require'lspconfig'.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                pylsp_mypy = { enabled = false },
                mccabe = { enabled = false },
                ruff = { enabled = true },
                rope = { enabled = true },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                rope_autoimport = {
                    enabled = true,
                },
            },
        },
        ruff_lsp = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
}

require('rust-tools').setup(opts)
require("fidget").setup()

require'lspconfig'.perlpls.setup {
    perl = {
        perlcritic = {
            enabled = false
        },
        syntax = {
            enabled = false
        },
    },
}

EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

lua <<EOF
-- init.lua
local opts = {
  highlight_hovered_item = true,
  show_guides = true,
  auto_preview = false,
  position = 'left',
  relative_width = true,
  width = 25,
  auto_close = false,
  show_numbers = false,
  show_relative_numbers = false,
  show_symbol_details = true,
  preview_bg_highlight = 'Pmenu',
  autofold_depth = nil,
  auto_unfold_hover = true,
  fold_markers = { '+', '+' },
  wrap = false,
  keymaps = { -- These keymaps can be a string or a table for multiple keys
    close = {"<Esc>", "q"},
    goto_location = "<Cr>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    toggle_preview = "K",
    rename_symbol = "r",
    code_actions = "a",
    fold = "h",
    unfold = "l",
    fold_all = "W",
    unfold_all = "E",
    fold_reset = "R",
  },
  lsp_blacklist = {},
  symbol_blacklist = {},
  symbols = {
    File = {icon = "F", hl = "TSURI"},
    Module = {icon = "M", hl = "TSNamespace"},
    Namespace = {icon = "N", hl = "TSNamespace"},
    Package = {icon = "P", hl = "TSNamespace"},
    Class = {icon = "C", hl = "TSType"},
    Method = {icon = "m", hl = "TSMethod"},
    Property = {icon = "p", hl = "TSMethod"},
    Field = {icon = "f", hl = "TSField"},
    Constructor = {icon = "", hl = "TSConstructor"},
    Enum = {icon = "E", hl = "TSType"},
    Interface = {icon = "I", hl = "TSType"},
    Function = {icon = "fn", hl = "TSFunction"},
    Variable = {icon = "v", hl = "TSConstant"},
    Constant = {icon = "c", hl = "TSConstant"},
    String = {icon = "s", hl = "TSString"},
    Number = {icon = "n", hl = "TSNumber"},
    Boolean = {icon = "b", hl = "TSBoolean"},
    Array = {icon = "a", hl = "TSConstant"},
    Object = {icon = "o", hl = "TSType"},
    Key = {icon = "k", hl = "TSType"},
    Null = {icon = "NULL", hl = "TSType"},
    EnumMember = {icon = "mbr", hl = "TSField"},
    Struct = {icon = "S", hl = "TSType"},
    Event = {icon = "e", hl = "TSType"},
    Operator = {icon = "+", hl = "TSOperator"},
    TypeParameter = {icon = "T", hl = "TSParameter"}
  }
}

require("symbols-outline").setup(opts)
EOF
map <F3> :SymbolsOutline<CR>

map <leader>c :cclose<cr>
map <leader>b :Git blame<cr>
map <leader>z :set hlsearch!<cr>

map <leader>aa <cmd>ArduinoAttach<CR>
map <leader>av <cmd>ArduinoVerify<CR>
map <leader>au <cmd>ArduinoUpload<CR>
map <leader>aus <cmd>ArduinoUploadAndSerial<CR>
map <leader>as <cmd>ArduinoSerial<CR>
map <leader>ab <cmd>ArduinoChooseBoard<CR>
map <leader>ap <cmd>ArduinoChooseProgrammer<CR>

