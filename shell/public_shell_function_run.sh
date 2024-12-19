#!/usr/bin/env bash
# 脚本名称: public_shell_function_run.sh
# 作者: HeQin
# 最后修改时间: 2024-12-08
# 描述: 调用 public_shell_function.sh 里的函数,暴露给alias使用

set -e
source "${__PATH_MY_CNF}/shell/public_shell_function.sh"

function logan_public_shell_function_run() {
    local my_shell_function="$1"
    if [ -z "$my_shell_function" ]; then
        return 1
    fi
    shift # 移除第一个参数，保留其余参数

    case $my_shell_function in
    logan_get_home_relative_path)
        logan_get_home_relative_path "$@"
        ;;
    esac
    return
}

logan_public_shell_function_run "$@"
