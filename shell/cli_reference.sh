#!/usr/bin/env bash
# 脚本名称: cli_reference.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: 用 glow 查看 cli-reference

set -e #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行

source "$HOME/.zshenv"
source "${__PATH_MY_CNF}/zsh/logan_function.sh"
source "${__PATH_MY_CNF}/my-functions/a2_fzf.sh"
source "${__PATH_MY_CNF}/shell/public_shell_function.sh"
# shellcheck disable=SC2034
FZF_FD_EXCLUDE_OPTS="{.git,.mvn,.idea,.vscode,.sass-cache,node_modules,.DS_Store,.obsidian,1-obsidian} "

function logan_glow_cli_reference() {
    cd "${__PATH_MY_CNF}/cli-reference"
    glow -p -s dark -w 0
}

function logan_bat_cli_reference() {
    local file_path
    file_path=$(ffp "${__PATH_MY_CNF}/cli-reference" "")
    bat --style="${BAT_STYLE:-numbers}" --color=always --line-range :600 --paging=always -- "$file_path"
}

function logan_bat_common_alias() {
    local file_path="${__PATH_MY_CNF}/zsh/common_alias.sh"
    bat --style="${BAT_STYLE:-numbers}" --color=always --line-range :600 --paging=always -- "$file_path"
}

function logan_glr() {
    echo1="\033[35m[ 1 ]\033[0m glow cli-reference \n"
    echo2="\033[35m[ 2 ]\033[0m bat cli-reference \n"
    echo2="\033[35m[ 3 ]\033[0m bat common_alias \n"
    echo3="\033[35m[ 4 ]\033[0m Exit.\n"
    echo -e "$echo1$echo2$echo3"
    local choice
    echo -en "\033[33m Input your choice:"
    read -r choice </dev/tty
    case $choice in
    1)
        logan_glow_cli_reference
        ;;
    2)
        logan_bat_cli_reference
        ;;
    3)
        logan_bat_common_alias
        ;;
    *)
        echo -e "\033[36m skip. \033[0m"
        return
        ;;
    esac
}

logan_glr "$@"
