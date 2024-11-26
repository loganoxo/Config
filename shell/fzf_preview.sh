#!/usr/bin/env bash

# 定义文件类型的后缀名和对应的描述
image_ext=("*.jpg" "*.JPG" "*.jpeg" "*.JPEG" "*.png" "*.PNG" "*.gif" "*.GIF" "*.bmp" "*.webp" "*.tiff" "*.svg" "*.raw" "*.ico" "*.heif" "*.heic")
audio_ext=("*.mp3" "*.wav" "*.flac" "*.aac" "*.ogg" "*.m4a" "*.wma" "*.opus" "*.alac" "*.aiff" "*.ape")
video_ext=("*.mp4" "*.mkv" "*.avi" "*.mov" "*.wmv" "*.flv" "*.webm" "*.mpeg" "*.mpg" "*.3gp" "*.mpg4" "*.vob" "*.rm" "*.rmvb")
archive_ext=("*.zip" "*.tar" "*.gz" "*.bz2" "*.xz" "*.7z" "*.rar" "*.tar.gz" "*.tar.bz2" "*.tar.xz" "*.cab" "*.iso" "*.dmg" "*.tgz")
exec_ext=("*.exe" "*.app" "*.msi" "*.bat" "*.jar" "*.bin" "*.run" "*.cmd" "*.cgi" "*.psd")
lib_ext=("*.dll" "*.so" "*.dylib" "*.lib")
office_ext=("*.doc" "*.docx" "*.xls" "*.xlsx" "*.ppt" "*.pptx")
iso_ext=("*.iso" "*.img" "*.cue" "*.bin" "*.mdf" "*.nrg")
mobile_ext=("*.apk" "*.ipa" "*.xapk")
db_ext=("*.sqlite" "*.db" "*.mdb" "*.sqlite3")

function logan_fzf_preview() {
    if [ ! -e "$1" ]; then
        # 不存在
        echo ""
    elif [[ -d "$1" ]]; then
        # 为目录
        tree -L 1 -C "$1" ||
            echo "$1" is a directory. 2>/dev/null
    elif [[ -f "$1" ]]; then
        case "$1" in
        *.pdf) echo "pdf文件" ;;
        *.md)
            if command -v glow >/dev/null 2>&1; then
                echo "aaa"
                glow -s dark "$1"
            elif command -v bat >/dev/null 2>&1; then
                bat --style=numbers --color=always --line-range :600 "$1" 2>/dev/null
            else
                cat "$1"
            fi
            ;;
        *)
            for ext in "${image_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "图片文件"
                    return 0
                fi
            done
            for ext in "${audio_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "音频文件"
                    return 0
                fi
            done
            for ext in "${video_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "视频文件"
                    return 0
                fi
            done
            for ext in "${archive_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "压缩文件"
                    return 0
                fi
            done
            for ext in "${exec_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "可执行文件"
                    return 0
                fi
            done
            for ext in "${lib_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "动态库文件"
                    return 0
                fi
            done
            for ext in "${office_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "办公文档"
                    return 0
                fi
            done
            for ext in "${iso_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "光盘镜像文件"
                    return 0
                fi
            done
            for ext in "${mobile_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "移动应用安装包"
                    return 0
                fi
            done
            for ext in "${db_ext[@]}"; do
                if [[ "$1" == $ext ]]; then
                    echo "数据库文件"
                    return 0
                fi
            done

            if command -v bat >/dev/null 2>&1; then
                bat --color=always --line-range :600 "$1" 2>/dev/null # 加--style=numbers会导致没有header,二进制文件的预览出错
                # bat --style=numbers --color=always --line-range :600 "$1" 2>/dev/null
            else
                cat "$1"
            fi
            ;;
        esac
    else
        echo "其他"
    fi
}

logan_fzf_preview "$@"
