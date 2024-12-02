#!/usr/bin/env bash
#
# 脚本名称: batch_rename.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux装机前置脚本; 包括软件源的配置、网络静态IP和DNS等
# 使用: 1.用wget(debian默认安装)        su -c 'wget -q -O- https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh | bash -s -- run'
# 2.用curl(debian等linux可能没有预装)   su -c 'curl -fsSL https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh | bash'
# 也可以放在nginx中

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行
flag="$1"

function _logan_if_mac() {
    if [[ "$(uname -s)" == Darwin* ]]; then
        return 0
    else
        return 1
    fi
}

function _logan_if_linux() {
    if [[ "$(uname -s)" == Linux* ]]; then
        return 0
    else
        return 1
    fi
}

function judge() {
    if [ -z "$flag" ]; then
        echo "需要参数"
        exit 1
    fi

    if [ "$flag" != 'run' ]; then
        echo "参数应该是 run "
        exit 1
    fi

    if _logan_if_mac; then
        echo "mac 不能执行"
        exit 1
    fi

    if ! _logan_if_linux; then
        echo "当前非linux系统, 不能执行"
        exit 1
    fi
}

# 预先判断
judge

# 软件源配置
function software_config() {
    echo -e "\033[31m 当前软件源配置为:  \033[0m \n"
    cat /etc/apt/sources.list
    echo -n "确定要重新配置吗? (y/n): "
    read -r choice1 < /dev/tty
    case "$choice1" in
    y | Y) ;;
    *)
        echo "操作取消.脚本停止"
        exit 1 #脚本停止
        ;;
    esac

    local version=""
    str0="\033[31m 配置官方软件源: 选择 debian 的版本  \033[0m \n"
    str1="\033[31m[ 1 ] debian11(bullseye) \033[0m \n"
    str2="\033[31m[ 2 ] debian12(bookworm) \033[0m \n"
    str3="\033[31m[ 3 ] Exit. \033[0m \n"
    echo -e "$str0$str1$str2$str3"
    echo -n "Input your choice :"
    read -r choice2 < /dev/tty
    case "$choice2" in
    1) version="bullseye" ;;
    2) version="bookworm" ;;
    *)
        echo "操作取消.脚本停止"
        exit 1 #脚本停止
        ;;
    esac

    echo "$version"
}
software_config
# 网络配置
