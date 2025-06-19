########################################## bash和zsh通用alias ##########################################
#######################################################################################################
########################################## 基础命令同名扩展 #############################################
alias less='less -FSRXc'
#   -F：如果内容可以在一屏内显示，less 会自动退出
#   -S：在长行超出屏幕宽度时不换行，方便水平滚动查看
#   -R：允许显示包含 ANSI 转义序列的“原始”控制字符，保留颜色输出
#   -X：在退出 less 后，保留终端内容（不清屏）
#   -c：每次重新绘制屏幕时，从头开始清除和绘制，而不是滚动更新。

# 若目标位置有同名文件,则有覆盖提示
alias mv='command mv -i'
alias cp='command cp -i'

# grep颜色
alias grep='command grep --color=auto'
# tree颜色
alias tree='command tree -C'

# python
alias python='python3'

# ls == lsd
if _logan_if_interactive; then
    if [ -r "${__PATH_MY_CNF}/zsh/ls.sh" ]; then
        source "${__PATH_MY_CNF}/zsh/ls.sh"
    fi
fi

########################################## 快速跳转常用目录 ##########################################
# Temp
alias tt='cd ~/Temp && pwd && ls -A'
# TempCode
alias ttc='cd ~/TempCode && pwd && ls -A'
# Home
alias th='cd ~ && pwd && ls -A'
# Desktop
alias tw='cd ~/Desktop && pwd && ls -A'
# Data
alias td='cd ~/Data && pwd && ls -A'
# Config
alias tc='cd ~/Data/Config && pwd && ls -A'
# pull Config
alias gpc='git -C "$__PATH_MY_CNF" pull'

########################################## 脚本的快速调用 ##########################################
# 查看 cli-reference common_alias.sh 等文档
alias doc='/usr/bin/env bash ${__PATH_MY_CNF}/shell/doc.sh'

# docker
alias dops1='/usr/bin/env bash ${__PATH_MY_CNF}/shell/dockerps1.sh'
alias dops2='/usr/bin/env bash ${__PATH_MY_CNF}/shell/dockerps2.sh'
alias dops='dops1'

# 文件或者文件夹删除
alias rm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_rm.sh '
if _logan_if_mac; then
    alias xxm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_trash_mac.sh '
    # alias trash='echo "Do not use this command! Please use xxm! "; false '
elif _logan_if_linux; then
    alias xxm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_trash_linux.sh '
fi

# 批量重命名脚本
alias batch_rename='/usr/bin/env bash ${__PATH_MY_CNF}/shell/batch_rename.sh'
# zookeeper
alias zk_handle='/usr/bin/env bash ${__PATH_MY_CNF}/shell/zk.sh'
# 代码缩进格式化脚本
alias logan_format='/usr/bin/env bash ${__PATH_MY_CNF}/shell/format.sh'
# 检查多个git仓库的状态
alias logan_check='/usr/bin/env bash ${__PATH_MY_CNF}/shell/logan_check.sh'

# yt-dlp 命令简单化
alias yts='/usr/bin/env bash ${__PATH_MY_CNF}/shell/yt_dlp_quick.sh "show" '
alias ytd='/usr/bin/env bash ${__PATH_MY_CNF}/shell/yt_dlp_quick.sh "download" '
alias ytb='/usr/bin/env bash ${__PATH_MY_CNF}/shell/yt_dlp_quick.sh "best" '

# 获取绝对路径
alias get_home_relative_path='/usr/bin/env bash ${__PATH_MY_CNF}/shell/public_shell_function_run.sh "get_home_relative_path_func"'

# 复制绝对路径
alias fcp='/usr/bin/env bash ${__PATH_MY_CNF}/shell/fcp.sh'

########################################## 命令行工具 ##########################################

# 加载自定义函数
alias au='autoload -U'

# homebrew
alias brews='
    echo "🔄 Updating Homebrew..."
    brew update
    echo "------------------------------------------------------------"

    echo "⚙️ Brew config:"
    brew config
    echo "------------------------------------------------------------"

    echo "💊 Running brew doctor:"
    brew doctor
    echo "------------------------------------------------------------"

    echo "📦 Outdated global packages:"
    brew outdated -g
'
alias brewc='
    echo "🗑️ Cleanup Homebrew..."
    brew cleanup --prune=all
    echo "------------------------------------------------------------"

    echo "🔄 Updating Homebrew..."
    brew update
    echo "------------------------------------------------------------"

    echo "⚙️ Brew config..."
    brew config
    echo "------------------------------------------------------------"

    echo "💊 Running brew doctor..."
    brew doctor
    echo "------------------------------------------------------------"

    echo "📦 Outdated global packages..."
    brew outdated -g
'
alias brewtree='brew deps --tree --installed'
alias brewlist='brew leaves | xargs brew deps  --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"'

# navi不直接执行命令; 经测试,用 navi --print ; 选好命令后回车,会输出命令(不执行)并换行; 只有用ctrl-g快捷键,才能让选好的命令显示在光标后
alias nav='navi --print'

# ffmpeg
alias ffmpeg='command ffmpeg -hide_banner'

# 在vim中的浮动窗口中,打开文件的命令
alias fvim='floaterm'
# nvim
alias nv='nvim'

########################################## 简单alias扩展 ##########################################
alias pingc='ping -c 4 google.com' # 快速检查网络连接
alias myip='curl ipinfo.io'        # 获取本机公网 IP 地址

########################################## 弃用的alias ##########################################
# z.lua
#alias zz="z -I"
#alias zb="z -b"
#alias zh='z -I -t .'

# ranger
# alias ra='ranger'
