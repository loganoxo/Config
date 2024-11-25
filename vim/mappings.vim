"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 通用映射 (Common Mappings)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"----------------- Tips {{{ -----------------
" 1、按键映射指令
" 使用 :h map-modes 查看映射适用的模式，配置自定义的需求,比如
" map! 递归映射(noremap! 非递归): 映射的模式为:Insert and Command-line ;
" map 递归映射(noremap 非递归): Normal, Visual, Select, Operator-pending;
" imap(inoremap): insert; nmap(nnoremap): Normal; vmap: Visual and Select;
" smap(snoremap): Select; xmap(xnoremap): Visual;
" unmap <F10>                      " 取消一个映射
" vim没有直接在 Normal 模式和 Insert 模式下同时生效的映射指令,若要同时生效,需要分别设置,如:
" inoremap j 5j
" nnoremap j 5j

" 2、尽量使用 nnoremap 代替 nmap，
"""" 举例1
" nmap j 5j                      会死循环
"""" 举例2
" nnoremap j 5j                  可以向下移动5行
" nnoremap <C-A> j               还是向下移动一行,因为不是递归
"""" 举例3
" nnoremap j 5j                  可以向下移动5行
" nmap <C-A> j                   可以向下移动5行,并且与这两个映射的前后关系无关
" 这两个按键级联的时候,按键生效的模式也要相同才行,比如这里就都是normal模式下生效

" 3、映射指令行尾不能有注释和空格!!!!!!!!!!!

" 4、<M> 表示Windows/Linux系统上的 alt，MacOS系统上的 option

"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"----------------- leader {{{ -----------------
" let maplocalleader = " "  用于用于局部于缓冲区的映射,不同文件类型或不同的buffer中
" map <buffer> <LocalLeader>A  oanother line<Esc>  o:下一行插入‘another line’
" autocmd FileType markdown nnoremap <buffer> <localleader>p :MarkdownPreview<CR>

" Leader键默认为:\, 没有g:等修饰符时,默认就是全局变量,所以一下两种方式相同,这里设为空格键
let mapleader = " "
let g:mapleader = " "

" 考虑到按键便利性，可将 ; 映射为 :，实现按 ; 键便可以从 Vim 普通模式进入命令行模式,但是行内搜索(f/t)需要用到分号和逗号,所以注释掉
" nnoremap ; :

"}}}


"---------------------------- vim功能优化 -----------------
" 空格只用做leader键
"nnoremap <Space> <Nop>
"xnoremap <Space> <Nop>
" Don't use Ex mode, use Q for formatting.
map Q gq

" 重新加载vim
nnoremap \r :source ~/.vimrc<CR>
" 使用 jj 进入normal模式,`^指的是从insert到normal模式下，保持光标位置不变
inoremap jj <Esc>`^
" 解决esc后光标左移的问题
inoremap <silent> <Esc> <Esc>`^

" 插入模式下撤销, normal为u
inoremap <C-z> <Esc>ui
" 禁用C-z直接退出vim
nnoremap <C-z> u
" 撤销后,重做
nnoremap U <C-r>
" 插入模式下撤销后,重做
inoremap <C-r> <Esc><C-r>i

" 复制 从光标到行尾 所在范围的文本(Y默认是复制一行,用yy平替)
nnoremap Y y$
" 插入模式复制一行(排除了行首行尾空格)
inoremap <C-y> <Esc>^y$`^i
" 不排除行首行尾空格
inoremap <C-c> <Esc>`^yyi
" visual模式下复制后进入插入模式,在有鼠标操作时很方便,不用重新按i进入插入模式
xnoremap <C-c> y<Esc>i

" 全选，Ctrl+A 组合键(插入模式下默认行为:插入上一次插入的文本;i文本<esc>a<C-a>)
nnoremap <C-a> ggVG

" Vim 搜索结果居中展示
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
" 向后搜索光标所在的单词并居中显示结果
nnoremap <silent> * *zz
" 向前搜索光标所在的单词并居中显示结果
nnoremap <silent> # #zz

" 插入模式下，常用标点符号自动补全,用auto-pairs插件自带功能
"inoremap ( ()<Esc>i
"inoremap [ []<Esc>i
"inoremap { {}<Esc>i
inoremap < <><Esc>i
"inoremap " ""<Esc>i
"inoremap ' ''<Esc>i
"inoremap ` ``<ESC>i
" 插入模式下减少缩进; 增加缩进为Tab或者C-i
inoremap <S-Tab> <C-d>

"---------------------------- 区分删除x和剪切d -----------------
" 最小化修改,保持d的功能不变(剪切),x为删除;大写D为删除到行末
inoremap <C-d> <Esc>`^ddi
nnoremap <C-d> dd
" 删除选区内所有行
xnoremap <C-d> D
" 剪切,x原本的功能可以用dl代替,X可以用dh代替;以下功能完全仿照d,只不过寄存器变为"
" 功能效果,支持xiw,xaw等参数操作,但不支持自定义寄存器
nnoremap x ""d
nnoremap xx ""dd
xnoremap x ""d
" 删除至行末
nnoremap X ""D
"xnoremap X ""D     在visual模式下没什么用,效果为删除选区的所有行;留给exchange用
" 插入模式下删除
inoremap <C-x> <Esc>`^""ddi
nnoremap <C-x> ""dd
xnoremap <C-x> ""D


"---------------------------- 快速移动 -----------------

" normal,visual,select <C-u/f>跳多行
noremap <C-u> m'5gk
noremap <C-f> m'5gj
inoremap <C-u> <Esc>`^m'5gki
inoremap <C-f> <Esc>`^m'5gji


" 上下滚动
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" 单词跳跃(插入模式下默认C-w是删除光标前一个单词,C-e默认插入一个来自插入点以下的字符(若光标所在列在下一行存在字符)
inoremap <silent> <C-w> <Esc>`^wi
inoremap <silent> <C-e> <Esc>`^ea
inoremap <silent> <C-b> <Esc>`^bi

" 插入模式,模拟方向键
inoremap <C-k> <Up>
inoremap <C-j> <Down>
" 遇到行首行尾,接着移动光标
inoremap <expr> <C-h> col('.') == 1 ? "\<C-o>h" : "\<Left>"
inoremap <expr> <C-l> col('.') == col('$') ? "\<C-o>l" : "\<Right>"

" 命令行模式增强
" 左右
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
" 行首行尾
cnoremap <C-k> <Home>
cnoremap <C-j> <End>
" alt option不能用
"cnoremap <A-h> <Home>
"cnoremap <A-l> <End>


" 定义一个函数来记录当前位置并执行数字+j动作（仅记录大于1的数字）
function! JumpWithRecordLogan(key,count)
" 判断数字是否大于1
    if a:count > 1
" 记录当前位置
        normal! m'
" 执行数字+j/k动作
        execute "normal! " . a:count . a:key
    else
" 如果数字不大于1，只执行普通的j动作（不记录）
        execute "normal! " . a:key
    endif
endfunction
nnoremap <silent> j :<C-u> silent call JumpWithRecordLogan('j',v:count)<CR>
nnoremap <silent> k :<C-u> silent call JumpWithRecordLogan('k',v:count)<CR>
nnoremap <silent> gj :<C-u> silent call JumpWithRecordLogan('gj',v:count)<CR>
nnoremap <silent> gk :<C-u> silent call JumpWithRecordLogan('gk',v:count)<CR>

" 当长行换行后,用方向键进行物理行的跳跃,esc默认会向左移动一个字符
nnoremap <silent> <Up> gk
nnoremap <silent> <Down> gj
inoremap <silent> <Up> <Esc>`^gki
inoremap <silent> <Down> <Esc>`^gji
" 遇到行首行尾,接着移动光标
inoremap <silent> <expr> <Left> col('.') == 1 ? "\<C-o>h" : "\<Left>"
inoremap <silent> <expr> <Right> col('.') == col('$') ? "\<C-o>l" : "\<Right>"

""" 前进/后退用 <C-;>/<C-,> 代替, 为了避免Ctrl-i 对 tab键的影响; ctrl-o还是可以正常使用
nnoremap <C-i> <Nop>
nnoremap <Tab> <Nop>
nnoremap <C-;> <C-i>
nnoremap <C-,> <C-o>
" g+`反引号,实现跳转但是不改变jumplist,即不改变C-o和C-i跳转的顺序和位置
xnoremap <C-;> <Esc><C-i>vg`<o
xnoremap <C-,> <Esc><C-o>vg`<o
inoremap <C-;> <Esc><C-i>i
inoremap <C-,> <Esc><C-o>i

" 为了解决自动补全代码窗口开启时,按esc关闭窗口的同时会退回到normal模式
inoremap <C-i> <Esc>`^i

" 默认情况下单引号只能跳转到标记的行;反引号可以跳转到标记的行和列,所以用单引号替代反引号,因为单引号更好按
noremap ' `
noremap ` '


" ) 移动到下一个句子的开头; ( 移动到[上一个句子/这个句子] 的开头;句子的结尾是由句号 (.)、问号 (?) 或感叹号 (!) 后跟一个或多个空格、制表符或换行符标识的;没有分隔符时,不会拆分成不同的句子
" [[ 跳转到上一个行首是{的那一行; ]] 跳转到下一个行首是{的那一行; 基本上没啥用
" ]} 从代码块内部向外找}; [{ 从代码块内部向外找{; 平级的不会找
" ]) 从代码块内部向外找); [( 从代码块内部向外找(; 平级的不会找
" % 不仅匹配跳转到对应的 {} () []，而且能在 if、else、elseif 之间跳跃
""""" 以上是vim的默认行为
" 移动到下一个段落并居中显示,空行分隔(有空格不会跳)
nnoremap }   }zz
" 移动到上一个段落并居中显示,空行分隔(有空格不会跳)
nnoremap {   {zz

"" 跳转到上一个成员函数开头(光标移动到{那里)
"nnoremap [[   [m
"" 跳转到下一个成员函数开头(光标移动到{那里)
"nnoremap ]]   ]m
"" 跳转到上一个成员函数结尾(光标移动到}那里)
"nnoremap []   [M
"" 跳转到下一个成员函数结尾(光标移动到}那里)
"nnoremap ][   ]M


" 跳转到下一个{
nnoremap <silent> ]] :call search('{')<CR>
" 跳转到上一个{
nnoremap <silent> [[ :call search('{', 'b')<CR>
" 跳转到下一个},]开头都是下一个
nnoremap <silent> ][ :call search('}')<CR>
" 跳转到上一个},[开头都是上一个
nnoremap <silent> [] :call search('}', 'b')<CR>


" 跳转到行首行尾
noremap H ^
noremap L $
inoremap <A-h> <Esc>^i
inoremap <A-l> <Esc>$a
" <A-[/]>快速选中行首/行尾
" <Command+[/]> 调整缩进

"----------------------------- 快速选中 -----------------
" 插入模式快速进入v模式
inoremap <C-v> <Esc>`^v
" 快速选中到行尾/行首
inoremap <A-]> <Esc>`^m'v$
inoremap <A-[> <Esc>m'v^
nnoremap <A-]> m'v$
nnoremap <A-[> m'v^
xnoremap <A-]> m'$
xnoremap <A-[> m'^

" 可视化模式下 缩进后依然保持选中,可以让缩进后继续按<>继续调整缩进
vnoremap > >gv
vnoremap < <gv
" 选中最后一次插入的内容,normal模式下用<v.> vnoremap下直接用<.>
vnoremap . <Esc>`[v`]

" 可视化模式下,快速进入插入模式,并移动光标到visual模式的起始位置
vnoremap <C-i> <Esc>`<i

nnoremap <leader>w viw

"----------------- buffer和tab相关映射 {{{ -----------------
" buffer
" 查看所有缓冲区; 用fzf的 <Leader>b 替代
"nnoremap <Leader>b :ls<CR>
" 上一个buffer
nnoremap <silent> [b :bprevious <CR>
" 下一个buffer
nnoremap <silent> ]b :bnext <CR>
" 映射 <Leader>num 到 num buffer
nnoremap <Leader>1 :b1<CR>
nnoremap <Leader>2 :b2<CR>
nnoremap <Leader>3 :b3<CR>
nnoremap <Leader>4 :b4<CR>
nnoremap <Leader>5 :b5<CR>
nnoremap <Leader>6 :b6<CR>
nnoremap <Leader>7 :b7<CR>
nnoremap <Leader>8 :b8<CR>
nnoremap <Leader>9 :b9<CR>
" 保存当前缓冲区的修改:update; 保存所有缓冲区的修改:bufdo update

" tab
" 列出所有标签页和窗口, 用fzf的: <Leader>t 或者 <Tab>f
nnoremap <silent><Tab>f :FzfWindows<CR>
" 映射 <Tab>num 到标签页编号
nnoremap <Tab>1 1gt
nnoremap <Tab>2 2gt
nnoremap <Tab>3 3gt
nnoremap <Tab>4 4gt
nnoremap <Tab>5 5gt
nnoremap <Tab>6 6gt
nnoremap <Tab>7 7gt
nnoremap <Tab>8 8gt
nnoremap <Tab>9 9gt
" tabNext 切换到下一个标签页   tab-tab 双击
nnoremap <silent><Tab><Tab> :tabn<CR>
" tabprevious 切换到上一个标签页 shift-tab
nnoremap <silent><S-Tab> :tabp<CR>
" 切换到最后一个标签页
nnoremap <Tab>0 :tablast<CR>

" 新建标签页
nnoremap <silent><Tab>n :tabnew<CR>
" 新建标签页并编辑
nnoremap <silent><Tab>e :tabedit<CR>
" 关闭所有其他的标签页
nnoremap <silent><Tab>o :tabonly<CR>
" 关闭当前的标签页
nnoremap <silent><Tab>c :tabclose<CR>
" 向右移动标签页
nnoremap <silent><Tab>+ :+tabmove<CR>
" 向左移动标签页
nnoremap <silent><Tab>- :-tabmove<CR>
" 移动标签页到最右边
nnoremap <silent><Tab>$ :tabmove<CR>
" 移动标签页到最左边
nnoremap <silent><Tab>^ :0tabmove<CR>

"nnoremap <silent><Tab>s :tabs<CR>                              " 查看所有打开的标签页,用 fzf: <Leader>fw 替代
"nnoremap <Leader>tt :tabedit <C-R>=expand("%:p:h")<CR>/        " 在新标签页打开当前目录下的文件,用CtrlP替代

"}}}


"---------------------------- 分屏窗口相关映射 -----------------
" :sp[file] 上下分屏   :vsp[file] 左右分屏
" vim -o file1 file2 file3    上下分屏
" vim -O file1 file2 file3    左右分屏
" <C-w>h/j/k/l/w              在窗口间移动光标
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" <C-w>H/J/K/L/r/R 移动窗口; <C-w>o 关闭其他窗口只保留当前的(:only); <C-w>T 将当前窗口移到新的标签页中
" <C-w>+-<> 增/减 窗口 高度/宽度 ; <C-w>= 设置所有窗口同宽同高
" 将当前窗口的高度增加/减小 5 行
nnoremap <Leader><Up> :resize +5<CR>
nnoremap <Leader><Down> :resize -5<CR>
" 将当前窗口的宽度增加/减小 5 列
nnoremap <Leader><Right> :vertical resize +5<CR>
nnoremap <Leader><Left> :vertical resize -5<CR>


"----------------------------- <BackSpace>键功能扩展 -----------------
nnoremap <BS> i<BS>

" 让normal和select模式和visual模式中 backspace键能有删除功能;
vnoremap <silent> <BS> ""c

" 删除到软行首<Shift-BS>
inoremap <silent> <S-BS> <Esc>`^""d^i
nnoremap <silent> <S-BS> ""d^i
" 删除光标前一个单词
inoremap <silent> <A-BS> <C-w>
nnoremap <silent> <A-BS> i<C-w>
" 删除到行尾
inoremap <silent> <C-BS> <Esc>`^d$a
nnoremap <silent> <C-BS> d$a


"----------------------------- <Enter>键功能扩展 -----------------
" 已在idea的keymap中配置
" Shift+Enter:              在内容下方插入空行;
" Ctrl+Shift+Enter:         在内容上方插入新行
" Ctrl+Enter:               (Split Line)将某行中,光标后到行尾的文本移动到下一行,光标位置不变
" Command+Enter:            (Generate)生成操作;
" Option+Enter:             (ShowContextActions,ShowQuickFixes)显示快速操作

" 弹出的菜单中,Ctrl+kjhl 在keymap中设置为了上下左右

" Shift + Enter 键,在下方插入空行
inoremap <silent> <S-Enter> <Esc>o
nnoremap <silent> <S-Enter> o<Space><C-h><Esc>
" (Split Line)将某行中,光标后到行尾的文本移动到下一行,光标位置不变
inoremap <silent> <C-Enter> <Enter><Esc>k$a
nnoremap <silent> <C-Enter> i<Enter><Esc>k$


"----------------------------- 搜索模式 -----------------
" 默认为magic:特殊字符为:^ $ . * []
" 使用 very magic 模式，规范所有特殊符号，启用后，除了下划线 _，大小写字母，和数字外，所有的字符都具有特殊含义
nnoremap / /\v
vnoremap / /\v

"---------------------------- 保存和退出 -----------------
" 使用idea原生功能Command+s Command+w
" 插入模式使用 Ctrl+s 直接保存,并重新进入插入模式
inoremap <C-s> <Esc>:w<CR>a
nnoremap <C-s> :w<CR>
" 直接退出 exit
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-q> :q<CR>
" 放弃修改，重新回到文件打开时的状态
nnoremap <Leader>! :edit!<CR>

"---------------------------- 折叠 -----------------
" 全折叠
nnoremap zm zM
" 全打开
nnoremap zr zR


"----------------- terminal终端映射 {{{ -----------------
" 切回normal模式:  <C-w>N 或者 <C-\><C-n> 或者退出终端请键入 exit，然后按下 Return 键 ; 切回terminal 用 <i> ;
" 新标签页打开终端 terminal，避免退出 Vim 来执行外部命令;
nnoremap <Leader>*1 :tab terminal<CR>
" 当前页分屏打开zsh终端
nnoremap <Leader>*2 :term zsh<CR>
" 当前页分屏打开bash终端
nnoremap <Leader>*3 :term bash<CR>
" 浮动终端在下面的插件配置里(浮动窗口(终端)floaterm),不是说插件自带的映射

"}}}

"----------------- 文件相关映射 {{{-----------------
" 打开/关闭autochdir(自动切换工作目录的功能)
nnoremap <Leader>o0 :set autochdir! autochdir?<CR>

" 复制当前文件名
nnoremap <Leader>o1 :let @+ = expand('%:t') \| echo expand('%:t')<CR>
" 复制当前文件夹的名字
nnoremap <Leader>o2 :let @+ = expand('%:p:h:t') \| echo expand('%:p:h:t')<CR>

" 复制当前文件的相对路径
nnoremap <Leader>o3 :let @+ = expand('%') \| echo expand('%')<CR>
" 复制当前当前文件夹的相对目录
nnoremap <Leader>o4 :let @+ = expand('%:h') \| echo expand('%:h')<CR>

" 复制当前文件的完整路径
nnoremap <Leader>o5 :let @+ = expand('%:p') \| echo expand('%:p')<CR>
" 复制当前当前文件夹的完整目录
nnoremap <Leader>o6 :let @+ = expand('%:p:h') \| echo expand('%:p:h')<CR>

" 显示非可见字符，如制表符被显示为 "^I"，\n标识为 "$",\r标识为 "^M"(最好在unix格式中看)
nnoremap <Leader>o7 :set list! list?<CR>
nnoremap <Leader>o8 :e ++ff=unix<CR>:set list! list?<CR>

" 用不同的文件格式打开,便于看到\r(c-m)\n($)\t(C-i)等特殊符号
nnoremap <Leader>o9 :set fileformat?<CR>
nnoremap <Leader>oa :e ++ff=unix<CR>:set fileformat?<CR>
nnoremap <Leader>ob :e ++ff=dos<CR>:set fileformat?<CR>
nnoremap <Leader>oc :e ++ff=mac<CR>:set fileformat?<CR>

" 文件重命名(加路径就是移动文件),自动删除旧文件
command! -nargs=1 Rename let oldpathlogan = expand('%:p') | execute 'saveas' <q-args> | call delete(oldpathlogan) | edit <q-args>
nnoremap <Leader>oe :Rename<Space>

" 文件复制(可以加路径)
function! CopyFileAndOpenInTab(newfilename)
" 获取当前文件名
    let old_file = expand('%')
" 新文件名
    let new_file = a:newfilename
" 记录当前标签页号
    let old_tab = tabpagenr()
" 保存当前文件为新文件,会在old_tab中自动打开
    execute 'saveas ' . new_file
" 新标签页打开旧文件
    execute 'tabnew ' . old_file
" 标签页移动到old_tab
    execute 'tabmove ' . (old_tab-1)
" 切回到新文件标签页
    execute 'tabnext '
endfunction
command! -nargs=1 Copyfile :call CopyFileAndOpenInTab(<f-args>)
nnoremap <Leader>of :Copyfile<Space>

"}}}

"-----------------  插件和工具 {{{-----------------
" json格式化
nnoremap <Leader>pj :%!python3 -m json.tool<CR>

"""""""""""" 插件管理
" 查看插件状态
nnoremap <Leader>p?1 :PlugStatus<CR>
" 安装在配置文件中声明的插件
nnoremap <Leader>p?2 :PlugInstall<CR>
" 更新升级插件
nnoremap <Leader>p?3 :PlugUpdate<CR>
" 升级 vim-plug 本身
nnoremap <Leader>p?4 :PlugUpgrade<CR>
" 查看插件的变化状态，简单地回滚有问题的插件
nnoremap <Leader>p?5 :PlugDiff<CR>
" 删除插件(clean配置文件中没有订阅的插件)
nnoremap <Leader>p?6 :PlugClean<CR>

"}}}

"-----------------  其他映射 {{{-----------------
" 取消 Vim 查找高亮显示
nnoremap <Leader>?0 :nohls<CR>
" 打开/关闭显示行号
nnoremap <Leader>?1 :set nu! nu?<CR>
" 打开/关闭显示相对行号
nnoremap <Leader>?2 :set rnu! rnu?<CR>
" 关闭所有行号
nnoremap <Leader>?3 :set norelativenumber nonumber <CR>
" 打开/关闭自动折行
nnoremap <Leader>?4 :set wrap! wrap?<CR>
" 打开/关闭语法高亮
nnoremap <Leader>?5 :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>
" 删除所有空行
nnoremap <Leader>?6 :g/^\s*$/d<CR>
" 删除选定范围内的空行
vnoremap <Leader>?7 :<C-u>'<,'>g/^\s*$/d
" 查看所有历史信息
nnoremap <Leader>?8 :messages<CR>
" 清除最近的搜索模式
nnoremap <Leader>?9 :let @/ = ""<CR>
" 按F5进入粘贴模式
set pastetoggle=<F5>
" 打开/关闭光标行高亮
nnoremap <Leader>?b :set cursorline! cursorline?<CR>
" 打开/关闭光标列高亮
nnoremap <Leader>?c :set cursorcolumn! cursorcolumn?<CR>
" 关闭光标行高亮和列高亮
nnoremap <Leader>?d :set nocursorline nocursorcolumn<CR>

"}}}

"-----------------  复杂映射 {{{-----------------
" 删除文件中所有行尾空格和\t制表符;\s包括空格和\t;\S包括除了空格和\t的所有
"nnoremap <Leader>?b :%s/\s\+$//<CR>
" <bar>是特殊字符|,用来分隔多个命令,相当于\|
" let _s=@/ ,将当前搜索模式（@/）保存到 _s 变量中。这样做是为了记录当前的搜索模式，因为后面会进行替换操作，可能会改变搜索模式
" e：忽略没有匹配项的错误，表示即使没有匹配到需要替换的内容，也不报错
" let @/=_s, 恢复之前的搜索状态,nohl：取消当前高亮显示的搜索匹配项，避免搜索结果继续高亮显示
nnoremap <Leader>?e :let _s=@/<bar>:%s/\s\+$//e<bar>:let @/=_s<bar>:nohls<CR>
vnoremap <Leader>?e :<C-u>let _s=@/<CR>:<C-u>'<,'>s/\s\+$//e<CR>:<C-u>let @/=_s<CR>:<C-u>nohls<CR>

" 一键去除全部 ^M 字符(windows换行符中的\r)
nnoremap <Leader>?f :%s/<C-v><C-m>//g<CR>
vnoremap <Leader>?f :<C-u>'<,'>s/<C-v><C-m>//g

" 替换全部Tab为空格
nnoremap <Leader>?g :retab<CR>

"}}}

"=========================================END=========================================
