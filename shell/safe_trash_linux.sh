#!/usr/bin/env bash
# 脚本名称: safe_trash.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: 安全删除文件或文件夹到废纸篓;针对于linux系统

#   trash-cli https://github.com/andreafrancia/trash-cli
#   trash-put   <file/directory>                # trash files and directories.
#   trash-empty                                 # 从垃圾箱中删除所有文件
#   trash-empty <days>                          # 仅删除已删除时间超过 <days> 的文件
#   trash-list | grep <path>                    # list trashed files.
#   trash-restore                               # 选择文件进行恢复, 若要覆盖同名文件则 加 --overwrite
#   trash-rm \*.o                               # 从垃圾箱中删除与模式匹配的文件
#   从 home 分区回收的文件将被移动到此处 ~/.local/share/Trash/

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行

CURRENT_DIR="$(pwd)" # 执行命令的当前目录;用source命令加载函数时也可以使用"$(cd "$(dirname "$0")";pwd)"
ABSOLUTE_PATH=()     # 绝对路径

# 校验
function _safe_delete_validate() {
    #  echo "_safe_delete_validate:$*"
    local important_paths=(
        "/" "/Applications" "/home" "/bin" "/cores" "/etc" "/Library"
        "/dev" "/opt" "/private" "/sbin" "/System" "/Users" "/usr" "/var"
        "$HOME" "$HOME/Applications" "$HOME/Data" "$HOME/Desktop" "$HOME/Documents" "$HOME/Downloads"
        "$HOME/Library" "$HOME/Logs" "$HOME/Movies" "$HOME/Music" "$HOME/OrbStack" "$HOME/Pictures"
        "$HOME/Public" "$HOME/Temp" "$HOME/TempCode" "$HOME/Virtual Machines.localized"
        "$HOME/Data/AappInstallMac" "$HOME/Data/Config" "$HOME/Data/Docker" "$HOME/Data/Parallels" "$HOME/Data/Software"
        "$HOME/Documents/Articles" "$HOME/Documents/BackupExclude" "$HOME/Documents/Blog" "$HOME/Documents/CloudFiles"
        "$HOME/Documents/Code" "$HOME/Documents/Files" "$HOME/Documents/Important" "$HOME/Documents/Larian Studios"
        "$HOME/Documents/Note" "$HOME/Documents/Technology" "$HOME/Library/Application Support"
    )

    # 检查输入参数是否为空
    if [ $# -eq 0 ]; then
        echo "!!!error: not trash, need argument"
        return 1
    fi

    # 预先判断
    for item in "$@"; do
        if [[ "$item" == "~" || "$item" == "/" || "$item" == -* || "$item" == */-* || "$item" == "." || "$item" == "\\" ]]; then
            # 如果条件满足，执行相应的操作
            echo "!!!error: not trash, $item --Character illegal ."
            return 1
        fi
    done

    for item in "$@"; do
        # 校验非法字符
        if ! _validate_illegal_character "$item"; then
            # 校验失败
            return 1
        fi

        if [ ! -e "$item" ]; then
            # 文件或目录不存在
            echo "!!!error: not trash, $item does not exist."
            continue
        fi

        # 获取绝对路径
        absolute_item=$(_get_absolute_path "$item")
        if [ -d "$absolute_item" ]; then
            # 如果是目录
            parent_path="$(dirname -- "$absolute_item")"
            if [ "$parent_path" = "$HOME" ] || [ "$parent_path" = "/" ]; then
                # home和/目录下的文件夹不能删除
                echo "!!!error: not trash, The folders in ' $parent_path ' cannot be trash ."
                return 1
            fi
        else
            # 如果是文件
            name=$(basename -- "$absolute_item") #去除前面所有目录，到最后一个/截止
            if [[ "$name" == "~" || "$name" == "/" || "$name" == -* || "$name" == "." || "$item" == "\\" ]]; then
                echo "!!!error: not trash, $name --Character illegal ."
                return 1
            fi
        fi

        # 判断important_paths
        if [ -d "$absolute_item" ]; then
            # 如果是目录
            for important_path in "${important_paths[@]}"; do
                if [ "$absolute_item" = "$important_path" ] || [ "$absolute_item" = "$important_path/" ]; then
                    # important_paths中定义的目录都不能删除
                    echo "!!!error: not trash, $important_path is an important path ."
                    return 1
                fi
            done
        fi
        ABSOLUTE_PATH+=("$absolute_item") # 校验通过,加入数组
    done

    return 0 #校验成功
}

# 校验非法字符
function _validate_illegal_character() {
    local str="$1"
    # 定义非法字符集合
    for ((i = 0; i < ${#str}; i++)); do
        char="${str:$i:1}"
        # 检查字符是否在非法字符集合中  \[\]|:;@\'。
        if [[ "$char" =~ [\\～\!\`\"\',?%^\&*()+={}|:\;@] || "$char" == "]" || "$char" == "[" ]]; then
            echo "!!!error: not trash, Illegal character '$char' found in '$item'."
            return 1 # 执行失败，返回非零值
        fi
    done
}

# 获取文件或文件夹绝对路径
# 默认pwd只会显示逻辑目录,就是说针对于软链接的目录,不会显示原始真实存在的那个目录; pwd -P 才能显示原始目录
function _get_absolute_path() {
    if [ -d "$1" ]; then
        # 如果是目录
        echo -n "$(cd -- "$1" && pwd)"
    else
        # 如果是文件
        echo -n "$(cd -- "$(dirname -- "$1")" && pwd)/$(basename -- "$1")"
    fi
}

function _safe_trash_run() {
    if [ "$#" -lt 1 ]; then
        echo -e "   \033[35m args error! \033[0m"
        exit 1
    fi

    # 判断是否有 -f
    local force="false"
    if [ "$#" -gt 1 ]; then
        local _safe_trash_operation="$1"
        if [ "$_safe_trash_operation" = "-f" ]; then
            force="true"
            # 移除第一个位置参数并让后面的参数依次向左移位
            shift
        fi
    fi

    # 校验
    if ! _safe_delete_validate "$@"; then
        # 校验失败
        return 1
    fi

    # 执行删除前的确认
    echo -e "CWD:    \033[31m '$CURRENT_DIR' \033[0m"
    for item in "${ABSOLUTE_PATH[@]}"; do
        if [ "$force" = "true" ]; then
            trash-put "$item"
            echo -e "\033[31m'$item'\033[0m has been moved.  ✅ success "
        else
            echo -en "Confirm? \033[31m'$item'\033[0m will be moved. (y/n): "
            read -r -n 1 choice # -n 1 等待一个字符输入，不需要回车
            case "$choice" in
            y | Y)
                trash-put "$item"
                echo "   ✅ success"
                ;;
            *) echo "   ❌ cancel" ;;
            esac
            echo ""
        fi
    done
}

_safe_trash_run "$@"
