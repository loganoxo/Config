# kill sessions
tmk() {
    local sessions
    sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null || true)
    if [ -z "$sessions" ]; then
        echo "No sessions found."
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

# 没有参数时,会显示当前所有session,选中后会进入
# 有参数时,若当前server有这个session的name,则直接进入; 若没有则创建后进入
# 在tmux内部也能使用
# shellcheck disable=SC2120
tms() {
    local change
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    if [ -n "$1" ]; then
        if tmux "$change" -t "$1" 2>/dev/null; then
            return
        else
            if _logan_for_sure "There is no such session, want to create '$1' ?"; then
                tmux new-session -d -s "$1"
                if _logan_for_sure "Created success, want to attach ?"; then
                    tmux "$change" -t "$1"
                fi
            fi
            return
        fi
    fi

    # 获取 tmux 会话列表
    local sessions
    sessions=$(tmux list-sessions -F '#{session_id} #{session_name}' 2>/dev/null || true)
    if [ -z "$sessions" ]; then
        if _logan_for_sure "No sessions found, want to create one ?"; then
            local input_session_name
            echo -en "   \033[33m input session name:\033[0m"
            read -r input_session_name </dev/tty
            tmux new-session -d -s "$input_session_name"
            if _logan_for_sure "Created success, want to attach ?"; then
                tmux "$change" -t "$input_session_name"
            fi
        fi
        return
    fi

    # 调用 fzf 选择会话
    # -e 显示颜色 -p 把窗格显示到终端 {1}是fzf的第一列,这里是 session_id($1) 或 window_id(@1) 或 pane_id(%1)
    # --with-nth=2.. 表示只显示第二列到结尾的内容,不会影响fzf的输出; awk 让 fzf 只输出 {1} 的内容(id)
    local fzf_result
    local session_id
    fzf_result=$(echo "$sessions" | fzf --with-nth=2.. --preview 'tmux capture-pane -pe -t {1}')
    if [ -n "$fzf_result" ]; then
        session_id=$(echo "$fzf_result" | awk '{print $1}')
        tmux "$change" -t "$session_id"
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

# 直接进入tmux,并显示session的选择, -s 是把session折叠;
# \; 这是 tmux 命令的分隔符,它允许在同一行中执行多个 tmux 命令
# -Z是先把当前窗格最大化,再显示session的选择,选择后,再还原;不然选择窗只会在窗格里展示,太小了
# 折叠/打开: 左右箭头
function tm() {
    tmux attach \; choose-tree -sZ
}
