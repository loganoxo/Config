"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件设置 这里使用的 vim-plug
" :PlugInstall[name ...]  安装插件; :PlugUpdate[name ...]  升级插件;
" :PlugClean 删除未列出的插件(在下面配置文件中删除插件,然后执行这个命令);
" :PlugUpgrade 升级vim-plug的版本; :PlugStatus 检查插件的状态;
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" If installed using Homebrew
set rtp+=/usr/local/opt/fzf

" If installed using Homebrew on Apple Silicon
set rtp+=/opt/homebrew/opt/fzf

" debian
set rtp+=/usr/bin/fzf

" If you have cloned fzf on ~/.fzf directory
" set rtp+=~/.fzf

call plug#begin('~/.vim/plugged')
"----------------------- 插件列表 {{{ -----------------------
" Initialize plugin system
" 安装插件只需把github地址放在这重启后执行 :PlugInstall 就好了
"""""""""""""""""""""""""""" 外观
" 主题
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
" vim开屏美化
Plug 'mhinz/vim-startify'
" 复制的时候高亮
Plug 'machakann/vim-highlightedyank'
" vim底部状态栏
Plug 'itchyny/lightline.vim'
" 顶栏美化
Plug 'mg979/vim-xtabline'
" 缩进线,替代Plug 'Yggdroot/indentLine'
Plug 'preservim/vim-indent-guides'

"""""""""""""""""""""""""""" 代码/文本处理
" 移动多行文本块(A-h/j/k/l),左右横跳需要set selection=inclusive
Plug 'matze/vim-move'
" 给dyc增加s参数;成对编辑括号和引号等  ds删 cs改 ys增加
" 例如 ds ( ,  ys iw ' , cs ( {
Plug 'tpope/vim-surround'
" 增强操作符对于各种文本对象的选中、删除、复制等;还支持函数参数操作(增加了a参数)
Plug 'wellle/targets.vim'
" 代码大纲
Plug 'preservim/tagbar'
" 快速移动 s/S
Plug 'justinmk/vim-sneak'
" 快速移动 f/t
Plug 'easymotion/vim-easymotion'
" git支持
Plug 'tpope/vim-fugitive'
" 快速注释gcc 取消gcgc
Plug 'tpope/vim-commentary'
" 多光标模式 c-up c-down c-n
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" 文件树 <Leader>e f
"Plug 'preservim/nerdtree',{ 'on':  ['NERDTreeToggle','NERDTreeFind'] }
Plug 'preservim/nerdtree'
" 文件搜索ctrl-p,按需加载,因为每次加载的话当前目录中文件过多,会导致索引时间过长
"Plug 'kien/ctrlp.vim',{'on': 'CtrlP' } 不维护了
Plug 'ctrlpvim/ctrlp.vim'
" 彩虹括号
Plug 'luochen1990/rainbow'
" 在左侧显示文件中添加、修改和删除的行
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
endif
" 自动补全/删除/跳转括号
Plug 'jiangmiao/auto-pairs'
"""""""""""""""""""""""""""" 其他功能
" fzf
"Plug '/opt/homebrew/opt/fzf'
Plug 'junegunn/fzf.vim'
" 自动切换输入法
" Plug 'ybian/smartim'
" vim浮动
Plug 'voldikss/vim-floaterm'
" 快捷键提示
Plug 'liuchengxu/vim-which-key'
" undo树
Plug 'mbbill/undotree'
" 解决 Vim 原生命令 . 在自定义映射或插件映射时无法重复的问题,支持surround.vim
Plug 'tpope/vim-repeat'
" 需要放在所有插件的最后加载;将文件类型字形（图标）添加到各种 vim 插件
Plug 'ryanoasis/vim-devicons'
" 函数参数操作,用targets.vim替代
"Plug 'vim-scripts/argtextobj.vim'
" 增强高亮搜索,<Leader>pz高亮 <Leader>pZ去高亮   n下一个 N上一个
" Plug 'loganoxo/vim-interestingwords' 用本地代码替代(plugin/vim-interestingwords)


"-----------------------end-----------------------
"}}}
call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           插件配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"----------------------- 移动多行文本块 matze/vim-move {{{ -----------------------
" 移动多行文本块(A-h/j/k/l),左右横跳需要set selection=inclusive
"}}}

"----------------------- vim-surround 成对编辑括号和引号等 {{{ -----------------------
" 给dyc增加s参数;  ds删 cs改 ys添加; 例如 ds ( ,  ys iw ' , cs ( {
" 1、假如有文本如: "Hello world!" => cs"' => 'Hello world!' ; 将文本两边的双引号修改为单引号
" 2、接下来敲击:              cs'<q>      会变成:  <q>Hello world!</q>
" 3、接下来敲击:              cst(        会变成:  (Hello world!)        ;t代表的意思就是tag标签
" 4、接下来敲击:              ds(         会变成:  Hello world!          ;删除了括号
" 4、光标放在hello上,敲击:     ysiw]       会变成:  [Hello] world!        ;iw 是一个文本对象,表示当前单词
" 5、    ysiw]       括号和单词之间不会添加空格; ysiw[ 括号和单词之间会添加空格
" 6、    yss)        将整行括在括号中
" 7、 可以用 <.> 键重复上一次的操作
" 将单词用双引号包围的映射
nmap <Leader>" ysiw"
"}}}

"----------------------- targets.vim {{{ -----------------------
" 增强操作符对于各种文本对象的选中、删除、复制等;还支持函数参数操作(增加了a参数)
" 以va[({"'举例,1、无需把光标移动到选区内,会自动选中最近的匹配; 2、支持了各种符号包括逗号和html标签(t参数)等;
" 3、还支持函数参数操作,增加了a参数,使用方式和argtextobj.vim差不多; 4、支持count,如 v2a( : 选中两个括号内的选区
" 4、vil[({"',找上一个最近的匹配; vin[({"',跳过下一个最近的匹配; 5、支持v[a/A/I/i] 用开区分选区是否包含空格等
"}}}


"----------------------- 代码大纲tagbar {{{ -----------------------
" Shift + ? 查看帮助
nmap <Leader>pt :TagbarToggle<CR>
" 打开时自动聚焦tagbar窗口
let g:tagbar_autofocus = 1
let g:tagbar_autopreview = 1
"}}}


"----------------------- justinmk/vim-sneak {{{ -----------------------
" normal和visual模式下都可以使用,visual模式下是扩展选区的作用,都用s字母键向下搜索,S大写搜索向上搜索
" <;> 下一个匹配项  <,> 上一个匹配项; s后面跟着的默认的搜索字符数为2位,也可以只输入一位,然后按回车键;
" ; and , and s and S 都会加入到jumplist中,所以可以用vim的前进后退命令;(连续的,;Ss不会记录)
" s字母键+<enter> : 适合移动光标后,想再次重复上次的搜索的时候;
" 增加了一个操作参数z,很有用;dzab: 'ab'是一个搜索词,执行后需要按键(label)确认target,从光标的位置删除到'ab'这个搜索词所在的位置(a的位置),删除的内容不包括'ab';按.可以重复这个操作;
" vim默认的s命令可以用c命令替代,cl 等价于 s ， cc 等价于 S

" 添加类似easymotion的标签
let g:sneak#label = 1
" sneak搜索默认是一直大小写敏感;设为1,会用当前vim配置中的ignorecase和smartcase的行为来搜索,即:搜索词为小写字母时不敏感,是大写字母时敏感
let g:sneak#use_ic_scs = 1
" 默认的label的字母有:let g:sneak#target_labels = ";sftunq/SFGHLTUNRMQZ?0",太少了,重新写入
let g:sneak#target_labels = ";12345qwertasdfgtunq/FGHLTUNRMQZ?0"
"}}}


"----------------------- easymotion {{{ -----------------------
" Disable default mappings
let g:EasyMotion_do_mapping = 0
" normal和visual模式下都可以使用,visual模式下是扩展选区的作用
" 修改默认前缀键,避免和其他插件冲突
let g:EasyMotion_leader_key='<Leader><Leader>'
" 默认操作映射多数是向后或向前搜索,自定义映射到双向搜索和跳窗口搜索
" 双向搜索两个字符,可以一个字符+回车;normal模式下支持多窗口查找(easymotion-overwin-f2);visual下不支持多窗口用(easymotion-s2)
noremap f <Plug>(easymotion-s2)
inoremap <A-f> <Esc>`^<Plug>(easymotion-s2)
nnoremap f <Plug>(easymotion-overwin-f2)

" 双向,在每个单词前加标签;normal模式下支持多窗口查找(easymotion-overwin-w);visual下不支持多窗口用(easymotion-bd-w)
noremap t <Plug>(easymotion-bd-w)
inoremap <A-t> <Esc>`^<Plug>(easymotion-bd-w)
nnoremap t <Plug>(easymotion-overwin-w)
" 搜索词大小写不敏感
let g:EasyMotion_smartcase = 1
"}}}


"----------------------- vim-fugitive {{{ -----------------------
" 插件 vim-fugitive 按键映射
nnoremap <silent><Leader>gs :Git status<CR>
nnoremap <silent><Leader>gd :Git diff<CR>
nnoremap <silent><Leader>gc :Git commit -m ""<Left>
nnoremap <silent><Leader>gl :Git log<CR>
nnoremap <silent><Leader>gp :Git pull<CR>
nnoremap <silent><Leader>gP :Git push<CR>
" 显示每一行的最后修改记录
nnoremap <silent><Leader>gb :Git blame<CR>
"}}}


"----------------------- 多光标vim-visual-multi {{{ -----------------------
" Extend mode: 用于扩展选区范围; Cursor mode: 用于操作光标; Extend mode下,vim的hjkl^$等动作都会扩展选区
" Cursor mode下,vim的hjkl^$等动作都会移动原来添加的光标; 使用<\+space>可以切换这种情况(两种模式),或者用箭头方向键
" 怎么启动:
" 一、normal模式下
" 1、<C-n> : 在光标下的单词添加光标(可以通过C-n继续往下找相同的单词添加光标),Extend mode
" 2、<C-Down>/<C-Up> : 开始向下/向上添加光标(相同列)，跳过空行,Cursor mode
" 3、\A : 反斜杠+大写A : 在光标下的单词添加cursor,并且将文件中所有这个单词都加cursor
" 4、\/ : 启动multi,并进入regex匹配,Cursor mode
" 5、\gS : 启动multi,并选中上次的选区
" 6、\\ :  启动multi,并在光标下加一个cursor,Cursor mode
" 7、Shift-左右箭头,进入Extend mode
" 二、visual模式下
" 1、<C-n> : 将选区当作搜索词,Extend mode
" 2、\a : 在每一行都添加cursor,Extend mode
" 3、\c : 在选区每一行添加cursor,Cursor mode
" 4、\f : 在选区搜索(/)寄存器里的文本,并在所有匹配项添加cursor,Extend mode
" 三、在vim-visual-multi启用后就进入了插件的VM模式,这个模式的buffer会加载很多快捷键,可以执行的操作如下: \` : 查看帮助
" 使用C-n时, n/C-n/N 下一个/下一个/上一个 ; q/Q/tab 跳过/删除一个光标/切换Extend和Cursor模式;  \w:切换整个单词搜索 \c:切换大小写敏感;
" siw: 拓展单词选区(在不是整个单词匹配时有用),s就是可以用vim移动光标的命令拓展选区; \f 过滤选区; \s 截断选区; \g 通过正则拓展选区
" \a 和 \<: 让多光标下的位置对齐缩进; 举例: vim a.json; \/:<CR>; \A; \a ; 或者: vim a.json; <C-a>; \a; \<:<CR>
" 四、有用的Tips:
" 1、 \n和\N : 添加编号; start=[count]/step/separator<CR> ; 先加入vm选区,<C-a>\a
"   For example, started with `\\N`: >
"       2/2/,<space>
"   <  will generate:  >
"       2, text
"       4, text
"       ...
"   <  If started with `\\n`, the result will be instead: >
"       text, 2
"       text, 4
" 2、 \t : 文本交换位置,前提是文本选中的行数要相同
"           "name": "Charlie",
"           "name": "Charlie",
" 在两行name的n处<C-Down>; 在两行Charlie的C处<C-Down>;<C-n>获得两个选区;使用\t后变成:
"           "Charlie": "name",
"           "Charlie": "name",
" 3、<C-S-Left> 和 <C-S-Right> 可以左右移动<C-n>选择的多个选区，移动的是文本整体的位置
" 4、\C : 更改单词变量的格式(下划线/空格/驼峰等)
"           u          lowercase
"           U          UPPERCASE
"           C          Captialize
"           t          Title Case
"           c          camelCase
"           P          PascalCase
"           s          snake_case
"           S          SNAKE_UPPERCASE
"           -          dash-case
"           .          dot.case
"           <space>    space case

" 鼠标支持:<S-RightMouse>: Mouse Cursor;  C-RightMouse: Mouse Word; <C-S-RightMouse>: Mouse Column

let g:VM_theme            = 'neon'
" buffer是vim-visual-multi启用后的buffer映射的leader
let g:VM_leader = {'default': '\', 'visual': '\', 'buffer': '\'}
" 初始化字典
let g:VM_maps = {}
" 默认情况下，此功能尚未启用：使用它，您可以撤消/重做在 VM 中所做的更改，并且区域也将恢复。您必须映射命令才能使其工作
let g:VM_maps["Undo"] = 'u'
let g:VM_maps["Redo"] = '<C-r>'
" 启用鼠标,iterm2中option和鼠标键不能映射,ctrl/Shift和鼠标左键也不能映射
let g:VM_mouse_mappings   = 1
let g:VM_maps["Mouse Cursor"]                = '<S-RightMouse>'
let g:VM_maps["Mouse Word"]                  = '<C-RightMouse>'
let g:VM_maps["Mouse Column"]                = '<C-S-RightMouse>'
noremap <Leader>pm :<c-u>WhichKeyVisual  "\\"<CR>
" 选区左右移动
let g:VM_maps["Move Right"] = '<C-S-Right>'
let g:VM_maps["Move Left"]  = '<C-S-Left>'
" 显示更完整的提示信息
let g:VM_verbose_commands=1
"}}}


"----------------------- nerdtree {{{ -----------------------
" shift+? 查看在nerdtree中的操作按键
" t:新标签页打开,并聚焦新标签; T:新标签页打开,但是不聚焦新标签;  鼠标双击在当前页打开; q:关闭目录树窗口
" i:上下分屏打开;  s:左右分屏打开; gb:定位到Bookmarks;  I:显示/隐藏隐藏文件; A:目录树窗口最大化; m:打开菜单
"
" 打开目录树并定位到当前文件
nnoremap <Leader>n :NERDTreeFind<CR>
" 打开/关闭目录树
nnoremap <Leader>e :NERDTreeToggle<CR>
" 开启 Nerdtree 时自动显示 Bookmarks
let NERDTreeShowBookmarks=1
" 不显示目录树行号
let NERDTreeShowLineNumbers=0
" 显示隐藏文件 0/1
let NERDTreeShowHidden=1
" 显示文件行数
let g:NERDTreeFileLines = 1
" 隐藏指定文件和文件夹
let NERDTreeIgnore = [
    \ '\.git$', '\.idea$', '\.vscode$', '__pycache__$','node_modules$','\.svn$','\.m2$',
    \ '\.DS_Store$','\.swp$','\.swo$','\.class$','\.dll$','\.exe$','\.so$','\.zip$','\.tar\.gz$','\.tar\.bz2$','\.app$','\.dmg$',
    \ 'tmp/cache$','tmp$','logan','\~$','Applications$','System$','Volumes$','opt$','sbin$','usr$','Library$', 'Users$','bin$'
    \]
"let g:NERDTreeWinPos = "right"  在右侧打开,默认在左侧
"let NERDTreeMinimalUI = 1 简化ui
" 当vim启动时后面跟着文件夹参数,则打开NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" 在每个标签页打开已经存在的NERDTree(已经触发NERDTree的情况下)
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" 如果当前窗口只有一个并且是NERDTree,则自动退出
" vim version > 9
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" vim version <= 8
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
"}}}


"----------------------- ctrlp {{{ -----------------------
" <C-z>标记/取消标记多个文件; <C-f> 和 <C-b> 可在模式之间循环(MRU/files/buffers);
" <C-d> 可切换到仅文件名搜索而不是完整路径;<C-r> 可切换到正则表达式模式; <C-j> 或 <C-k> 或箭头键在结果列表中导航
" <C-n> ,<C-p> 选择提示历史记录中的下一个/上一个字符串; <C-y> 创建新文件及其父目录
" 选中之后; <C-t>文件在新标签页打开; <C-v> 左右分屏打开;  <C-x> 上下分屏打开
" 0:禁用; 默认是ra; r:把包含以下目录或文件之一的当前文件的最近祖先当作工作目录： .git .hg .svn .bzr _darcs ; a:当前文件的目录，除非它是 CWD(当前工作目录,在/path中直接vim,工作目录为/path; 在/path中 vim ./to/file.txt ,工作目录为./to) 的子目录
"let g:ctrlp_working_path_mode = '0'

" 按需加载,因为每次加载的话当前目录中文件过多,会导致索引时间过长
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
nnoremap <C-p> :CtrlP<Cr>
vnoremap <C-p> <Esc>:CtrlP<Cr>
" ctrlp忽略一些文件和目录(一些目录logan/Library目录存在很多文件,也给它隐藏),也可以使用Vim自己的wildignore
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](tmp|logan|Applications|System|Volumes|opt|sbin|usr|Library|Users|bin|var|private|node_modules|\.idea|\.git|\.svn|\.m2)$',
  \ 'file': '\v(\~|\.dll|\.exe|\.so|\.swp|\.zip|\.tar\.gz|\.tar\.bz2|\.pyc|\.class|\.code-workspace|\.DS_Store|\.app|\.dmg|\.jpg|\.png|\.gif|\.jpeg|\.bmp|\.tiff|\.ico|\.mp4|\.mp3|\.mkv)$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
  \ }

" 可以自定义搜索命令,但是就用不到ctrlp_custom_ignore设置的忽略目录和文件了
"let g:ctrlp_user_command = 'find %s -type f'
"}}}


"----------------------- luochen1990/rainbow 彩虹括号 {{{ -----------------------
"set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_active = 1
" separately中*对应的{}表示其他filetype使用默认的parentheses; *对应的改成0,表示其他filetype不启用rainbow
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'guis': [''],
\	'cterms': [''],
\	'operators': '_,_',
\	'contains_prefix': 'TOP',
\	'parentheses_options': '',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'markdown': {
\			'parentheses_options': 'containedin=markdownCode contained',
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'haskell': {
\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold'],
\		},
\		'ocaml': {
\			'parentheses': ['start=/(\ze[^*]/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\[|/ end=/|\]/ fold', 'start=/{/ end=/}/ fold'],
\		},
\		'tex': {
\			'parentheses_options': 'containedin=texDocZone',
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'vim': {
\			'parentheses_options': 'containedin=vimFuncBody,vimExecute',
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold'],
\		},
\		'xml': {
\			'syn_name_prefix': 'xmlRainbow',
\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\		},
\		'xhtml': {
\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((script|style|area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'lua': {
\			'parentheses': ["start=/(/ end=/)/", "start=/{/ end=/}/", "start=/\\v\\[\\ze($|[^[])/ end=/\\]/"],
\		},
\		'perl': {
\			'syn_name_prefix': 'perlBlockFoldRainbow',
\		},
\		'php': {
\			'syn_name_prefix': 'phpBlockRainbow',
\			'contains_prefix': '',
\			'parentheses': ['start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold contains_prefix=TOP'],
\		},
\		'stylus': {
\			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
\		},
\		'css': 0,
\		'sh': 0,
\		'vimwiki': 0,
\	}
\}
" }}}


"----------------------- 在左侧显示文件中添加、修改和删除的行 mhinz/vim-signify {{{ -----------------------
" default updatetime 4000ms is not good for async update
set updatetime=100
"}}}


"----------------------- 自动补全/删除/跳转括号 jiangmiao/auto-pairs {{{ -----------------------
" 只在insert模式下起作用
" 输入时自动补全: (=>()   [=>[]   {=>{}   "=>""   '=>''   `=>`` ;当符号内部为空时,insert模式下删除左符号,会自动删除相应的右符号
" 在[]、（）、{}内部, 敲击: <Space>foo => [ foo ] ; 字符foo左右两边各有一个空格
" 在[]、（）、{}内部, 当光标位置是符号内部的最后一行,并且光标位置是行尾或者光标之后全是空格时,按下闭合符号])},会直接跳转到闭合符号的位置;当闭合符号在下一行时很有用
" 在""、 ''、``内部,  光标位置是行尾或者光标之后全是空格时,按下闭合符号,可以跳转,但是不能换行跳转
" 跳转后,如果本意是真的想插入一个闭合符号,则在跳转后,按let g:AutoPairsShortcutBackInsert = '<M-b>',会在之前那个位置插入符号
" |[foo, bar()]  光标位置为|时,敲击(<M-e>,左括号和alt-e, 会把后面的表达式用括号包括起来,效果为: ([foo, bar()]);敲击的左括号也可用其他括号,结果就是用相应的括号包裹
" M-括号,则会去找相应的括号当作截止位置包裹
" |[foo, bar()] (press (<M-]> at |)          =>  ([foo, bar()]|)
" (|){["foo"]} (press <M-}> at |)            =>  ({["foo"]}|)
" (|){["foo"]} (press <M-]> at |)            =>  ({["foo"])}
" <M-n> : 跳转到下一个匹配的符号位置 (g:AutoPairsShortcutJump)
" <M-b> : 跳转后,回来继续插入 (g:AutoPairsShortcutBackInsert)
" 关闭A-()[]{}"' 的映射
let g:AutoPairsMoveCharacter = ""
" 关闭C-h的映射
let g:AutoPairsMapCh=0
" 禁用默认的映射方式,因为会自动添加imap和nmap,我只需要nmap,所以自己映射插件的函数
let g:AutoPairsShortcutToggle = ''
nnoremap <buffer> <silent> <Leader>pp :call AutoPairsToggle()<CR>
"execute 'inoremap <buffer> <silent> <expr> '.g:AutoPairsShortcutToggle.' AutoPairsToggle()'
"}}}


"----------------------- fzf {{{ -----------------------
" <C-j> 或 <C-k> 或箭头键在结果列表中导航; <Tab>键可以进行多选;
" ctrl-t 新标签打开; ctrl-v 左右分屏; ctrl-x 上下分屏;
" ctrl-g 移动到第一行;  ctrl-d 向下翻页;  ctrl-u 向上翻页
" ctrl-l 触发预览窗口的快捷键,改成ctrl-l,默认为ctrl-/
" 下面所有的命令都要加上prefix, 如 默认是 :Files  加前缀 -> :FzfFiles
let g:fzf_command_prefix = 'Fzf'
" 列出所有Buffers列表
noremap <Leader>b :FzfBuffers<CR>
" 列出所有标签页和窗口
noremap <Leader>t :FzfWindows<CR>
" 列出当前文件夹下的文件
noremap <Leader>fa :FzfFiles<CR>
" 列出所有文件的修改内容
noremap <Leader>fc :FzfChanges<CR>
" 列出被git版本控制的文件
noremap <Leader>fg :FzfGFiles<CR>
" 列出 git commit信息
noremap <Leader>fG :FzfCommits<CR>
" 列出最近使用过的文件
noremap <Leader>fh :FzfHistory<CR>
" 列出最近跳转列表
noremap <Leader>fj :FzfJumps<CR>
" 列出所有的mark标记
noremap <Leader>fm :FzfMarks<CR>
" 列出当前文件所有的标识符
noremap <Leader>ft :FzfBTags<CR>
" 列出项目中所有文件的标识符
noremap <Leader>fT :FzfTags<CR>
" 列出home文件夹下的文件
noremap <Leader>fH :FzfFiles ~<CR>

" 初始化配置
let g:fzf_vim = {}
" 切换预览,默认是ctrl-/ 但是这个按键组合使用有问题,用ctrl-l代替;
let g:fzf_vim.preview_window = ['hidden,up,40%', 'ctrl-l']
" 切换buffer(<Leader>fb)时,若存在该buffer的窗口则复用
let g:fzf_vim.buffers_jump = 1
"}}}


"----------------------- 浮动窗口(终端)floaterm {{{ -----------------------
"""""" <C-\><C-n> 切换回normal模式;
let g:floaterm_width=0.8
let g:floaterm_height=0.8
" 在浮动终端中使用floaterm(我自定义了alias:fvim,在common_alias.sh里)命令打开文件,会返回vim中编辑
" 当用floaterm命令打开新文件时,文件打开方式由floaterm_opener决定
" 默认是split:上下分屏 ; tabe:标签页打开; vsplit:左右分屏
let g:floaterm_opener="tabe"
" 设置浮动窗口黑色背景,要放在vim的colorscheme的下面
"hi Floaterm guibg=black
" 设置边框颜色,要放在vim的colorscheme的下面
"hi FloatermBorder guibg=orange guifg=cyan

" 创建新的浮动终端
nnoremap   <silent>   <F7>    :FloatermNew<CR>
tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
" 上一个终端
nnoremap   <silent>   <F8>    :FloatermPrev<CR>
tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
" 下一个终端
nnoremap   <silent>   <F9>    :FloatermNext<CR>
tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
" 显示/隐藏所有终端
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
"}}}


"----------------------- undo树undotree {{{ -----------------------
" 每一次从insert模式返回到normal模式时,不管文件有没保存,undo树会自动保存;直到文件保存,之前未保存文件的历史版本也不会丢失;所以左边undo树中有些行没有s/S标记
" 标记:  >num< : 右边窗口显示的当前版本; {num} : 下一个版本; [num] : 最后一个版本; s:已保存的版本; S已保存的最后一个版本
" 操作:Shift + ? 查看帮助; 回车/双击鼠标:切换到选中的版本; u/<C-r>:打开上一个版本/下一个版本;K/J:上一个版本/下一个版本;
" <和>打开上一个已保存的版本(带有s/S标记)/下一个已保存的版本(带有s/S标记); <Tab>回到原始窗口; q:隐藏undo树窗口
" T:显示相对/绝对时间; D:显示/隐藏下方的diff窗口
nnoremap <Leader>pu :UndotreeToggle<CR>
" 不用相对时间
let g:undotree_RelativeTimestamp=0
" 打开时自动聚焦
let g:undotree_SetFocusWhenToggle=1
"}}}


"----------------------- vim-interestingwords {{{ -----------------------
" 高亮光标下的单词,可以多次高亮不同的单词;<Leader>pz高亮 <Leader>pZ去高亮   n下一个 N上一个
" 自定义按键
let g:MapInterestingWords='<leader>pz'
let g:MapUncolorAllWords='<leader>pZ'
" 自定义颜色
let g:interestingWordsGUIColors = ['#8CCBEA', '#A4E57E', '#FFDB72', '#FF7272', '#FFB3FF', '#9999FF']
let g:interestingWordsTermColors = ['154', '123', '124', '130', '135', '138']
source ${__PATH_MY_CNF}/vim/plugin/vim-interestingwords/interestingwords.vim
"}}}

"----------------------- 底部状态栏lightline {{{ -----------------------
if !has('gui_running')
  set t_Co=256
endif
"let g:lightline = {
"          \ 'colorscheme': 'catppuccin_mocha',
"	      \ 'active': {
"	      \   'right': [ [ 'syntastic', 'lineinfo' ],
"	      \              [ 'percent' ],
"	      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
"	      \ },
"	      \ 'component_function': {
"	      \   'syntastic': 'SyntasticStatuslineFlag',
"	      \ },
"	      \ 'component_type': {
"	      \   'syntastic': 'error',
"	      \ }
"	      \ }

let g:lightline = {
            \ 'colorscheme': 'catppuccin_mocha',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component_function': {
            \   'filetype': 'MyFiletypeLogan',
            \   'fileformat': 'MyFileformatLogan',
            \   'gitbranch': 'FugitiveHead'
            \ },
            \ }

let g:lightline.enable = {
                    \ 'statusline': 1,
                    \ 'tabline': 0
                    \ }
" lightline中使用vim-devicons的图标
function! MyFiletypeLogan()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformatLogan()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
"}}}


"----------------------- 顶栏vim-xtabline {{{ -----------------------
let g:xtabline_settings = get(g:, 'xtabline_settings', {})
let g:xtabline_settings.theme='dracula'
" 禁用默认按键映射
let g:xtabline_settings.enable_mappings=0
"}}}


"----------------------- 缩进线 vim-indent-guides {{{ -----------------------
" 默认启动缩进线
let g:indent_guides_enable_on_vim_startup = 1
" 色块宽度,0到shiftwidth之间
let g:indent_guides_guide_size = 1

" 使用插件自动生成的颜色
"let g:indent_guides_auto_colors = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#535C91   ctermbg=61
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#686D76 ctermbg=242
" 排除filetype
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'startify', 'which_key', 'WhichKey']
" 禁用插件默认的映射<Leader>ig
let g:indent_guides_default_mapping = 0
" 自定义映射
nnoremap <silent> <Leader>pg <Plug>IndentGuidesToggle
"}}}


"----------------------- 将文件类型字形（图标）添加到各种 vim 插件 ryanoasis/vim-devicons {{{ -----------------------
" linux
" set guifont=DroidSansMono\ Nerd\ Font\ 11
" mac/windows
set guifont=DroidSansMono_Nerd_Font:h11
"}}}


"----------------------- vim中自带的matchit插件,扩展%的功能 {{{ -----------------------
" :help matchit-install 安装方式;  :help matchit 插件描述
packadd! matchit
" 忽略大小写
let b:match_ignorecase = 1
" vim中自带的editorconfig插件,需要set nocompatible filetype off,不用了
" :help editorconfig-install 安装方式;  :help editorconfig.txt 插件描述
" packadd! editorconfig
"}}}


"----------------------- tpope/vim-repeat {{{ -----------------------
" 解决 Vim 原生命令 . 在自定义映射或插件映射时无法重复的问题
" 支持surround.vim,放在最后;whichkey和startify不需要
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)
"}}}


"=============================== 插件end ===============================


"----------------------- 备忘录 {{{ -----------------------
"----------------------- 函数参数操作vim-scripts/argtextobj.vim
" 给di/da/yi/ya/ci/ca/vi/va 命令增加了a参数
" dia:删除光标下的函数参数(不删除逗号);    daa:删除光标下的函数参数(会删除逗号);
" yia:拷贝光标下的函数参数(不包含逗号);    yaa:拷贝光标下的函数参数(包含逗号);
" cia:删除光标下的函数参数(不包含逗号),并进入插入模式;    caa:删除光标下的函数参数(包含逗号),并进入插入模式;
" via:选中光标下的函数参数(不包含逗号);    vaa:选中光标下的函数参数(包含逗号);
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"}}}


"----------------------- 弃用插件设置 {{{ -----------------------
"----------------------- 缩进虚线indentLine Plug 'Yggdroot/indentLine'
"let g:indentLine_enabled = 1
" 这个插件默认会开启 set concealcursor='inc' ; set conceallevel = 2
" 会隐藏文件中某些字符(如json文件中的双引号),设置indentLine_setConceal=0不让这个功能生效,但是也会让indentLine功能失效,所以弃用
"let g:indentLine_setConceal = 0
"let g:indentLine_fileTypeExclude = ['startify']
" let g:indentLine_char = '⎸'

"----------------------- 代码检查  -----------------------
"let g:syntastic_always_populate_loc_list = 0
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0

"----------------------- 自动切换输入法 -----------------------
" let g:smartim_default = 'com.apple.keylayout.ABC'
"function! Multiple_cursors_before()
"  let g:smartim_disable = 1
"endfunction
"function! Multiple_cursors_after()
"  unlet g:smartim_disable
"endfunction
" 修改smartim.vim,   autocmd VimEnter * call Smartim_SelectDefault()
" 使每次进入vim的时候都是默认输入法
"}}}


"=========================================END=========================================

