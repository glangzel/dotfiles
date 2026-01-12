" ==========================================
" Lualine風 ステータスライン (背景透過対応)
" ==========================================
if exists("g:loaded_my_statusline")
  finish
endif
let g:loaded_my_statusline = 1

" --- ハイライト定義 (ここがポイント) ---
" MyInactive: 文字はグレー(242), 背景はなし(NONE)
highlight MyInactive ctermfg=242 ctermbg=NONE guifg=#6c6c6c guibg=NONE

" --- Buffer Line (上部: 常時表示) ---
set showtabline=2 

function! MyTabLine()
  let l:s = ''
  let l:last_buffer = bufnr('$')
  for i in range(1, l:last_buffer)
    if buflisted(i)
      if i == bufnr('%')
        let l:s .= '%#TabLineSel#' 
      else
        let l:s .= '%#TabLine#' 
      endif
      let l:fname = fnamemodify(bufname(i), ':t')
      if l:fname == ''
        let l:fname = '[No Name]'
      endif
      let l:s .= ' ' . i . ':' . l:fname
      if getbufvar(i, "&mod")
        let l:s .= '[+]'
      endif
      let l:s .= ' '
    endif
  endfor
  let l:s .= '%#TabLineFill#%T'
  return l:s
endfunction
set tabline=%!MyTabLine()

" --- Git Branch 取得ロジック (軽量化キャッシュ版) ---
function! GetGitBranch()
  " 既にキャッシュがあればそれを使う
  if exists("b:git_branch")
    return b:git_branch
  endif
  
  " キャッシュがない場合のみコマンド実行
  " (古いgitでも動く rev-parse を使用)
  try
    let l:cmd = "git rev-parse --abbrev-ref HEAD 2>/dev/null"
    let l:branch = system(l:cmd)
    let l:branch = substitute(l:branch, '\n', '', 'g') " 改行除去
    let b:git_branch = l:branch
    return b:git_branch
  catch
    let b:git_branch = ""
    return ""
  endtry
endfunction

" イベント発生時にキャッシュを更新する関数
function! RefreshGitBranch()
  unlet! b:git_branch " キャッシュ削除
  call GetGitBranch() " 再取得
  redrawstatus
endfunction

" 自動更新の設定
augroup GitBranchCache
  autocmd!
  " ファイルを開いた時、保存した時、シェルから戻った時に更新
  autocmd BufEnter,BufWritePost,ShellCmdPost,FocusGained * call RefreshGitBranch()
augroup END

" --- Status Line (下部: ウィンドウごとに切り替え) ---
set laststatus=2

function! GetMode()
  let l:mode = mode()
  if l:mode ==# 'n'
     return '  NORMAL '
  elseif l:mode ==# 'i'
     return '  INSERT '
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-v>"
     return '  VISUAL '
  elseif l:mode ==# 'R'
     return '  REPLACE '
  else
     return ' ' . l:mode . ' '
  endif
endfunction

function! GetPct()
  let l:curr = line('.')
  let l:total = line('$')
  if l:total == 0
    return '0%'
  endif
  let l:pct = (l:curr * 100) / l:total
  return l:pct . '%' 
endfunction

" 1. アクティブウィンドウ用
function! SetActiveStatusLine()
  let l:s = ''
  let l:s .= '%#DiffAdd#%{(mode()=="n")?GetMode():""}'
  let l:s .= '%#DiffChange#%{(mode()=="i")?GetMode():""}'
  let l:s .= '%#DiffText#%{(mode()=="v"||mode()=="V"||mode()==nr2char(22))?GetMode():""}'
  let l:s .= '%#ErrorMsg#%{(mode()=="R")?GetMode():""}'
  let l:s .= '%*'
  
  " --- Git Branch 表示部分 (追加) ---
  " ブランチ名がある場合のみ表示
  let l:branch = GetGitBranch()
  if l:branch != ""
    let l:s .= ' ' . l:branch . ' | '
  else
    let l:s .= ' '
  endif
  " -------------------------------

  let l:s .= ' %<%F %m%r%h '
  let l:s .= '%='
  let l:s .= ' %{GetPct()} | %Y | %{&fileencoding} | %l:%c '
  let &l:statusline = l:s
endfunction

" 2. 非アクティブウィンドウ用 (背景なし)
function! SetInactiveStatusLine()
  let l:s = ''
  " ここでカスタム定義した背景なしハイライトを適用
  let l:s .= '%#MyInactive#'
  
  " ファイル名だけシンプルに表示
  let l:s .= ' %F %m%r%h '
  
  " 右寄せしてパーセンテージだけ表示
  let l:s .= '%='
  let l:s .= ' %{GetPct()} '
  
  let &l:statusline = l:s
endfunction

" 3. 自動切り替え
augroup StatusLineSwitch
  autocmd!
  autocmd WinEnter,BufEnter * call SetActiveStatusLine()
  autocmd WinLeave * call SetInactiveStatusLine()
augroup END

call SetActiveStatusLine()

