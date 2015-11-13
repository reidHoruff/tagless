#Tagless
Simple grep execution because tags never work that well...

##Installation 
####Vundle
add `Plugin 'reidHoruff/tagless'` to your ~/.vimrc then `so%` and `:BundleInstall`

####Pathogen
?

##Configs
```vim
"number of context lines to display
let g:tagless_context_lines=3

"highlight the current string being grepped for in results
let g:tagless_highlight_result=1

"height of the preview window which contains the grep results
let g:tagless_window_height=30

"set syntax based on the current buffer - it's shitty
let g:tagless_enable_shitty_syntax_highlighting=0

"infer what files to grep through based on current buffer
let g:tagless_infer_file_types=1

"grep for current word under cursor - its the only command
map gf :TaglessCW<CR>
```

