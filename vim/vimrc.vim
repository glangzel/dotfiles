" --- Generated for EDA Environment (Final) ---
set nocompatible
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp
set number
set norelativenumber
set cursorline
set hlsearch
set incsearch
set showmatch
set backspace=indent,eol,start
set t_Co=256
set clipboard+=unnamed
set hidden " 保存されていないバッファがあっても切り替え可能にする(重要)
syntax on

" --- カラースキーム ---
try
  colorscheme desert
catch
  colorscheme default
endtry

if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[3 q"
endif

" --- 外部設定の読み込み ---
if filereadable(expand("~/.vim/statusline.vim"))
  source ~/.vim/statusline.vim
endif

" --- バッファ切り替え用キーマップ (追加機能) ---
" [b で前のバッファ、]b で次のバッファへ移動
nnoremap <silent> [b :bprev<CR>
nnoremap <silent> ]b :bnext<CR>
" (オプション) 閉じる時は :bd ですが、強制的に閉じるマッピングも便利なら以下
" nnoremap <Leader>bd :bd<CR>

" --- Netrw Config (Filer) ---
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20

let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i 
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Vexplore!
    endif
endfunction
nnoremap <silent> <C-n> :call ToggleNetrw()<CR>

