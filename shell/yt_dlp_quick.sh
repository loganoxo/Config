#!/usr/bin/env bash
# 脚本名称: yt_dlp_quick.sh
# 作者: HeQin
# 最后修改时间: 2024-12-08
# 描述: yt-dlp 下载视频的命令简单化

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行

function yt_show() {
    command yt-dlp -F "$@"
}

# 针对 m3u8 等视频的下载
# 下载多个同名视频时,使用 autonumber 加序号, epoch 为信息提取完成时的时间戳
function yt_download() {
    if command -v "aria2c" >/dev/null 2>&1; then
        command yt-dlp --external-downloader aria2c -o "%(autonumber)s-%(title)s-%(epoch)s.%(ext)s" "$@"
    else
        command yt-dlp -o "%(autonumber)s-%(title)s-%(epoch)s.%(ext)s" "$@"
    fi
}

# 针对 b站 youtube 等 视频的下载
function yt_download_best() {
    if command -v "aria2c" >/dev/null 2>&1; then
        command yt-dlp --external-downloader aria2c -f "bestvideo+bestaudio" -o "%(playlist_index)s-%(title)s.%(ext)s" "$@"
    else
        command yt-dlp -f "bestvideo+bestaudio" -o "%(playlist_index)s-%(title)s.%(ext)s" "$@"
    fi
}

function yt_run() {
    if [ "$#" -lt 2 ]; then
        echo -e "   \033[35m args error! \033[0m"
        exit 1
    fi
    local yt_operation="$1"
    # 移除第一个位置参数并让后面的参数依次向左移位
    shift
    case $yt_operation in
    show)
        yt_show "$@"
        ;;
    download)
        yt_download "$@"
        ;;
    best)
        yt_download_best "$@"
        ;;
    *)
        echo -e "   \033[35m operation error! \033[0m"
        ;;
    esac
}

yt_run "$@"
