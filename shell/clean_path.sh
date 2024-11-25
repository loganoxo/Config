#!/usr/bin/env bash
#
# 脚本名称: clean_path.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
#
# 描述: $PATH $FPATH 路径去重。

set -eu
# 默认处理 $PATH
target_var="$PATH"
# 判断是否传入参数，默认值为 "path"
if [ "$#" -gt 0 ]; then
    if [ "$1" == "fpath" ]; then
        target_var="$FPATH"
    elif [ "$1" != "path" ]; then
        # Invalid argument. Please use 'path' or 'fpath'.
        exit 0
    fi
fi

# 检查目标变量是否为空
if [ -z "$target_var" ]; then
    exit 0
fi

# 将目标变量转换为数组，以 ":" 分隔
IFS=: read -r -a path_array <<<"$target_var"

# 定义一个新数组用于保存已去重的路径
unique_paths=()

# 遍历路径数组并手动检查是否重复
for p in "${path_array[@]}"; do
    # 跳过空路径
    if [ -z "$p" ]; then
        continue
    fi

    # 检查路径是否在 unique_paths 中
    is_unique=true
    for up in "${unique_paths[@]}"; do
        if [ "$up" == "$p" ]; then
            is_unique=false
            break
        fi
    done

    # 如果路径不在 unique_paths 中，则添加
    if $is_unique; then
        unique_paths+=("$p")
    fi
done

# 将数组重新转换为以 ":" 分隔的字符串
new_path=$(
    IFS=:
    echo "${unique_paths[*]}"
)

echo "$new_path"
