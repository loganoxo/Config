# yt-dlp

- 自己配置的 alias:
    - `yts <URLs>`  # 显示可下载的视频源
    - `ytb <URLs>`  # 用ariac(如果有的话)下载最佳视频和音频
    - `ytd <URLs>`  # 用ariac(如果有的话)下载m3u8视频

## 一、安装

```shell
# yt-dlp 安装
uv tool install yt-dlp
```

## 二、简单下载

```shell
# 直接下载视频(bilibili 和 youtube 测试通过 )
yt-dlp "https://www.youtube.com/watch?v=example"
# 只下载音频文件
yt-dlp -x --audio-format mp3 "https://www.youtube.com/watch?v=example"
# 使用视频标题作为文件名
yt-dlp -o "%(title)s.%(ext)s" "https://www.youtube.com/watch?v=example"
# 查看可用的格式和编号
yt-dlp -F "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 选择指定格式;30032 是你通过上面命令获取的格式编号
yt-dlp -f 30032 "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 假设 -F 中显示的视频格式都是 mp4, 但是我要的是 mkv,那么可以转换
yt-dlp -f 30032 -o "aaa.%(ext)s" --remux-video mkv "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 或者用 ffmpeg 转换
ffmpeg -i aaa.mp4 -c copy aaa.mkv
```

## 四、按条件下载

```shell
# 目标格式没有音频(通常是 DASH 流分离了音视频, 像youtube的8k视频),可以下载指定分辨率的视频流和音频流,然后让 yt-dlp 自动合并
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
```

## 五、指定 cookie 和 header

```shell
# 指定 Cookies 文件, 在 yt-dlp 中,可以使用浏览器的登录状态(例如 Cookies)来绕过某些限制或访问会员专属内容
yt-dlp --cookies cookies.txt "https://www.bilibili.com/video/BVxxxxxx"
# yt-dlp 支持直接从浏览器中加载 Cookies(无需导出)
yt-dlp --cookies-from-browser chrome "https://www.bilibili.com/video/BVxxxxxx"

# 有的网站不允许直接下载, 所以需要使用 headers
yt-dlp \
    --add-headers "Referer:https://tv.cctv.com/" \
    -o "a.%(ext)s" "https://dh5.cntv.qcloudcdn.com/asp/h5e/hls/4000/0303000a/3/default/fe1b5738af444920954477dcdaf0001d/4000.m3u8"

```

## 六、指定使用 aria2 多线程下载

```shell
# yt-dlp在使用aria2时加了 --no-conf 参数,所以我们用不了自己的配置文件,所有aria2的配置需要用 --external-downloader-args 传过去
# 经测试,即便是:  --external-downloader-args "aria2c:--conf-path=$HOME/.aria2/aria2.conf"  这样也不能用到自己的配置文件
yt-dlp --external-downloader aria2c "https://www.bilibili.com/video/BVxxxxxx"
# -c: 启用断点续传
yt-dlp --external-downloader aria2c --external-downloader-args "aria2c:-c" "https://www.bilibili.com/video/BVxxxxxx"
# -x 16: 设置每个下载任务与单个服务器建立的最大连接数为16; -k 1M: 每个分片大小为 1 MB; -s 16: 指定分片数量
yt-dlp --external-downloader aria2c --external-downloader-args "aria2c:-x 16 -k 1M -s 16" "https://www.bilibili.com/video/BVxxxxxx"

```

## 七、记录下载时间

```shell
# time <command>, 多个命令需要用 ( ) 包裹,最好有空格和括号分开,若没有空格,粘贴到iterm2中时右括号会被转译;但是代码格式化时会删空格,就挺冲突的
# 所以就不要括号了,反正我这里只是一个命令
time yt-dlp "https://www.bilibili.com/video/BVxxxxxx"
```

## 八、其他

```shell
# 查看 yt-dlp 支持的网站列表
# https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md
# 用命令查看
yt-dlp --list-extractors
yt-dlp --list-extractors | grep -i "bilibili"

# 下载视频及其字幕
yt-dlp --write-subs --sub-lang en "https://www.youtube.com/watch?v=example"
# 下载整个合集或 UP 主的所有视频
yt-dlp "https://space.bilibili.com/123456/video"
# 下载合集并按序号命名
yt-dlp -o "%(playlist_index)s - %(title)s.%(ext)s" "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 跳过已下载文件;避免重复下载
yt-dlp -i "https://www.bilibili.com/video/BV1xx4y1t7xx"
# 下载多个同名视频时,使用 autonumber 加序号, epoch 为信息提取完成时的时间戳
yt-dlp -o "%(autonumber)s-%(title)s-%(epoch)s.%(ext)s" "url1" "url2" "url3"

```
