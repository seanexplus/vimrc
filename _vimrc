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
set relativenumber                " 設定顯示相對行數
set tabstop=4                     " 設定tab 鍵的顯示長度為4
set shiftwidth=4                  " 設定shift 操作移動的寬度，預設為8
set autoread					  " 設定自動偵測檔案是否變動並更新
set clipboard+=unnamed            " 將無名暫存器加入系統剪貼簿，簡化剪貼操作

if !has('gui_running')            " 偵測是否為gui 版的vim
  set mouse=                      " 取消支援滑鼠
  set ttimeoutlen=0               " 將模式轉換時的畫面更新設定為最快
  if $COLORTERM == "truecolor" || $OS == "Windows_NT"	" 偵測是否是支援True Color的終端機？
    set termguicolors
  endif
endif
set nofixendofline                " Windowsのエディタの人達に嫌われない設定
set ambiwidth=double              " 讓CJK 語系中的全型字元，例如○, △, □的寬度是ASCII的兩倍
set directory-=.                  " 將暫存檔目錄設定為vim 的目錄
set formatoptions+=mM             " 日本語の途中でも折り返す
" let &grepprg="grep -rnIH --exclude=.git --exclude-dir=.hg --exclude-dir=.svn --exclude=tags"
" 將原先使用的gnu grep 置換為ripgrep
let &grepprg = "rg -nH -g \"!.git\" -g \"!.tags\" -g \"!.hg\" -g \"!.svn\" --vimgrep"
let grepformat = "%f:%l:%c:%m,%f:%l:%m"
let loaded_matchparen = 1         " 當遊標在括弧上的時候，不會突出對應的括弧 カーソルが括弧上にあっても括弧ペアをハイライトさせない

" :grep 等でquickfixウィンドウを開く (:lgrep 等でlocationlistウィンドウを開く)
augroup qf_win
" 重置autocmd群組
  autocmd!
  " 所有不是l開頭的quick fix指令就執行copen
  autocmd QuickfixCmdPost [^l]* copen
  " 所有l 開頭的fix指令就執行lopen
  autocmd QuickfixCmdPost l* lopen
  " 建立類似VSCode的錯誤清單瀏覽快速鍵並根據開啟的quickfix 視窗是否為Location List重新設定相關快捷鍵
  " autocmd FileType qf if getwininfo(win_getid())[0]['loclist']
  "              \ |     nnoremap <f4> :<c-u>lnext<cr>
  "              \ |     nnoremap <s-f4> :<c-u>lprevious<cr>
		"		\ |   else
  "              \ |     nnoremap <f4> :<c-u>cnext<cr>
  "              \ |     nnoremap <s-f4> :<c-u>cprevious<cr>
  "              \ |   endif
augroup END
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
" let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}] "
" if has('iconv')
"   let &statusline .= "0x%{FencB()}"
"
"   function! FencB()
"     let c = matchstr(getline('.'), '.', col('.') - 1)
"     if c != ''
"       let c = iconv(c, &enc, &fenc)
"       return s:Byte2hex(s:Str2byte(c))
"     else
"       return '0'
"     endif
"   endfunction
"   function! s:Str2byte(str)
"     return map(range(len(a:str)), 'char2nr(a:str[v:val])')
"   endfunction
"   function! s:Byte2hex(bytes)
"     return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
"   endfunction
" else
"   let &statusline .= "0x%B"
" endif
" let &statusline .= "%=%l,%c%V %P"

"-------------------------------------------------------------------------------
" 移除原本的檔案編碼設定段落，等之後更了解Vim 再考慮補上 ファイルエンコーディング検出設定


"-------------------------------------------------------------------------------
" 色彩模版的設定
colorscheme desert

" ctag設定
set tags=./.tags;,.tags

try
  silent hi CursorIM
catch /E411/
  " 當使用輸入法時，遊標設定為紫色 CursorIM (IME ON中のカーソル色)が定義されていなければ、紫に設定
  hi CursorIM ctermfg=16 ctermbg=127 guifg=#000000 guibg=#af00af
endtry

" 載入matchit.vim 套件，用來強化原本的%指令
packadd! matchit
" vim:set et ts=2 sw=0:
" 初始化 vim-plug

call plug#begin('~/.vim/plugged')

" 安裝nerdtree

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'previm/previm', { 'for': 'markdown' }
Plug 'vim-scripts/dbext.vim', { 'for': 'sql' }
" Plug 'Valloric/YouCompleteMe'
Plug 'Raimondi/delimitMate'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'w0rp/ale'
Plug 'mhinz/vim-signify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/LeaderF'
Plug 'justinmk/vim-dirvish'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'tyru/caw.vim'
Plug 'Shougo/context_filetype.vim'
" Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
" let g:mkdp_path_to_chrome = 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'tpope/vim-unimpaired'

" 結束 vim-plug設定
call plug#end()
" vim-markdown相關設定
" let g:vim_markdown_fenced_language = [ 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'java=java', 'py=python', 'js=javascript', 'html=html']
" 開啟gutentags的進階指令，通常用來Debug
" let g:gutentags_define_advanced_commands = 1
" gutentags 搜尋專案目錄的標記，遇到這些文件/目錄名稱就停止向上層目錄搜尋
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 設定gutentags產生的檔案名稱
let g:gutentags_ctags_tagfile = '.tags'

" 將自動生成的tags檔案放在~/.cache/tags 目錄，避免污染專案目錄
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/opt/homebrew/Cellar/global/6.6.5/share/gtags/gtags.conf'
" 設定ctags的參數
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
endif
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
" " 禁用 gutentags 自动加载 gtags 数据库的行为
let g:gutentags_auto_add_gtags_cscope = 0
let g:gutentags_plus_switch = 1

" 確認 ~/.cache/tags 不存在的話就產生
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif
" 設定YCM 的Extra Config檔案路徑
" let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
" ale 相關設定
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
" let g:ale_linters = {'javascript': ['eslint'],'css': ['prettier']}
" let g:ale_c_cppcheck_options = '--enable=all --std=c99'
" let g:ale_cpp_cppcheck_options = '--enable=all --std=c++17'
" let g:ale_javascript_eslint_options = '--fix'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
" let g:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:airline#extensions#ale#enabled = 1
" let g:airline#extenss#gutentags#enabled = 1
let g:airline_powerline_fonts = 1
" 設定airline theme
let g:airline_theme = 'solarized'
let g:airline_solarized_bg = 'dark'
" 設定LeadF 快速鍵與其它
let mapleader = '`'
let g:Lf_ShortcutF = '<leader>ff'
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
" 參考網頁https://github.com/Yggdroot/LeaderF/wiki/Leaderf-rg
noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -e %s ", expand("<cword>"))<CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search visually selected text literally
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
noremap go :<C-U>Leaderf! rg --recall<CR>
" let g:Lf_ShortcutB = '<m-n>'
" noremap <c-n> :LeaderfMru<cr>
" noremap <m-p> :LeaderfFunction!<cr>
" noremap <m-n> :LeaderfBuffer<cr>
" noremap <m-m> :LeaderfTag<cr>
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsGutentags = 1
" 記得要pip install pygments才能讓ctag支援其它語言，mac可用homebrew安裝
let g:Lf_Gtagslabel = 'native-pygments'
" noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
" noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
" noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
" let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
" 由於跟vsnip 的hotkey相衝，所以修改deLimitMe的熱鍵設定
imap <C-e> <Plug>delimitMateS-Tab
" netrw相關設定
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1
" let g:netrw_liststyle = 3 " Tree mode
" let g:netrw_banner = 0 " 關閉Banner
" 開始vim-lsp的初始設定
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> <f2> <plug>(lsp-rename)
	autocmd BufWritePre <buffer> LspDocumentFormatSync
    " nmap <buffer> gr <plug>(lsp-references)
    " nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    " nmap <buffer> <leader>rn <plug>(lsp-rename)
    " nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    " nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    " nmap <buffer> K <plug>(lsp-hover)

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" 設定c/c++ lsp
if executable('/opt/homebrew/Cellar/llvm/11.1.0/bin/clangd')
    au User lsp_setup call lsp#register_server({
	    \ 'name': 'clangd',
	    \ 'cmd': {server_info->['/opt/homebrew/Cellar/llvm/11.1.0/bin/clangd', '-background-index', '--std=c++20']},
	    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
	    \ })
endif
" 設定vim lsp
if executable('vim-language-server')
	augroup LspVim
		autocmd!
		autocmd User lsp_setup call lsp#register_server({
			\ 'name': 'vim-language-server',
			\ 'cmd': {server_info->['vim-language-server', '--stdio']},
			\ 'whitelist': ['vim'],
			\ 'initialization_options': {
			\   'vimruntime': $VIMRUNTIME,
			\   'runtimepath': &rtp,
			\ }})
	augroup END
endif
" 設定java lsp
if executable('java') && filereadable(expand('~/lsp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.5.800.v20200727-1323.jar'))
	au User lsp_setup call lsp#register_server({
	    \ 'name': 'eclipse.jdt.ls',
	    \ 'cmd': {server_info->[
	    \     'java',
	    \     '-Declipse.application=org.eclipse.jdt.ls.core.id1',
	    \     '-Dosgi.bundles.defaultStartLevel=4',
	    \     '-Declipse.product=org.eclipse.jdt.ls.core.product',
	    \     '-Dlog.level=ALL',
	    \     '-noverify',
	    \     '-Dfile.encoding=UTF-8',
	    \     '-Xmx1G',
	    \     '-jar',
	    \     expand('~/lsp/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_1.5.800.v20200727-1323.jar'),
	    \     '-configuration',
	    \     expand('~/lsp/eclipse.jdt.ls/config_win'),
	    \     '-data',
	    \     getcwd()
	    \ ]},
	    \ 'whitelist': ['java'],
	    \ })
endif
" 設定javascript lsp
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
	    \ 'name': 'javascript support using typescript-language-server',
	    \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
	    \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
	    \ 'whitelist': ['javascript', 'javascript.jsx', 'javascriptreact']
	    \ })
endif
" 設定typescript lsp
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
	    \ 'name': 'typescript-language-server',
	    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
	    \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
	    \ 'whitelist': ['typescript', 'typescript.tsx'],
	    \ })
endif
if executable('gopls')
	au User lsp_setup call lsp#register_server({
	        \ 'name': 'gopls',
	        \ 'cmd': {server_info->['gopls']},
	        \ 'whitelist': ['go'],
	        \ })
	autocmd BufWritePre *.go LspDocumentFormatSync
endif
let g:lsp_diagnostics_echo_cursor = 1
" 加入vsnip的key mapping
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
