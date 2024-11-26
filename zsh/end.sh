# 最后加载的脚本
# homebrew 命令自动补全
if [ -n "$BASH_VERSION" ]; then
    # 当前是 Bash
    if command -v brew >/dev/null 2>&1; then
        HOMEBREW_PREFIX="$(brew --prefix)"
        if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
            source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
        else
            for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
                [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
            done
        fi
    fi
elif [ -n "$ZSH_VERSION" ]; then
    #  Zsh中 在 init.sh 中 eval "$(/opt/homebrew/bin/brew shellenv)" 包含了自动补全; 是通过 FPATH 做的
    # if command -v brew >/dev/null 2>&1; then
    #     FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    # fi
    : # 什么都不做的占位符
fi

############################### 防止被覆盖的 alias 配置 ###################################
alias rm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_rm.sh '
alias xxm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_trash.sh '
alias trash='echo "Do not use this command! Please use xxm! "; false '
#alias trash='trash -F'

_my_alias_init_ls() {
    if command ls --color=auto ~ >/dev/null 2>&1; then
        command ls --color=auto "$@"
    elif command ls -G ~ >/dev/null 2>&1; then
        command ls -G "$@"
    fi
}

# 	-l: 以长格式显示，提供详细信息，例如权限、所有者、大小、修改日期等。
# 	-h: 以人类可读的格式显示文件大小，例如使用 KB、MB、GB 等单位，而不是纯字节数。
# 	-a: 显示所有文件，包括以 . 开头的隐藏文件。
#   -A: 显示所有文件，包括以 . 开头的隐藏文件; 但不包括 .（当前目录）和 ..（上级目录）
#   -F: 在每个文件/文件夹名后加上特定的标识符，帮助区分文件/文件夹类型,如文件夹后会加`/`,*：表示可执行文件;@：表示符号链接（symlink）。
#   --color=auto 在 Linux 系统中用于根据终端是否支持颜色自动决定是否启用颜色输出。它是一个较为广泛的标准选项，在大多数 Linux 发行版中都能正常工作
#   -G：在 macOS 和某些 Linux 发行版中启用颜色化输出，类似于 ls --color=auto
alias ls='_my_alias_init_ls'
alias l='ls -lAFh'
alias ll='ls -lAFh'
alias la='ls -lhA'
alias lsa='ls -lha'

# Temp
alias tt='cd ~/Temp && pwd && ls -A'
# Home
alias th='cd ~ && pwd && ls -A'
# Desktop
alias tw='cd ~/Desktop && pwd && ls -A'
# Data
alias td='cd ~/Data && pwd && ls -A'
# Config
alias tc='cd ~/Data/Config && pwd && ls -A'
############################################################################

# idea
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# $PATH 路径去重
source "${__PATH_MY_CNF}/zsh/cleanshrc"

# 为 zsh和bash 自定义历史命令配置
source "${__PATH_MY_CNF}/zsh/history.sh"

# 执行fastfetch
fastfetch_if_run=0 # 1为执行
fastfetch_config_path="$HOME/.config/fastfetch/config.jsonc"
if [ -f "$fastfetch_config_path" ]; then
    if command -v fastfetch >/dev/null 2>&1; then
        if [ $fastfetch_if_run -eq "1" ]; then
            supported_terms=("iTerm.app" "Apple_Terminal" "WezTerm" "Tabby")
            for term in "${supported_terms[@]}"; do
                if [ "$TERM_PROGRAM" = "$term" ]; then
                    command fastfetch -c "$fastfetch_config_path"
                    break
                fi
            done
        fi
        alias fastfetch='command fastfetch -c "$fastfetch_config_path"'
    fi
fi

# 用于测试的函数
function test_error() {
    echo "error..."
    return 3
}

function test_success() {
    echo "success..."
    return 0
}

# ssh-agent 判断当前用户是否存在ssh-agent进程
os_type=$(uname -s) #获取操作系统类型
if [ "$os_type" = "Darwin" ]; then
    # mac
    : # 什么都不做的占位符
elif [ "$os_type" = "Linux" ]; then
    # linux
    if ! ssh-add -l >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
    #ssh-add ~/.ssh/id_rsa
else
    echo "自启动 ssh-agent 时, 未知的操作系统: $os_type"
fi
