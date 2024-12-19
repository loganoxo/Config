#!/usr/bin/env bash
# 脚本名称: fcp.sh
# 作者: HeQin
# 最后修改时间: 2024-12-08
# 描述: 复制文件或文件夹的地址
# 有些环境的cd命令会自动打印一行当前目录的数据,所以写在脚本里,而不是zshrc/bashrc中

set -e #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行

source "$HOME/.zshenv"
source "${__PATH_MY_CNF}/zsh/logan_function.sh"
source "${__PATH_MY_CNF}/my-functions/a2_fzf.sh"
source "${__PATH_MY_CNF}/shell/public_shell_function.sh"

# 复制文件或文件夹的地址
# fcp               直接在当前目录下搜索
# fcp .             直接复制当前目录路径
# fcp <file>        如果文件不存在,则通过fzf在当前目录下搜索;若存在则直接复制
# fcp <dir>         如果目录已存在,则直接复制并打印,如果不存在则在当前目录搜索
# fcp <dir>/        如果以/结尾的已存在的目录,则在<dir>目录下打开fzf搜索
function logan_fcp() {
    local fcp_path="$1"
    local absolute_path
    local copy_path
    local if_fzf=0
    # 判断是否以/结尾,用fzf搜索这个目录的内容
    if [[ "$fcp_path" == */ ]]; then
        if_fzf=1
    fi

    # 如果没有传参,或者传参的path不存在,则直接通过fzf搜索
    if [ -z "$fcp_path" ] || [ ! -e "$fcp_path" ]; then
        absolute_path=$(logan_get_home_relative_path ".")
        copy_path=$(ffp "$absolute_path" "$fcp_path")
    else
        # fcp . 直接复制当前目录
        if [ "$fcp_path" = "." ]; then
            if ! absolute_path=$(logan_get_home_relative_path "$fcp_path"); then
                echo -e "   \033[35m Failed to get absolute path for '$fcp_path'! \033[0m"
                return 1
            fi
            copy_path="$absolute_path"
        else
            if ! absolute_path=$(logan_get_home_relative_path "$fcp_path"); then
                echo -e "   \033[35m Failed to get absolute path for '$fcp_path'! \033[0m"
                return 1
            fi

            if [ ! -e "$absolute_path" ]; then
                echo -e "   \033[35m Path $absolute_path does not exist! \033[0m"
                return 1
            fi

            if [ -f "$absolute_path" ]; then
                copy_path="$absolute_path"
            elif [ -d "$absolute_path" ]; then
                if [ "$if_fzf" -eq 1 ]; then
                    copy_path=$(ffp "$absolute_path" "")
                else
                    copy_path="$absolute_path"
                fi
            fi
        fi
    fi

    copy_path=$(logan_get_home_relative_path "$copy_path")
    if [ ! -e "$copy_path" ]; then
        echo -e "   \033[35m copy_path is error, skip! \033[0m"
        return 1
    fi

    # 替换主目录为 $HOME
    copy_path="\"${copy_path/#$HOME/\$HOME}\""
    echo ""
    echo -n "      $copy_path      "
    if _logan_if_command_exist "pbcopy"; then
        echo -n "$copy_path" | pbcopy
        echo -e "\033[35m Already copied! \033[0m"
    fi
    echo ""
    return 0
}

logan_fcp "$@"
