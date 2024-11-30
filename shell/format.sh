#!/bin/bash

# 检查是否提供文件名
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

input_file="$1"

# 检查文件是否存在
if [ ! -f "$input_file" ]; then
    echo "Error: File not found!"
    exit 1
fi

# 获取文件后缀名
extension="${input_file##*.}"

# 定义输出文件名
output_file="out.$extension"

# 调整缩进
awk '
BEGIN { indent_level = 0 }
{
    # 删除行首的空白
    sub(/^[[:space:]]*/, "")

    # 如果是 "}" 行，先减缩进
    if ($0 ~ /^}/) {
        indent_level--
    }

    # 打印当前行，添加缩进
    printf "%*s%s\n", indent_level * 4, "", $0

    # 如果是 "{" 行，增加缩进
    if ($0 ~ /{$/) {
        indent_level++
    }
}
' "$input_file" >"$output_file"

echo "Output written to $output_file"
