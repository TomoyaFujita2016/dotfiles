"インデント系
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" バックアップファイルを作らない
set nobackup

" スワップファイルを作らない
set noswapfile

" バッファが編集中でもその他のファイルを開けるように
set hidden

" ターミナル接続を高速化
set ttyfast

" 改行時自動インデント
set smartindent

" 行番号を表示
set number

" 不可視文字を表示
"set list

" インクリメントサーチを有効にする
"set incsearch

" ハイライトサーチを有効にする
set hlsearch

" 検索時大文字小文字を区別しない
set ignorecase

" 検索時に大文字を入力した場合ignorecaseが無効になる
set smartcase

" カーソルラインを表示する
set cursorline

" ファイル更新で自動で読み直す
"set autoread

" 補完ウィンドウの設定
set completeopt=menuone

" ビープ音を可視化
"set visualbell

" 括弧入力時の対応する括弧を表示
set showmatch

" 対応括弧の表示秒数を3秒にする
"set matchtime=3

" ステータスラインを常に表示
set laststatus=2

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" タイトルを表示
set title

" カーソルの行数表示
set cursorline

" タイムアウト時間設定
set timeout 
set timeoutlen=1000 
set ttimeout 
set ttimeoutlen=50

" wildmenuを有効にする
set wildmenu
set wildmode=full

" 保存するコマンド履歴の数
set history=500

" バックスペースキーの有効化
"set backspace=indent,eol,start

" 移動コマンドを使ったとき、行頭に移動しない
set nostartofline


" カーソルラインの位置を保存する
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

" 挿入モードでクリップボードからペーストする時に自動でインデントさせないようにする
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction
endif
