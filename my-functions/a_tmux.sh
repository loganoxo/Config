# 精确判断某个 session name 是否已存在
# tmux has-session -t "name" 是模糊匹配的
function tm_has_session_exact() {
    if [ -z "$1" ]; then
        return 1
    fi
    # -F：固定字符串匹配（不使用正则表达式）。
    # -x：要求整个行与 参数 完全匹配。
    # -q：静默模式，只返回状态码，不输出内容。
    if tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -Fxq "$1"; then
        return 0
    else
        return 1
    fi
}

# 没有参数时,会显示当前所有session,选中后会进入
# 有参数时,若当前server有这个session的name,则直接进入; 若没有则创建后进入
# 在tmux内部也能使用
# shellcheck disable=SC2120
tms() {
    local change
    local session_name="$1"
    local split_count="$2"
    local sessions
    local if_enter_directly=0

    # 获取 tmux 会话列表
    sessions=$(tmux list-sessions -F '#{session_id} #{session_name}' 2>/dev/null || true)
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    # tmux中有session,但是没有传参数时,调用fzf显示session列表
    if [ -z "$session_name" ] && [ -n "$sessions" ]; then
        local fzf_result
        local session_id
        # -e 显示颜色 -p 把窗格显示到终端 {1}是fzf的第一列,这里是 session_id($1) 或 window_id(@1) 或 pane_id(%1)
        # --with-nth=2.. 表示只显示第二列到结尾的内容,不会影响fzf的输出; awk 让 fzf 只输出 {1} 的内容(id)
        fzf_result=$(echo "$sessions" | fzf --with-nth=2.. --preview 'tmux capture-pane -pe -t {1}')
        if [ -n "$fzf_result" ]; then
            session_id=$(echo "$fzf_result" | awk '{print $1}')
            tmux "$change" -t "$session_id"
        fi
        return
    fi

    # session name 去除前后空格
    session_name=$(echo "$session_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    # 判断是否需要创建session
    if tm_has_session_exact "$session_name" 2>/dev/null; then
        # 不需要创建,直接进入
        tmux "$change" -t "$session_name"
        return 0
    else
        # 需要创建
        if [ -z "$session_name" ]; then
            # 传参为空,则提示输入
            echo -e "   \033[35m No tmux session available! Create one?\033[0m"
            echo -en "   \033[33m input session name:\033[0m"
            read -r session_name </dev/tty
            # session name 去除前后空格
            session_name=$(echo "$session_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            # 校验
            if [ -z "$session_name" ]; then
                echo -e "   \033[35m session name is blank, skip! \033[0m"
                return 1
            fi
            echo -en "   \033[33m input split count:\033[0m"
            read -r split_count </dev/tty
        else
            if_enter_directly=1
        fi
    fi

    # 校验
    if [ -z "$session_name" ]; then
        echo -e "   \033[35m session name is blank, skip! \033[0m"
        return 1
    fi
    if [ -n "$split_count" ]; then
        if [[ $split_count =~ ^[0-9]+$ ]]; then
            if [ "$split_count" -gt 10 ]; then
                echo -e "   \033[35m split_count need less than 10, skip! \033[0m"
                return 1
            fi
        else
            echo -e "   \033[35m split_count need be number, skip! \033[0m"
            return 1
        fi

    fi
    # 后台创建session
    if tmux new-session -d -s "$session_name"; then
        # 是否要分屏
        if [ -n "$split_count" ]; then
            for ((i = 1; i < split_count; i++)); do
                tmux split-window -h -t "$session_name"
                # 重新等宽等高布局,需要写在循环里,不然可能会没有空间创建新窗格
                tmux select-layout -t "$SSH_TMUX_SESSION_NAME" tiled
            done
        fi
        # 选择第一个窗格
        tmux select-pane -t "$SSH_TMUX_SESSION_NAME:1.1"
        echo -e "   \033[35m Created success. \033[0m"

        # 是否要直接进入
        if [ "$if_enter_directly" -eq 1 ]; then
            tmux "$change" -t "$session_name"
            return 0
        else
            if _logan_for_sure "want to attach ?"; then
                tmux "$change" -t "$session_name"
            fi
            return 0
        fi
    fi
}

# 以窗口为基准
tmw() {
    # 获取 tmux 窗口列表
    local windows
    # -a 显示所有session的window,默认只会显示当前(或刚退出的)session的window
    windows=$(tmux list-windows -a -F '#{session_id} #{window_id} #{session_name} #{window_name}' 2>/dev/null || true)
    if [ -z "$windows" ]; then
        # 调用 tms 创建 session
        # shellcheck disable=SC2119
        tms
        return
    fi

    # 调用 fzf 选择窗口
    local fzf_result
    local session_id
    local window_id
    fzf_result=$(echo "$windows" | fzf --with-nth=3.. --preview 'tmux capture-pane -pe -t {2}')
    if [ -n "$fzf_result" ]; then
        session_id=$(echo "$fzf_result" | awk '{print $1}')
        window_id=$(echo "$fzf_result" | awk '{print $2}')
        tmux attach -t "$session_id" \; select-window -t "$window_id"
    fi
}

# 以窗格为基准
tmp() {
    # 获取 tmux 窗格列表
    local panes
    # -a 显示所有session的所有window的pane pane没有name
    panes=$(tmux list-panes -a -F '#{session_id} #{window_id} #{pane_id} #{session_name} #{window_name} #{pane_id}' 2>/dev/null || true)
    if [ -z "$panes" ]; then
        # 调用 tms 创建 session
        # shellcheck disable=SC2119
        tms
        return
    fi

    # 调用 fzf 选择窗格
    local fzf_result
    local session_id
    local window_id
    local pane_id
    fzf_result=$(echo "$panes" | fzf --with-nth=4.. --preview 'tmux capture-pane -pe -t {3}')
    if [ -n "$fzf_result" ]; then
        session_id=$(echo "$fzf_result" | awk '{print $1}')
        window_id=$(echo "$fzf_result" | awk '{print $2}')
        pane_id=$(echo "$fzf_result" | awk '{print $3}')
        # select-pane -Z 保持窗格的缩放状态,当选择的窗格(隐藏起来的)所在窗口有最大化的窗格,则把选择的窗格最大化显示
        tmux attach -t "$session_id" \; select-window -t "$window_id" \; select-pane -t "$pane_id"
    fi
}

# 用tmux同时打开多个ssh连接,并开启同步输入
function tm_ssh() {
    local SSH_ARRAY=()
    local SSH_FILE
    local SSH_TMUX_SESSION_NAME="multiple-ssh"
    # 检查参数
    if [ "$#" -lt 1 ]; then
        echo "need: -f '/path/file' "
        echo "or  : user@host1 user@host2 [user@hostN ...]"
        return 1
    elif [ "$1" = "-f" ]; then
        if [ "$#" -eq 2 ]; then
            SSH_FILE="$2"
        else
            echo "need: -f '/path/file' "
            return 1
        fi
    else
        for item in "${@}"; do
            item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            if [ -n "$item" ]; then
                SSH_ARRAY+=("$item")
            fi
        done
    fi

    if [ "${#SSH_ARRAY[@]}" -lt 1 ] && [ -f "$SSH_FILE" ]; then
        local line
        while IFS= read -r line; do
            line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            if [ -n "$line" ]; then
                SSH_ARRAY+=("$line")
            fi
        done <"$SSH_FILE"
    fi

    if [ "${#SSH_ARRAY[@]}" -lt 1 ]; then
        echo -e "   \033[35m There has none ssh hosts!\033[0m"
        return 1
    fi
    if [ "${#SSH_ARRAY[@]}" -gt 8 ]; then
        echo -e "   \033[35m Too many ssh hosts! 8 Max \033[0m"
        return 1
    fi

    # 循环判断是否已存在同名session,创建新的 tmux 会话
    local count_session=1
    while tm_has_session_exact "${SSH_TMUX_SESSION_NAME}-${count_session}" 2>/dev/null; do
        count_session=$((count_session + 1))
    done
    SSH_TMUX_SESSION_NAME="${SSH_TMUX_SESSION_NAME}-${count_session}"

    if ! tm_has_session_exact "$SSH_TMUX_SESSION_NAME" 2>/dev/null; then
        tmux new-session -d -s "$SSH_TMUX_SESSION_NAME"
    fi

    if ! tm_has_session_exact "$SSH_TMUX_SESSION_NAME" 2>/dev/null; then
        echo -e "   \033[35m No tmux session available! \033[0m"
        return 1
    fi

    local ssh_target
    local count=0
    for ssh_target in "${SSH_ARRAY[@]}"; do
        if [ $count -eq 0 ]; then
            # 第一个服务器在默认窗格 C-m 为回车
            tmux send-keys -t "$SSH_TMUX_SESSION_NAME" "ssh ${ssh_target}" C-m "clear" C-m
        else
            # 其他服务器在新窗格中执行 ssh
            tmux split-window -h -t "$SSH_TMUX_SESSION_NAME" "ssh ${ssh_target}"
            # 重新等宽等高布局,需要写在循环里,不然可能会没有空间创建新窗格
            tmux select-layout -t "$SSH_TMUX_SESSION_NAME" tiled
        fi
        # 选择第一个窗格
        tmux select-pane -t "$SSH_TMUX_SESSION_NAME:1.1"
        count=$((count + 1))
    done

    # 让所有窗格启用同步输入模式
    tmux set-option -t "$SSH_TMUX_SESSION_NAME" synchronize-panes on

    # 附加到 session
    local change
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    tmux "$change" -t "$SSH_TMUX_SESSION_NAME"
}

# 直接进入tmux,并显示session的选择, -s 是把session折叠;
# \; 这是 tmux 命令的分隔符,它允许在同一行中执行多个 tmux 命令
# -Z是先把当前窗格最大化,再显示session的选择,选择后,再还原;不然选择窗只会在窗格里展示,太小了
# 折叠/打开: 左右箭头
function tm() {
    tmux attach \; choose-tree -sZ
}

# kill sessions
tmk() {
    local sessions
    sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null || true)
    if [ -z "$sessions" ]; then
        echo "No tmux session available!"
        return
    fi

    local kill_sessions
    local session

    kill_sessions=$(echo "$sessions" | fzf --multi)

    if [ -n "$kill_sessions" ]; then
        while IFS= read -r session; do
            if _logan_for_sure "if kill '$session' ?"; then
                tmux kill-session -t "$session"
                echo -e "   \033[31m '$session' killed. \033[0m"
            fi
        done <<<"$kill_sessions"
    fi
}
