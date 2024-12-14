"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 主题设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"-----------------{{{-----------------

" 启用termguicolors,能够使用终端的 24 位 RGB 颜色(#FFFFFF等)
if (has("termguicolors"))
    set termguicolors
endif

" 光标颜色
function! MyCursor() abort
    highlight Visual cterm=none ctermbg=144  ctermfg=16  gui=bold guibg=#edf5a9 guifg=#4a4849
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait110-blinkoff150-blinkon175
    highlight Cursor gui=none guifg=NONE guibg=yellow
endfunction

augroup MyColors
    autocmd!
    autocmd VimEnter,ColorScheme * call MyCursor()
augroup END


" dracula, catppuccin_frappe, catppuccin_latte, catppuccin_macchiato, catppuccin_mocha
colorscheme catppuccin_mocha

" dracula主题背景透明
"let g:dracula_colorterm = 0
"colorscheme dracula

"}}}
