function! GotoFileWithLineNum()
  let path = expand('<cfile>')
  if !strlen(path)
    echo 'NO FILE UNDER CURSOR'
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

  echo path

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
  let cw = expand('<cword>')
  let cur_ft = &filetype
  let cur_syn = &syntax
  let include = ''

  if cur_ft == 'cpp'
    let include = "--include='*.cc' --include='*.cpp' --include='*.h'"
  elseif cur_ft == 'sql'
    let include = "--include='*.sql' --include='*.test' --include='*.result'"
  endif

  silent! exe "noautocmd botright pedit grep"
  noautocmd wincmd P
  set buftype=nofile
  exe "read !grep -rinI -B 2 -A 2 --group-separator=' ' ".include." ".cw
  exe 0
  setlocal winheight=30
  exe "set syntax=".cur_syn
  set nohlsearch
  let @/ ="".cw
  set hlsearch
  nnoremap <buffer> <CR> :call GotoFileWithLineNum()<CR>
endfunction

com! -nargs=0 TaglessCW call Tagless()
