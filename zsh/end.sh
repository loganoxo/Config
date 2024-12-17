# 最后加载的脚本
# homebrew 命令自动补全
if _logan_if_bash && _logan_if_command_exist "brew"; then
    HOMEBREW_PREFIX="$(brew --prefix)"
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            if [[ -r "${COMPLETION}" ]]; then
                # shellcheck disable=SC1090
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

if _logan_if_interactive; then
    if [ -f "${__PATH_MY_CNF}/zsh/ls.sh" ]; then
        source "${__PATH_MY_CNF}/zsh/ls.sh"
    fi
fi

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

###########################################################################################

# 为 zsh和bash 自定义历史命令配置
source "${__PATH_MY_CNF}/zsh/history.sh"

# ssh-agent 判断当前用户是否存在ssh-agent进程
if _logan_if_linux; then
    if ! ssh-add -l >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
    fi
fi

# 用tabby进行ssh连接时,给tabby报告当前文件夹的目录,以便于使用传输文件功能(SFTP)时,不用自己找文件目录
function _report_current_dir_for_tabby() {
    # shellcheck disable=SC2028
    echo -n "\x1b]1337;CurrentDir=$(pwd)\x07"
}
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

# 加载 conda配置
source "${__PATH_MY_CNF}/zsh/conda/conda.sh"

# fastfetch 放在最后
if [ -f "${__PATH_MY_CNF}/others/fastfetch/fastfetch.sh" ]; then
    source "${__PATH_MY_CNF}/others/fastfetch/fastfetch.sh"
fi

# 重载配置文件
function rr() {
    local _logan_profile
    if _logan_if_zsh; then
        _logan_profile="$HOME/.zshrc"
    fi
    if _logan_if_bash; then
        _logan_profile="$HOME/.bashrc"
    fi
    if [ "${_logan_profile}x" != "x" ]; then
        echo -e "\033[31m reloading '${_logan_profile}' ... \033[0m"
        # shellcheck disable=SC1090
        source "${_logan_profile}"
        echo -e "\033[35m Done. \033[0m"
    else
        echo -e "\033[35m Shell not supported. \033[0m"
    fi
}

# idea
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"
# shellcheck disable=SC1090
if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

########################### 加载自定义函数 ###########################
source "${__PATH_MY_CNF}/my-functions/a_tmux.sh"
source "${__PATH_MY_CNF}/my-functions/b_theme_handle.sh"
source "${__PATH_MY_CNF}/my-functions/c1_getproxy.sh"
source "${__PATH_MY_CNF}/my-functions/c2_setproxy.sh"
source "${__PATH_MY_CNF}/my-functions/c3_unproxy.sh"
source "${__PATH_MY_CNF}/my-functions/d1_show_path.sh"
source "${__PATH_MY_CNF}/my-functions/d2_show_fpath.sh"
source "${__PATH_MY_CNF}/my-functions/e_other_functions.sh"

#fpath+=~/Data/Config/my-functions
## 代理函数
#autoload -U setproxy unproxy getproxy
## fzf杀进程 fzf预览
#autoload -U fkill preview
# $PATH 路径去重
#source "${__PATH_MY_CNF}/zsh/cleanshrc"
############################################################################
