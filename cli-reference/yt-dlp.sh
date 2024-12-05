#!/usr/bin/env bash
# shellcheck disable=SC2317
# 描述: yt-dlp 的使用
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 防止直接执行
set -eu
echo "This script is not meant to be executed directly."
exit 0
return 0
#################################################  Start  #################################################

# ffmpeg 安装
uv tool install yt-dlp

################ 简单下载
# 直接下载视频(bilibili 和 youtube 测试通过 )
yt-dlp "https://www.youtube.com/watch?v=example"
# 只下载音频文件
yt-dlp -x --audio-format mp3 "https://www.youtube.com/watch?v=example"
# 使用视频标题作为文件名
yt-dlp -o "%(title)s.%(ext)s" "https://www.youtube.com/watch?v=example"

################ 其他
# 下载视频及其字幕
yt-dlp --write-subs --sub-lang en "https://www.youtube.com/watch?v=example"
# 查看可用的格式,选择视频质量
yt-dlp -F "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 选择指定格式;80 是你通过上面命令获取的格式编号
yt-dlp -f 80 "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 下载整个合集或 UP 主的所有视频
yt-dlp "https://space.bilibili.com/123456/video"
# 下载合集并按序号命名
yt-dlp -o "%(playlist_index)s - %(title)s.%(ext)s" "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 跳过已下载文件;避免重复下载
yt-dlp -i "https://www.bilibili.com/video/BV1xx4y1t7xx"

################ 按条件下载
# 查看可用的格式和编号
yt-dlp -F "https://www.bilibili.com/video/BVxxxxxx"
# 目标格式没有音频（通常是 DASH 流分离了音视频, 像youtube的8k视频）,可以下载指定分辨率的视频流和音频流,然后让 yt-dlp 自动合并
# 如果视频和音频是分离的,可以通过这个命令自动合并; 如: 127 是视频的格式编号; 222 是音频的格式编号
yt-dlp -f "127+222" "https://www.bilibili.com/video/BVxxxxxx"
# 自动选择包含视频和音频的最佳格式;
yt-dlp -f "best" "https://www.youtube.com/watch?v=xxxxxxx"
# 如果视频和音频分开存储(如 DASH 流媒体), 这条命令会自动下载最佳的视频和音频并合并
yt-dlp -f "bestvideo+bestaudio" "https://www.youtube.com/watch?v=xxxxxxx"
# 限制视频分辨率,并确保带音频,这会选择小于或等于 720p 的最佳视频流和音频流,并自动合并
yt-dlp -f "bestvideo[height<=720]+bestaudio" "https://www.youtube.com/watch?v=xxxxxxx"
# 这种方法会直接选择包含音频的单一流,避免合并步骤
yt-dlp -f "best[height<=480]" "https://www.youtube.com/watch?v=xxxxxxx"

################ 指定 cookie
# 指定 Cookies 文件, 在 yt-dlp 中,可以使用浏览器的登录状态(例如 Cookies)来绕过某些限制或访问会员专属内容
yt-dlp --cookies cookies.txt "https://www.bilibili.com/video/BVxxxxxx"
# yt-dlp 支持直接从浏览器中加载 Cookies(无需导出)
yt-dlp --cookies-from-browser chrome "https://www.bilibili.com/video/BVxxxxxx"

#################################################  End  #################################################
