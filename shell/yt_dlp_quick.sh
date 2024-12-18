#!/usr/bin/env bash
# 脚本名称: yt_dlp_quick.sh
# 作者: HeQin
# 最后修改时间: 2024-12-08
# 描述: yt-dlp 下载视频的命令简单化

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行

function yt_show() {
    command yt-dlp -F "$1"
}

function yt_download() {
    if command -v "aria2c" >/dev/null 2>&1; then
        command yt-dlp --external-downloader aria2c "$1"
    else
        command yt-dlp "$1"
    fi
}

function yt_download_best() {
    if command -v "aria2c" >/dev/null 2>&1; then
        command yt-dlp --external-downloader aria2c -f "bestvideo+bestaudio" "$1"
    else
        command yt-dlp -f "bestvideo+bestaudio" "$1"
    fi
}

function yt_run() {
    if [ "$#" -ne 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "   \033[35m args error! \033[0m"
        exit 1
    fi
    local yt_operation="$1"
    local yt_url="$2"
    case $yt_operation in
    show)
        yt_show "$yt_url"
        ;;
    download)
        yt_download "$yt_url"
        ;;
    best)
        yt_download_best "$yt_url"
        ;;
    *)
        echo -e "   \033[35m operation error! \033[0m"
        ;;
    esac
}

yt_run "$@"
