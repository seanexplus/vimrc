" 參考Software design 2018 七月號Vim 特集中的Vim 設定檔
" Vim8用sample vimrc
"
if has('win32')                   " 偵測Windows 32bit 或 64bit ?
  set encoding=utf-8              " 理論上在中文Windows 10上應該修改為cp950 但是我還是修改成utf-8
else
  set encoding=utf-8
endif
scriptencoding utf-8              " 設定這個vim 設定檔的編碼

" 讀取vim 目錄下的vim 預設值設定 (:h default.vim)
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

"===============================================================================
" 設定的項目集中在這區塊
" 不熟的項目則加入相關的文件指引註解，例如:
" :h 'helplang

" 取消原版的日文文件讀取與設定
"packadd! vimdoc-ja                " 日本語help の読み込み
"set helplang=ja,en                " help言語の設定

set scrolloff=0
set laststatus=2                  " 狀態列常駐
set cmdheight=2                   " 減少hit-enter的次數? 需要理解文件!
set number                        " 加入行號
set tabstop=4                     " 設定tab 鍵的顯示長度為4
set autoread					  " 設定自動偵測檔案是否變動並更新

if !has('gui_running')            " 偵測是否為gui 版的vim
  set mouse=                      " 取消支援滑鼠
  set ttimeoutlen=0               " 將模式轉換時的畫面更新設定為最快
  if $COLORTERM == "truecolor"    " 偵測是否是支援True Color的終端機？
    set termguicolors
  endif
endif
set nofixendofline                " Windowsのエディタの人達に嫌われない設定
set ambiwidth=double              " 讓CJK 語系中的全型字元，例如○, △, □的寬度是ASCII的兩倍
set directory-=.                  " 將暫存檔目錄設定為vim 的目錄
set formatoptions+=mM             " 日本語の途中でも折り返す
let &grepprg="grep -rnIH --exclude=.git --exclude-dir=.hg --exclude-dir=.svn --exclude=tags"
let loaded_matchparen = 1         " 當遊標在括弧上的時候，不會突出對應的括弧 カーソルが括弧上にあっても括弧ペアをハイライトさせない

" :grep 等でquickfixウィンドウを開く (:lgrep 等でlocationlistウィンドウを開く)
"augroup qf_win
"  autocmd!
"  autocmd QuickfixCmdPost [^l]* copen
"  autocmd QuickfixCmdPost l* lopen
"augroup END

" 取消滑鼠滾輪的貼上動作 マウスの中央ボタンクリックによるクリップボードペースト動作を抑制する
noremap <MiddleMouse> <Nop>
noremap! <MiddleMouse> <Nop>
noremap <2-MiddleMouse> <Nop>
noremap! <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap! <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>
noremap! <4-MiddleMouse> <Nop>

"-------------------------------------------------------------------------------
" 狀態列設定
let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}] "
if has('iconv')
  let &statusline .= "0x%{FencB()}"

  function! FencB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    if c != ''
      let c = iconv(c, &enc, &fenc)
      return s:Byte2hex(s:Str2byte(c))
    else
      return '0'
    endif
  endfunction
  function! s:Str2byte(str)
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
  endfunction
  function! s:Byte2hex(bytes)
    return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
  endfunction
else
  let &statusline .= "0x%B"
endif
let &statusline .= "%=%l,%c%V %P"

"-------------------------------------------------------------------------------
" 移除原本的檔案編碼設定段落，等之後更了解Vim 再考慮補上 ファイルエンコーディング検出設定


"-------------------------------------------------------------------------------
" 色彩模版的設定
colorscheme torte

try
  silent hi CursorIM
catch /E411/
  " 當使用輸入法時，遊標設定為紫色 CursorIM (IME ON中のカーソル色)が定義されていなければ、紫に設定
  hi CursorIM ctermfg=16 ctermbg=127 guifg=#000000 guibg=#af00af
endtry


" vim:set et ts=2 sw=0:
" 初始化 vim-plug

call plug#begin('~\vimfiles\plugged')

" 安裝nerdtree

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'kannokanno/previm', { 'for': 'markdown' }
Plug 'vim-scripts/dbext.vim', { 'for': 'sql' }
" Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
" let g:mkdp_path_to_chrome = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'


" 結束 vim-plug設定
call plug#end()
