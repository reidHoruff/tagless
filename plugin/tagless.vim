"author: reid horuff

function! SetSettings()
  if !exists('g:tagless_context_lines')
    let g:tagless_context_lines=3
  endif

  if !exists('g:tagless_window_height')
    let g:tagless_window_height=30
  endif

  if !exists('g:tagless_highlight_result')
    let g:tagless_highlight_result=1
  endif

  if !exists('g:tagless_enable_shitty_syntax_highlighting')
    let g:tagless_enable_shitty_syntax_highlighting=1
  endif

  if !exists('g:tagless_infer_file_types')
    let g:tagless_infer_file_types=1
  endif
endfunction

function! GotoFileWithLineNum()
  normal 0
  let path = expand('<cfile>')
  if !strlen(path)
    echo 'no file under cursor'
    return
  endif

  if search('\%#\f*:\zs[0-9]\+')
    let temp = &iskeyword
    set iskeyword=48-57
    let line_number = expand('<cword>')
    exe 'set iskeyword=' . temp
  endif

  if strpart(path, 0, 1) != "/"
    let path = getcwd() . "/" . path
  endif

  if filereadable(path)
    close
    exe 'e '.path
    if exists('line_number')
      exe line_number
    endif
  else
    echo 'file not found'
  endif
endfunction

function! Tagless()
  call SetSettings()

  let cw = expand('<cword>')
  let cur_ft = &filetype
  let cur_syn = &syntax
  let include = ''

  if g:tagless_infer_file_types
    if cur_ft == 'cpp'
      let include = "--include='*.cc' --include='*.cpp' --include='*.h'"
    elseif cur_ft == 'sql'
      let include = "--include='*.sql' --include='*.test' --include='*.result'"
    elseif cur_ft == 'perl'
      let include = "--include='*.perl' --include='*.test'"
    elseif cur_ft == 'python'
      let include = "--include='*.py'"
    endif
  endif

  "create window
  silent! exe "noautocmd botright pedit grep"
  noautocmd wincmd P
  set buftype=nofile

  "exec command and pipe into new window
  exe "read !grep -rinI -C ".g:tagless_context_lines." --group-separator=' ' ".include." ".cw

  normal gg

  exe 'setlocal winheight='.g:tagless_window_height

  if g:tagless_enable_shitty_syntax_highlighting
    exe "set syntax=".cur_syn
  endif

  nnoremap <buffer> <CR> :call GotoFileWithLineNum()<CR>
endfunction

com! -nargs=0 TaglessCW call Tagless()
