" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1
set nocompatible
" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
filetype plugin indent on
endif

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


" 色設定
colorscheme  molokai
" 文字コードを指定する
set encoding=utf-8
" ファイルエンコードを指定する
set fileencodings=utf-8,iso-2022-jp,sjis,euc-jp
" 自動認識させる改行コードを指定する
set fileformats=unix,dos
" マウスを無効化
set mouse-=a


" カーソルが何行目の何列目に置かれているかを表示する。（有効:ruler/無効:noruler）
set ruler 
" 毎行の前に行番号を表示する。（有効:number/無効:nonumber）
set number
"インデント
set autoindent
"行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]
" 左右スクロールは一文字づつ行う
set sidescroll=1
" オンのときは、ウィンドウの幅より長い行は折り返され、次の行に続けて表示される。（有効:wrap/無効:nowrap）
set nowrap
" コントロール文字を表示する。（有効:list/無効:nolist）
set list
" Listモード (訳注: オプション 'list' がオンのとき) に使われる文字を設定する。
set listchars=tab:»-,extends:<,trail:-,eol:↲
" 対応する括弧のハイライト表示をしない
let loaded_matchparen = 1
" Insertモードで <Tab> を挿入するとき、代わりに適切な数の空白を使う。（有効:expandtab/無効:noexpandtab）
set expandtab
" 最下ウィンドウにいつステータス行が表示されるかを設定する。
"  0: 全く表示しない  1: ウィンドウの数が2以上のときのみ表示  2: 常に表示
set laststatus=2
" コマンド (の一部) を画面の最下行に表示する。（有効:showcmd/無効:noshowcmd）
set showcmd
" ファイル内の <Tab> が対応する空白の数。
set tabstop=3
" オンのとき、コマンドライン補完が拡張モードで行われる。（有効:wildmenu/無効:nowildmenu）
set wildmenu

" 検索パターンにおいて大文字と小文字を区別しない。（有効:ignorecase/無効:noignorecase）
set noignorecase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索する。（有効:wrapscan/無効:nowrapscan）
set wrapscan
" 検索語にマッチした単語をハイライトする
" 逆は [ set nohlsearch ]
set hlsearch
" カーソル下の単語をハイライトする https://qiita.com/itmammoth/items/312246b4b7688875d023
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
" カーソル下の単語をハイライトしてから置換する
nmap # <Space><Space>:%s/<C-r>///g<Left><Left>


" ファイルを上書きする前にバックアップを作る。書き込みが成功してもバックアップはそのまま取っておく。（有効:backup/無効:nobackup）
set nobackup
" ファイルの上書きの前にバックアップを作る。オプション 'backup' がオンでない限り、バックアップは上書きに成功した後削除される。（有効:writebackup/無効:nowritebackup）
set nowritebackup
" w!!でsudoで保存する
cabbr w!! w !sudo tee > /dev/null %
>
