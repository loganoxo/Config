# shellcheck disable=SC2034
theme_if_simple="true" #是否使用简单主题,注释打开会强制使用;true:使用简单主题; false:使用多符号主题
theme_prefer="starship"  #默认使用 starship 还是 om: ohmyzsh 或 ohmybash

# starship
export starship_theme="logan"                 # 主题名; 设为空字符串则为默认: starship.toml
export starship_simple_theme="logan_simple"   # 简单主题名; 设为空字符串则为默认: starship.toml
export starship_path="$HOME/.config/starship" # 路径; 设为空字符串则为默认: ~/.config/
alias logan_star="run_starship_handle"        # starship 主题 的一些 功能函数
logan_starship_load=0                         # starship是否加载过

function _theme_judge_load() {
    # theme_if_simple为空时需要代码判断;mac内置终端和jetbrains的终端 不太能支持各种表情和符号 所以需要简单的主题
    if [[ -z "${theme_if_simple}" ]]; then
        theme_if_simple="false" #默认使用多符号主题
        case "$TERM_PROGRAM" in
        "Hyper" | "iTerm.app" | "Tabby" | "WezTerm" | "vscode") theme_if_simple="false" ;;
        "Apple_Terminal" | "Jetbrains") theme_if_simple="true" ;;
        *) theme_if_simple="true" ;;
        esac
    fi

    if [ "$theme_prefer" = "starship" ]; then
        # starship
        OSH_THEME=""
        ZSH_THEME=""
        _om_load
        _starship_load_pre
        _starship_load
    elif [ "$theme_prefer" = "om" ]; then
        # ohmyzsh 或 ohmybash
        OSH_THEME="powerbash10k"
        ZSH_THEME="mydracula"
        _om_load
    fi
}

function _starship_load_pre() {
    if command -v starship >/dev/null 2>&1; then
        # 默认没有值的情况下,在 ~/.config/starship.toml
        if [[ -z "${starship_theme}" ]]; then
            starship_theme="starship"
        fi
        if [[ -z "${starship_simple_theme}" ]]; then
            starship_simple_theme="starship"
        fi
        if [[ -z "${starship_path}" ]]; then
            starship_path="$HOME/.config"
        fi

        if [ "$theme_if_simple" = "true" ]; then
            # 使用简单主题
            export STARSHIP_CONFIG="${starship_path}/${starship_simple_theme}.toml" # 设置主题文件路径
        elif [ "$theme_if_simple" = "false" ]; then
            # 使用多符号主题
            export STARSHIP_CONFIG="${starship_path}/${starship_theme}.toml" # 设置主题文件路径
        fi
    fi
}

# 加载starship
function _starship_load() {
    # 加载
    if [ -n "$BASH_VERSION" ]; then
        eval "$(starship init bash)"
    elif [ -n "$ZSH_VERSION" ]; then
        eval "$(starship init zsh)"
    fi
    logan_starship_load=1
}

function _om_load() {
    # 加载
    if [ -n "$BASH_VERSION" ]; then
        [[ -s "${__PATH_MY_CNF}/bash/omb.sh" ]] && source "${__PATH_MY_CNF}/bash/omb.sh"
    elif [ -n "$ZSH_VERSION" ]; then
        [[ -s "${__PATH_MY_CNF}/zsh/omz.sh" ]] && source "${__PATH_MY_CNF}/zsh/omz.sh"
    fi
}

_theme_judge_load

# 加载自定义主题功能函数
source "${__PATH_MY_CNF}/my-functions/theme_handle.sh"
