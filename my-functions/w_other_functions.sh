# 局域网ip
lanip() {
    ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}'
}

# 用于测试的函数
function test_error() {
    echo "error..."
    return 3
}

function test_success() {
    echo "success..."
    return 0
}
