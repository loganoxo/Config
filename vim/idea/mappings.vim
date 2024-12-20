"----------------- Tips {{{ -----------------
" 1、按键映射指令
" 使用 :h map-modes 查看映射适用的模式，配置自定义的需求,比如
" map! 递归映射(noremap! 非递归): 映射的模式为:Insert and Command-line ;
" map 递归映射(noremap 非递归): Normal, Visual, Select, Operator-pending;
" imap(inoremap): insert; nmap(nnoremap): Normal; vmap: Visual and Select;
" smap(snoremap): Select; xmap(xnoremap): Visual;
" unmap <F10>                      " 取消一个映射
" 2、ideavim
" ideavim中映射<Action>(),不能用noremap,只能用map,imap,vmap,xmap
" 3、idea的keymap的快捷键
"    <Command+\>            显示很有用的显示右键菜单(ShowContextMenu)
"    <Ctrl+Tab>             显示所有标签页
"    <Alt+Tab>              分屏时移动光标
"    <Command+E>            显示最近使用的文件
"    <Ctrl+Space>           显示代码提示
"    <Ctrl+;>               前进
"    <Ctrl+,>               后退
"    <Command+]>            整行缩进增加
"    <Command+[>            整行缩进减小
"    <Option+BS>            删除光标前一个单词
"    <Ctrl+BS>              删除到行尾
"    <Command+BS>           删除光标后一个单词
"    <Shift+BS>             删除光标到行首
"    <Shift+Enter>          在内容下方插入空行
"    <Ctrl+Shift+Enter>     在内容上方插入新行
"    <Ctrl+Enter>           (Split Line)将某行中,光标后到行尾的文本移动到下一行,光标位置不变
"    <Command+Enter>        (Generate)生成操作;
"    <Option+Enter>         (ShowContextActions,ShowQuickFixes)显示快速操作
"    <Option+V>             打开或关闭vim
"    <Command+'>            打开AceJump搜索字符,快速跳转,支持分屏时跨窗口跳转
"    <Option+'>             给所有单词加标签,跳转;AceJump
"    <Ctrl+Shift+'>         给所有行首行尾加标签,跳转;AceJump
"    <Option+Shift+'>       跳转后选中跳转后的单词;AceJump
"    <Ctrl+.>               从各种窗口中,把focus跳转回编辑窗口
"    <Command+1>            toggle目录窗口
"    <Command+2>            打开目录窗口,并选中当前文件
"    <Command+p>            显示当前函数的参数信息
" 所有的弹出的菜单中,Ctrl+kjhl 在keymap中设置为了上下左右
"}}}

"---------------------------- vim功能优化 -----------------
" 空格只用做leader键
"nnoremap <Space> <Nop>
"xnoremap <Space> <Nop>
" Don't use Ex mode, use Q for formatting.
map Q gq

" 重新加载vim
nnoremap \r :source ~/.ideavimrc<CR>
" 使用 jj 进入normal模式,`^指的是从insert到normal模式下,保持光标位置不变
inoremap jj <Esc>`^
" 解决esc后光标左移的问题,自动切换输入法
inoremap <silent> <Esc> <Esc>`^

" 撤销(u和<C-z>)和重做(U和<C-r>)
imap <C-z> <Action>($Undo)
map <C-z> <Action>($Undo)
map <C-r> <Action>($Redo)
map U <C-r>
imap <C-r> <Action>($Redo)

" 复制 从光标到行尾 所在范围的文本(Y默认是复制一行,用yy平替)
nnoremap Y y$
" 插入模式复制一行(排除了行首行尾空格)
inoremap <C-y> <Esc>^y$`^i
" 不排除行首行尾空格
inoremap <C-c> <Esc>`^yyi
" visual模式下复制后进入插入模式,在有鼠标操作时很方便,不用重新按i进入插入模式
xnoremap <C-c> y<Esc>i

" 全选，Ctrl+A 组合键(插入模式下默认行为:插入上一次插入的文本;i文本<esc>a<C-a>)
map <C-a> <Action>($SelectAll)

" Vim 搜索结果居中展示
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
" 向后搜索光标所在的单词并居中显示结果
nnoremap <silent> * *zz
" 向前搜索光标所在的单词并居中显示结果
nnoremap <silent> # #zz
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
noremap <C-u> m'5k
noremap <C-f> m'5j
inoremap <C-u> <Esc>`^m'5ki
inoremap <C-f> <Esc>`^m'5ji


" 上下左右滚动
map <A-j> <Action>(EditorScrollDown)
imap <A-j> <Action>(EditorScrollDown)
map <A-k> <Action>(EditorScrollUp)
imap <A-k> <Action>(EditorScrollUp)
map <A-h> <Action>(EditorScrollLeft)
imap <A-h> <Action>(EditorScrollLeft)
map <A-l> <Action>(EditorScrollRight)
imap <A-l> <Action>(EditorScrollRight)

" 单词跳跃(插入模式下默认C-w是删除光标前一个单词,C-e默认插入一个来自插入点以下的字符(若光标所在列在下一行存在字符)
inoremap <silent> <C-w> <Esc>`^wi
inoremap <silent> <C-e> <Esc>`^ea
inoremap <silent> <C-b> <Esc>`^bi

" 插入模式,模拟方向键
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

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


" 数字+j/k 多行跳转时记录位置到跳转列表中;以支持使用前进/后退
" idea中j/k 和 gj/gk是等价的
nnoremap <expr> j (v:count <= 1 ? 'j' : "m'" . v:count . 'j')
nnoremap <expr> k (v:count <= 1 ? 'k' : "m'" . v:count . 'k')
xnoremap <expr> j (v:count <= 1 ? 'j' : "m'" . v:count . 'j')
xnoremap <expr> k (v:count <= 1 ? 'k' : "m'" . v:count . 'k')

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

" ]m/M 跳转到下一个函数开头/结尾 [m/M 跳转到上一个函数开头/结尾
" ideavim不支持search,自定义一个search函数;这个函数不会把搜索词加入n/N的搜索中
function! SearchLogan(keyword,forward) abort
    if a:forward
        execute "normal! m' /" . a:keyword
    else
        execute "normal! m' ?" . a:keyword
    endif
endfunction
" 跳转到下一个{
noremap <silent> ]] :call SearchLogan('{',1)<CR>
" 跳转到上一个{
nnoremap <silent> [[ :call SearchLogan('{', 0)<CR>
" 跳转到下一个},]开头都是下一个
nnoremap <silent> ][ :call SearchLogan('}',1)<CR>
" 跳转到上一个},[开头都是上一个
nnoremap <silent> [] :call SearchLogan('}', 0)<CR>

" 跳转到行首行尾
noremap H ^
noremap L $
inoremap <C-[> <Esc>^i
inoremap <C-]> <Esc>$a
" <A-[/]>快速选中行首/行尾
" <Command+[/]> 调整缩进

"----------------------------- 快速选中 -----------------
" 插入模式快速进入v模式
inoremap <C-v> <Esc>:!/Users/logan/.input-source-vim/toggle-normal.sh<CR>v
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

"---------------------------- 标签页相关映射 -----------------
" 可以用idea的keymap中配置的Ctrl+Tab,功能强大
" 映射 <Tab>num 到标签页编号
noremap <Tab>1 1gt
noremap <Tab>2 2gt
noremap <Tab>3 3gt
noremap <Tab>4 4gt
noremap <Tab>5 5gt
noremap <Tab>6 6gt
noremap <Tab>7 7gt
noremap <Tab>8 8gt
noremap <Tab>9 9gt
" tabNext 切换到下一个标签页   tab-tab 双击
map <Tab><Tab> <Action>(NextTab)
" tabprevious 切换到上一个标签页 shift-tab
map <S-Tab> <Action>(PreviousTab)
" 切换到最后一个标签页
map <Tab>0 <Action>(GoToLastTab)
nmap <Tab>co <Action>(CloseAllEditorsButActive)    " 关闭其他所有 Tab
nmap <Tab>cl <Action>(CloseAllToTheRight)          " 关闭右侧的 Tab
nmap <Tab>ch <Action>(CloseAllToTheLeft)           " 关闭左侧的 Tab
nmap <Tab>ca <Action>(CloseActiveTab)



"---------------------------- 分屏窗口相关映射 -----------------
" <C-w>o 关闭其他窗口只保留当前的(:only);<C-w>c 关闭当前分屏;
" :sp[file] 上下分屏   :vsp[file] 左右分屏
" <C-w>h/j/k/l/w              在窗口间移动光标
" 可以用Alt+tab切换光标到相邻的分屏,idea的keymap中定义
" 上下分屏的情况很少
noremap <A-Down> <C-w>j
noremap <A-Up> <C-w>k
noremap <A-Left> <C-w>h
noremap <A-Right> <C-w>l

" 以下操作ideavim不支持,用action替代
" <C-w>H/J/K/L/r/R 移动窗口;  <C-w>T 将当前窗口移到新的标签页中
" <C-w>+-<> 增/减 窗口 高度/宽度 ; <C-w>= 设置所有窗口同宽同高;idea都不支持

" 最大化
nmap <C-w>\| <Action>(MaximizeEditorInSplit)
nmap <C-w>= <Action>(MaximizeEditorInSplit)
" 控制窗口大小
nmap <C-w><Down> <Action>(StretchSplitToBottom)
nmap <Leader><Down> <Action>(StretchSplitToBottom)
nmap <C-w><Left> <Action>(StretchSplitToLeft)
nmap <Leader><Left> <Action>(StretchSplitToLeft)
nmap <C-w><Right> <Action>(StretchSplitToRight)
nmap <Leader><Right> <Action>(StretchSplitToRight)
nmap <C-w><Up> <Action>(StretchSplitToTop)
nmap <Leader><Up> <Action>(StretchSplitToTop)
" 取消分屏
nmap <C-w>u <Action>(Unsplit)

"----------------------------- <BackSpace>键功能扩展 -----------------
nnoremap <BS> i<BS>

" 让normal和select模式和visual模式中 backspace键能有删除功能;
" idea中snoremap还不支持,曲线实现;用xnoremap覆盖visual模式
" select模式+visual模式
vmap <silent> <BS> <Action>(EditorDelete)<Esc>i
" visual模式,覆盖vmap
xnoremap <silent> <BS> ""c

"------- 修饰键+<BackSpace>
" 删除到软行首<Shift-BS>
inoremap <silent> <S-BS> <Esc>`^""d^i
nnoremap <silent> <S-BS> ""d^i

" 以下功能用keymap中的配置
" 删除光标前一个单词        <Option+BS>
" 删除到行尾               <Ctrl+BS>
" 删除光标后一个单词        <Command+BS>

"----------------------------- <Enter>键功能扩展 -----------------
" 已在idea的keymap中配置
" Shift+Enter:              在内容下方插入空行;
" Ctrl+Shift+Enter:         在内容上方插入新行
" Ctrl+Enter:               (Split Line)将某行中,光标后到行尾的文本移动到下一行,光标位置不变
" Command+Enter:            (Generate)生成操作;
" Option+Enter:             (ShowContextActions,ShowQuickFixes)显示快速操作

" 弹出的菜单中,Ctrl+kjhl 在keymap中设置为了上下左右

"----------------------------- 搜索模式 -----------------
" 默认为magic:特殊字符为:^ $ . * []
" 使用 very magic 模式，规范所有特殊符号，启用后，除了下划线 _，大小写字母，和数字外，所有的字符都具有特殊含义
nnoremap / /\v
vnoremap / /\v

"---------------------------- 保存和退出 -----------------
" 使用idea原生功能Command+s Command+w

"---------------------------- 折叠 -----------------
nmap za <Action>(ExpandCollapseToggleAction)
" 可支持的折叠相关命令:
" zo zO 打开折叠(O为递归)
" zc zC 把代码折叠起来(C为递归)
" 全折叠
nnoremap zm zM
" 全打开
nnoremap zr zR


"---------------------------- 其他映射 -----------------
" 取消Vim
nmap <Leader>?? <Action>(VimPluginToggle)
" 取消 Vim 查找高亮显示
nnoremap <Leader>?1 :nohls<CR>
" 清除最近的搜索模式
nnoremap <Leader>?2 :let @/ = ""<CR>
" 打开/关闭自动折行
nnoremap <Leader>?3 :set wrap! wrap?<CR>
" 打开/关闭显示相对行号
nnoremap <Leader>?4 :set rnu! rnu?<CR>




"---------------------------- 编程常用 -----------------
" 行尾加分号
inoremap ;; <Esc>A;
" IDEA 的格式化代码
map = <Action>(ReformatCode)
" 单行注释
map <C-/> <Action>(CommentByLineComment)
imap <C-/> <Action>(CommentByLineComment)
" 多行注释
map <A-/> <Action>(CommentByBlockComment)
imap <A-/> <Action>(CommentByBlockComment)

nmap ]b <Action>(GotoNextBookmark)
nmap [b <Action>(GotoPreviousBookmark)

" 新建class
nmap <Leader>nc <Action>(NewClass)
" 新建 Module
nmap <Leader>nm <Action>(NewModule)
" 新建文件
nmap <Leader>nf <Action>(NewFile)
" 代码环绕，如 if、try/catch 块等
map <Leader>sw <Action>(SurroundWith)
" 查找引用当前方法的文件信息
nmap <Leader>fu <Action>(FindUsages)
" 显示方法内使用该变量的引用信息
nmap <Leader>su <Action>(ShowUsages)
" 优化导入，移除多余的 imports
nmap <Leader>oi <Action>(OptimizeImports)
"gd                  # 跳转到局部变量定义处，即光标下的单词的定义
"gD                  # 跳转到全局变量定义处，即光标下的单词的定义
nmap ghc <Action>(CallHierarchy)
nmap ght <Action>(TypeHierarchy)
nmap ghm <Action>(MethodHierarchy)

" Maven 依赖重新导入
nmap <Leader>mr <Action>(Maven.Reimport)

" 复制当前文件的绝对路径
nmap <Leader>fa <Action>(CopyAbsolutePath)
" 复制文件相对于项目根目录的相对路径
nmap <Leader>fr <Action>(CopyContentRootPath)
" 复制文件名
nmap <Leader>fn <Action>(CopyFileName)

"""""""""""""""" 重构篇 """"""""""""""""""""""
" 元素名称重构
nmap <Leader>re <Action>(RenameElement)
" 移动重构
nmap <Leader>mv <Action>(Move)
" 成员变量转换为静态变量重构(配合移动重构有奇效)
nmap <Leader>ms <Action>(MakeStatic)
" 静态变量转换为成员变量重构
nmap <Leader>ci <Action>(ConvertToInstanceMethod)
" 内联重构(删除函数定义,将函数体的实现放入调用的地方)
nmap <Leader>il <Action>(Inline)
" 抽取方法重构
map <Leader>em <Action>(ExtractMethod)
" 抽取接口重构
map <Leader>ei <Action>(ExtractInterface)
" 字段的访问限制
map <Leader>ef <Action>(EncapsulateFields)
" 引入临时变量 <Ctrl+Command+v>
map <Leader>iv <Action>(IntroduceVariable)
" 引入常量
map <Leader>ic <Action>(IntroduceConstant)
" 引入方法参数
map <Leader>ip <Action>(IntroduceParameter)
" 引入字段
map <Leader>if <Action>(IntroduceField)
" 引入参数对象(指定参数)
map <Leader>po <Action>(IntroduceParameterObject)
" 方法下放到子类
map <Leader>pd <Action>(MemberPushDown)
" 方法上移到父类
map <Leader>pu <Action>(MembersPullUp)
" 文件名称重构
map <Leader>RF <Action>(RenameFile)
" 修改方法签名
map <Leader>cs <Action>(ChangeSignature)
" 抽取类
map <Leader>ec <Action>(ExtractClass)
" 匿名类到内部类
map <Leader>ai <Action>(AnonymousToInner)
" 切换方法为方法对象
map <Leader>rmo  <Action>(ReplaceMethodWithMethodObject)

""""""""""""""""""""""""""""""""""""" 跳转篇 """""""""""""""""""""""""""""""""""""
" 跳转到定义
nmap <Leader>gd m'<Action>(GotoDeclaration)
" 测试类跳转
nmap <Leader>gt m'<Action>(GotoTest)
" 文本搜索
nmap <Leader>fp m'<Action>(FindInPath)
" 跳转下个报错处
nmap <Leader>ne m'<Action>(GotoNextError)
" 跳转上个报错处
nmap <Leader>pe m'<Action>(GotoPreviousError)
" 从子类方法跳到父类的方法
nmap <Leader>gk m'<Action>(GotoSuperMethod)
" 跳转到方法实现
nmap <Leader>gi m'<Action>(GotoImplementation)
" 跳转到上个改动处
nmap <Leader>g, m'<Action>(JumpToLastChange)
" 跳转到下个改动处
nmap <Leader>g; m'<Action>(JumpToNextChange)


"---------------------------- 书签管理 -----------------
" 添加/删除标签
nmap mm <Action>(ToggleBookmark)
" 显示所有书签
nmap ma <Action>(ShowBookmarks)
" 编辑书签
nmap m; <Action>(Bookmarks)
" idea中m[数字或字母]给标签设置一个编号,字母必须大写,所以有了如下映射
"nmap ma  <Action>(ToggleBookmarkA)
nmap mb  <Action>(ToggleBookmarkB)
nmap mc  <Action>(ToggleBookmarkC)
nmap md  <Action>(ToggleBookmarkD)
nmap me  <Action>(ToggleBookmarkE)
nmap mf  <Action>(ToggleBookmarkF)
nmap mg  <Action>(ToggleBookmarkG)
nmap mh  <Action>(ToggleBookmarkH)
nmap mi  <Action>(ToggleBookmarkI)
nmap mj  <Action>(ToggleBookmarkJ)
nmap mk  <Action>(ToggleBookmarkK)
nmap ml  <Action>(ToggleBookmarkL)
"nmap mm  <Action>(ToggleBookmarkM)
nmap mn  <Action>(ToggleBookmarkN)
nmap mo  <Action>(ToggleBookmarkO)
nmap mp  <Action>(ToggleBookmarkP)
nmap mq  <Action>(ToggleBookmarkQ)
nmap mr  <Action>(ToggleBookmarkR)
nmap ms  <Action>(ToggleBookmarkS)
nmap mt  <Action>(ToggleBookmarkT)
nmap mu  <Action>(ToggleBookmarkU)
nmap mv  <Action>(ToggleBookmarkV)
nmap mw  <Action>(ToggleBookmarkW)
nmap mx  <Action>(ToggleBookmarkX)
nmap my  <Action>(ToggleBookmarkY)
nmap mz  <Action>(ToggleBookmarkZ)
nmap 'a <Action>(GotoBookmarkA)
nmap 'b <Action>(GotoBookmarkB)
nmap 'c <Action>(GotoBookmarkC)
nmap 'd <Action>(GotoBookmarkD)
nmap 'e <Action>(GotoBookmarkE)
nmap 'f <Action>(GotoBookmarkF)
nmap 'g <Action>(GotoBookmarkG)
nmap 'h <Action>(GotoBookmarkH)
nmap 'i <Action>(GotoBookmarkI)
nmap 'j <Action>(GotoBookmarkJ)
nmap 'k <Action>(GotoBookmarkK)
nmap 'l <Action>(GotoBookmarkL)
nmap 'm <Action>(GotoBookmarkM)
nmap 'n <Action>(GotoBookmarkN)
nmap 'o <Action>(GotoBookmarkO)
nmap 'p <Action>(GotoBookmarkP)
nmap 'q <Action>(GotoBookmarkQ)
nmap 'r <Action>(GotoBookmarkR)
nmap 's <Action>(GotoBookmarkS)
nmap 't <Action>(GotoBookmarkT)
nmap 'u <Action>(GotoBookmarkU)
nmap 'v <Action>(GotoBookmarkV)
nmap 'w <Action>(GotoBookmarkW)
nmap 'x <Action>(GotoBookmarkX)
nmap 'y <Action>(GotoBookmarkY)
nmap 'z <Action>(GotoBookmarkZ)







"---------------------------- 窗口管理 -----------------
" 打开工具组窗口
nmap \wa <Action>(ActiveToolwindowGroup)
" 打开Structure窗口,更倾向于使用idea的keymap中配置的Ctrl+s
nmap \ws <Action>(ActivateStructureToolWindow)
" Vim 配置操作
nmap \wv <Action>(VimActions)
" 项目之间的跳转(下一个)
nmap \wn <Action>(NextProjectWindow)
" 项目之间的跳转(上一个)
nmap \wp <Action>(PreviousProjectWindow)
" 激活 Maven 窗口
nmap \wm <Action>(ActivateMavenToolWindow)
" 最近查看文件间相互跳转 <Command+E>
nmap \wr m'<Action>(RecentFiles)
" 最近改动文件间相互跳转  <Command+E>
nmap \wc m'<Action>(RecentChangedFiles)
" 激活终端窗口
nmap \wt m'<Action>(ActivateTerminalToolWindow)
" 隐藏所有窗口
nmap \wh <Action>(HideAllWindows)

" 显示当前文件的文件路径
nmap \fp <Action>(ShowFilePath)
" SearchAnyWhere 全部
nmap \S m'<Action>(SearchEverywhere)
" SearchAnyWhere 声明
nmap \ss m'<Action>(GotoSymbol)
" SearchAnyWhere 动作
nmap \sa m'<Action>(GotoAction)
" SearchAnyWhere 文件
nmap \sf m'<Action>(GotoFile)
" SearchAnyWhere Java类
nmap \sc m'<Action>(GotoClass)
" 生成一些class基础成员  和 <Command+Enter> 效果相同
nmap \G <Action>(Generate)

"---------------------------- end -----------------
