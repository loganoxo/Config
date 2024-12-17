# 加载
if _logan_if_command_exist "fzf"; then
    if _logan_if_zsh; then
        eval "$(fzf --zsh)"
    elif _logan_if_bash; then
        eval "$(fzf --bash)"
    fi
fi

# fzf配置
FZF_FD_EXCLUDE_OPTS=" --exclude={.git,.mvn,.idea,.vscode,.sass-cache,node_modules,.DS_Store} "
export FZF_DEFAULT_COMMAND="fd -HI $FZF_FD_EXCLUDE_OPTS "

FZF_FACE_OPTS=" --height=85% --layout=reverse --border -m --tmux 82% " #m为多选

# 预览窗口在右方
FZF_PREVIEW_RIGHT_OPTS=" --preview '~/Data/Config/shell/fzf_preview.sh {}' --preview-window right,55%,border,nowrap "

# 预览窗口在上方
FZF_PREVIEW_UP_OPTS=" --preview '~/Data/Config/shell/fzf_preview.sh {}' --preview-window up,5,border,wrap "

FZF_PREVIEW_OPTS="$FZF_PREVIEW_RIGHT_OPTS"

# 默认情况下,预览窗口可以通过 shift+上下箭头 来上下移动
# ctrl-y 复制选项的内容到剪贴板,不通用, ctrl-r中可以正常使用;
# ctrl-w 预览窗口切换换行
# ctrl-s 切换预览窗口的位置
# ctrl-l 触发预览窗口的快捷键,改成ctrl-l,默认为ctrl-/
# ctrl-g 移动到第一行;  ctrl-d 向下翻页;  ctrl-u 向上翻页;
# <C-j> 或 <C-k> 或箭头键在结果列表中导航; <Tab>键可以进行多选;

FZF_BIND_OPTS=" --bind 'ctrl-w:toggle-preview-wrap,ctrl-s:change-preview-window(up,40%|right),ctrl-l:toggle-preview,ctrl-g:top,ctrl-d:page-down,ctrl-u:page-up' "
FZF_BIND_OPTS2=" --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)' "
# --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'  有+号,复制后直接退出

FZF_HEADER="C-y:copy C-w:wrap C-s:spin C-l:view Tab:mul C-g:top C-d:down C-u:up "
# 其他配置: fzf 行号/搜索项数/全部数 ; +S 表示排序模式已启用; (0) 表示当前的多选模式中已选择的条目数
FZF_INFO_OPTS="--info-command='echo -e \"\$FZF_POS/\$FZF_INFO 💛 $FZF_HEADER \"'"
if _logan_if_linux; then
    # FZF_INFO_OPTS=""
    :
fi

# fzf窗口的header提示信息,在FZF_INFO_OPTS下一行
FZF_HEADER_OPTS=" --color header:italic --header ' $FZF_HEADER' "
FZF_HEADER_OPTS=""

# catppuccin 的颜色
# bg+ fg+ 为选中的背景色和前景色
# marker selected-bg selected-fg 为用tab键多选 前面的竖线和背景色和前景色
# hl hl+ 为搜索词匹配的颜色
FZF_CATPPUCCIN_COLORS=" \
                      --color=bg+:#313244,fg+:yellow,spinner:#f5e0dc \
                      --color=fg:#cdd6f4,header:#f38ba8,info:magenta,pointer:#f5e0dc \
                      --color=marker:#EE66A6,selected-bg:#151515,selected-fg:green \
                      --color=prompt:blue,hl:#f38ba8,hl+:#f38ba8 "

FZF_DEFAULT_OPTS="$FZF_FACE_OPTS $FZF_CATPPUCCIN_COLORS \
                    $FZF_PREVIEW_OPTS $FZF_BIND_OPTS $FZF_BIND_OPTS2 \
                    $FZF_HEADER_OPTS $FZF_INFO_OPTS"

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
export FZF_CTRL_R_OPTS=" --prompt='commands > ' $FZF_FACE_OPTS $FZF_CATPPUCCIN_COLORS \
  --preview 'echo {}' --preview-window up,3,border,wrap,hidden \
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

# 显示进程,选择kill
function fkill() {
    local pids
    local pid_array=()
    local pid
    # 关键进程白名单（防止误杀）
    local whitelist="sshd|init|systemd|launchd|kernel_task|WindowServer|hidd|SystemUIServer|configd|blued|coreservicesd|syslogd|mds|mdworker|fseventsd|cloudfamily|airportd|ptsd|diskarbitrationd|powerd|opendirectoryd|securityd"
    # 根据权限显示进程并通过 fzf 选择
    if [ "$UID" != "0" ]; then
        pids=$(ps -f -u $UID | sed 1d | grep -i -v -E "$whitelist" |
            fzf -m --height=90% --preview='' |
            awk '{print $2}')
    else
        pids=$(ps -ef | sed 1d | grep -i -v -E "$whitelist" |
            fzf -m --height=90% --preview='' |
            awk '{print $2}')
    fi

    # 检查是否选择了 PID 并执行 kill
    if [ "x$pids" != "x" ]; then
        while IFS= read -r pid; do
            pid_array+=("$pid")
        done <<<"$pids"

        local PROCESS_USER
        local PROCESS_COMMAND
        for pid in "${pid_array[@]}"; do
            # 获取所属用户
            PROCESS_USER="$(ps -p "$pid" -o user= 2>/dev/null)"
            # 获取完整的命令
            PROCESS_COMMAND="$(ps -p "$pid" -o args= 2>/dev/null)"
            # 提示输出
            echo "PID : $pid"
            echo "USER: $PROCESS_USER"
            echo "CMD : $PROCESS_COMMAND"

            if _logan_for_sure "if kill $pid ?"; then
                if [ "$1" = 9 ]; then
                    kill -9 "$pid"
                else
                    kill "$pid"
                fi
                echo -e "   \033[31m $pid killed. \033[0m"
            fi
        done
    else
        echo "No process selected."
    fi
}
