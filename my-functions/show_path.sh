# 将 PATH 以冒号分割并逐行显示
function show_path() {
    echo "PATH 中的各个路径为："
    echo "$PATH" | tr ':' '\n'
    # 统计路径的数量
    count=$(echo "$PATH" | tr ':' '\n' | wc -l)
    echo "总共有 $count 个路径。"
}

function show_unique_path() {
    echo "PATH 中的各个路径为(去重)："
    foo="$(bash "${__PATH_MY_CNF}/shell/clean_path.sh")"
    echo "$foo" | tr ':' '\n'
    # 统计路径的数量
    count=$(echo "$foo" | tr ':' '\n' | wc -l)
    echo "总共有 $count 个路径。"
}
