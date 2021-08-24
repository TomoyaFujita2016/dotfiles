let mapleader = "\<Space>"

" .vueの読み込み時に正常にSyntaxが反映されるように
autocmd FileType vue syntax sync fromstart

" Ctrl-j = esc
imap <C-j> <ESC>

" 検索ハイライトを消す
nnoremap <ESC><ESC> :nohl<CR>

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"

" 文頭文末移動
inoremap <C-e> <Esc>$a
inoremap <C-a> <Esc>^i
noremap <C-e> <Esc>$a
noremap <C-a> <Esc>^i


" 折り返しでも行単位で移動
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"インサートモードでも移動 ALT + x
"inoremap <C-j> <down>
"inoremap <C-k> <up>
"inoremap <C-l> <left>
"inoremap <C-h> <right>

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" NERDTree用バインド
"nnoremap <silent><C-e> :NERDTreeToggle<CR>

" w!! でスーパーユーザーとして保存
cmap w!! w !sudo tee > /dev/null %

" ZZ kakikomi
map ZZ :wq!<CR>

" カーソル下の単語をハイライトする
nnoremap <silent> <Space><Space> "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
