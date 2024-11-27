# bashrc 和 bash_profile 公用的配置
if [ -z "${_INIT_BASH_PUBLIC_LOADED}" ]; then
    _INIT_BASH_PUBLIC_LOADED=1
else
    return
fi

# 重载配置文件
alias rr="echo 'reloading...'&&source ~/.bashrc"

# navi
# export NAVI_CONFIG="${__PATH_HOME_CONFIG}/navi/config.yaml" #不配置,则默认在~/.config/navi/config.yaml
_logan_if_command_exist "navi" && eval "$(navi widget bash)"

# zoxide
export _ZO_DATA_DIR="$HOME/.zoxide"                          #zz命令数据存放的目录
export _ZO_EXCLUDE_DIRS="/:$HOME:$HOME/private/*:$HOME/Temp" #排除某些目录
_logan_if_command_exist "zoxide" && eval "$(zoxide init --no-cmd bash)"
alias z="__zoxide_z"   # z <path> 直接跳转到最佳匹配的目录
alias zz="__zoxide_zi" # zz <path> 通过fzf

########################### 加载其他 ###########################

# 加载 通用alias
source "${__PATH_MY_CNF}/zsh/common_alias.sh"

# 加载 fzf配置
source "${__PATH_MY_CNF}/zsh/fzf.sh"

# 加载 rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
