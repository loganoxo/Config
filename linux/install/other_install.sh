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
mkdir -p "$HOME/software/fastfetch" && wget -P "$HOME/software/fastfetch" https://github.com/fastfetch-cli/fastfetch/releases/download/2.31.0/fastfetch-linux-aarch64.deb
sudo apt update && sudo dpkg -i "$HOME/software/fastfetch/fastfetch-linux-aarch64.deb"
fastfetch --version && which -a fastfetch
git -C "$HOME/Data/Config" pull

# ssh 连接时,不要打印 系统版本和版权信息
touch "$HOME/.hushlogin"

# ffmpeg 安装
sudo apt install -y ffmpeg
# 下载 m3u8 视频
ffmpeg -i "https://aa.ww.bb/mixed.m3u8" -c copy -bsf:a aac_adtstoasc output.mp4
################################################## End At 2024-12-05 ##################################################

# 安装 open-vm-tools
sudo apt install -y open-vm-tools
################################################## End At 2024-12-06 ##################################################
