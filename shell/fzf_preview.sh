#! /bin/bash

if [ ! -e "$1" ]; then
  echo ""
else
  case "$1" in
  *.pdf) echo "pdf文件" ;;
  *.jpg | *.png | *.gif | *.JPEG) echo "图片文件" ;;
  *.md) glow -s dark "$1" ;;
  *.zip) zipinfo "$1" ;;
  *.mp4 | *.mkv) echo "视频文件" ;;
  *)
    if [[ $(file -i "$1") =~ directory ]]; then
      tree -L 1 -C "$1" ||
        echo "$1" is a directory. 2>/dev/null
    elif [[ $(file -I "$1") =~ binary ]]; then
      echo "二进制文件"
    else
      bat --style=numbers --color=always --line-range :600 "$1" 2>/dev/null
    fi
    ;;
  esac

fi
