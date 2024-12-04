#!/usr/bin/env bash
#
# 脚本名称: install.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux其他工具的安装
# shellcheck disable=SC2317
# 防止直接执行
echo "This script is not meant to be executed directly."
exit 0
return 0

# 安装 fastfetch
mkdir -p "$HOME/software/fastfetch"
wget -P "$HOME/software/fastfetch" https://github.com/fastfetch-cli/fastfetch/releases/download/2.31.0/fastfetch-linux-aarch64.deb
sudo apt update
sudo dpkg -i "$HOME/software/fastfetch/fastfetch-linux-aarch64.deb"
fastfetch --version
which -a fastfetch
git -C "$HOME/Data/Config" pull
