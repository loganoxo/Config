#!/usr/bin/env bash
# 脚本名称: yt_dlp_quick.sh
# 作者: HeQin
# 最后修改时间: 2024-12-08
# 描述: yt-dlp 下载视频的命令简单化

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行

function yt_show() {
    command yt-dlp -F "$@"
}

function yt_download() {
    if command -v "aria2c" >/dev/null 2>&1; then
        command yt-dlp --external-downloader aria2c -o "%(title)s-%(timestamp)s.%(ext)s" "$@"
    else
        command yt-dlp -o "%(title)s-%(timestamp)s.%(ext)s" "$@"
    fi
}

function yt_download_best() {
    if command -v "aria2c" >/dev/null 2>&1; then
        command yt-dlp --external-downloader aria2c -f "bestvideo+bestaudio" -o "%(title)s.%(ext)s" "$@"
    else
        command yt-dlp -f "bestvideo+bestaudio" -o "%(title)s.%(ext)s" "$@"
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
