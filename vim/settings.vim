" ===============================================================================
" Author: logan
" Repository:
" Blog: https://www.wssw.fun/
" Create Date: 2024-05-01
" Desc:  Vim 定制化配置文件❤(vimrc for Unix/Linux/Windows/Mac, GUI/Console)
" License: MIT
" ===============================================================================


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  主要配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"----------------- 主要 {{{ -----------------
" 显示顶部标签栏，为 0 时隐藏标签栏，1 会按需显示，2 会永久显示
set showtabline=2
" 设置最大标签页上限为 10
set tabpagemax=20
" 突出显示当前行
set cursorline
" 突出显示当前列,在func.vim中有配置
set cursorcolumn
" 启动的时候不显示那个援助乌干达儿童的提示
set shortmess=atI
" 显示行号,用<Leader>?1切换
set number
" 行号以相对当前行的方式显示，可以用 nj/nk 进行跳转;用<Leader>?2切换
set relativenumber
" 关于行号的详细配置(自动函数)在fun.vim

" 启用语法高亮度
syntax enable
" 开启语法高亮;用<Leader>?4切换
syntax on
" 记录 200 条历史命令
set history=200
" 默认启用,在搜索模式中可以使用正则表达式的一些特殊字符:^ $ . * [], 启用更多需要启用very magic,即: /\v
set magic
" 高亮搜索的字符串 :set nohls 暂时清除高亮,用<Leader>?0切换
set hlsearch
" 即时搜索高亮
set incsearch
" 搜索时忽略大小写
set ignorecase
" 智能大小写敏感，只要有一个字母大写，就大小写敏感，否则不敏感
set smartcase
" 光标距离顶部和底部 4 行,当光标接近窗口的顶部或底部边界时，Vim 会自动滚动文本
set scrolloff=4
" 始终显示状态栏
set laststatus=2
" 命令行的高度
set cmdheight=1
" unnamed:'*'寄存器;unnamedplus:'+'寄存器;win和mac上两个寄存器都是系统剪切板;linux中+对应Ctrl+C和Ctrl+V,*对应鼠标中键粘贴;'^='添加到现有值的前面
set clipboard^=unnamed,unnamedplus
" 高亮显示匹配的括号,在输入闭括号时，短暂地跳转到与之匹配的开括号
set showmatch
" 匹配括号高亮的时间,用于控制显示配对括号的时间，其单位为0.1秒，默认值为5，即0.5秒
set matchtime=2
" 左下角显示当前vim模式
set showmode
" 输入的命令显示出来
set showcmd
" 默认是nohidden;编辑文件后未保存的情况下切换到另一个buffer时会提示先保存;设置hidden后,会先保存在内存中,不会有提示了;当:q和:qa时,还是会提示的;但是加上!就不会提示直接退出了,所以慎用q!和qa!,以免忘记之前未保存情况下切换了buffer
set hidden
" 设置当文件被改动时自动载入
set autoread
"set autowrite     " 自动保存

" 默认为:menu,preview;打开预览窗口会导致下拉菜单抖动，一般都去掉预览窗口的显示,
" longest：自动插入最长公共前缀，并不会自动完成整个补全项,不加会自动插入第一个选项,如: completion complement compile
" 三个补全项最大公共前缀为comp,当键入com时,调用C-n,会自动插入comp; 不用longest:会自动插入第一个补全项的所有字符
" menu：这个选项指示 Vim 在补全时显示一个菜单
set completeopt=longest,menu
" 让命令模式具备补全菜单功能<Tab>
set wildmenu
" 文件名补全（如使用命令 :edit 时）时要忽略的文件和目录模式
set wildignore+=*~,*.dll,*.exe,*.so,*.swp,*.zip,*.tar.gz,*.tar.bz2,*.pyc,*.class,*.code-workspace,.DS_Store,.app,.dmg
set wildignore+=*/tmp/*,*/node_modules/*,*/.idea/*,*/.git/*,*/.svn/*,*/.m2/*
set wildignore+=*.jpg,*.png,*.gif,*.jpeg,*.bmp,*.tiff,*.ico,*.mp4,*.mp3,*.mkv
" 启用鼠标
set mouse=a
" 显示光标当前位置
set ruler
" 设置终端title
set title
" 指定在选择文本时光标所在位置也属于被选中的范围,会影响插件vim-move,vim-visual-multi
set selection=inclusive
" 用`选择模式`替换视觉模式,选择后可以直接插入替换
"set selectmode=mouse,key
" 当光标位于行尾时，按下 h/左箭头 键会将光标移动到前一行的行尾;当光标位于行首时，按下 l/右箭头 键会将光标移动到下一行的行首。
set whichwrap+=<,>,h,l
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 修改行数触发报告的阈值,0表示始终显示(左下角显示)
set report=0
" 分割窗口时保持相等的宽/高
set equalalways
" 竖直 split 时，在右边开启
set splitright
" 水平 split 时，在下边开启
set splitbelow
" 保存全局变量
set viminfo+=!
" 自定义哪些字符被视为单词的一部分,影响换行和单词跳转和diw等操作
set iskeyword+=_,$,@,%,#,-
" 自动切换工作目录为当前文件所在的目录;用<leader>?a切换
"set autochdir
" timeoutlen: mapping组合键序列等待时间; ttimeoutlen:keycode键(Esc键等)
set timeout timeoutlen=1000 ttimeoutlen=100
" 禁止备份,以~结尾的文件,每次保存都会生成,默认就是禁用
set nobackup
" 不生成undo文件,默认就是noundofile,undo树存在内存中;持久化需要set undofile;在func.vim中有配置自动化函数
set undofile
set undodir=~/.undodir

" 禁止生成临时文件,以 .swp 结尾的交换文件，用于存储未保存的修改;编辑并保存退出后，临时交换文件将会被删除；但如果Vim意外退出，那么这个临时文件就会留在硬盘中,再次编辑时给出警告
"set noswapfile
"根据默认设置，交换文件会每隔4000毫秒（4秒）或者200个字符保存一次。我们可以使用以下命令，修改保存交换文件的频率：
"set updatetime=23000
"set updatecount=400
"set noeb    " 去掉输入错误的提示声音

" 设置拼写检查,默认为英文
"set spell
"set spelllang=en

"}}}

"----------------- 格式,缩进 {{{ -----------------
" 设置代码自动折行;用<Leader>?3切换
set wrap
" 根据 C 语言的缩进规则自动缩进代码
set cindent
" 控制一个 <Tab> 键所占据的空格数量,默认 8
set tabstop=4
" 在插入模式下按下 <Tab> 键时光标移动的空格数
set softtabstop=4
" 设置了在执行自动缩进操作（如按下 >> 或 <<）时移动的空格数或列数
set shiftwidth=4
" 开启智能缩进,根据语言的语法结构智能调整缩进
set smartindent
" 启用自动缩进功能，把上一行的对齐格式应用到下一行
set autoindent
" 设置退格键可用，正常处理 indent(缩进), eol(允许删除到行头后,继续向上一行删除), start(可以一直删除到行头)
set backspace=eol,start,indent
" 输入 tab 时自动将其转化为空格,若需输入真正的 tab，则在插入模式按下: Ctrl+V, tab
set expandtab
" Visual 模式下在使用 > 和 < 命令移动文本或块时，Vim 会将缩进对齐到 shiftwidth 的倍数
set shiftround
" 配合shiftwidth使用，如果设置该值，在行首键入<tab>会填充shiftwidth的数值,其他地方使用tabstop的数值，不设置的话，所有地方都是用shiftwidth数值
set smarttab
" 基于缩进进行代码折叠，fdm 是缩写; 下面按键映射有相关操作按键的解释(代码折叠命令)
set foldmethod=indent
" 启动 Vim 时关闭折叠
set nofoldenable
" 自动识别文件类型,用于自动识别文件类型并加载相应的语法高亮
filetype on
" 包含了 filetype on 的功能，同时还启用了插件支持和自动缩进功能
filetype plugin indent on
" 根据文件类型设置缩进,textwidth表示文本达到 120 列时自动进行换行
" autocmd FileType sass,scss,css setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120

"}}}

"----------------- 文件编码和换行符 {{{ -----------------
" Vim内部buffer、寄存器、viminfo等使用的编码方式，以下统一使用 UTF-8, 减少编码问题
set encoding=utf-8
" Vim所在的终端的字符编码格式
set termencoding=utf-8
" 当前编辑文件的字符编码方式，保存文件也使用这种编码方式,若为空则用encoding的值
set fileencoding=utf-8
"set fileencodings=ucs-bom,utf-8,default,latin1 " 自动判断编码时，依次尝试这些编码
" m 表示在任何值高于 255 的多字节字符(亚洲语言)上分行,否则只在空白字符处折行
set formatoptions+=m
" B 表示在连接行(J命令)时，不要在两个多字节字符之间插入空格
set formatoptions+=B
" Vim 自动识别文件格式，缩写：ffs；回车键编码不同：dos 是\r\n，unix是\n，mac(老版本的mac系统)是\r
set fileformats=unix,dos,mac
" 设置以 UNIX 的格式保存文件，尽量通用
set fileformat=unix
" 设置首选帮助文档的语言,若未安装则显示默认的英文文档
set helplang=cn

"}}}

"=========================================END=========================================
