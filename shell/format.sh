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

# 去掉所有原有缩进并重新格式化，同时保留空行
awk '
BEGIN { indent_level = 0 }
{
    # 如果是空行，直接输出
    if ($0 == "") {
        print ""
        next
    }

    # 去掉行首多余空白
    sub(/^[[:space:]]+/, "")

    # 处理当前行中的所有字符
    while (match($0, /[{]|[}]/)) {
        match_index = RSTART
        match_char = substr($0, match_index, RLENGTH)

        if (match_char == "{") {
            # 输出匹配字符前的内容并保留 { 在当前行
            printf "%*s%s {\n", indent_level * 4, "", substr($0, 1, match_index - 1)
            indent_level++
        } else if (match_char == "}") {
            indent_level--
            # 输出匹配字符前的内容并保留 } 在当前行
            printf "%*s%s\n", indent_level * 4, "", substr($0, 1, match_index - 1) "}"
        }

        # 更新剩余内容
        $0 = substr($0, match_index + RLENGTH)
    }

    # 如果行中还有剩余内容，按当前缩进输出
    if ($0 != "") {
        printf "%*s%s\n", indent_level * 4, "", $0
    }
}
' "$input_file" >"$output_file"

echo "Output written to $output_file"
