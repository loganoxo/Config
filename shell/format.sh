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

# 调整缩进: 将 {} 之间的内容每层缩进 4 个空格
awk '
{
    for (i = 1; i <= NF; i++) {
        if ($i == "{") {
            indent_level++
        }
        if ($i == "}") {
            indent_level--
        }
    }

    # 输出缩进后的内容
    if (indent_level > 0) {
        printf "%s\n", gensub(/^/, sprintf("%*s", indent_level * 4, ""), 1)
    } else {
        print
    }
}
' "$input_file" >"$output_file"

echo "Output written to $output_file"
