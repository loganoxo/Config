# navi
# export NAVI_CONFIG="${__PATH_HOME_CONFIG}/navi/config.yaml" #不配置,则默认在~/.config/navi/config.yaml
if _logan_if_interactive; then
    if _logan_if_command_exist "navi"; then
        if _logan_if_zsh; then
            eval "$(navi widget zsh)"
            #加载navi配置,覆盖 eval "$(navi widget zsh)"
            if [ -r "${__PATH_MY_CNF}/others/navi/navi.sh" ]; then
                source "${__PATH_MY_CNF}/others/navi/navi.sh"
            fi
        fi
        if _logan_if_bash; then
            eval "$(navi widget bash)"
        fi
    fi
fi

# zoxide
if _logan_if_interactive; then
    export _ZO_DATA_DIR="$HOME/.zoxide"                          #zz命令数据存放的目录
    export _ZO_EXCLUDE_DIRS="/:$HOME:$HOME/private/*:$HOME/Temp" #排除某些目录
    if _logan_if_command_exist "zoxide"; then
        if _logan_if_zsh; then
            eval "$(zoxide init --no-cmd zsh)"
        fi
        if _logan_if_bash; then
            eval "$(zoxide init --no-cmd bash)"
        fi
    fi
    alias z="__zoxide_z"   # z <path> 直接跳转到最佳匹配的目录
    alias zz="__zoxide_zi" # zz <path> 通过fzf
fi

# thefuck
if _logan_if_interactive; then
    if _logan_if_command_exist "thefuck"; then
        if _logan_if_mac; then
            export THEFUCK_EXCLUDE_RULES='sudo'
        fi
        if _logan_if_zsh; then
            # 使用 omz 加载; 可以执行 fuck 命令调用; 也可以按两次 Esc 键调用;(Esc功能是这个omz插件配置的)
            :
        fi
        if _logan_if_bash; then
            eval "$(thefuck --alias)"
        fi
    fi
fi
