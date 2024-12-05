#!/usr/bin/env bash
# shellcheck disable=SC2317
# 描述: ffmpeg 的使用
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 防止直接执行
set -eu
echo "This script is not meant to be executed directly."
exit 0
return 0
#################################################  Start  #################################################

# ffmpeg 安装
sudo apt install -y ffmpeg
# 下载 m3u8 视频
ffmpeg -i "https://aa.ww.bb/mixed.m3u8" -c copy -bsf:a aac_adtstoasc output.mp4

#################################################  End  #################################################
