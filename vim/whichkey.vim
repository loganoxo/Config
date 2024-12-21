" which-key.nvim 配置

" 列之间的最小水平间距
let g:which_key_hspace=3
" 1:使用浮动窗口,优点是保持当前窗口布局不变; 默认为0:拆分新窗口
let g:which_key_use_floating_win = 0
" 居中显示
let g:which_key_centered = 1
" 如果设置为非0的值，则条目将按水平排序
let g:which_key_sort_horizontal = 0
" 1:隐藏描述字典元素之外的所有映射,会导致提示窗口打开后,未配置在字典中的映射不可用,要赶在提示窗口打开前才有用
"let g:which_key_ignore_outside_mappings = 1
" 字典中配置的按键 放在 未配置字典的按键 的前面
let g:which_key_group_dicts = 'start'
" 描述字典
let g:which_key_map =  {}
" 隐藏未配置字典元素之外的映射,但是不影响执行
let g:which_key_map['<Up>'] = 'which_key_ignore'
let g:which_key_map['<Down>'] = 'which_key_ignore'
let g:which_key_map['<Right>'] = 'which_key_ignore'
let g:which_key_map['<Left>'] = 'which_key_ignore'
let g:which_key_map['b'] = 'which_key_ignore'
let g:which_key_map['1'] = 'which_key_ignore'
let g:which_key_map['2'] = 'which_key_ignore'
let g:which_key_map['3'] = 'which_key_ignore'
let g:which_key_map['4'] = 'which_key_ignore'
let g:which_key_map['5'] = 'which_key_ignore'
let g:which_key_map['6'] = 'which_key_ignore'
let g:which_key_map['7'] = 'which_key_ignore'
let g:which_key_map['8'] = 'which_key_ignore'
let g:which_key_map['9'] = 'which_key_ignore'


" 配置描述字典,个人设为两种:1、可以在which-key打开(normal/visual模式)时执行的,我在这种描述文字前加上'>'来区分
" 2、只能在某些情况下(insert模式或插件的buffer中)执行的,只是当作备忘录

let g:which_key_map.r = "重载vimrc"
let g:which_key_map.s = "启动页(startify)"
let g:which_key_map.b = "列出所有Buffers列表"
let g:which_key_map.t = "列出所有标签页和窗口"
let g:which_key_map.n = "打开目录树并定位到当前文件"
let g:which_key_map.e = "打开/关闭目录树"
let g:which_key_map['!'] = "放弃修改，重新回到文件打开时的状态"
let g:which_key_map[';'] = ['<C-i>'          ,     '前进(NI模式)<C-;>']
let g:which_key_map[','] = ['<C-o>'          ,     '后退(NI模式)<C-,>']

" buffer 缓冲区
let g:which_key_map['B'] = {
        \ 'name' : '+buffer缓冲区' ,
        \ '0' : [':FzfBuffers'          ,     '查看所有缓冲区<Leader>b']      ,
        \ '1' : ['b1'                   ,     'buffer编号<Leader>1']        ,
        \ '2' : ['b2'                   ,     'buffer编号<Leader>2']        ,
        \ '3' : ['bnext'                ,     '下一个]b']     ,
        \ '4' : ['bprevious'            ,     '上一个[b'] ,
        \ '5' : ['bd'                   ,     '关闭当前缓冲区']   ,
        \ '6' : ['bfirst'               ,     '第一个缓冲区:bfirst']    ,
        \ '7' : ['blast'                ,     '最后一个缓冲区:blast']     ,
        \ }
"        \ '' : ['update'               ,     '保存当前缓冲区的修改:update'] ,
"        \ '' : [':bufdo update'        ,     '保存所有缓冲区的修改:bufdo update'] ,

" tab 标签页
let g:which_key_map['T'] = {
        \ 'name' : '+tab标签页' ,
        \ '0' : [':FzfWindows'          ,     '查看所有标签页和窗口<Leader>t']      ,
        \ '1' : ['1gt'                  ,     'Tab编号<Tab>1']        ,
        \ '2' : ['2gt'                  ,     'Tab编号<Tab>2']        ,
        \ '3' : [':tabn'                ,     '下一个<Tab><Tab>']     ,
        \ '4' : [':tabp'                ,     '上一个<Shift-Tab>'] ,
        \ '5' : [':tablast'             ,     '最后一个<Tab>0']   ,
        \ '6' : [':tabnew'              ,     '新建标签页<Tab>n']    ,
        \ '7' : [':tabedit'             ,     '新建标签页并编辑<Tab>e']    ,
        \ '8' : [':tabonly'             ,     '关闭所有其他的标签页<Tab>o']    ,
        \ '9' : [':tabclose'            ,     '关闭当前的标签页<Tab>c']    ,
        \ 'a' : [':+tabmove'            ,     '向右移动标签页<Tab>+']    ,
        \ 'b' : [':-tabmove'            ,     '向左移动标签页<Tab>-']    ,
        \ 'c' : [':tabmove'             ,     '移动标签页到最右边<Tab>$']    ,
        \ 'd' : [':0tabmove'            ,     '移动标签页到最左边<Tab>^']    ,
        \ }

" CtrlP文件搜索
let g:which_key_map['C'] = {
        \ 'name' : '+CtrlP文件搜索' ,
        \ '1' : ['<C-p>'          ,      '>打开CtrlP<C-p>']       ,
        \ '2' : ['<Esc>'          ,      '标记/取消标记多个文件<C-z>']       ,
        \ '3' : ['<Esc>'          ,      '文件在新标签页打开<C-t>']       ,
        \ '4' : ['<Esc>'          ,      '左右分屏打开<C-v>']       ,
        \ '5' : ['<Esc>'          ,      '上下分屏打开<C-x>']       ,
        \ '6' : ['<Esc>'          ,      '在模式(MRU/files/buffers)之间循环<C-f>和<C-b>']   ,
        \ '7' : ['<Esc>'          ,      '切换到仅文件名搜索而不是完整路径<C-d>']   ,
        \ '8' : ['<Esc>'          ,      '创建新文件及其父目录<C-y>']   ,
        \ '9' : ['<Esc>'          ,      '切换到正则表达式模式<C-r>']   ,
        \ 'a' : ['<Esc>'          ,      '在结果列表中导航<C-j>或<C-k>或箭头键']   ,
        \ 'b' : ['<Esc>'          ,      '选择提示历史记录中的下一个/上一个字符串<C-n>和<C-p>']   ,
        \ }

" window分屏
let g:which_key_map['W'] = {
        \ 'name' : '+window分屏(C-w)' ,
        \ '1' : ['<C-w>s'          ,      '>上下分屏:sp']       ,
        \ '2' : ['<C-w>v'          ,      '>左右分屏:vsp']       ,
        \ '3' : ['<C-w>c'          ,      '>关闭当前窗口<C-w>c']   ,
        \ '4' : ['<C-w>o'          ,      '>关闭其他窗口<C-w>o']   ,
        \ '5' : ['<C-w>T'          ,      '>在新的标签页中打开<C-w>T']   ,
        \ '6' : ['<C-h>'           ,      '>光标移动到左侧窗口<C-h>']   ,
        \ '7' : ['<C-l>'           ,      '>光标移动到右侧窗口<C-l>']   ,
        \ '8' : ['<C-j>'           ,      '>光标移动到下方窗口<C-j>']   ,
        \ '9' : ['<C-k>'           ,      '>光标移动到上方窗口<C-k>']   ,
        \ 'a' : ['<C-w>w'          ,      '>光标循环移动到下一个窗口<C-w>w']  ,
        \ 'b' : ['<C-w>J'          ,      '>窗口移动到下方<C-w>J']       ,
        \ 'c' : ['<C-w>K'          ,      '>窗口移动到上方<C-w>K']       ,
        \ 'd' : ['<C-w>H'          ,      '>窗口移动到左侧<C-w>H']       ,
        \ 'e' : ['<C-w>L'          ,      '>窗口移动到右侧<C-w>L']       ,
        \ 'f' : ['<C-w>r'          ,      '>窗口交换<C-w>r']       ,
        \ 'g' : [':resize +5'   ,          '>高度增加5行<Leader><Up>']         ,
        \ 'h' : [':resize -5' ,            '>高度减少5行<Leader><Down>']         ,
        \ 'i' : [':vertical resize +5',    '>宽度增加5列<Leader><Right>']         ,
        \ 'j' : [':vertical resize -5' ,   '>宽度减少5列<Leader><Left>']         ,
        \ 'k' : ['<C-w>='          ,       '>所有窗口同宽同高<C-w>=']         ,
        \ 'l' : ['<C-w>_'          ,       '>纵向最大化当前窗口<C-w>_']         ,
        \ 'm' : ['<C-w>|'          ,       '>(改为了左右分屏)横向最大化当前窗口<C-w>|']         ,
        \ 'z' : ['<C-w>z'          ,       '>最大化/还原 当前分屏']         ,
        \ 'n' : ['<C-w>n'          ,       '>新建一个无文件窗口<C-w>n']         ,
        \ }

" 文本编辑备忘录
let g:which_key_map['I'] = {
        \ 'name' : '+文本编辑备忘录' ,
        \ '1' : ['<Esc>'          ,      '(I)使用 jj 进入normal模式']             ,
        \ '2' : ['<Esc>'          ,      '(N)选中单词<Leader>w']             ,
        \ '3' : ['<Esc>'          ,      '(I/N)直接保存<C-s>']       ,
        \ '4' : ['<Esc>'          ,      '(I/N)直接退出<C-q>']       ,
        \ '5' : ['<Esc>'          ,      '(N)放弃修改，重新回到文件打开时的状态<Leader>!']   ,
        \ '6' : ['<Esc>'          ,      '(I/N)在下方插入空行<S-Enter>']   ,
        \ '7' : ['<Esc>'          ,      '(I/N)将某行中,光标后到行尾的文本移动到下一行,光标位置不变<C-Enter>']   ,
        \ '8' : ['<Esc>'          ,      '(I/N)撤销<C-z>,N模式还有u']   ,
        \ '9' : ['<Esc>'          ,      '撤销后,重做;N模式U和<C-r>;I模式<C-r>']   ,
        \ 'a' : ['<Esc>'          ,      '复制从光标到行尾;N模式Y>;I模式<C-y>']   ,
        \ 'b' : ['<Esc>'          ,      '(N)全选<C-a>']   ,
        \ 'c' : ['<Esc>'          ,      '(I)插入上一次插入的文本;i文本<esc>a<C-a>']   ,
        \ 'd' : ['<Esc>'          ,      '插入模式下剪切<C-d>']   ,
        \ 'D' : ['<Esc>'          ,      '插入模式下删除<C-x>']   ,
        \ 'e' : ['<Esc>'          ,      '插入模式下减少缩进<S-Tab>']   ,
        \ 'f' : ['<Esc>'          ,      '选中最后一次插入的内容,normal模式下用<v.> vnoremap下直接用<.>']   ,
        \ 'g' : ['<Esc>'          ,      '自动补全代码(按照代码语言)<C-.>']   ,
        \ 'h' : ['<Esc>'          ,      '(I)删除光标前一个单词<A-BS>']   ,
        \ 'i' : ['<Esc>'          ,      '(I)删除光标到行首<S-BS>']   ,
        \ 'j' : ['<Esc>'          ,      '(I)删除光标到行尾<C-BS>']   ,
        \ 'k' : ['<Esc>'          ,      '插入模式快速进入v模式<C-v>']   ,
        \ 'l' : ['<Esc>'          ,      '插入模式快速选中到行尾<A-]>']   ,
        \ 'm' : ['<Esc>'          ,      '插入模式快速选中到行首<A-[>']   ,
        \ 'n' : ['<Esc>'          ,      '合并行,行与行会加空格J']   ,
        \ 'o' : ['<Esc>'          ,      '合并行,行与行直接不加空格gJ']   ,
        \ }

" move光标移动/跳转/屏幕移动
let g:which_key_map['M'] = {
        \ 'name' : '+move光标移动/跳转/屏幕移动' ,
        \ '1' : ['<Esc>'          ,      '向上滚动半页<C-u>']             ,
        \ '2' : ['<Esc>'          ,      '向下滚动半页<C-f>']             ,
        \ '3' : ['<Esc>'          ,      '屏幕居中zz']       ,
        \ '4' : ['<Esc>'          ,      '前进(N模式)<C-i>']       ,
        \ '5' : ['<Esc>'          ,      '后退(N模式)<C-o>']   ,
        \ '6' : ['<Esc>'          ,      '向后/向前搜索光标所在的单词*/#']   ,
        \ '7' : ['<Esc>'          ,      'I模式中临时执行一个普通模式命令<C-o>']   ,
        \ '8' : ['<Esc>'          ,      '光标移动(I模式)<C-h/j/k/l>']   ,
        \ '9' : ['<Esc>'          ,      '物理行跳跃(NI模式)上下箭头']   ,
        \ 'a' : ['<Esc>'          ,      '行内搜索(N模式)f/t/F/T']   ,
        \ 'b' : ['<Esc>'          ,      '移动到行首(N模式H/^)(I模式A-h)']   ,
        \ 'c' : ['<Esc>'          ,      '移动到硬行首(N模式)数字0']   ,
        \ 'd' : ['<Esc>'          ,      '移动到行尾(N模式L/$)(I模式A-l)']   ,
        \ 'e' : ['<Esc>'          ,      '下一个单词的开头(N模式w)(I模式C-w)']   ,
        \ 'f' : ['<Esc>'          ,      '下一个单词的结尾(N模式e)(I模式C-e)']   ,
        \ 'g' : ['<Esc>'          ,      '上一个单词的开头(N模式b)(I模式C-b)']   ,
        \ 'h' : ['<Esc>'          ,      '跳转到下一个{(N模式)]]']   ,
        \ 'i' : ['<Esc>'          ,      '跳转到上一个{(N模式)[[']   ,
        \ 'j' : ['<Esc>'          ,      '跳转到下一个}(N模式)][']   ,
        \ 'k' : ['<Esc>'          ,      '跳转到上一个}(N模式)[]']   ,
        \ 'l' : ['<Esc>'          ,      '跳转到上一个成员函数开头[m']   ,
        \ 'm' : ['<Esc>'          ,      '跳转到下一个成员函数开头]m']   ,
        \ 'n' : ['<Esc>'          ,      '跳转到上一个成员函数结尾[M']   ,
        \ 'o' : ['<Esc>'          ,      '跳转到下一个成员函数结尾]M']   ,
        \ 'p' : ['<Esc>'          ,      '向上滚动3行<C-e>']   ,
        \ 'q' : ['<Esc>'          ,      '向下滚动3行<C-y>']   ,
        \ }

" fzf相关
let g:which_key_map['f'] = {
        \ 'name' : '+fzf相关' ,
        \ '0b' : [':FzfBuffers'          ,      '>列出Buffers列表<Leader>b']  ,
        \ '0t' : [':FzfWindows'          ,      '>列出所有标签页和窗口<Leader>t'],
        \ 'a' : '>列出当前文件夹下的文件<Leader>fa'            ,
        \ 'c' : '>列出所有文件的修改内容<Leader>fc'            ,
        \ 'g' : '>列出被git版本控制的文件<Leader>fg'           ,
        \ 'G' : '>列出 git commit信息<Leader>fG'           ,
        \ 'h' : '>列出最近使用过的文件<Leader>fh'             ,
        \ 'j' : '>列出最近跳转列表<Leader>fj'                ,
        \ 'm' : '>列出所有的mark标记<Leader>fm'                ,
        \ 't' : '>列出当前文件所有标识符<Leader>ft'  ,
        \ 'T' : '>列出项目中所有文件的标识符<Leader>fT'  ,
        \ 'H' : '>列出home文件夹下的文件<Leader>fH'             ,
        \ 'l' : [':FzfBLines'               ,      '>列出当前文件的每一行']  ,
        \ 'L' : [':FzfLines'                ,      '>列出所有文件的每一行']  ,
        \ 'v' : [':FzfMaps'           ,             '>列出所有键盘映射'] ,
        \ 'w' : [':FzfFiletypes'           ,      '>列出当前文件所有的filetype'] ,
        \ 'x' : [':FzfHistory:<CR>'        ,      '>列出最近使用过的命令'] ,
        \ 'y' : [':FzfHistory/<CR>'        ,      '>列出最近的搜索'] ,
        \ 'z' : [':FzfGFiles?'         ,      '>git status'] ,
        \ '1' : ['<Esc>'                ,      '新标签打开<C-t>'] ,
        \ '2' : ['<Esc>'                ,      '左右分屏<C-v>']  ,
        \ '3' : ['<Esc>'                ,      '上下分屏<C-x>']  ,
        \ '4' : ['<Esc>'                ,      '多选<Tab>']   ,
        \ '5' : ['<Esc>'                ,      '打开预览窗口<C-l>'] ,
        \ '6' : ['<Esc>'                ,      '向下翻页<C-d>']  ,
        \ '7' : ['<Esc>'                ,      '向上翻页<C-u>']    ,
        \ '8' : ['<Esc>'                ,      '移动到第一行<C-g>']   ,
        \ '9' : ['<Esc>'                ,      '上下移动<C-k><C-j>或者上下箭头']  ,
        \ }

" 文件相关(路径/格式等)
let g:which_key_map['o'] = {
        \ 'name' : '+文件相关(路径/格式等)' ,
        \ '0' : '>打开/关闭autochdir(自动切换工作目录的功能)' ,
        \ '1' : '>复制当前文件名' ,
        \ '2' : '>复制当前文件夹的名字' ,
        \ '3' : '>复制当前文件的相对路径',
        \ '4' : '>复制当前当前文件夹的相对目录',
        \ '5' : '>复制当前文件的完整路径',
        \ '6' : '>复制当前当前文件夹的完整目录',
        \ '7' : '>显示/隐藏非可见字符',
        \ '8' : '>显示/隐藏非可见字符(并设为unix格式)',
        \ '9' : '>显示当前文件格式',
        \ 'a' : '>以unix格式重新打开',
        \ 'b' : '>以dos格式重新打开',
        \ 'c' : '>以mac格式重新打开',
        \ 'd' : [':FzfFiletypes'  ,  '>设置文件filetype'] ,
        \ 'e' : '>文件重命名(加路径就是移动文件),自动删除旧文件' ,
        \ 'f' : '>"文件复制(可以加路径)' ,
        \ }

" 插件和工具
let g:which_key_map['p'] = {
        \ 'name' : '+插件和工具' ,
        \ 'g' : '>显示/隐藏缩进线' ,
        \ 'j' : '>json格式化' ,
        \ 'p' : '>开启/关闭自动补全/删除/跳转括号' ,
        \ 't' : '>显示/隐藏代码大纲tagbar' ,
        \ 'u' : '>显示/隐藏undo树' ,
        \ 'z' : '>多次高亮不同的单词' ,
        \ 'Z' : '>去高亮' ,
        \ '5' : ['<Esc>' ,      '移动一行/选区(N模式)<A-hjkl>'],
        \ }

let g:which_key_map['p']['?']= {
        \ 'name' : '+插件管理' ,
        \ '1' : '>查看插件状态' ,
        \ '2' : '>安装在配置文件中声明的插件' ,
        \ '3' : '>更新升级插件' ,
        \ '4' : '>升级 vim-plug 本身' ,
        \ '5' : '>查看插件的变化状态，简单地回滚有问题的插件' ,
        \ '6' : '>删除插件(clean配置文件中没有订阅的插件)' ,
        \ }

let g:which_key_map['p']['e']= {
        \ 'name' : '+easymotion操作' ,
        \ '1' : ['<Esc>' ,     '双向搜索两个字符<f>'],
        \ '2' : ['<Esc>' ,     '双向,在每个单词前加标签<t>'],
        \ }

let g:which_key_map['p']['m']= {
        \ 'name' : '+多光标vim-visual-multi' ,
        \ '1' : ['<Esc>' ,     '在光标下的单词添加光标<C-n>'],
        \ '2' : ['<Esc>' ,     '向下/向上添加光标(相同列)<S-Down>/<S-Up>'],
        \ '3' : ['<Esc>' ,     '在光标下的单词添加光标,并且将文件中所有这个单词都加光标<\A>(反斜杠+大写A)'],
        \ '4' : ['<Esc>' ,     '启动multi,并进入regex匹配<\/>(反斜杠+斜杠)'],
        \ '5' : ['<Esc>' ,     '启动multi,并选中上次的选区<\gS>'],
        \ '6' : ['<Esc>' ,     '启动multi,并在光标下加一个cursor<\\>(两个反斜杠)'],
        \ '7' : ['<Esc>' ,     '进入多光标选区模式(Shift+左右箭头)'],
        \ '8' : ['<Esc>' ,     'V模式下将选区当作搜索词<C-n>'],
        \ '9' : ['<Esc>' ,     'V模式下在每一行都添加光标,并进入选区模式<\a>'],
        \ 'a' : ['<Esc>' ,     'V模式下在每一行都添加光标,并进入光标模式<\c>'],
        \ 'b' : ['<Esc>' ,     'V模式下在选区搜索(/)寄存器里的文本,并在所有匹配项添加光标<\f>'],
        \ 'c' : ['<Esc>' ,     '<\`> : 查看帮助'],
        \ 'd' : ['<Esc>' ,     '<n/C-n/N> : 下一个/下一个/上一个'],
        \ 'e' : ['<Esc>' ,     '<q/Q/tab> : 跳过/删除一个光标/切换Extend和Cursor模式'],
        \ 'f' : ['<Esc>' ,     '<\w> : 切换整个单词搜索'],
        \ 'g' : ['<Esc>' ,     '<\c> : 切换大小写敏感'],
        \ 'h' : ['<Esc>' ,     '<siw> : 拓展单词选区(在不是整个单词匹配时有用),s就是可以用vim移动光标的命令拓展选区'],
        \ 'i' : ['<Esc>' ,     '<\f> <\s> <\g> : 过滤选区 截断选区 通过正则拓展选区'],
        \ 'j' : ['<Esc>' ,     '\a 和 \< : 让多光标下的位置对齐缩进'],
        \ 'k' : ['<Esc>' ,     'vim a.json; \/:<CR>; \A; \a ;'],
        \ 'l' : ['<Esc>' ,     'or : vim a.json; <C-a>; \a; \<:<CR>'],
        \ 'm' : ['<Esc>' ,     '\n和\N : 添加编号;start=[count]/step/separator<CR>'],
        \ 'n' : ['<Esc>' ,     '\t : 文本交换位置,前提是文本选中的行数要相同'],
        \ 'o' : ['<Esc>' ,     '<C-S-Left> 和 <C-S-Right> 可以左右移动<C-n>选择的多个选区'],
        \ 'p' : ['<Esc>' ,     '\C : 更改单词变量的格式(下划线/空格/驼峰等)'],
        \ 'q' : ['<Esc>' ,     '<\+space> : 切换VM/normal模式;解放光标'],
        \ 'x' : ['<Esc>' ,     '<S-RightMouse>:   Mouse Cursor'],
        \ 'y' : ['<Esc>' ,     'C-RightMouse:     Mouse Word'],
        \ 'z' : ['<Esc>' ,     '<C-S-RightMouse>: Mouse Column'],
        \ }


" git相关
let g:which_key_map['g'] = {
        \ 'name' : '+git相关' ,
        \ 's' : '>status' ,
        \ 'd' : '>diff' ,
        \ 'c' : '>commit' ,
        \ 'l' : '>log' ,
        \ 'p' : '>pull' ,
        \ 'P' : '>push' ,
        \ 'b' : '>显示每一行的最后修改记录(blame)' ,
        \ 'y' : [':FzfCommits' ,      '>fzf列出git commit信息<Leader>fG'],
        \ 'z' : [':FzfGFiles?' ,      '>fzf列出git status信息'],
        \ }

" terminal终端
let g:which_key_map['*'] = {
        \ 'name' : '+terminal终端' ,
        \ '*' : ['<Esc>' ,      '特殊情况下切回normal模式<C-\><C-n>'],
        \ '.' : ['<Esc>' ,      'or特殊情况下切回normal模式<C-w>N'],
        \ '1' : '>新标签页打开终端' ,
        \ '2' : '>当前页分屏打开zsh终端' ,
        \ '3' : '>当前页分屏打开bash终端' ,
        \ '4' : ['<F7>' ,      '>创建新的浮动终端<F7>'],
        \ '5' : ['<Esc>' ,      '上一个浮动终端<F8>'],
        \ '6' : ['<Esc>' ,      '下一个浮动终端<F9>'],
        \ '7' : ['<Esc>' ,     '显示/隐藏所有浮动终端<F12>'],
        \ '8' : ['<Esc>' ,     '编辑文件命令为fvim或者floaterm'],
        \ }

" 其它映射
let g:which_key_map['?'] = {
        \ 'name' : '+其它映射' ,
        \ '0' : '>取消搜索高亮显示' ,
        \ '1' : '>打开/关闭显示行号' ,
        \ '2' : '>打开/关闭显示相对行号' ,
        \ '3' : '>关闭所有行号' ,
        \ '4' : '>打开/关闭自动折行' ,
        \ '5' : '>打开/关闭语法高亮' ,
        \ '6' : '>删除所有空行' ,
        \ '7' : '>删除选定范围内的空行' ,
        \ '8' : '>查看所有历史信息',
        \ '9' : '>清除最近的搜索模式' ,
        \ 'a' : ['<F5>' ,     '>按F5进入粘贴模式'],
        \ 'b' : '>打开/关闭光标行高亮' ,
        \ 'c' : '>打开/关闭光标列高亮' ,
        \ 'd' : '>关闭光标行高亮和列高亮' ,
        \ 'e' : '>去除行尾空格和\t制表符' ,
        \ 'f' : '>去除^M字符(windows换行符中的\r)' ,
        \ 'g' : '>替换全部Tab为空格' ,
        \ }




call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <Leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <Leader> :<c-u>WhichKeyVisual '<Space>'<CR>


function! LoganMsg() abort
    echohl WarningMsg | echo "\tCase Conversion\n---------------------------------"
    echohl WarningMsg | echo "u         " | echohl Type | echon "lowercase"       | echohl None
    echohl WarningMsg | echo "U         " | echohl Type | echon "UPPERCASE"       | echohl None
    echohl WarningMsg | echo "C         " | echohl Type | echon "Captialize"      | echohl None
    echohl WarningMsg | echo "t         " | echohl Type | echon "Title Case"      | echohl None
    echohl WarningMsg | echo "c         " | echohl Type | echon "camelCase"       | echohl None
    echohl WarningMsg | echo "P         " | echohl Type | echon "PascalCase"      | echohl None
    echohl WarningMsg | echo "s         " | echohl Type | echon "snake_case"      | echohl None
    echohl WarningMsg | echo "S         " | echohl Type | echon "SNAKE_UPPERCASE" | echohl None
    echohl WarningMsg | echo "-         " | echohl Type | echon "dash-case"       | echohl None
    echohl WarningMsg | echo ".         " | echohl Type | echon "dot.case"        | echohl None
    echohl WarningMsg | echo "<space>   " | echohl Type | echon "space case"      | echohl None
    echohl WarningMsg | echo "---------------------------------"
endfunction
