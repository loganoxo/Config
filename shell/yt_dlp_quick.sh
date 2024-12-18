#!/usr/bin/env bash
# 脚本名称: yt_dlp_quick.sh
# 作者: HeQin
# 最后修改时间: 2024-12-08
# 描述: yt-dlp 下载视频的命令简单化

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行
function yt_run() {
    if [ "$#" -ne 2 ]; then
        echo -e "   \033[35m 参数错误! \033[0m"
        return 1
    fi
}
function yt_show() {

}
function yt_download() {

}

dlp_run $@
