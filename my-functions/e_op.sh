# 增强mac的open命令
op() {
    if [ "$#" = "0" ]; then
        echo "!!!error: 需要传参"
        return 1
    fi
    if [ "$#" -gt 1 ]; then
        echo "!!!error: 参数过多，检查是否有空格，可以用双引号包裹"
        return 1
    fi
    if [[ "$1" == "." || -f $1 ]]; then
        /usr/bin/open "$1"
    elif [ -d "$1" ]; then
        cd "$1" && /usr/bin/open .
    else
        echo "!!!error: 没有这个目录或文件"
        return 1
    fi
}
