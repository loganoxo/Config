# fzf配置
FZF_FD_EXCLUDE_OPTS=" --exclude={.git,.mvn,.idea,.vscode,.sass-cache,node_modules,.DS_Store} "
export FZF_DEFAULT_COMMAND="fd -HI $FZF_FD_EXCLUDE_OPTS "

FZF_FACE_OPTS=" --height=90% --layout=reverse --border -m " #m为多选

# 预览窗口在右方
FZF_PREVIEW_RIGHT_OPTS=" --preview '~/Data/Config/shell/fzf_preview.sh {}' --preview-window right,45%,border,wrap "

# 预览窗口在上方
FZF_PREVIEW_UP_OPTS=" --preview '~/Data/Config/shell/fzf_preview.sh {}' --preview-window up,5,border,wrap "

FZF_PREVIEW_OPTS="$FZF_PREVIEW_RIGHT_OPTS"

# <C-j> 或 <C-k> 或箭头键在结果列表中导航; <Tab>键可以进行多选;
# ctrl-y 复制选项的内容到剪贴板,不通用, ctrl-r中可以正常使用;
# ctrl-g 移动到第一行;  ctrl-d 向下翻页;  ctrl-u 向上翻页;
# ctrl-l 触发预览窗口的快捷键,改成ctrl-l,默认为ctrl-/
FZF_BIND_OPTS=" --bind ctrl-g:top,ctrl-d:page-down,ctrl-u:page-up,ctrl-l:toggle-preview "
FZF_BIND_OPTS2=" --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)' "
# --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'  有+号,复制后直接退出

# fzf窗口的header提示信息
FZF_HEADER_OPTS=" --color header:italic --header '<Tab>:multi;Ctrl-y:copy;Ctrl-g:top;Ctrl-d:pagedown;Ctrl-u:pageup;Ctrl-l:preview' "

# 其他配置: 1、fzf 行号/搜索项数/全部数
FZF_INFO_OPTS="--info-command='echo -e \"\x1b[33;1m\$FZF_POS\x1b[m/\$FZF_INFO 💛\"'"

os_type=$(uname) #获取操作系统类型
if [ "$os_type" = "Darwin" ]; then
    : # 什么都不做的占位符
elif [ "$os_type" = "Linux" ]; then
    FZF_INFO_OPTS=""
    # 进一步判断是否为 Debian
#    if [ -f /etc/debian_version ]; then
#        echo "当前系统是 Debian"
#    else
#        echo "当前系统是 Linux, 但不是 Debian"
#    fi
else
    echo "fzf.zsh中 未知的操作系统: $os_type"
fi

FZF_DEFAULT_OPTS="$FZF_FACE_OPTS $FZF_PREVIEW_OPTS $FZF_BIND_OPTS $FZF_BIND_OPTS2 $FZF_HEADER_OPTS $FZF_INFO_OPTS"

export FZF_DEFAULT_OPTS
export FZF_COMPLETION_TRIGGER="\\" # 默认为 **

# 默认功能
# fzf 查找当前目录下的所有文件和文件夹
# cd /path/to\<tab> 触发fzf; kill -9 \<TAB> Kill 命令提供了 PID 的模糊补全
# unset \<TAB> 和 export \<TAB> 和 unalias \<TAB>   显示环境变量/别名
# ssh \<TAB> 和 telnet \<TAB>    对于 ssh 和 telnet 命令，提供了主机名的模糊补全。这些名称是从 /etc/hosts 和 ~/.ssh/config 中提取的
# ctrl-r ; FZF_CTRL_R_OPTS; 获取历史命令到终端，不会自动回车，需要自己执行
# ctrl-t ; FZF_CTRL_T_OPTS; 选择当前目录的文件或目录，复制到终端，不会自动回车，需要自己修改
# alt-c ; FZF_ALT_C_OPTS; 列出当前目录下的所有目录(包含子目录),进入所选目录; 和alfred快捷键冲突,所以禁用;用 cd \<TAB>代替
# 和其他工具的配合
# ctrl-g 调用navi备忘录
# zz命令,快速切换目录

FZF_BIND_OPTS3=" --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)' "
export FZF_CTRL_R_OPTS=" $FZF_FACE_OPTS
  --preview 'echo {}' --preview-window up,3,border,wrap,hidden
  $FZF_BIND_OPTS $FZF_BIND_OPTS3 $FZF_HEADER_OPTS $FZF_INFO_OPTS "

# 禁用ALT-C
export FZF_ALT_C_COMMAND=""

################ 自定义以下功能函数 ######################################
# fcd - 在当前目录查找文件，然后选中文件后回车，会自动cd到该文件所在目录
fcd() {
    local file
    local dir
    file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir" || return
}

# 显示在当前目录下所有一级目录,不包含子目录,按回车进入
cf() {
    dir=$(eval "fd $1 -HI --max-depth=1 --type d $FZF_FD_EXCLUDE_OPTS " | fzf) && cd "$dir" || return
}
#cf() {
#    local dir
#    dir=$(find . -maxdepth 1 -type d -name "*${1:-*}*" -print 2>/dev/null | fzf) && cd "$dir" || return
#}

# 从某个目录查找, 包含子目录,按回车进入
ff() {
    dir=$(eval "fd $1 -HI --type d $FZF_FD_EXCLUDE_OPTS " | fzf) && cd "$dir" || return
}

# 仅兼容zsh;列出当前会话中进入过的目录,需要 setopt autopushd;才能让 cd 自动加入 dirs; setopt | grep autopushd
zf() {
    local dir
    dir=$(
        dirs -l -p |         # 获取目录栈中的所有路径,-l 绝对路径; -p 换行输出每个路径
            fzf --height 40% # 用 fzf 选择
    )
    [ -d "$dir" ] && cd "$dir" || return
}
