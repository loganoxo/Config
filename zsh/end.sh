# 最后加载的脚本
# homebrew 命令自动补全
if _logan_if_bash && _logan_if_command_exist "brew"; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            if [[ -r "${COMPLETION}" ]]; then
                source "${COMPLETION}"
            fi
        done
    fi
fi

# uv python管理工具
export UV_PYTHON_PREFERENCE="only-managed"
# uv 命令补全
if _logan_if_command_exist "uv"; then
    if _logan_if_zsh; then
        eval "$(uv generate-shell-completion zsh)"
    elif _logan_if_bash; then
        eval "$(uv generate-shell-completion bash)"
    fi
fi
if _logan_if_command_exist "uvx"; then
    if _logan_if_zsh; then
        eval "$(uvx --generate-shell-completion zsh)"
    elif _logan_if_bash; then
        eval "$(uvx --generate-shell-completion bash)"
    fi
fi

############################### 防止被覆盖的 alias 配置 ###################################
alias rm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_rm.sh '
if _logan_if_mac; then
    alias xxm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_trash_mac.sh '
    alias trash='echo "Do not use this command! Please use xxm! "; false '
elif _logan_if_linux; then
    alias xxm='/usr/bin/env bash ${__PATH_MY_CNF}/shell/safe_trash_linux.sh '
fi
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
# pull Config
alias gpc='git -C "$__PATH_MY_CNF" pull'

############################################################################

# idea
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# $PATH 路径去重
source "${__PATH_MY_CNF}/zsh/cleanshrc"

# 为 zsh和bash 自定义历史命令配置
source "${__PATH_MY_CNF}/zsh/history.sh"

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
if _logan_if_linux; then
    if ! ssh-add -l >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
fi

function _report_current_dir_for_tabby() {
    echo -n "\x1b]1337;CurrentDir=$(pwd)\x07"
}

# 用tabby进行ssh连接时,给tabby报告当前文件夹的目录,以便于使用传输文件功能(SFTP)时,不用自己找文件目录
if [ "$(_logan_term_type)" = "ssh" ]; then
    #    _logan_if_bash && export PS1="$PS1\[\e]1337;CurrentDir="'$(pwd)\a\]' # 与starship 不兼容
    if _logan_if_zsh; then
        add-zsh-hook precmd _report_current_dir_for_tabby
    fi
fi

# 设置orbstack 的 linux 虚拟机的语言
if _logan_if_linux; then
    if _logan_if_command_exist "mac" || [ -f "/opt/orbstack-guest/bin/mac" ]; then
        export LANG="en_US.UTF-8"
    fi
fi

# fastfetch 放在最后
if [ -f "${__PATH_MY_CNF}/others/fastfetch/fastfetch.sh" ]; then
    source "${__PATH_MY_CNF}/others/fastfetch/fastfetch.sh"
fi
