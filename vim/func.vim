"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自动化功能设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"--------------- 插入模式和分屏时中关闭高亮光标行列 {{{
autocmd InsertLeave,WinEnter * set cursorline cursorcolumn
autocmd InsertEnter,WinLeave * set nocursorline nocursorcolumn
"}}}

"--------------- 按需打开文件历史的持久化 {{{
if has("persistent_undo")
    let target_path = expand('~/.undodir')
    if !isdirectory(target_path)
        set noundofile
        echo "need to create directory:'" . target_path . "' to enable persistent_undo!"
    else
        let &undodir=target_path
        set undofile
    endif
endif
"}}}

"--------------- 行号/相对行号自动化配置 {{{
" vim失去焦点时(点击桌面或其他程序)显示绝对行号,获取焦点时显示相对行号
autocmd FocusLost * if match(['which_key', 'WhichKey','startify','nerdtree','tagbar','help'], &filetype) < 0 | set norelativenumber number | endif
autocmd FocusGained * if match(['which_key', 'WhichKey','startify','nerdtree','tagbar','help'], &filetype) < 0 | set relativenumber number | endif
" 插入模式下用绝对行号, 普通模式下用相对,分屏时移动到另一个窗口时,原窗口也用绝对行号
autocmd InsertEnter,WinLeave * if match(['which_key', 'WhichKey','startify','nerdtree','tagbar','help'], &filetype) < 0 | set norelativenumber number | endif
autocmd InsertLeave,WinEnter * if match(['which_key', 'WhichKey','startify','nerdtree','tagbar','help'], &filetype) < 0 | set relativenumber number | endif
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber number
  else
    set relativenumber
  endif
endfunc
"nnoremap <Leader>x :call NumberToggle()<CR>

"}}}

"--------------- 打开自动定位到最后编辑的位置, 需要确认 .viminfo 当前用户可写 {{{
function! RestoreCursorPosition()
" 如果上次退出的行号大于0,并且小于等于当前文件的最大行号,则跳转到上次的位置
    if line("'\"") > 0 && line("'\"") <= line("$")
        exe "normal! g`\""
    else
" 否则跳转到最后一行的结尾
        exe "normal! G$"
    endif
endfunction
if has("autocmd")
    autocmd BufReadPost * call RestoreCursorPosition()
endif
"}}}


"--------------- vim文件自动折叠 {{{
" 自动命令组实现 Vim 代码折叠函数，使用 Vim 默认 标志折叠（marker）来折叠代码
augroup Filetype_Vim_Logan
" 开头增加 autocmd! 命令，以确保没有重复的自动命令存在
    autocmd!
" vim文件自动折叠
    autocmd FileType vim setlocal foldmethod=marker foldenable
augroup END
"}}}

"--------------- 防止tmux下vim的背景色显示异常 {{{
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
"}}}

"--------------- 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉 {{{
" 好处：误删什么的，如果以前屏幕打开，可以找回
"set t_ti= t_te=
"}}}

"--------------- 自动识别文件类型,先禁用,目前没使用场景,vim自己的判断就已经满足需求 {{{
if 0
    augroup Filetype_Logan
        autocmd!
        autocmd BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}  set filetype=markdown
        autocmd BufRead,BufNewFile *.{go}     set filetype=go
        autocmd BufRead,BufNewFile *.{js}     set filetype=javascript

        autocmd BufRead,BufNewFile *.h        set ft=c
        autocmd BufRead,BufNewFile *.i        set ft=c
        autocmd BufRead,BufNewFile *.m        set ft=objc
        autocmd BufRead,BufNewFile *.di       set ft=d
        autocmd BufRead,BufNewFile *.ss       set ft=scheme
        autocmd BufRead,BufNewFile *.cl       set ft=lisp
        autocmd BufRead,BufNewFile *.phpt     set ft=php
        autocmd BufRead,BufNewFile *.inc      set ft=php
        autocmd BufRead,BufNewFile *.cson     set ft=coffee

        autocmd BufRead,BufNewFile *.sql      set ft=mysql
        autocmd BufRead,BufNewFile *.tpl      set ft=smarty
        autocmd BufRead,BufNewFile *.txt      set ft=txt
        autocmd BufRead,BufNewFile *.log      set ft=conf
        autocmd BufRead,BufNewFile hosts      set ft=conf
        autocmd BufRead,BufNewFile *.conf     set ft=dosini
        autocmd BufRead,BufNewFile http*.conf set ft=apache
        autocmd BufRead,BufNewFile *.ini      set ft=dosini

        autocmd BufRead,BufNewFile */nginx/*.conf        set ft=nginx
        autocmd BufRead,BufNewFile */nginx/**/*.conf     set ft=nginx
        autocmd BufRead,BufNewFile */openresty/*.conf    set ft=nginx
        autocmd BufRead,BufNewFile */openresty/**/*.conf set ft=nginx
        autocmd BufRead,BufNewFile *.yml.bak             set ft=yaml
        autocmd BufRead,BufNewFile *.yml.default         set ft=yaml
        autocmd BufRead,BufNewFile *.yml.example         set ft=yaml
        echo "Filetype_Logan 已启用"
    augroup END
endif
"}}}

"--------------- 自动插入文件头 {{{
function! AutoSetFileHeadLogan()
" 如果第一行为空
    if getline(1) =~ '^\s*$'
        "如果文件类型为.sh文件
        if &filetype == 'sh' || &filetype == 'zsh'
            if &filetype == 'sh'
                call append(0, '#!/usr/bin/env bash')
            endif
            if &filetype == 'zsh'
                call append(0, '#!/usr/bin/env zsh')
            endif
            call append(1, '')
            call append(2, '#########################################################################')
            call append(3, '#File:              '. expand("%:t"))
            call append(4, '#Author:            logan <openmailovo@gmail.com>')
            call append(5, '#Date:              '. strftime("%Y-%m-%d"))
            call append(6, '#Description:       ')
            call append(7, '#########################################################################')
            normal! G
            normal! o
            normal! o
        endif

        "如果文件类型为python
        if &filetype == 'python'
            call append(0, '#!/usr/bin/env python3')
            call append(1, '# -*- coding: utf-8 -*-')
            call append(2, '')
            call append(3, '"""')
            call append(4, 'File:               ' . expand("%:t"))
            call append(5, 'Author:             logan <openmailovo@gmail.com>')
            call append(6, 'Date:               ' . strftime("%Y-%m-%d"))
            call append(7, 'Description:        ')
            call append(8, '"""')
            normal! G
            normal! o
            normal! o
        endif

        "如果文件类型为java
        if &filetype == 'java'
            call append(0, '/**')
            call append(1, ' * File:            ' . expand("%:t"))
            call append(2, ' * Author:          logan <openmailovo@gmail.com>')
            call append(3, ' * Date:            ' . strftime("%Y-%m-%d"))
            call append(4, ' * Description:     ')
            call append(5, ' */')
            call append(6, '')
            call append(7, 'public class ' . expand("%:t:r") . ' {')
            call append(8, '    ')
            call append(9, '}')
            normal! 9G$
        endif

    endif
endfunction
if 1
    autocmd BufNewFile *.sh,*.py,*.java,*.zsh exec ":call AutoSetFileHeadLogan()"
endif
"}}}

"--------------- 保存文件时删除多余空格 {{{
function! <SID>StripTrailingWhitespacesLogan()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction
if 1
    autocmd FileType c,sh,zsh,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> silent! :call <SID>StripTrailingWhitespacesLogan()
endif
"}}}

"--------------- 设置可以高亮的关键字 {{{
if 1
    if has("autocmd")
      " Highlight TODO, FIXME, NOTE, etc.
      if v:version > 701
        autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|DONE\|XXX\|BUG\|HACK\)')
        autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\|NOTICE\)')
      endif
    endif
endif
"}}}

"--------------- 设置拼写检查错误的背景色，防止错误整行标红导致看不清 {{{
" set spell后再打开
if 0
    augroup SpellUnderline
        autocmd!
" 单词拼写错误
        autocmd ColorScheme *
            \ highlight SpellBad
            \   cterm=underline
            \   ctermfg=none
            \   ctermbg=none
            \   term=reverse
            \   gui=undercurl
            \   guisp=red
" 首字母大写错误
        autocmd ColorScheme *
            \ highlight SpellCap
            \   cterm=underline
            \   ctermfg=none
            \   ctermbg=none
            \   term=reverse
            \   gui=undercurl
            \   guisp=red
" 其他地区使用的语言
        autocmd ColorScheme *
            \ highlight SpellLocal
            \   cterm=underline
            \   ctermfg=none
            \   ctermbg=none
            \   term=reverse
            \   gui=undercurl
            \   guisp=red
" 不常用的语法
        autocmd ColorScheme *
            \ highlight SpellRare
            \   cterm=underline
            \   ctermfg=none
            \   ctermbg=none
            \   term=reverse
            \   gui=undercurl
            \   guisp=red
    augroup END
endif
"}}}
