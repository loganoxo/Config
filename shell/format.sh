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

    # 遍历当前行的每个字符，逐一处理 { 和 }
    for (i = 1; i <= length($0); i++) {
        char = substr($0, i, 1)

        if (char == "{") {
            # 输出当前行之前的内容
            if (i > 1) {
                printf "%*s%s\n", indent_level * 4, "", substr($0, 1, i - 1)
            }
            # 输出 { 并增加缩进
            printf "%*s{\n", indent_level * 4, ""
            indent_level++
            $0 = substr($0, i + 1)
            i = 0
        } else if (char == "}") {
            # 减少缩进并输出 }
            indent_level--
            printf "%*s}\n", indent_level * 4, ""
            $0 = substr($0, i + 1)
            i = 0
        }
    }

    # 如果剩余行内容不是空，则按照当前缩进输出
    if ($0 != "") {
        printf "%*s%s\n", indent_level * 4, "", $0
    }
}
' "$input_file" >"$output_file"

echo "Output written to $output_file"
