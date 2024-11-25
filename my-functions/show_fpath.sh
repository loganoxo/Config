# 将 FPATH 以冒号分割并逐行显示
function show_fpath() {
    echo "FPATH 中的各个路径为："
    echo "$FPATH" | tr ':' '\n'
    # 统计路径的数量
    count=$(echo "$FPATH" | tr ':' '\n' | wc -l)
    echo "总共有 $count 个路径。"
}
