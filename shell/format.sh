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
    # 去掉行首多余空白
    sub(/^[[:space:]]+/, "")

    # 处理当前行中的所有字符
    while (match($0, /[{]|[}]/)) {
        match_index = RSTART
        match_char = substr($0, match_index, RLENGTH)

        if (match_char == "{") {
            # 输出匹配字符前的内容
            printf "%*s%s{\n", indent_level * 4, "", substr($0, 1, match_index)
            indent_level++
        } else if (match_char == "}") {
            indent_level--
            # 输出匹配字符前的内容，并将 } 保留在当前行
            printf "%*s%s\n", indent_level * 4, "", substr($0, 1, match_index)
        }

        # 剩余内容继续处理
        $0 = substr($0, match_index + RLENGTH)
    }

    # 输出剩余行内容
    if ($0 != "") {
        printf "%*s%s\n", indent_level * 4, "", $0
    }
}
' "$input_file" >"$output_file"

echo "Output written to $output_file"
