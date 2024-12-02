###################################################### init #################################################################
##################        zprofile zshrc 统一执行的脚本
# 01、Mac电脑开机并登陆用户后,并不会自动执行zprofile和zshrc和zshenv;
# 02、若要在Mac电脑登陆后自动执行脚本,需要用 launchctl + plist 的方式,如jetbrains的破解
# 03、将终端程序(Iterm2和Terminal)从关闭状态打开 或者 新建一个终端窗口或标签页 后,以下文件会按顺序执行 1(注意是一次,zshenv并不会执行两次) 次: zshenv zprofile zshrc
# 04、在已存在的终端的窗口内执行zsh时(即只是新开了一个交互式shell),以下文件会按顺序执行 1 次: zshenv zshrc;不会执行zprofile
# 05、在已存在的终端的窗口内执行 zsh -l 命令时(新开了一个login shell),以下文件会按顺序执行 1 次: zshenv zprofile zshrc; 但是echo $0输出的zsh前没有 - 前缀
# 06、在mac和linux中可以通过运行 echo $0 检查 shell 的类型。如果输出类似 -zsh（前面带有 -），则表示这是一个登录 shell。
# 07、但是手动运行 zsh -l 时，启动的 shell 虽然是登录 shell，但并不会自动在 $0 中加上 - 前缀。这个 - 前缀主要用于区分由系统登录管理器启动的会话。
# 08、在 zshenv zprofile zshrc中 写 或 手动执行 source script_name 时，只会执行 script_name 文件的内容，不会触发或重新加载 zshenv zshrc zprofile
# 09、运行 zsh script_name 执行脚本时，Zsh 会启动一个非交互式并且非登录的 Shell, 只会执行一次zshenv
# 10、在linux系统中,开机登录后会直接进入 login shell ,并自动执行zshenv和zprofile;后面再新建shell就不会执行zprofile了,除非用 zsh -l 命令
# 11、在iterm2中,在profile的General配置中Command配置为Command(/bin/zsh),这会使每次打开Iterm2或新建窗口或标签时创建的都是交互式shell;以下文件会按顺序执行 1 次: zshenv zshrc;不会执行zprofile
# 12、在iterm2中,在profile的General配置中Command配置为Custom Shell(/bin/zsh),这会使每次打开Iterm2或新建窗口或标签时创建的都是 login shell;以下文件会按顺序执行 1 次: zshenv zprofile zshrc
# 13、在iterm2中,Command配置中的 login shell 选项的shell类型不能修改,默认为系统的默认shell; 如果要改成bash的login shell , 需要选择 Custom Shell, 填入/bin/bash
# 14、打开macos系统自带的终端程序或新建窗口和标签时, 一直是使用的 login shell; 尽管可以在 设置-Shell的打开方式中修改为 命令(/bin/zsh), 依然还是login shell; 以下文件会按顺序执行 1 次: zshenv zprofile zshrc
# 15、在macos系统自带的终端程序中,执行 zsh 或 zsh -l 命令时, 效果与在Iterm2中相同
# 16、在mac中只执行 zshenv 和 zprofile 但是不执行 zshrc的 情况: zsh -l -c "pwd"; 因为这只会启动一个非交互式的 login shell 直接输出pwd的结果

# 17、当你在交互式 shell 中执行命令 zsh 或 zsh a.sh 或 zsh -l 或 zsh -l -c "pwd" 等,都会启动一个新的 zsh 子进程时，该子进程会继承以下内容:
#       导出的环境变量:    所有在父进程中通过 export 导出的全局环境变量，例如 PATH、HOME 以及用户自定义的 export VAR="value" 变量。
#       当前的工作目录:    子 shell 会继承父 shell 的当前工作目录。
#       用户权限:         子 shell 以当前用户的权限运行。
#       进程环境:         其他与运行环境相关的信息，比如终端类型、语言设置（LANG、LC_* 变量）等。
#  当在shell 中执行命令 zsh b.sh; b.sh中执行了 a.sh; 全局环境依然会被依次继承到 b 和 a 中; b中如果新增了全局环境变量,则a中也可以继承并使用该变量;但是局部变量就不行
#  但是子shell中对全局环境变量的修改并不会传到父shell

# 不会继承的内容包括:
#       未导出的局部变量：例如使用 VAR="value" 定义而未 export 的变量，这些只在当前 shell 会话中可用，不会传递给子 shell。
#       未被导出的函数:    如果你希望子 shell 能继承父 shell 中定义的函数,需要使用 export -f 命令来显式导出函数

# a.    /etc/zshenv   和  ~/.zshenv：   始终运行于每个 Zsh 实例中，不管是交互式还是非交互式或者 login shell。
# b.    /etc/zprofile 和  ~/.zprofile： 只在 login Shell 中运行。
# c.    /etc/zshrc    和  ~/.zshrc：    只在交互式 Shell 中运行。
# d.    /etc/zlogin   和  ~/.zlogin：   仅在 login Shell 中运行，且在 .zshrc 之后执行。
# e.    /etc/zlogout  和  ~/.zlogout：  在 login Shell 退出时运行。

##############################################################################################################################

#if [ -z "${_INIT_ZSH_INIT_LOADED}" ]; then
#    _INIT_ZSH_INIT_LOADED=1
#else
#    return
#fi
# 此脚本被我在bash的配置文件也引入了,也会被bash加载
# 让 init.sh 只会被加载一次;注意 _INIT_ZSH_INIT_LOADED 为局部变量,子shell不会继承该变量
# 所以只要不是同一个shell,包括新建的子shell, init.sh 都会重新被 zprofile 或 zshrc 加载

# touch "$HOME/.hushlogin" # 默认每次打开终端(zsh/bash)都会在第一行提示上次登陆信息,创建这个空文件后,就不显示了;

# 加载通用函数
[ -f "${__PATH_MY_CNF}/zsh/logan_function.sh" ] && source "${__PATH_MY_CNF}/zsh/logan_function.sh"

# export LANG=zh_CN.UTF-8 # 控制界面语言的展示或输出等 en_US.UTF-8; 注释掉,使用系统默认的,不然会对debian环境有影响

export TERM=xterm-256color

export BAT_THEME="Dracula" # bat主题

# 定义在命令行中，哪些字符被视为“单词的一部分”,用在单词删除(ctrl+w),和单词跳转(option+left/right)时; 写在omz之下
# WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'

# HomeBrew
# 放在开头,后面的命令才能找到,不能放在zshenv中
# export PATH=/usr/local/sbin:$PATH  intel的homebrew
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
# 禁止自动更新软件包
export HOMEBREW_NO_AUTO_UPDATE=1
# brew 清华镜像源
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
# 中科大brew镜像
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
# export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

# maven
if _logan_if_mac; then
    export MAVEN_HOME=~/Data/Software/apache-maven
    export PATH=$MAVEN_HOME/bin:$PATH
fi

# ruby
if _logan_if_command_exist "brew"; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
    export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
fi

# go安装的包的路径
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

# java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/17.0.8-oracle
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-8-arm/Contents/Home
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11-arm/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH

# java多版本
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"

# git
#export GITDIR=/usr/local/Cellar/git/2.41.0_2
#export PATH=$GITDIR/bin:$PATH

# python3
#export PYTHON3DIR=/usr/local/Cellar/python@3.11/3.11.4_1
#export PATH=$PYTHON3DIR/bin:$PATH

########################### 加载自定义函数 ###########################
source "${__PATH_MY_CNF}/my-functions/getproxy.sh"
source "${__PATH_MY_CNF}/my-functions/setproxy.sh"
source "${__PATH_MY_CNF}/my-functions/unproxy.sh"
source "${__PATH_MY_CNF}/my-functions/fkill.sh"
source "${__PATH_MY_CNF}/my-functions/show_path.sh"
source "${__PATH_MY_CNF}/my-functions/show_fpath.sh"

#fpath+=~/Data/Config/my-functions
## 代理函数
#autoload -U setproxy unproxy getproxy
## fzf杀进程 fzf预览
#autoload -U fkill preview

###################################################### 放在末尾 ##################################################################

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Added by OrbStack: command-line tools and integration
[[ -f "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"

# fnm(node版本管理工具)
_logan_if_command_exist "fnm" && _logan_if_zsh && eval "$(fnm env --use-on-cd --shell zsh)"
_logan_if_command_exist "fnm" && _logan_if_bash && eval "$(fnm env --use-on-cd --shell bash)"

# nvm 弃用,太慢了
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# 功能1:让输入行和提示符都在最后一行
#   方法1: 打印行数-1个换行符;但是如果执行 fzf或navi等工具的命令后,就不在最后一行了
#printf '\n%.0s' $(seq 1 $LINES)
#   方法2: 每次执行完命令后都通过钩子函数把光标移动到最后一行,也有点问题
#function bottom_prompt {
#    tput cup $(($LINES - 1)) 0
#}
#add-zsh-hook precmd bottom_prompt

# 功能2:让光标变成细线
#printf '\033[5 q\r'
###################################################### 放在末尾 ##################################################################
