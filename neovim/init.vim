let g:python_host_prog  = '/usr/local/bin/python3'
let g:python3_host_prog  = '/usr/local/bin/python3'
set number
set laststatus=2
set background=dark
set shiftwidth=4
set showcmd
set nocompatible
set path+=**
set wildmenu
set tabstop=2
set shiftwidth=2
set expandtab

colorscheme muon
call plug#begin('~/.local/share/nvim/plugs')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'abudden/taghighlight-automirror'
Plug 'tomasiser/vim-code-dark'
Plug 'romainl/Apprentice'
Plug 'junegunn/vim-easy-align'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'windwp/windline.nvim'
Plug 'cocopon/iceberg.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'folke/tokyonight.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'nyoom-engineering/oxocarbon.nvim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'Mofiqul/vscode.nvim'
Plug 'scottmckendry/cyberdream.nvim'
Plug 'maxmx03/fluoromachine.nvim'
Plug 'olivercederborg/poimandres.nvim'
Plug 'blazkowolf/gruber-darker.nvim'
Plug 'aliqyan-21/darkvoid.nvim'
Plug '0xstepit/flow.nvim'
Plug 'Skalyaeve/a-nvim-theme'
Plug 'dgox16/oldworld.nvim'
Plug 'm15a/nvim-srcerite'
Plug 'b0o/lavi.nvim'
Plug 'rktjmp/lush.nvim'

Plug 'bfrg/vim-cpp-modern'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'neoclide/coc-highlight'

Plug 'MeanderingProgrammer/render-markdown.nvim'

" Remote development
Plug 'amitds1997/remote-nvim.nvim'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'pocco81/auto-save.nvim'

Plug 'ntpeters/vim-better-whitespace'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'lewis6991/gitsigns.nvim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" On-demand loading

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons' " Optional, for file icons

"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'ncm2/ncm2', { 'do': ':UpdateRemotePlugins'}
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'junegunn/fzf'

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'


Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'zsh install.sh'
    \ }

Plug 'pangloss/vim-javascript'

Plug 'https://github.com/tpope/vim-fugitive'

Plug 'airblade/vim-gitgutter'

Plug 'ludovicchabant/vim-gutentags'

Plug 'zivyangll/git-blame.vim'

Plug 'simplyzhao/cscope_maps.vim'

Plug 'tpope/vim-commentary'
Plug 'isRuslan/vim-es6'
Plug 'rhysd/vim-clang-format'

call plug#end()

" C++ syntax highlighting modifications
" Enable coc.nvim
let g:coc_global_extensions = ['coc-clangd', 'coc-python', 'coc-tsserver']

" Optional: Configure clangd options
let g:coc_clangd_args = ['--background-index', '--clang-tidy']

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

" Use Enter to confirm completion
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Ensure Coc uses correct behavior for <Tab> and <S-Tab>
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"



set completeopt=noinsert,menuone,noselect

" Map Ctrl-N to toggle nerd tree
map <C-n> :NERDTreeToggle<CR>
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>
"
set tags+=/usr/local/include/node

let g:PaperColor_Theme_Options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }

let g:gutentags_enabled = 0
  augroup auto_gutentags
    au FileType c,cpp,javascript,python,java,scala,sh,groovy,vim let g:gutentags_enabled=1
  augroup plug#end

autocmd FileType c,cpp,h,hpp ClangFormatAutoEnable
set encoding=UTF-8

" Clipboard
set clipboard+=unnamedplus

lua << EOF
local telescope = require('telescope')
-- local sorters = require('telescope.sorters')

telescope.setup {
  extensions = {
--    defaults = {
--      sorting_strategy = "ascending",
--      layout_config = {
--        prompt_position = "top",
--      },
--      file_sorter = sorters.get_fuzzy_file,
--      generic_sorter = sorters.get_generic_fuzzy_sorter,
--    },
--    pickers = {
--      live_grep_args = {
--        sorting_strategy = "ascending",
--        sorter = sorters.get_generic_fuzzy_sorter(),
--      },
--    },
    live_grep_args = {
      auto_quoting = true,  -- enable/disable auto-quoting
      mappings = {          -- extend mappings
        i = {
          ["<C-k>"] = require('telescope-live-grep-args.actions').quote_prompt(),
          ["<C-i>"] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = " --iglob " }),
        },
      },
      additional_args = function(opts)
        return {"--glob", "!**/tags", "--glob", "!*.log"}
      end,
    },
    frecency = {
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = {"*.git/*", "*/tmp/*", "*.log"},
      workspaces = {
        ["conf"]    = "/Users/ebuckshi/.config",
        ["data"]    = "/Users/ebuckshi/.local/share",
        ["project"] = "/data/",
        ["wiki"]    = "/data/Platform"
      }
    }
  }
}
telescope.load_extension('live_grep_args')
telescope.load_extension('frecency')
EOF

" Key mappings
nnoremap <leader>fr :lua require('telescope').extensions.frecency.frecency()<CR>
nnoremap <leader>fg :lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>

"nnoremap <leader>rc :lua require('remote-sshfs.api').connect()<CR>
"nnoremap <leader>rd :lua require('remote-sshfs.api').disconnect()<CR>
"nnoremap <leader>re :lua require('remote-sshfs.api').edit()<CR>

" Plugin configuration
lua << EOF
require('render-markdown').setup {
  file_types = { 'markdown' },
  anti_conceal = {
    enabled = true,
    ignore = { 'code_background', 'sign' },
    above = 0,
    below = 0,
  },
  win_options = {
    conceallevel = {
      default = vim.api.nvim_get_option_value('conceallevel', {}),
      rendered = 3,
    },
    concealcursor = {
      default = vim.api.nvim_get_option_value('concealcursor', {}),
      rendered = '',
    },
  },
}
EOF

" Key mappings
nnoremap <leader>rt :lua require('render-markdown').toggle()<CR>

nnoremap <leader>rpc :let @+ = expand('%')<CR>
nnoremap <leader>apc :let @+ = expand('%:p')<CR>

"" Delete shouldn't populate clipboard
nnoremap d "_d
nnoremap dd "_dd
nnoremap dw "_dw
vnoremap d "_d

lua << EOF
require('fluoromachine').setup({
  glow = true,  -- Enable glow effect
  theme = 'retrowave',  -- Set the theme variant
  transparent = false,  -- Disable transparent background
})
EOF

lua << EOF
require("nvim-tree").setup({
  view = {
    width = 30, -- Width of the tree
    side = "left", -- Tree on the left
  },
  renderer = {
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
      },
    },
  },
  git = {
    enable = true,
  },
  filters = {
    dotfiles = false, -- Show hidden files
  },
})

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true })

EOF

" gitsigns
lua << EOF
require('gitsigns').setup({
  current_line_blame = true, -- Enable inline blame for the current line
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Key mappings for gitsigns
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', { noremap = true, silent = true })
  end,
})
EOF

lua << EOF
require("cyberdream").setup({
    -- Enable transparent background
    transparent = false,

    -- Enable italics comments
    italic_comments = false,

    -- Replace all fillchars with ' ' for the ultimate clean look
    hide_fillchars = false,

    -- Modern borderless telescope theme - also applies to fzf-lua
    borderless_telescope = true,

    -- Set terminal colors used in `:terminal`
    terminal_colors = true,

    -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
    cache = false,

    theme = {
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
        saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)
        highlights = {
            -- Highlight groups to override, adding new groups is also possible
            -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

            -- Example:
            Comment = { fg = "#696969", bg = "NONE", italic = true },

            -- Complete list can be found in `lua/cyberdream/theme.lua`
        },

        -- Override a highlight group entirely using the color palette
        overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
            -- Example:
            return {
                Comment = { fg = colors.green, bg = "NONE", italic = true },
                ["@property"] = { fg = colors.magenta, bold = true },
            }
        end,

        -- Override a color entirely
        colors = {
            -- For a list of colors see `lua/cyberdream/colours.lua`
            -- Example:
            bg = "#1c1c1c",
            -- green = "#00ff00",
            -- magenta = "#ff00ff",
        },
    },

    -- Disable or enable colorscheme extensions
    extensions = {
        telescope = true,
        notify = true,
        mini = true,
        ...
    },
})
EOF

colorscheme cyberdream

lua << EOF
vim.api.nvim_set_hl(0, "Visual", { fg = "#1c1c1c", bg = "#87ffdf", bold = false })
EOF

lua << EOF
local telescope = require('telescope')
local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')

function _G.spell_suggestions()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local sorters = require('telescope.sorters')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- Get suggestions for the current word under the cursor
    local misspelled_word = vim.fn.expand('<cword>')
    local suggestions = vim.fn.spellsuggest(vim.fn.expand(misspelled_word))

    pickers.new({}, {
        prompt_title = 'Spell Suggestions: "' .. misspelled_word .. '"',
        finder = finders.new_table {
            results = suggestions,
        },
        sorter = sorters.get_generic_fuzzy_sorter(),
        layout_config = {
            width = 0.3, -- 30% of the editor width
            preview_width = 0.5, -- Optional, for preview customization
        },
        attach_mappings = function(_, map)
            -- Map the <CR> key to replace the word
            map('i', '<CR>', function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                    -- Replace the current word with the selected suggestion
                    vim.api.nvim_command('normal! ciw' .. selection[1])
                end
            end)
            return true
        end,
    }):find()
end
EOF

nnoremap <leader>ss :lua spell_suggestions()<CR>

lua << EOF
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "cpp", "lua", "python", "javascript" },
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
    },
    textobjects = {
        enable = true,
    },
    --rainbow = {
    --enable = true,
    --extended_mode = false, -- Highlight also non-bracket delimiters like html tags, boolean or table: lang -> boolean
    --max_file_lines = nil, -- Do not enable for files with more than n lines, int
    --},
}
EOF

lua << EOF
require('statusline')
EOF
