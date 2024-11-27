#_common_home_for_root=""
# shellcheck disable=SC2154
# 常用 环境变量
export __PATH_MY_CNF_FOR_ROOT="$_common_home_for_root/Data/Config"                    # 我自己的配置文件目录
export __PATH_MY_SOFT_FOR_ROOT="$_common_home_for_root/Data/Software"                 # 我自己的软件目录
export __PATH_MY_CNF_SENSITIVE_FOR_ROOT="$_common_home_for_root/Data/ConfigSensitive" # 本地敏感数据目录
export __PATH_HOME_CONFIG_FOR_ROOT="$_common_home_for_root/.config"                   # 默认配置目录

export PATH=$PATH:/usr/sbin/       # 针对linux系统的默认PATH没有sbin的问题
export PATH=$PATH:$HOME/.local/bin # 针对linux系统

export TERM=xterm-256color
# 加载通用函数
[ -f "${__PATH_MY_CNF_FOR_ROOT}/zsh/logan_function.sh" ] && source "${__PATH_MY_CNF_FOR_ROOT}/zsh/logan_function.sh"
# 加载自定义函数
source "${__PATH_MY_CNF_FOR_ROOT}/my-functions/show_path.sh"
source "${__PATH_MY_CNF_FOR_ROOT}/my-functions/show_fpath.sh"

if _logan_if_linux; then
    alias xxm='/usr/bin/env bash ${__PATH_MY_CNF_FOR_ROOT}/shell/safe_trash_linux.sh '
fi

_my_alias_init_ls() {
    if command ls --color=auto ~ >/dev/null 2>&1; then
        command ls --color=auto "$@"
    elif command ls -G ~ >/dev/null 2>&1; then
        command ls -G "$@"
    fi
}

alias ls='_my_alias_init_ls'
alias l='ls -lAFh'
alias ll='ls -lAFh'
alias la='ls -lhA'
alias lsa='ls -lha'
alias tt='cd ~/Temp && pwd && ls -A'
alias less='less -FSRXc'

# 为 zsh和bash 自定义历史命令配置
source "${__PATH_MY_CNF_FOR_ROOT}/zsh/history.sh"
