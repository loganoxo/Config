################ 自定义 fzf 的功能函数 ######################################

# fcd - 在当前目录查找文件，然后选中文件后回车，会自动cd到该文件所在目录
fcf() {
    local file
    local dir
    file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir" || return
}

# 从某个目录查找, 包含子目录,按回车进入
fcd() {
    local dir
    dir=$(fd "$1" -HI --type d --exclude="$FZF_FD_EXCLUDE_OPTS" | fzf) && cd "$dir" || return
}

# 显示在当前目录下所有一级目录,不包含子目录,按回车进入
fcd1() {
    local dir
    dir=$(fd "$1" -HI --max-depth=1 --type d --exclude="$FZF_FD_EXCLUDE_OPTS" | fzf) && cd "$dir" || return
}

# 仅兼容zsh;列出当前会话中进入过的目录,需要 setopt autopushd;才能让 cd 自动加入 dirs; setopt | grep autopushd
fcr() {
    local dir
    dir=$(
        dirs -l -p |         # 获取目录栈中的所有路径,-l 绝对路径; -p 换行输出每个路径
            fzf --height 40% # 用 fzf 选择
    )
    [ -d "$dir" ] && cd "$dir" || return
}

# 搜索,打印
function ffp() {
    local print_path
    if _logan_if_command_exist "fd"; then
        print_path=$(fd . "$1" -HLI --exclude="$FZF_FD_EXCLUDE_OPTS" | fzf --query "${2}") || return 1
    else
        print_path=$(find "$1" \
            -path '*/.git/*' -prune \
            -o -path '*/node_modules/*' -prune \
            -o -path '*/site-packages/*' -prune \
            -o -path '*.DS_Store*' -prune \
            -o -print | fzf --query "${2}") || return 1
    fi
    echo "$print_path"
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
