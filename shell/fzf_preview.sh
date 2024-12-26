#!/usr/bin/env bash

if [ -r "${__PATH_MY_CNF}/zsh/logan_function.sh" ]; then
    source "${__PATH_MY_CNF}/zsh/logan_function.sh"
fi

# 定义文件类型的后缀名和对应的描述
_logan_image_ext=("*.jpg" "*.JPG" "*.jpeg" "*.JPEG" "*.png" "*.PNG" "*.gif" "*.GIF" "*.bmp" "*.webp" "*.tiff" "*.svg" "*.raw" "*.ico" "*.heif" "*.heic")
_logan_audio_ext=("*.mp3" "*.wav" "*.flac" "*.aac" "*.ogg" "*.m4a" "*.wma" "*.opus" "*.alac" "*.aiff" "*.ape")
_logan_video_ext=("*.mp4" "*.mkv" "*.avi" "*.mov" "*.wmv" "*.flv" "*.webm" "*.mpeg" "*.mpg" "*.3gp" "*.mpg4" "*.vob" "*.rm" "*.rmvb")
_logan_archive_ext=("*.zip" "*.tar" "*.gz" "*.bz2" "*.xz" "*.7z" "*.rar" "*.tar.gz" "*.tar.bz2" "*.tar.xz" "*.cab" "*.iso" "*.dmg" "*.tgz")
_logan_exec_ext=("*.exe" "*.app" "*.msi" "*.bat" "*.jar" "*.bin" "*.run" "*.cmd" "*.cgi" "*.psd")
_logan_lib_ext=("*.dll" "*.so" "*.dylib" "*.lib")
_logan_office_ext=("*.doc" "*.docx" "*.xls" "*.xlsx" "*.ppt" "*.pptx")
_logan_iso_ext=("*.iso" "*.img" "*.cue" "*.bin" "*.mdf" "*.nrg")
_logan_mobile_ext=("*.apk" "*.ipa" "*.xapk")
_logan_db_ext=("*.sqlite" "*.db" "*.mdb" "*.sqlite3")

function bat_cat() {
    local batname
    # Sometimes bat is installed as batcat.
    if _logan_if_command_exist "batcat"; then
        batname="batcat"
    elif _logan_if_command_exist "bat"; then
        batname="bat"
    else
        cat "$1"
        return
    fi
    ${batname} --style="${BAT_STYLE:-numbers}" --color=always --line-range :600 --paging=never -- "$1" 2>/dev/null
}

function image_cat() {
    dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
    if [[ $dim = x ]]; then
        dim=$(stty size </dev/tty | awk '{print $2 "x" $1}')
    elif ! [[ $KITTY_WINDOW_ID ]] && ((FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size </dev/tty | awk '{print $1}'))); then
        # Avoid scrolling issue when the Sixel image touches the bottom of the screen
        # * https://github.com/junegunn/fzf/issues/2544
        dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
    fi

    # 1. Use kitty icat on kitty terminal
    if [[ $KITTY_WINDOW_ID ]]; then
        # 1. 'memory' is the fastest option but if you want the image to be scrollable,
        #    you have to use 'stream'.
        #
        # 2. The last line of the output is the ANSI reset code without newline.
        #    This confuses fzf and makes it render scroll offset indicator.
        #    So we remove the last line and append the reset code to its previous line.
        kitty icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" "$1" | sed '$d' | sed $'$s/$/\e[m/'

    # 2. Use chafa with Sixel output
    elif _logan_if_command_exist "chafa"; then
        chafa -s "$dim" "$1"
        # Add a new line character so that fzf can display multiple images in the preview window
        echo

    # 3. If chafa is not found but imgcat is available, use it on iTerm2
    elif _logan_if_command_exist "imgcat"; then
        # NOTE: We should use https://iterm2.com/utilities/it2check to check if the
        # user is running iTerm2. But for the sake of simplicity, we just assume
        # that's the case here.

        imgcat -W "${dim%%x*}" -H "${dim##*x}" "$1"
    # 4. Cannot find any suitable method to preview the image
    else
        echo "图片文件"
    fi
}

function logan_fzf_preview() {
    local file type
    file="${1/#\~\//$HOME/}"
    type="$(file --dereference --mime -- "$file")"

    if [ ! -e "$file" ]; then
        # 不存在
        echo ""
        return
    elif [[ -d "$file" ]]; then
        # 为目录
        tree -L 1 -C "$file" ||
            echo "$file" is a directory. 2>/dev/null
        return
    elif [[ -f "$file" ]]; then
        case "$file" in
        *.pdf) echo "pdf文件" ;;
        *.epub) echo "epub文件" ;;
        *.md)
            if _logan_if_command_exist "glow"; then
                glow "$file"
            else
                bat_cat "$file"
            fi
            ;;
        *)
            if [[ $type =~ image/ ]]; then
                # image_cat "$file"
                echo "图片文件"
                return 0
            fi
            for ext in "${_logan_image_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    # image_cat "$file"
                    echo "图片文件"
                    return 0
                fi
            done

            for ext in "${_logan_audio_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "音频文件"
                    return 0
                fi
            done
            for ext in "${_logan_video_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "视频文件"
                    return 0
                fi
            done
            for ext in "${_logan_archive_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "压缩文件"
                    return 0
                fi
            done
            for ext in "${_logan_exec_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "可执行文件"
                    return 0
                fi
            done
            for ext in "${_logan_lib_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "动态库文件"
                    return 0
                fi
            done
            for ext in "${_logan_office_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "办公文档"
                    return 0
                fi
            done
            for ext in "${_logan_iso_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "光盘镜像文件"
                    return 0
                fi
            done
            for ext in "${_logan_mobile_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "移动应用安装包"
                    return 0
                fi
            done
            for ext in "${_logan_db_ext[@]}"; do
                if [[ "$file" == $ext ]]; then
                    echo "数据库文件"
                    return 0
                fi
            done
            bat_cat "$file"
            ;;
        esac
    else
        echo "其他"
    fi
}

logan_fzf_preview "$@"
