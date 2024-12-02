#!/usr/bin/env bash
#
# 脚本名称: batch_rename.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux装机前置脚本; 包括软件源的配置、网络静态IP和DNS等
# 使用: 1.用wget(debian默认安装)
# su -c 'wget -q -O- "https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh?$(date +%s)" | bash -s -- run'
# 2.用curl(debian等linux可能没有预装)
# su -c 'curl -fsSL "https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh?$(date +%s)" | bash -s -- run'
# 也可以放在nginx中
# 提示信息不能使用中文,因为linux自己的tty终端不支持中文

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行
flag="$1"
export PATH=$PATH:/usr/sbin

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

function for_sure() {
    local choice
    echo -n "$1"
    read -r choice </dev/tty
    case "$choice" in
    y | Y) ;;
    *)
        echo "Operation cancelled. Script stopped."
        exit 1 #脚本停止
        ;;
    esac
}

function notice() {
    echo -en "\033[31m $1. \033[0m $2"
}

# 软件源配置
function show_software_config() {
    notice "current sources: \n"
    cat /etc/apt/sources.list
}
function software_config() {
    show_software_config
    for_sure "Are you sure you want to reconfigure ? (y/n):"
    local version=""
    local dynamic=""
    str0="\033[31m Configure official software sources: Choose the Debian version  \033[0m \n"
    str1="\033[31m[ 1 ] debian11 (bullseye) \033[0m \n"
    str2="\033[31m[ 2 ] debian12 (bookworm) \033[0m \n"
    str3="\033[31m[ 3 ] Exit. \033[0m \n"
    echo -e "$str0$str1$str2$str3"
    echo -n "Input your choice :"
    read -r choice </dev/tty
    case "$choice" in
    1)
        version="bullseye"
        dynamic=""
        ;;
    2)
        version="bookworm"
        dynamic=" non-free-firmware"
        ;;
    *)
        echo "Operation cancelled. Script stopped."
        exit 1 #脚本停止
        ;;
    esac
    for_sure "Are you sure you want to reconfigure to '$version' ? (y/n):"

    cp /etc/apt/sources.list "/etc/apt/sources.list-$(date +%s).bak"
    cat >/etc/apt/sources.list <<EOF
# 提供主要的软件包库,是系统大部分软件的来源,包括基础的操作系统组件和应用程序包,用于升级系统和安装软件
deb http://deb.debian.org/debian $version main contrib non-free$dynamic
deb-src http://deb.debian.org/debian $version main contrib non-free$dynamic

# 提供安全性修复的更新,包含及时修复的安全漏洞补丁,用于修复系统或软件中的已知漏洞
deb http://security.debian.org/debian-security $version-security main contrib non-free$dynamic
deb-src http://security.debian.org/debian-security $version-security main contrib non-free$dynamic

# 快速修复一些关键问题,目的是解决一些无法等到下一个点版本(例如从 12.1 到 12.2)发布才能修复的问题
deb http://deb.debian.org/debian $version-updates main contrib non-free$dynamic
deb-src http://deb.debian.org/debian $version-updates main contrib non-free$dynamic

# 反向移植,指从 Debian 的较高版本中(例如 $version)选取特定的软件包,并在当前稳定版本(例如 bullseye)上进行重新编译和打包;用户可以在稳定版系统中使用更高版本的应用程序或工具,而无需升级整个系统到测试版或不稳定版
# deb http://deb.debian.org/debian $version-backports main contrib non-free$dynamic
# deb-src http://deb.debian.org/debian $version-backports main contrib non-free$dynamic
EOF
    notice " reconfigure success! \n"
    show_software_config
}
software_config
apt update && apt-get update && apt upgrade && apt autoremove && apt autoclean

# 网络配置
function show_network_config() {
    notice " current interfaces: \n"
    cat /etc/network/interfaces
    notice " current resolv.conf: \n"
    cat /etc/resolv.conf
}

function ip_correct() {
    if [[ "$1" =~ ^([0-9]+\.){3}[0-9]+$ ]]; then
        return 0
    else
        echo "Ip format not correct !"
        exit 1
    fi
}

function network_config() {
    show_network_config
    for_sure "Are you sure you want to reconfigure ? (y/n):"

    local static_ip=""
    local gateway_ip=""
    local interface=""
    notice " Please Input The Static Ip. \n"
    echo -n "Input Static Ip:"
    read -r static_ip </dev/tty
    if [ -z "$static_ip" ]; then
        echo "Operation cancelled. Script stopped."
        exit 1 #脚本停止
    fi
    ip_correct "$static_ip"
    for_sure "Are you sure you want to reconfigure address to '$static_ip' ? (y/n):"

    notice "Use '172.16.106.2' For Gateway Ip ?" " (y/n):"
    read -r choice1 </dev/tty
    if [ "$choice1" = "y" ] || [ "$choice1" = "Y" ]; then
        gateway_ip="172.16.106.2"
    else
        notice "Please Input The Gateway Ip.\n"
        echo -n "Input Gateway Ip:"
        read -r gateway_ip </dev/tty
        if [ -z "$gateway_ip" ]; then
            echo "Operation cancelled. Script stopped."
            exit 1 #脚本停止
        fi
    fi
    ip_correct "$gateway_ip"
    for_sure "Are you sure you want to reconfigure gateway to '$gateway_ip' ? (y/n):"

    notice "Use 'ens160' For Interface ?" " (y/n):"
    read -r choice2 </dev/tty
    if [ "$choice2" = "y" ] || [ "$choice2" = "Y" ]; then
        interface="ens160"
    else
        notice "Please Input The Interface."
        echo -n "Input Interface:"
        read -r interface </dev/tty
        if [ -z "$interface" ]; then
            echo "Operation cancelled. Script stopped."
            exit 1 #脚本停止
        fi
    fi

    for_sure "Are you sure you want to reconfigure interface to '$interface' ? (y/n):"

    cp /etc/network/interfaces "/etc/network/interfaces-$(date +%s).bak"
    cat >/etc/network/interfaces <<EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
# allow-hotplug $interface
# iface $interface inet dhcp
auto $interface
iface $interface inet static
    address $static_ip
    netmask 255.255.255.0
    gateway $gateway_ip
    dns-nameservers 223.5.5.5 119.29.29.29 8.8.8.8
EOF
    notice "reconfigure success! \n"
    show_network_config
}
network_config
systemctl restart networking.service
ip addr
for_sure "Is That Right ? (y/n):"
apt install resolvconf
systemctl restart networking.service
systemctl restart resolvconf.service
resolvconf -u
systemctl status resolvconf.service
notice "current resolv.conf:\n"
cat /etc/resolv.conf
for_sure "Is That Right ? (y/n):"
ping -c 5 www.baidu.com
for_sure "Is That Right ? (y/n):"
dig www.baidu.com
for_sure "Is That Right ? (y/n):"
nslookup -debug www.baidu.com
for_sure "Is That Right ? (y/n):"

for_sure "Next Step : Language Config  ? (y/n):"
dpkg-reconfigure locales
locale
locale -a

for_sure "Next Step : Install sudo  ? (y/n):"
apt update && apt-get update && apt install sudo
user_name=""
notice "Make 'helq' support sudo ?" " (y/n):"
read -r choice </dev/tty
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    user_name="helq"
else
    notice "Please Input The UserName.\n"
    echo -n "Input UserName:"
    read -r user_name </dev/tty
    if [ -z "$user_name" ]; then
        echo "Operation cancelled. Script stopped."
        exit 1 #脚本停止
    fi
fi

/usr/sbin/usermod -aG sudo "$user_name"
groups "$user_name"
notice "May be need reboot.\n"
