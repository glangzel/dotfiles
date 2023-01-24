call plug#begin('~/.local/share/nvim/plugged')

" Plugin Start
Plug 'lervag/vimtex'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'preservim/nerdtree'
Plug 'preservim/tagbar'

Plug 'edkolev/tmuxline.vim'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'previm/previm'

Plug 'brglng/vim-im-select'

" Markdown Config
let g:vim_markdown_folding_disabled = 1
let g:previm_enable_realtime = 1
let g:previm_open_cmd = 'open -a Google\ Chrome'

" Appearance Config
set background=dark
set number
set cursorline
highlight CursorLine term=reverse ctermbg=238

" Airline/Tmuxline Config
let g:tmuxline_preset = {
  \'a'    : '#S',
  \'win'  : ['#I', '#W'],
  \'cwin' : ['#I', '#W', '#F'],
  \'x'    : ['#(tmux-mem-cpu-load -a 0)'],
  \'y'    : ['%R', '%Y-%m-%d'],
  \'z'    : ['#(whoami)', '#H'],
  \'options' : {'status-justify' : 'left'}}
let g:tmuxline_theme = 'papercolor'
let g:tmuxline_powerline_separators = 0

let g:airline#extensions#tabline#enabled = 1

nmap <F8> :TagbarToggle<CR>

" Ctrl + e でエクスプローラー表示
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" IME Config(macOS)
" let g:im_select_default = 'com.apple.keylayout.ABC'

call plug#end()
