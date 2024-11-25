### bash和zsh通用alias
alias less='less -FSRXc'
#   -F：如果内容可以在一屏内显示，less 会自动退出
#   -S：在长行超出屏幕宽度时不换行，方便水平滚动查看
#   -R：允许显示包含 ANSI 转义序列的“原始”控制字符，保留颜色输出
#   -X：在退出 less 后，保留终端内容（不清屏）
#   -c：每次重新绘制屏幕时，从头开始清除和绘制，而不是滚动更新。

alias mv='command mv -i'
alias cp='command cp -i'
alias grep='command grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
# tree颜色
alias tree='command tree -C'
# 在vim中的浮动窗口中,打开文件的命令
alias fvim='floaterm'
# 调用tmux脚本
alias tm='osascript ~/Data/Config/applescripts/tmux.scpt'
# ranger
# alias ra='ranger'
# 加载自定义函数
alias au='autoload -U'
# brew命令
alias brewtree='brew deps --tree --installed'
alias brewlist='brew leaves | xargs brew deps  --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"'
# python
alias python='python3'
# nvim
alias nv='nvim'

alias pinggoogle='ping google.com' # 快速检查网络连接
alias myip='curl ipinfo.io'        # 获取本机公网 IP 地址
# 局域网ip
lanip() {
    ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}'
}

# 增强mac的open命令
op() {
    if [ "$#" = "0" ]; then
        echo "!!!error: 需要传参"
        return 1
    fi
    if [ "$#" -gt 1 ]; then
        echo "!!!error: 参数过多，检查是否有空格，可以用双引号包裹"
        return 1
    fi
    if [[ "$1" == "." || -f $1 ]]; then
        /usr/bin/open "$1"
    elif [ -d "$1" ]; then
        cd "$1" && /usr/bin/open .
    else
        echo "!!!error: 没有这个目录或文件"
        return 1
    fi
}

# docker
alias dops1='/opt/homebrew/bin/bash ${__PATH_MY_CNF}/shell/dockerps1.sh'
alias dops2='/bin/bash ${__PATH_MY_CNF}/shell/dockerps2.sh'
alias dops='dops1'

# navi不直接执行命令; 经测试,用 navi --print ; 选好命令后回车,会输出命令(不执行)并换行; 只有用ctrl-g快捷键,才能让选好的命令显示在光标后
alias nav='navi --print'

# 批量重命名脚本
alias batch_rename='/bin/bash ${__PATH_MY_CNF}/shell/batch_rename.sh'

# z.lua
#alias zz="z -I"
#alias zb="z -b"
#alias zh='z -I -t .'
