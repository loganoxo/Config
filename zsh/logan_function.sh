########### 此文件只能写函数,不能写具体的设置和执行命令操作 ##############
########### 因为有很多脚本都source了这个文件 #########################

function _logan_if_mac() {
    if [[ "$(uname -s)" == Darwin* ]]; then
        return 0
    else
        return 1
    fi
}

function _logan_if_linux() {
    if [[ "$(uname -s)" == Linux* ]]; then
        return 0
    else
        return 1
    fi
}

function _logan_if_debian() {
    if [[ "$(uname -s)" == Linux* ]]; then
        if grep -qi '^ID=debian' /etc/os-release; then
            return 0
        fi
    fi
    return 1
}

function _logan_if_windows() {
    local uname_out
    uname_out=$(uname -s)
    if grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
        # windows 的 WSL 环境
        return 0
    elif [[ "$uname_out" == CYGWIN* || "$uname_out" == MINGW* || "$uname_out" == MSYS* ]]; then
        # windows 上的 git bash 或 Cygwin 等环境
        return 0
    else
        return 1
    fi
}

function _logan_if_command_exist() {
    command -v "$1" >/dev/null 2>&1
}

function _logan_if_bash() {
    if [ -n "$BASH_VERSION" ]; then
        return 0
    else
        return 1
    fi
}

function _logan_if_zsh() {
    if [ -n "$ZSH_VERSION" ]; then
        return 0
    else
        return 1
    fi
}

# 判断终端环境
function _logan_term_type() {
    if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" ]]; then
        # 通过远程连接操作(SSH)
        echo "ssh"
    elif [[ -n "$DISPLAY" ]]; then
        # 图形化界面中的终端(GUI)
        echo "gui"
    elif [[ "$(tty)" == /dev/tty* ]]; then
        # 本地登录的黑屏终端(虚拟控制台)
        echo "system_console"
    else
        # 无法确定操作方式
        echo "unknown"
    fi
}

# 当前环境是否为交互式终端环境
function _logan_if_interactive() {
    if [[ $- == *i* ]]; then
        return 0
    fi
    return 1
}

# 提示输入
function _logan_for_sure() {
    if [ -z "$1" ]; then
        echo -e "   \033[31m need prompts. \033[0m"
        return 1
    fi

    local choice
    echo -en "   \033[33m $1\033[0m \033[35m(Y|y/n):\033[0m"
    read -r choice </dev/tty
    case "$choice" in
    y | Y)
        return 0
        ;;
    *)
        echo -e "   \033[31m operation cancelled. \033[0m"
        return 1 #脚本停止
        ;;
    esac
}
