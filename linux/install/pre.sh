#!/usr/bin/env bash
#
# 脚本名称: batch_rename.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux装机前置脚本; 包括软件源的配置、网络静态IP和DNS等
# 使用: 1.用wget(debian默认安装)        su -c 'wget -q -O- https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh | bash -s -- run'
# 2.用curl(debian等linux可能没有预装)   su -c 'curl -fsSL https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh | bash -s -- run'
# 也可以放在nginx中
# 提示信息不能使用中文,因为linux自己的tty终端不支持中文

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
        echo "need arg"
        exit 1
    fi

    if [ "$flag" != 'run' ]; then
        echo "arg must be 'run' "
        exit 1
    fi

    if _logan_if_mac; then
        echo "can't run on macos"
        exit 1
    fi

    if ! _logan_if_linux; then
        echo "only support linux"
        exit 1
    fi
}

# 预先判断
judge

# 软件源配置
function software_config() {
    echo -e "\033[31m current sources :  \033[0m \n"
    cat /etc/apt/sources.list
    echo -n "Are you sure you want to reconfigure? (y/n): "
    read -r choice1 </dev/tty
    case "$choice1" in
    y | Y) ;;
    *)
        echo "Operation cancelled. Script stopped."
        exit 1 #脚本停止
        ;;
    esac

    local version=""
    str0="\033[31m Configure official software sources: Choose the Debian version  \033[0m \n"
    str1="\033[31m[ 1 ] debian11 (bullseye) \033[0m \n"
    str2="\033[31m[ 2 ] debian12 (bookworm) \033[0m \n"
    str3="\033[31m[ 3 ] Exit. \033[0m \n"
    echo -e "$str0$str1$str2$str3"
    echo -n "Input your choice :"
    read -r choice2 </dev/tty
    case "$choice2" in
    1) version="bullseye" ;;
    2) version="bookworm" ;;
    *)
        echo "Operation cancelled. Script stopped."
        exit 1 #脚本停止
        ;;
    esac

    echo -n "Are you sure you want to reconfigure to '$version' ? (y/n): "
    read -r choice3 </dev/tty
    case "$choice3" in
    y | Y) ;;
    *)
        echo "Operation cancelled. Script stopped."
        exit 1 #脚本停止
        ;;
    esac
    cat >/etc/apt/sources.list <<EOF
    # 提供主要的软件包库,是系统大部分软件的来源,包括基础的操作系统组件和应用程序包,用于升级系统和安装软件
    deb http://deb.debian.org/debian $version main contrib non-free non-free-firmware
    deb-src http://deb.debian.org/debian $version main contrib non-free non-free-firmware

    # 提供安全性修复的更新,包含及时修复的安全漏洞补丁,用于修复系统或软件中的已知漏洞
    deb http://security.debian.org/debian-security $version-security main contrib non-free non-free-firmware
    deb-src http://security.debian.org/debian-security $version-security main contrib non-free non-free-firmware

    # 快速修复一些关键问题,目的是解决一些无法等到下一个点版本(例如从 12.1 到 12.2)发布才能修复的问题
    deb http://deb.debian.org/debian $version-updates main contrib non-free non-free-firmware
    deb-src http://deb.debian.org/debian $version-updates main contrib non-free non-free-firmware

    # 反向移植,指从 Debian 的较高版本中(例如 $version)选取特定的软件包,并在当前稳定版本(例如 bullseye)上进行重新编译和打包;用户可以在稳定版系统中使用更高版本的应用程序或工具,而无需升级整个系统到测试版或不稳定版
    # deb http://deb.debian.org/debian $version-backports main contrib non-free non-free-firmware
    # deb-src http://deb.debian.org/debian $version-backports main contrib non-free non-free-firmware
EOF
    echo -e "\033[31m reconfigure success  \033[0m \n"
    echo -e "\033[31m current sources :  \033[0m \n"
    cat /etc/apt/sources.list
}
software_config
# 网络配置
