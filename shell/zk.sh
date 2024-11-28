#! /bin/bash
# This is controller for start/stop-zk-all.sh .
set -e

# https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz
################### local ######################
local_zk_home='/Users/logan/Data/Software/zookeeper'
#localDirArray=()
localDirArray=(
    "cluster/zookeeper1"
    "cluster/zookeeper2"
    "cluster/zookeeper3"
)

################# remote ######################
# remote ip
remoteHosts=("1,1,1,1")
# remote dir
remoteDir="/usr/local/software/zookeeper"

################## function ###################
startRemote() {
    echo -e "\033[31m  启动远程的  \033[0m"
    index=1
    for host in "${remoteHosts[@]}"; do
        echo -e "\033[31m Zookeeper$index start on $host... \033[0m"
        # 不用管, $remoteDir 就是要在客户端解析
        # shellcheck disable=SC2029
        ssh "root@$host" "source /etc/profile; $remoteDir/bin/zkServer.sh start"
        echo -e "\n"
        index=$((index + 1))
        sleep 1
    done
}
startLocal() {
    echo -e "\033[31m  启动本地的  \033[0m"
    index=1
    for dir in "${localDirArray[@]}"; do
        absolute_dir="$local_zk_home/$dir"
        echo -e "\033[31m Zookeeper$index start on $absolute_dir... \033[0m"
        "$absolute_dir/bin/zkServer.sh" start
        echo -e "\n"
        index=$((index + 1))
        sleep 1
    done
}

stopRemote() {
    echo -e "\033[31m  终止远程的  \033[0m"
    index=1
    for host in "${remoteHosts[@]}"; do
        echo -e "\033[31m Zookeeper$index stop on $host... \033[0m"
        # 不用管, $remoteDir 就是要在客户端解析
        # shellcheck disable=SC2029
        ssh "root@$host" "source /etc/profile; $remoteDir/bin/zkServer.sh stop"
        echo -e "\n"
        index=$((index + 1))
        sleep 1
    done
}
stopLocal() {
    echo -e "\033[31m  终止本地的  \033[0m"
    index=1
    for dir in "${localDirArray[@]}"; do
        absolute_dir="$local_zk_home/$dir"
        echo -e "\033[31m Zookeeper$index stop on $absolute_dir... \033[0m"
        "$absolute_dir/bin/zkServer.sh" stop
        echo -e "\n"
        index=$((index + 1))
        sleep 1
    done
}

checkRemote() {
    echo -e "\033[31m  检查远程的  \033[0m"
    index=1
    for host in "${remoteHosts[@]}"; do
        echo -e "\033[31m Zookeeper$index check on $host... \033[0m"
        # 不用管, $remoteDir 就是要在客户端解析
        # shellcheck disable=SC2029
        ssh "root@$host" "source /etc/profile; $remoteDir/bin/zkServer.sh status"
        echo -e "\n"
        index=$((index + 1))
        sleep 1
    done
}
checkLocal() {
    echo -e "\033[31m  检查本地的  \033[0m"
    index=1
    for dir in "${localDirArray[@]}"; do
        absolute_dir="$local_zk_home/$dir"
        echo -e "\033[31m Zookeeper$index check on $absolute_dir... \033[0m"
        "$absolute_dir/bin/zkServer.sh" status
        echo -e "\n"
        index=$((index + 1))
        sleep 1
    done
}

################# output #######################
one="\033[31m[ 1 ]\033[0m Start Zookeeper.\n"
two="\033[31m[ 2 ]\033[0m Stop Zookeeper.\n"
three="\033[31m[ 3 ]\033[0m Check Zookeeper status.\n"
four="\033[31m[ 4 ]\033[0m Exit.\n"

echo -e "$one$two$three$four"

read -rp "Input your choice : " choice

################ execute #######################
if [ "$choice" == "1" ]; then
    if [[ ${#localDirArray[@]} -gt 0 ]]; then
        startLocal
    elif [[ ${#remoteHosts[@]} -gt 0 ]]; then
        startRemote
    fi
elif [ "$choice" == "2" ]; then
    if [[ ${#localDirArray[@]} -gt 0 ]]; then
        stopLocal
    elif [[ ${#remoteHosts[@]} -gt 0 ]]; then
        stopRemote
    fi
elif [ "$choice" == "3" ]; then
    if [[ ${#localDirArray[@]} -gt 0 ]]; then
        checkLocal
    elif [[ ${#remoteHosts[@]} -gt 0 ]]; then
        checkRemote
    fi
elif [ "$choice" == "4" ]; then
    exit
else
    echo "ERROR: There is no such choice,please input the right number."
fi
