#! /bin/bash
# This is controller for start/stop-zk-all.sh .
set -e

################### local ######################
localDirArray=(
    "cluster/zookeeper1"
    "cluster/zookeeper2"
    "cluster/zookeeper3"
)

################# remote ######################
# remote ip
remoteHosts=("1,1,1,1")
# remote dir
remoteDir="/usr/local/software/zookeeper-3.8.0"

################## function ###################
startRemote() {
    index=1
    for host in "${remoteHosts[@]}"; do
        echo -e "\033[31m Zookeeper$index start on $host... \033[0m"
        ssh "root@$host" "source /etc/profile; $remoteDir/bin/zkServer.sh start"
        echo -e "\n"
        index=$((index + 1))
        sleep 1s
    done
}
startLocal() {
    index=1
    for dir in "${localDirArray[@]}"; do
        echo -e "\033[31m Zookeeper$index start on $dir... \033[0m"
        "$dir/bin/zkServer.sh" start
        echo -e "\n"
        index=$((index + 1))
        sleep 1s
    done
}

stopRemote() {
    index=1
    for host in "${remoteHosts[@]}"; do
        echo -e "\033[31m Zookeeper$index stop on $host... \033[0m"
        ssh "root@$host" "source /etc/profile; $remoteDir/bin/zkServer.sh stop"
        echo -e "\n"
        index=$((index + 1))
        sleep 1s
    done
}
stopLocal() {
    index=1
    for dir in "${localDirArray[@]}"; do
        echo -e "\033[31m Zookeeper$index stop on $dir... \033[0m"
        "$dir/bin/zkServer.sh" stop
        echo -e "\n"
        index=$((index + 1))
        sleep 1s
    done
}

checkRemote() {
    index=1
    for host in "${remoteHosts[@]}"; do
        echo -e "\033[31m Zookeeper$index check on $host... \033[0m"
        ssh "root@$host" "source /etc/profile; $remoteDir/bin/zkServer.sh status"
        echo -e "\n"
        index=$((index + 1))
        sleep 1s
    done
}
checkLocal() {
    index=1
    for dir in "${localDirArray[@]}"; do
        echo -e "\033[31m Zookeeper$index check on $dir... \033[0m"
        "$dir/bin/zkServer.sh" status
        echo -e "\n"
        index=$((index + 1))
        sleep 1s
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
