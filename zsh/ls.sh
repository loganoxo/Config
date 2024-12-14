# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;36:ln=00;35:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:*.patch=00;34:*.o=00;32:*.so=01;35:*.ko=01;31:*.la=00;33:*.mp4=00;35:*.mkv=00;35'

_my_alias_init_ls() {
    if command ls --color=auto ~ >/dev/null 2>&1; then
        command ls --color=auto "$@"
    elif command ls -G ~ >/dev/null 2>&1; then
        command ls -G "$@"
    fi
}

# 	-l: 以长格式显示，提供详细信息，例如权限、所有者、大小、修改日期等。
# 	-h: 以人类可读的格式显示文件大小，例如使用 KB、MB、GB 等单位，而不是纯字节数。
# 	-a: 显示所有文件，包括以 . 开头的隐藏文件。
#   -A: 显示所有文件，包括以 . 开头的隐藏文件; 但不包括 .（当前目录）和 ..（上级目录）
#   -F: 在每个文件/文件夹名后加上特定的标识符，帮助区分文件/文件夹类型,如文件夹后会加`/`,*：表示可执行文件;@：表示符号链接（symlink）。
#   --color=auto 在 Linux 系统中用于根据终端是否支持颜色自动决定是否启用颜色输出。它是一个较为广泛的标准选项，在大多数 Linux 发行版中都能正常工作
#   -G：在 macOS 和某些 Linux 发行版中启用颜色化输出，类似于 ls --color=auto

if _logan_if_command_exist "lsd"; then
    alias ls='lsd'

    alias l='ls -lAh'
    alias ll='ls -lAh'
    alias lf='ls -lAhF'
    alias lsa='ls -A'

    alias lso='_my_alias_init_ls'
    alias lo='lso -lAhF'
    alias llo='lso -lAhF'
    alias lsao='lso -AF'
else
    alias ls='_my_alias_init_ls'
    alias l='ls -lAhF'
    alias ll='ls -lAhF'
    alias lsa='ls -AF'
fi
