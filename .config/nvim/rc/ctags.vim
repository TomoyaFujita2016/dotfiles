" ctags
set tags=./.tags;$HOME
nnoremap <C-]> g<C-]>

augroup ctags
  autocmd!
  autocmd BufWritePost * call s:execute_ctags()
augroup END

function! s:execute_ctags() abort
  " 探すタグ/gitファイル名
  let tag_name = '.tags'
  let git_name = '.git'
  " ディレクトリを遡り、タグファイルを探し、パス取得
  let tags_path = findfile(tag_name, '.;')
  " タグファイルパスが見つからなかった場合
  if tags_path ==# ''
    let tags_path = finddir(git_name, '.;')
    if tags_path ==# ''
        return
    endif
    let tags_dirpath = fnamemodify(tags_path, ':p:h')
    execute 'silent !cd' tags_dirpath[:-strlen(git_name)] '&& ctags -R -f' tag_name '2> /dev/null &'
    return
  endif

  " タグファイルのディレクトリパスを取得
  " `:p:h`の部分は、:h filename-modifiersで確認
  let tags_dirpath = fnamemodify(tags_path, ':p:h')
  " 見つかったタグファイルのディレクトリに移動して、ctagsをバックグラウンド実行（エラー出力破棄）
  execute 'silent !cd' tags_dirpath '&& ctags -R -f' tag_name '2> /dev/null &'
endfunction
