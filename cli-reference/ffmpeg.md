# ffmpeg

## 一、安装

```shell
# ffmpeg 安装
sudo apt install -y ffmpeg
# 查看文件信息
ffmpeg -i aaa.mp4
# 隐藏 ffmpeg 的版本信息和库的详细配置; 我写在alias里面了
ffmpeg -hide_banner -i aaa.mp4
```

## 二、下载视频

```shell
# 下载 m3u8 视频,不重新编码
ffmpeg -hide_banner -i "https://vip.ffzy-play7.com/20230501/23679_393f1ee4/2000k/hls/mixed.m3u8" -c copy -bsf:a aac_adtstoasc output.mp4
# 有的网站不允许直接访问 m3u8 文件, 所以需要使用 headers; 这里用了重新编码
ffmpeg -headers "Referer: https://tv.cctv.com/" \
    -i "https://dh5.cntv.qcloudcdn.com/asp/h5e/hls/4000/0303000a/3/default/fe1b5738af444920954477dcdaf0001d/4000.m3u8" \
    -c:v libx264 -c:a aac -bsf:a aac_adtstoasc output.mp4

```

## 三、 视频/音频 处理

```shell

# 用 ffmpeg 转换 视频格式
ffmpeg -hide_banner -i aaa.mp4 -c copy aaa.mkv # 不重新编码
ffmpeg -hide_banner -i aaa.mp4 copy aaa.mkv    # 重新编码,兼容性更好,但是慢一点
# 将视频分辨率调整为 1280x720
ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4
# 压缩视频;-b:v:设置视频比特率(如 1000kbps)
ffmpeg -i input.mp4 -b:v 1000k output.mp4
# 降低音频比特率;-b:a:设置音频比特率(如 128kbps)
ffmpeg -i input.mp4 -b:a 128k output.mp4
# 截取视频片段;-ss:开始时间; -t:持续时间/秒; -c copy:无重新编码,快速截取
ffmpeg -i input.mp4 -ss 00:01:30 -t 10 -c copy output.mp4
# 截取 长度 10分钟10秒
ffmpeg -i input.mp4 -ss 00:01:30 -t 00:10:10 -c copy output.mp4
# 添加字幕
ffmpeg -i input.mp4 -vf subtitles=aaa.srt output.mp4
# 视频转为 GIF; fps=10:设置帧率为 10; scale=320:-1:宽度为 320,高度自动调整
ffmpeg -i input.mp4 -vf "fps=10,scale=320:-1" output.gif
# 添加(图片)水印;位置在右下角;overlay=W-w-10:H-h-10:水印距离右下角 10 像素
ffmpeg -i input.mp4 -i aaa.png -filter_complex "overlay=W-w-10:H-h-10" output.mp4
# 每秒提取一帧图片; 生成的图片按序号命名:frame_001.png, frame_002.png 等
ffmpeg -i input.mp4 -vf fps=1 frame_%03d.png
# 调整视频速度
ffmpeg -i input.mp4 -vf "setpts=0.5*PTS" output.mp4 # 加快视频播放速度(2 倍)
ffmpeg -i input.mp4 -vf "setpts=2.0*PTS" output.mp4 # 减慢视频播放速度(0.5 倍)
# 加快音频速度;使用 ffmpeg 的 atempo 滤镜。atempo 用于调整音频速度,适用于调整速度范围在 0.5 到 2.0 倍之间。如果需要超过这个范围,可以多次使用该滤镜
ffmpeg -i input.mp4 -filter:a "atempo=1.5" -c:v copy output.mp4
# 加快音频速度超过 2.0 倍; 如4倍
ffmpeg -i input.mp4 -filter:a "atempo=2.0,atempo=2.0" -c:v copy output.mp4
# 将 MP3 转换为 AAC
ffmpeg -i input.mp3 -c:a aac output.aac
# 提取视频中的音频并保存为 MP3; -vn:去掉视频流,仅保留音频
ffmpeg -i input.mp4 -vn -c:a libmp3lame output.mp3
# 去除音频;-an:去掉音频流
ffmpeg -i input.mp4 -an output.mp4
# 合并音频和视频
ffmpeg -i video.mp4 -i audio.mp3 -c:v copy -c:a aac output.mp4
# 调整音量;将音量增大 50%
ffmpeg -i input.mp3 -filter:a "volume=1.5" output.mp3

# 合并多个视频
# 如果多个视频的编码格式、分辨率或音频参数不同,需要重新编码
# concat:video1.mp4|video2.mp4|video3.mp4:将多个视频顺序拼接。
# -c:v libx264:指定视频编码器为 H.264。
# -crf 23:控制质量,值越小质量越高(建议范围 18-28)。
# -preset fast:编码速度和压缩率的平衡点。
# -c:a aac:音频编码器为 AAC。
# -b:a 192k:音频比特率。
ffmpeg -i "concat:video1.mp4|video2.mp4|video3.mp4" -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 192k output.mp4
# 如果多个视频格式相同(编码、分辨率、帧率、音频参数一致),可以直接使用 concat 协议进行合并
ffmpeg -i "concat:video1.mp4|video2.mp4|video3.mp4" -c copy output.mp4

# 推荐方式:转为中间格式 .ts 再拼接
ffmpeg -i video1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp1.ts
ffmpeg -i video2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp2.ts
ffmpeg -i "concat:temp1.ts|temp2.ts" -c copy -bsf:a aac_adtstoasc output.mp4 # 合并 .ts 文件

# 还可以把文件名写在文件中
# 创建文件列表 filelist.txt,格式为
# file 'video1.mp4'
# file 'video2.mp4'
# file 'video3.mp4'
ffmpeg -f concat -safe 0 -i filelist.txt -c copy output.mp4
```
