local opt = vim.opt
local g = vim.g

-- mapleaderの設定
g.mapleader = " "
g.maplocalleader = " "

-- netrw を無効化
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- 基本設定
opt.termguicolors = true
opt.mouse = "" -- まうすむこう
opt.clipboard:append({ "unnamedplus" })

-- インデント設定
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true

-- ファイル関連
opt.backup = false -- バックアップファイルを作らない
opt.swapfile = false -- スワップファイルを作らない
opt.hidden = true -- バッファ切り替えを可能に
opt.autoread = true -- ファイル更新時に自動で読み直す

-- 表示設定
opt.number = true -- 行番号を表示
opt.cursorline = true -- カーソルラインを表示
opt.visualbell = true -- ビープ音を可視化
opt.showmatch = true -- 対応する括弧を表示
opt.laststatus = 2 -- ステータスラインを常に表示
opt.title = true -- タイトルを表示
-- opt.list = true     -- 不可視文字を表示

-- 検索設定
opt.incsearch = true -- インクリメンタルサーチ
opt.hlsearch = true -- 検索結果をハイライト
opt.ignorecase = true -- 大文字小文字を区別しない
opt.smartcase = true -- 検索時に大文字を入力した場合は区別する
opt.wrapscan = true -- 最後まで検索したら先頭に戻る

-- パフォーマンス設定
opt.ttyfast = true -- ターミナル接続を高速化

-- 補完・メニュー設定
opt.completeopt = "menuone"
opt.wildmenu = true
opt.wildmode = "full"

-- タイムアウト設定
opt.timeout = true
opt.timeoutlen = 1000
opt.ttimeout = true
opt.ttimeoutlen = 50

-- 履歴設定
opt.history = 500

-- カーソル移動設定
opt.startofline = false

-- 文字コードをUFT-8に設定
vim.opt.fileencoding = "utf-8"
vim.opt.encoding = "utf-8"

-- 改行コードの自動判別
vim.opt.fileformat = "unix"
