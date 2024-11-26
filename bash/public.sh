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
if command -v navi >/dev/null 2>&1; then
    eval "$(navi widget bash)"
fi

# zoxide
export _ZO_DATA_DIR="$HOME/.zoxide"                          #zz命令数据存放的目录
export _ZO_EXCLUDE_DIRS="/:$HOME:$HOME/private/*:$HOME/Temp" #排除某些目录
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --no-cmd bash)"
fi
alias z="__zoxide_z"   # z <path> 直接跳转到最佳匹配的目录
alias zz="__zoxide_zi" # zz <path> 通过fzf

# fzf, zsh中因为有开启omz的fzf插件,所以不需要自己加这个集成语句
# Set up fzf key bindings and fuzzy completion
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

########################### 加载其他 ###########################

# 加载 通用alias
source "${__PATH_MY_CNF}/zsh/common_alias.sh"

# 加载 fzf配置
source "${__PATH_MY_CNF}/zsh/fzf.sh"

# 加载 rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
