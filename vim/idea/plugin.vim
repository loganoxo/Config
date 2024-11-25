" 需要在idea插件仓库安装的: IdeaVim AceJump IdeaVim-EasyMotion

" 一、highlightedyank
set highlightedyank
" 高亮时间为1秒
let g:highlightedyank_highlight_duration="1000"
" 高亮背景色
let g:highlightedyank_highlight_color="rgba(116, 0, 148, 100)"

" 二、surround
set surround
" 给dyc增加s参数;  ds删 cs改 ys添加; 例如 ds ( ,  ys iw ' , cs ( {
" 1、假如有文本如: "Hello world!" => cs"' => 'Hello world!' ; 将文本两边的双引号修改为单引号
" 2、接下来敲击:              cs'<q>      会变成:  <q>Hello world!</q>
" 3、接下来敲击:              cst(        会变成:  (Hello world!)        ;t代表的意思就是tag标签
" 4、接下来敲击:              ds(         会变成:  Hello world!          ;删除了括号
" 5、光标放在hello上,敲击:     ysiw]       会变成:  [Hello] world!        ;iw 是一个文本对象,表示当前单词
" 6、    ysiw]       括号和单词之间不会添加空格; ysiw[ 括号和单词之间会添加空格
" 7、    yss)        将整行括在括号中
" 8、 可以用 <.> 键重复上一次的操作
" 9、 visual模式下可以用大写S操作  v$ 选中到行尾后 按S"  给选中的内容两边加双引号
" 将单词用双引号包围的映射
nmap <Leader>" ysiw"
nmap <Leader>( ysiw(
nmap <Leader>) ysiw)
nmap <Leader>{ ysiw{
nmap <Leader>} ysiw}
nmap <Leader>[ ysiw[
nmap <Leader>] ysiw]
nmap <Leader>' ysiw'
nmap <Leader>` ysiw`
nmap <Leader>< ysiw<
nmap <Leader>> ysiw>


" 三、
" 让{}跳转的位置包括只有空格的行,默认只能跳转到没有任何字符的空行
set vim-paragraph-motion

" 四、easymotion
set easymotion
" 禁用默认映射
let g:EasyMotion_do_mapping=0
" 在当前窗口屏幕显示中搜索字符
map f <Plug>(easymotion-bd-f)
map <A-f> <Action>(AceAction)
imap <A-f> <Esc><Action>(AceAction)
" 当前文件中全局搜索字符
map F <Plug>(easymotion-bd-n)
" 在当前窗口屏幕显示中给所有单词开头/结尾加标签
map t <Plug>(easymotion-bd-W)
map <A-t> <Action>(AceLineAction)
imap <A-t> <Esc><Plug>(easymotion-bd-W)
map T <Plug>(easymotion-bd-E)
" map F <Action>(AceAction)  直接调用Ace插件,和按<Command+;>的效果相同,比easymotion的写法多了支持分屏之间跳转;但是不支持和vim的d、c、v等操作配合使用

" 键入label时用shift会进入visual模式
" 输入完字符后,可以用backspace键重新开始
" enter键移动到下一个  shift+enter 移动到上一个
" 全局搜索时,按tab和shift+tab可以把屏幕翻页

" Press `f` to activate AceJump
"map f <Action>(AceAction)
" Press `F` to activate Target Mode
"map F <Action>(AceTargetAction)


" 五、sneak
set sneak
" s/S+两个字符 向光标之后/前搜索这两个字符 用,和;继续跳转
" visual模式下只能用s.不能用S,因为S在visual模式下是用于surround插件的

" 六、目录支持
set NERDTree
" 打开/关闭目录树,<Command+1>
nnoremap \w1 :NERDTreeToggle<CR>
" 打开目录树并定位到当前文件,<Command+2>
nnoremap \w2 :NERDTreeFind<CR>
" <Ctrl+.>  从各种窗口中,把focus跳转回编辑窗口
"所有的弹出的菜单中,Ctrl+kjhl 在keymap中设置为了上下左右
" q:隐藏目录窗口; r/R 刷新当前目录/root目录; m:显示右键菜单;  A:放大/缩小目录窗口;
" jk:上下移动;  J/K:光标移动到当前父目录列表的end/start       P: 光标移动到root目录;  p:光标移动到当前的父目录
" o:打开文件;展开或关闭目录;      O: 递归展开目录      go:打开文件,但是焦点还在目录窗口;
" s: 左右分屏打开;     gs:左右分屏打开,但是焦点还在目录窗口
" d: 删除文件/文件夹;   n/N: 创建文件/文件夹;   /:搜索,避免当作执行命令

" 七、多光标 terryma/vim-multiple-cursors
set multiple-cursors
" idea原生对鼠标支持: 鼠标中键移动; option+鼠标左键移动; Shift+Option+鼠标左键 点击添加cursor
" 通过光标下的单词来匹配依次添加光标并选中
nmap <C-n> <Plug>NextWholeOccurrence
xmap <C-n> <Plug>NextWholeOccurrence
nmap \n <Plug>NextWholeOccurrence
xmap \n <Plug>NextWholeOccurrence
" 与g* g#类似,不严格按照单词来分界;`aaa bbb`的aaa上, 能匹配到 aaaacccc中的aaa
nmap g<C-n> <Plug>NextOccurrence
xmap g<C-n> <Plug>NextOccurrence
nmap \gn <Plug>NextOccurrence
xmap \gn <Plug>NextOccurrence

" 跳过/删除某个光标
xmap \q <Plug>SkipOccurrence
xmap \Q <Plug>RemoveOccurrence

" 直接通过光标下的单词,匹配文件中所有出现的位置,全都加上光标并选中
nmap \A <Plug>AllWholeOccurrences
xmap \A <Plug>AllWholeOccurrences
" 不严格按照单词来分界
nmap \gA <Plug>AllOccurrences
xmap \gA <Plug>AllOccurrences
" 选中后按c、d、y等操作; 或者按esc进入normal模式操作多光标的位置(i,a等进入插入模式编辑多个位置)

" 八、注释
set commentary
" [n]gcc            快速注释/取消注释 n行
" {Visual}gc        快速注释/取消注释 visual 选区
" gciw              注释一个单词,使用Text object语法;
" gci{              注释当前光标所在位置两边的{}之间的所有内容
" gc{motion}        如gcf调用easymotion找到光标终点; gc$ 注释到行尾; gcj/k:注释到下/上一行; gcG 注释到文件结尾; 等

" 九、增加函数参数的文本对象,a参数
set argtextobj
" 给di/da/yi/ya/ci/ca/vi/va 命令增加了a参数
" dia:删除光标下的函数参数(不删除逗号);    daa:删除光标下的函数参数(会删除逗号);
" yia:拷贝光标下的函数参数(不包含逗号);    yaa:拷贝光标下的函数参数(包含逗号);
" cia:删除光标下的函数参数(不包含逗号),并进入插入模式;    caa:删除光标下的函数参数(包含逗号),并进入插入模式;
" via:选中光标下的函数参数(不包含逗号);    vaa:选中光标下的函数参数(包含逗号);
nmap <Leader>a vaa
nmap <Leader>A via


" 十、交换两个选区的内容
set exchange
" 首次使用时，定义要交换的第一个 {motion}。在第二次使用时，定义第二个 {motion} 并执行交换
" cx{motion}        如: cx$ cx^ cxG cxf等
" cxc   清除任何待交换的 {motion}。
" cxx   把当前行作为{motion}
" X     在visual模式下,把选区当作{motion}
" 假如:  1aaa  2bbb; 光标在1位置,cxiw设定第一个选区,光标移到2位置,cx$交换1aaa和2bbb的位置


" 十一、自带的p命令就能覆盖,但是会把被覆盖的内容也复制到剪切板,并且格式也不好
set ReplaceWithRegister
"[count]["x]gr{motion}   Replace {motion} text with the contents of register x.
"                        Especially when using the unnamed register, this is
"                        quicker than "_d{motion}P or "_c{motion}<C-R>"
"[count]["x]grr          Replace [count] lines with the contents of register x.
"                        To replace from the cursor position to the end of the
"                        line use ["x]gr$
"{Visual}["x]gr          Replace the selection with the contents of register x.


" 十二、根据缩进级别定义一个新的文本对象
set textobj-indent
" 此插件定义了两个新的文本对象。它们非常相似 - 它们的区别仅在于它们是否包含块下方的行;你可以使用这些文本对象来执行常见的编辑操作，如删除、复制和替换整个缩进级别的代码块
"<count>ai	选择当前缩进级别 一直到上方的第一个非空行
"<count>ii	选择当前缩进级别内的代码块
"<count>aI	选择当前缩进级别和上方和下方的空行(一直到上方和下方的第一个非空行)
"<count>iI	内部缩进级别（没有上方和下方的空行）与ii等效。
"
"这些映射既可以与期望运动的运算符一起使用，例如 d 或 c 或 y，也可以在视觉模式下使用
"在可视化模式下，映射可以重复，这具有迭代增加所选缩进块范围的效果。指定计数可用于实现相同的效果
" yii  yai y2ii y2ai等

" 十三、支持%对于if/else try/catch html标签 等跳转
set matchit
