#!/usr/bin/env bash
# 创建root用户的环境配置文件,使用方式:
# sudo bash ./create_root_files.sh "/home/helq"
set -eu

common_home="$1"
# 定义模板路径和目标目录
template_file="template.sh"
target_dir="/root"
header_line="_common_home_for_root=\"$common_home\""

function _logan_if_mac() {
    if [[ "$(uname -s)" == Darwin* ]]; then
        return 0
    else
        return 1
    fi
}

function _logan_if_linux() {
    if [[ "$(uname -s)" == Linux* ]]; then
        return 0
    else
        return 1
    fi
}

if [ -z "$common_home" ]; then
    echo "需要参数"
    exit 1
fi

if [ ! -d "$common_home" ]; then
    echo "参数应该是一个目录"
    exit 1
fi

if _logan_if_mac; then
    echo "mac 不能执行"
    exit 1
fi

if ! _logan_if_linux; then
    echo "当前非linux系统, 不能执行"
    exit 1
fi

if [ ! -d "$target_dir" ]; then
    echo " $target_dir 目录不存在"
    exit 1
fi

# 定义需要复制的目标文件列表
files=(".bashrc" ".bash_profile" ".zshrc" ".zprofile")

# 备份
timestamp=$(date +%Y%m%d%H%M%S)
backup_dir="$target_dir/.shell_bak/$timestamp/"
mkdir "$backup_dir"
for file in "${files[@]}"; do
    original_file="$target_dir/$file"
    if [ -f "$original_file" ]; then
        mv "$original_file" "$backup_dir"
        echo " $original_file 已备份到 $backup_dir "
    fi
done

# 确保模板文件存在
if [[ ! -f "$template_file" ]]; then
    echo "Template file $template_file does not exist."
    exit 1
fi

# 遍历文件列表，依次复制并添加头部信息
for file in "${files[@]}"; do
    target_file="$target_dir/$file"
    {
        echo "$header_line"
        cat "$template_file"
    } >"$target_file"
    echo "Created $target_file with added header."
done

echo "All files have been created successfully."
