" 禁止 startify 自动切换目录
" let g:startify_change_to_dir =0
let g:startify_bookmarks = [ '~/.vimrc', '~/.zshrc' , '~/.config/nvim/init.vim' ]
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'files',     'header': ['   MRU']            },
          \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
          \ ]

" let g:ascii= [
"             \ '                                 ________  __ __        ',
"             \ '            __                  /\_____  \/\ \\ \       ',
"             \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
"             \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
"             \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
"             \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
"             \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
"             \ ]

" let g:ascii = [
"       \ '',
"       \ '         __         _    _        _    _      _         _          ',
"       \ '        / /    ___ | |_ ( ) ___  | |_ | |__  (_) _ __  | | __      ',
"       \ '       / /    / _ \| __||/ / __| | __|| |_ \ | || |_ \ | |/ /      ',
"       \ '      / /___ |  __/| |_    \__ \ | |_ | | | || || | | ||   <       ',
"       \ '      \____/  \___| \__|   |___/  \__||_| |_||_||_| |_||_|\_\      ',
"       \ '                                                                   ',
"       \ '',
"       \ ]

let g:ascii= [
      \ '',
      \ '     __         _    _        _    _      _         _          ',
      \ '    / /    ___ | |_ ( ) ___  | |_ | |__  (_) _ __  | | __      ',
      \ '   / /    / _ \| __||/ / __| | __|| |_ \ | || |_ \ | |/ /      ',
      \ '  / /___ |  __/| |_    \__ \ | |_ | | | || || | | ||   <       ',
      \ '  \____/  \___| \__|   |___/  \__||_| |_||_||_| |_||_|\_\      ',
      \ '                                                               ',
      \ '                                      __                       ',
      \ '                                     ( /                       ',
      \ '                                      /    __ _,  __,  __,     ',
      \ '                                    (/___/(_)(_)_(_/(_/ /_     ',
      \ '                                              /|               ',
      \ '                                             (/                ',
      \ '',
      \ ]



let g:startify_padding_left=13
" pad
let g:startify_custom_header='startify#center(g:ascii)'

" 如果vim后面没有跟参数(文件名),则打开Startify并且设置不换行
autocmd VimEnter *
                \   if !argc()
                \ |   Startify
                \ |   setlocal nowrap
                \ | endif
" endif前不能用注释,所以下面这两行移到外面了,原本是放在wincmd w的上一行;加上下面的两行可以打开Startify的同时打开NERDTree
"    \ |   NERDTree
"    \ |   wincmd w
nnoremap <Leader>s :Startify<CR>
