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

# 去掉所有原有缩进并重新格式化
awk '
BEGIN { indent_level = 0 }
{
    # 去掉所有行首的空白
    sub(/^[[:space:]]+/, "")

    # 如果包含 "}"，先减缩进
    while ($0 ~ /}/) {
        sub(/}/, "")  # 去掉第一个 "}"
        indent_level--
        printf "%*s}\n", indent_level * 4, ""
    }

    # 打印行内容
    if ($0 != "") {
        printf "%*s%s\n", indent_level * 4, "", $0
    }

    # 如果包含 "{"，增加缩进
    while ($0 ~ /{/) {
        sub(/{/, "")  # 去掉第一个 "{"
        printf "%*s{\n", indent_level * 4, ""
        indent_level++
    }
}
' "$input_file" >"$output_file"

echo "Output written to $output_file"
