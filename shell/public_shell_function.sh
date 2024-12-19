#!/usr/bin/env bash
# 脚本名称: public_shell_function.sh.sh
# 作者: HeQin
# 最后修改时间: 2024-12-08
# 描述: 公共的给shell脚本使用的函数,与zshrc或bashrc解偶;

# 获取绝对路径; 有些环境的cd命令会自动打印一行当前目录的数据,所以写在脚本里,而不是zshrc/bashrc中
function get_home_relative_path_func() {
    local the_path="$1"
    local absolute_path
    if [ ! -e "$the_path" ]; then
        echo -e "   \033[35m Path '$the_path' does not exist! \033[0m"
        return 1
    fi

    if [ -d "$the_path" ]; then
        absolute_path="$(cd "$the_path" 2>/dev/null && pwd)"
    else
        local dir_path base_name
        dir_path="$(cd "$(dirname "$the_path")" && pwd)"
        base_name="$(basename "$the_path")"
        if [ "$dir_path" = "/" ]; then
            dir_path=""
        fi
        absolute_path="$dir_path/$base_name"
    fi
    echo "$absolute_path"
}
