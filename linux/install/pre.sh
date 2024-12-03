#!/usr/bin/env bash
#
# 脚本名称: pre.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux装机前置脚本; 包括软件源的配置、网络静态IP、DNS、sudo等
# 使用:
# 一、使用 github
# 1.用wget(debian默认安装)
# su -c "wget -q -O- --header='Cache-Control: no-cache' \"https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\""
# 2.用curl(debian等linux可能没有预装)
# su -c "curl -fsSL -H 'Cache-Control: no-cache' \"https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\""

# 二、也可以放在nginx中
# su -c "wget -q -O- --header='Cache-Control: no-cache' \"http://192.168.0.101:18080/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\""
# su -c "curl -fsSL -H 'Cache-Control: no-cache' \"http://192.168.0.101:18080/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\""
# 提示信息不能使用中文,因为linux自己的tty终端不支持中文

# 虚拟机克隆之后的处理
# su -c "wget -q -O- --header='Cache-Control: no-cache' \"https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\" \"clone\" "
# su -c "curl -fsSL -H 'Cache-Control: no-cache' \"https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\" \"clone\" "
# su -c "wget -q -O- --header='Cache-Control: no-cache' \"http://192.168.0.101:18080/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\" \"clone\" "
# su -c "curl -fsSL -H 'Cache-Control: no-cache' \"http://192.168.0.101:18080/pre.sh?$(date +%s)\" | bash -s -- \"run\" \"$(whoami)\" \"clone\" "

set -e #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行
flag="$1"
user_name="$2"
after_clone="$3"
static_ip=""
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
    _log_start "judge"
    if [ -z "$flag" ]; then
        echo "need arg"
        exit 1
    fi

    if [ "$flag" != 'run' ]; then
        echo "arg must be 'run' "
        exit 1
    fi

    if [ -z "$user_name" ]; then
        echo "don't have user_name"
        exit 1
    fi

    if [ "$user_name" = "root" ]; then
        echo "need a common user_name arg"
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
    _log_end
}

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
    echo -en "\033[31m$1\033[0m$2"
}

function _log_start() {
    title=""
    if [ -n "$1" ]; then
        title="  $1  "
    fi
    echo -en "\033[31m##########################################################$title##########################################################\033[0m\n"
}

function _log_end() {
    echo -en "\033[31m#############################################################________#############################################################\033[0m\n\n"
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
    str1="\033[31m[ 1 ] debian12 (bookworm) \033[0m \n"
    str2="\033[31m[ 2 ] debian11 (bullseye) \033[0m \n"
    str3="\033[31m[ 3 ] Exit. \033[0m \n"
    echo -e "$str0$str1$str2$str3"
    echo -n "Input your choice :"
    read -r choice </dev/tty
    case "$choice" in
    1)
        version="bookworm"
        dynamic=" non-free-firmware"

        ;;
    2)
        version="bullseye"
        dynamic=""
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
    notice "reconfigure success! \n"
    show_software_config
}

# 网络配置
function show_network_config() {
    notice "current interfaces: \n"
    cat /etc/network/interfaces
    notice "current resolv.conf: \n"
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

    local gateway_ip=""
    local interface=""
    notice "Please Input The Static Ip. \n"
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
        for_sure "Are you sure you want to reconfigure gateway to '$gateway_ip' ? (y/n):"
    fi
    ip_correct "$gateway_ip"

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
        for_sure "Are you sure you want to reconfigure interface to '$interface' ? (y/n):"
    fi

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

function show_hostname() {
    notice "hostname:\n"
    hostname
    notice "hostnamectl:\n"
    hostnamectl
    notice "current /etc/hosts:\n"
    cat /etc/hosts
}

function run() {
    # 预先判断
    judge

    _log_start "software_config"
    software_config
    for_sure "Is That Right ? (y/n):"
    apt update -y && apt-get update -y
    notice "update success!\n"
    apt upgrade -y
    notice "upgrade success!\n"
    apt autoremove -y
    notice "autoremove success!\n"
    apt autoclean -y
    notice "autoclean success!\n"
    _log_end

    _log_start "network_config"
    network_config
    for_sure "Is That Right ? (y/n):"
    # systemctl restart networking.service
    # ip addr
    # for_sure "Is That Right ? (y/n):"
    apt install -y resolvconf
    notice "install resolvconf success\n"
    # systemctl restart networking.service
    systemctl restart resolvconf.service
    resolvconf -u
    systemctl status resolvconf.service
    notice "current resolv.conf:\n"
    cat /etc/resolv.conf
    ping -c 5 www.baidu.com
    dig www.baidu.com
    nslookup -debug www.baidu.com
    _log_end

    _log_start "Language Config"
    for_sure "Next Step : Language Config  ? (y/n):"
    dpkg-reconfigure locales
    notice "locale : \n"
    locale
    notice "locale -a : \n"
    locale -a
    _log_end

    _log_start "Install sudo"
    for_sure "Next Step : Install sudo  ? (y/n):"
    apt update -y && apt install -y sudo
    user_name_tmp=""
    notice "Make '$user_name' support sudo ?" " (y/n):"
    read -r choice </dev/tty
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        user_name_tmp="$user_name"
    else
        notice "Please Input The UserName.\n"
        echo -n "Input UserName:"
        read -r user_name_tmp </dev/tty
        if [ -z "$user_name_tmp" ]; then
            echo "Operation cancelled. Script stopped."
            exit 1 #脚本停止
        fi
        for_sure "Make '$user_name_tmp' support sudo ?" " (y/n):"
    fi
    /usr/sbin/usermod -aG sudo "$user_name_tmp"
    groups "$user_name_tmp"
    notice "install sudo success\n"
    _log_end

    _log_start "Install zsh"
    apt install -y zsh
    zsh --version
    chsh -s "$(which zsh)"
    notice "change zsh for common user\n"
    usermod -s "$(which zsh)" "$user_name_tmp"
    notice "install zsh success\n"
    _log_end

    # 安装一些必备软件
    apt install -y net-tools build-essential openssh-server curl unzip zip tree cmake jq
    apt install -y shellcheck shfmt tmux universal-ctags

    # 允许root直接登录
    echo "PermitRootLogin yes" | tee -a /etc/ssh/sshd_config >/dev/null

    echo "######################################################"
    notice "new static ip is: \n"
    notice "ssh $user_name_tmp@$static_ip\n"
    echo "######################################################"
    notice "May be need reboot.\n"
    notice "May be need test after reboot.\n"
    echo "######################################################"
    notice "cat /etc/network/interfaces\n"
    notice "cat /etc/resolv.conf\n"
    notice "systemctl status resolvconf.service\n"
    notice "ping -c 5 www.baidu.com\n"
    notice "dig www.baidu.com\n"
    notice "nslookup -debug www.baidu.com\n"
    notice "locale\n"
    notice "locale -a\n"
    notice "sudo echo 'aaa'\n"
}

function _clone() {
    # 预先判断
    judge
    apt update -y && apt-get update -y
    apt autoremove -y
    apt autoclean -y
    _log_start "network_config"

    # 静态ip和dns配置
    notice "Reconfigure  Network ?" " (y/n):"
    read -r ch </dev/tty
    if [ "$ch" = "y" ] || [ "$ch" = "Y" ]; then
        network_config
        for_sure "Is That Right ? (y/n):"
        apt install -y resolvconf
        notice "install resolvconf success\n"
        systemctl restart resolvconf.service
        resolvconf -u
        systemctl status resolvconf.service
        notice "current resolv.conf:\n"
        cat /etc/resolv.conf
        ping -c 5 www.baidu.com
        dig www.baidu.com
        nslookup -debug www.baidu.com
    else
        echo "skip"
        sleep 2
    fi
    _log_end

    # 语言设置 鼠标滚轮可以快速滚动
    _log_start "Language Config"
    notice "Reconfigure Language ?" " (y/n):"
    read -r cho </dev/tty
    if [ "$cho" = "y" ] || [ "$cho" = "Y" ]; then
        # 鼠标滚轮可以快速滚动
        dpkg-reconfigure locales
        notice "locale : \n"
        locale
        notice "locale -a : \n"
        locale -a
    else
        echo "skip"
        sleep 2
    fi
    _log_end

    # 安装一些必备软件
    apt install -y net-tools build-essential openssh-server curl unzip zip tree cmake jq
    apt install -y shellcheck shfmt tmux universal-ctags

    # 修改 hostname
    show_hostname
    notice "Reconfigure hostname ?" " (y/n):"
    read -r choice1 </dev/tty
    if [ "$choice1" = "y" ] || [ "$choice1" = "Y" ]; then
        # 获取当前主机名
        CURRENT_HOSTNAME=$(hostname)
        notice "Please Input The New HostName:"
        read -r new_hostname </dev/tty
        if [ -n "$new_hostname" ]; then
            notice "Are you sure you want to reconfigure hostname to '$new_hostname' ? (y/n):"
            read -r choice2 </dev/tty
            if [ "$choice2" = "y" ] || [ "$choice2" = "Y" ]; then
                # 设置主机名
                hostnamectl set-hostname "$new_hostname"
                # 修改 /etc/hosts 中的主机名
                if grep -q "$CURRENT_HOSTNAME" /etc/hosts; then
                    # 替换现有主机名
                    sudo sed -i "s/$CURRENT_HOSTNAME/$new_hostname/g" /etc/hosts
                else
                    # 如果未找到当前主机名，追加新主机名
                    echo "127.0.1.1 $new_hostname" | tee -a /etc/hosts
                fi
                notice "/etc/hosts has been edited \n"
                show_hostname
            else
                echo "skip"
                sleep 2
            fi
        else
            echo "new_hostname is blank; skip"
            sleep 2
        fi
    else
        echo "skip."
        sleep 2
    fi

    echo "######################################################"
    notice "new static ip is: $static_ip\n"
    notice "ssh $user_name@$static_ip\n"
    echo "######################################################"
    notice "May be need to Check MAC address .\n"
    notice "May be need reboot.\n"
    echo "######################################################"

    # 因为 A、B 和 C 虚拟机的 SSH 主机密钥是克隆时复制过来的，三台虚拟机的密钥相同，所以 SSH 客户端会认为它们是同一台主机。
    # ssh连接这三台机器时,本地~/.ssh/known_hosts 文件中这三台机器的指纹完全相同;
    # 当你尝试通过 SSH 连接到主机时，SSH 客户端会检查该主机的指纹是否与之前记录的匹配。如果三台虚拟机的指纹相同，当你切换连接到另一个虚拟机时，SSH 客户端会认为主机身份可能被篡改，提示警告
    # 主机指纹的目的是确保客户端连接到正确的服务器。如果三台虚拟机的指纹相同，客户端无法区分它们。这可能会带来以下问题：
    #	•	中间人攻击更容易成功，因为客户端无法验证主机的唯一性。
    #	•	如果某台虚拟机被攻破，攻击者可能利用相同的指纹冒充其他虚拟机
    # 管理混乱: 在使用工具（如 Ansible、SSH 配置文件）管理多台主机时，相同的指纹可能导致配置错误或意外连接到错误的主机
    # 尽量为每台虚拟机生成唯一的 SSH 主机密钥，确保指纹唯一性，以避免潜在问题并提高系统安全性。

    notice "After reboot; You Need To regenerate SSH Host Key In Linux Visual Machine. \n"
    notice "sudo rm -f /etc/ssh/ssh_host_* \n"
    notice 'sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" \n'
    notice 'sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N "" \n'
    notice 'sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N "" \n'
    notice "sudo systemctl restart ssh \n"
    # ssh-keygen: 用于生成 SSH 密钥的工具; -t rsa: 指定生成密钥的类型为 RSA。RSA 是一种常用的公钥算法
    # -f /etc/ssh/ssh_host_rsa_key : 指定生成的密钥文件的路径和文件名; 公钥会自动生成在相同路径，文件名为 /etc/ssh/ssh_host_rsa_key.pub ; 私钥存储在同目录 /etc/ssh/ssh_host_rsa_key
    # -N ""   : 双引号不能去掉; 设置密钥的密码为空;空密码适用于 SSH 主机密钥，因为它们需要在没有人工干预的情况下由 SSH 服务自动使用
    echo "######################################################"
    notice "Next Step in Client Machine: \n"
    notice "ssh-keygen -R <VM Ip> \n"
    notice 'ssh-keygen -R "172.16.106.110" \n'
    notice 'ssh-keygen -R "172.16.106.120" \n'
    notice 'ssh-keygen -R "172.16.106.130" \n'
    notice 'cat ~/.ssh/known_hosts \n'
    notice "These Command above will delete <IP+Fingerprint> in ~/.ssh/known_hosts \n"
    notice "Now run SSH agin to regenerate Fingerprint in ~/.ssh/known_hosts \n"
    echo "######################################################"
}

if [ -z "$after_clone" ] || [ "$after_clone" != "clone" ]; then
    # 执行安装
    run
else
    # 执行clone的逻辑处理
    _clone
fi
