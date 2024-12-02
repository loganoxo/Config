#!/usr/bin/env bash
#
# 脚本名称: install.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux装机脚本; 包括命令行工具等
# 前提: pre.sh; 要安装 sudo
# 使用:
# 一、使用 github
# 1.用wget(debian默认安装)
# wget -q -O- --header="Cache-Control: no-cache" "https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/install.sh?$(date +%s)" | bash -s -- $ZSH_VERSION
# 2.用curl(debian等linux可能没有预装)
# curl -fsSL -H "Cache-Control: no-cache" "https://raw.githubusercontent.com/loganoxo/Config/master/linux/install/install.sh?$(date +%s)" | bash -s -- $ZSH_VERSION

# 二、也可以放在nginx中
# wget -q -O- --header="Cache-Control: no-cache" "http://192.168.0.101:18080/install.sh?$(date +%s)" | bash -s -- $ZSH_VERSION
# curl -fsSL -H "Cache-Control: no-cache" "http://192.168.0.101:18080/install.sh?$(date +%s)" | bash -s -- $ZSH_VERSION
# 提示信息不能使用中文,因为linux自己的tty终端不支持中文

set -e #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行
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
    _log_start "judge"
    if [ -z "$flag" ]; then
        echo "only run in zsh"
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
    echo -en "\033[31m#############################################################  END  #############################################################\033[0m\n\n"
}

# 预先判断
judge
sudo apt update -y

# 为当前用户启用zsh环境
cd ~
# 安装 git
sudo apt install -y git
git --version

# 安装shell插件
_log_start "Install shel plugin"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
rm -f ~/.zshrc.pre-oh-my-zsh
# 如果您将 Oh My Bash 安装脚本作为自动安装的一部分运行，则可以将--unattended标志传递给install.sh脚本。这将不会尝试更改默认 shell，并且在安装完成后也不会运行bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
rm -f ~/.bashrc.omb-backup-*
curl -sS https://starship.rs/install.sh | sh
_log_end

# 环境搭建
_log_start "Environment construction"
mkdir -p ~/.aria2 ~/.config ~/.ssh ~/.shell_bak ~/software ~/Data ~/.local/bin ~/.config/navi ~/.zoxide ~/.undodir ~/.vim ~/Temp ~/share
git clone https://github.com/loganoxo/Config.git ~/Data/Config
mv ~/.bashrc ~/.shell_bak/ && mv ~/.profile ~/.shell_bak/ && mv ~/.zshrc ~/.shell_bak/
bash ~/Data/Config/my-ln.sh
sudo bash ~/Data/Config/linux/for_root/create_root_files.sh "$HOME"
sudo ln -sf ~/Data/Config/vim/settings.vim /root/.vimrc
source "$HOME/.zshrc"
_log_end

# git 私钥
_log_start "git private key"
github_key_url=""
notice "Need To Download Github Private Key ?" " (y/n):"
read -r choice1 </dev/tty
if [ "$choice1" = "y" ] || [ "$choice1" = "Y" ]; then
    notice "Use 'http://192.168.0.101:18080/loganoxo-GitHub' ? " " (y/n):"
    read -r choice2 </dev/tty
    if [ "$choice2" = "y" ] || [ "$choice2" = "Y" ]; then
        github_key_url="http://192.168.0.101:18080/loganoxo-GitHub"
    else
        notice "Please Input The github_key_url .\n"
        echo -n "Input github_key_url:"
        read -r github_key_url </dev/tty
        if [ -z "$github_key_url" ]; then
            echo "Operation cancelled. Script stopped."
            exit 1 #脚本停止
        fi
        for_sure "Use '$github_key_url' ?" " (y/n):"
    fi
    wget -P "$HOME/.ssh/" --header="Cache-Control: no-cache" "$github_key_url"
    ssh -T git@github.com || true
fi
_log_end

# 安装必备工具
function _install_system_tools() {
    _log_start "_install_system_tools"
    # 安装防火墙
    sudo apt install -y ufw
    sudo ufw status #inactive，说明 UFW 未启用
    # 默认情况下，UFW 会阻止所有传入的网络流量，除非明确允许。例如，如果没有添加允许 SSH 的规则，远程登录将会被拒绝;
    # 默认情况下，UFW 会允许所有传出的网络流量，比如从本机访问互联网的请求
    # UFW 的 allow 命令默认允许的是传入流量; ufw allow ssh 等效于 ufw allow in ssh ;  传出的用法如: ufw allow out 53
    sudo ufw disable #禁用
    sudo ufw default deny incoming && sudo ufw default allow outgoing
    # enable之前先开放 ssh 端口, 否则远程连接会断开; 允许SSH（端口 22） HTTP（端口 80） HTTPS（端口 443）
    sudo ufw allow ssh && sudo ufw allow http && sudo ufw allow https && sudo ufw allow 80
    sudo ufw allow 6000:6007/tcp && sudo ufw allow 6000:6007/udp #允许使用端口 6000-6007 的 连接
    sudo ufw limit ssh                                           # 限制ssh登录尝试的连接次数,防止暴力破解密码;每个ip每30秒最多尝试6次
    sudo ufw enable                                              #启用
    sudo ufw status verbose                                      #查看所有端口开放情况

    # 安装 nginx
    sudo apt install -y nginx
    #sudo systemctl list-unit-files --state=enabled #查看所有自启动的软件
    sudo systemctl disable nginx.service #禁止nginx开机自启
    sudo systemctl start nginx
    curl http://127.0.0.1:80 #测试
    sudo systemctl stop nginx
    sudo systemctl status nginx

    # 安装 go
    sudo apt install -y golang-go
    go version
    _log_end
}

# 安装 命令行工具
function _install_CLI_tools() {
    _log_start "_install_CLI_tools"
    # 安装 bat
    sudo apt install -y bat #这样安装的bat会因为避免名字冲突而让他的命令变为 batcat, 所以需要符号链接
    # 切换到普通用户执行:
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat

    # 安装fzf
    # sudo apt install -y fzf #版本太低了
    mkdir -p ~/software
    git clone https://github.com/junegunn/fzf.git ~/software/fzf
    wget -P "$HOME/software/fzf/" https://github.com/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-linux_arm64.tar.gz
    tar -xzf ~/software/fzf/fzf-0.56.3-linux_arm64.tar.gz -C ~/software/fzf
    ln -sf ~/software/fzf/fzf ~/.local/bin/fzf

    # 安装fd
    sudo apt install -y fd-find
    ln -s "$(which fdfind)" ~/.local/bin/fd

    # 安装zoxide
    mkdir -p ~/.zoxide
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

    # 安装vim
    mkdir -p ~/.undodir ~/.vim
    sudo apt install -y vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    # 测试 :PlugStatus :PlugInstall  :PlugClean
    vim -c ':PlugStatus' -c ':PlugInstall' -c ':PlugClean' -c ':qa!'

    # 安装sdkman
    curl -s "https://get.sdkman.io?rcupdate=false" | bash #不修改zshrc 和 bashrc
    source "$HOME/.zshrc"
    sdk version
    sdk install java 8.0.432.fx-zulu
    sdk install java 11.0.25.fx-zulu
    sdk install java 17.0.13.fx-zulu
    sdk install java 17.0.13-zulu
    sdk install java 17.0.12-oracle #设为默认
    sdk install java 17.0.13-tem
    sdk default java 17.0.12-oracle
    sdk install maven 3.9.9
    sdk default maven 3.9.9
    # 重启虚拟机
    # sdk list java
    # java -version
    # sdk list maven
    # mvn -version
    # java -XshowSettings:properties -version #查看安装的jdk详细版本信息

    # 安装fnm
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell #不修改zshrc 和 bashrc
    ln -s ~/.local/share/fnm/fnm ~/.local/bin/fnm
    source "$HOME/.zshrc"
    fnm -V               #查看fnm的版本
    fnm ls               #查看本地已安装的nodejs的版本
    fnm current          #打印当前使用的node版本
    fnm install --lts    #安装最新的LTS版本,会自动加别名 default, lts-latest
    fnm install --latest #安装最新的版本,会自动加别名 latest
    fnm default lts-latest
    fnm alias lts-latest lts
    which -a npm
    npm -g install nrm pm2 prettier yarn yrm
    npm list -g
    nrm ls
    nrm use taobao
    # fnm ls-remote                      #通过网络查看所有已发布的nodejs版本
    # fnm ls-remote --lts                #通过网络查看所有已发布的长期支持的nodejs版本
    # fnm ls-remote --sort <SORT>        #默认asc升序,desc为倒序
    # fnm install v18.3.0              #安装指定的版本
    # fnm install 17                   #部分版本匹配,从你的部分输入中猜测最新的可用版本,它将安装版本为v17.9.1 的节点
    # fnm use <alias/version>          #在当前shell中临时使用某个版本的node
    # fnm use 22
    # fnm use lts-latest
    # fnm use default
    # fnm default <alias/version>      #将某个版本设为默认版本;即新shell中默认使用的node版本
    # fnm uninstall <alias/version>    #卸载某个版本
    # fnm 给某node版本起别名,用于让其他命令在使用时,将版本号用别名替换;
    # fnm alias [OPTIONS] <alias/version> <NAME>  设置别名; 别名唯一;
    # 若此次设置的别名 aaa 与其他版本的别名重复,则会自动取消之前的别名,给这个命令里的版本17设置别名 aaa
    # fnm alias 17 aaa
    # fnm unalias [OPTIONS] <alias_name>  取消别名
    # fnm unalias lts

    # 安装rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.zshrc"
    rustc --version

    # 安装navi
    # 方法一,用cargo
    cargo install --locked navi
    # 方法二,自己编译,有问题
    # git clone https://github.com/denisidoro/navi && cd navi
    # make BIN_DIR=/home/helq/.local/bin install
    # 方法三,用脚本,有问题,在debian上执行不了
    # BIN_DIR=/home/helq/.local/bin bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)

    # tldr
    cargo install tealdeer
    tldr --update
    tldr bat
    tldr -L zh tree

    # glow
    mkdir -p ~/software
    wget -P "$HOME/software" https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Linux_arm64.tar.gz
    tar xvzf ~/software/glow_2.0.0_Linux_arm64.tar.gz -C "$HOME/software/"
    mv ~/software/glow_2.0.0_Linux_arm64 ~/software/glow
    ln -s ~/software/glow/glow ~/.local/bin/glow

    # the_silver_searcher
    sudo apt install -y silversearcher-ag

    # trash-cli https://github.com/andreafrancia/trash-cli
    sudo apt install -y python3 python3-pip python3-venv
    sudo apt install -y trash-cli # 版本很低
    sudo mkdir --parent /.Trash
    sudo chmod a+rw /.Trash
    sudo chmod +t /.Trash

    # uv 包含了 pipx 的功能  https://docs.astral.sh/uv/
    # 默认是managed: 最先找uv管理的python,其次找系统python(若此时在conda的某个环境中,conda该环境的python也会被找到),最后才下载;only-managed:只找uv管理的python,没有则下载;
    # # 安装选项:https://docs.astral.sh/uv/configuration/installer/#disabling-shell-modifications
    curl -LsSf https://astral.sh/uv/install.sh | sh # 默认在 ~/.local/share/uv/
    source "$HOME/.zshrc"
    export UV_PYTHON_PREFERENCE="only-managed"
    # uv python list
    uv python install # 默认在 ~/.local/share/uv/python/
    uv python install 3.12
    # uv python uninstall 3.12
    # uv tool list
    uv tool install ruff # 安装命令行工具,默认在 ~/.local/bin/  ~/.local/share/uv/tools/
    # uv tool install ruff -p 3.12 # 指定安装的命令行工具的虚拟环境中的python版本
    ruff --version
    # ruff check a.py # 这个命令的功能: 检查python代码是否有问题
    # uv tool uninstall ruff
    # 命令补全: https://docs.astral.sh/uv/getting-started/installation/#upgrading-uv

    # 安装miniconda  linux 静默安装
    mkdir -p ~/Temp
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/Temp/miniconda.sh
    bash ~/Temp/miniconda.sh -b -u -p ~/.miniconda3 # -b:不对 shell 脚本进行 PATH 修改,以非交互模式（静默模式）运行安装; -u:如果指定的安装路径（通过 -p）已有 Miniconda 安装，它会更新而不是报错或覆盖安装; -p: 指定安装路径
    rm ~/Temp/miniconda.sh
    source "$HOME/.zshrc"
    conda --version
    conda create -n env_test python=3.9 # -n 是创建的环境的名字
    conda activate env_test
    python3 -V
    conda activate # 默认是base环境
    python3 -V
    conda deactivate || true
    conda deactivate || true
    conda deactivate || true
    # 静默安装后,可选择shell环境,会修改 .zshrc .bashrc
    # conda init zsh
    # conda init bash
    # conda init --all # 在所有可用 shell 上初始化 conda
    # conda list
    # conda info
    # base环境 推荐 只能用于安装 anaconda、conda 和 conda 相关的软件包，例如`anaconda-client`或`conda-build`
    # 配置文件 : ~/.condarc
    # conda config --set auto_activate_base false # 设置开启新shell的时候不自动进入conda的base环境
    # conda config --set changeps1 False          # 抑制 conda 自己的提示修饰符
    # conda config --add channels conda-forge 会加在第一个
    # conda config --append channels conda-forge
    # conda config --remove channels conda-forge
    # conda -V
    # conda update conda # 更新自己
    # 安装包或者命令行工具
    # conda install trash-cli                # 官方的 channel 没有很多的开源包
    # conda install -c conda-forge trash-cli # 指定 conda-forge 的channel
    # install的命令行工具的执行文件放在当前环境的bin目录下,如 /home/helq/miniconda3/envs/env_test/bin/trash-put; 同时也会被pip管理
    # install 也可以安装python库文件,可以在 Python 脚本或交互式环境中直接导入并使用 import numpy as np
    # 卸载conda
    # rm -rf ~/conda
    # rm -rf ~/.condarc ~/.conda ~/.continuum
    # 导出某个非base环境到yaml文件; 仅将 Anaconda 或 Miniconda 文件复制到新目录或另一台计算机不会重新创建环境。您必须将环境作为一个整体导出
    # conda activate env_test
    # conda export -f env_test.yml --no-builds 或者 conda env export -f env_test.yml --no-builds
    # --override-channels 不导出.condarc里的channel;
    # --no-builds 不导出构建编号,当跨平台迁移的时候必加,因为同一个版本的包在不同平台上的构建编号肯定不同;如: mac导出到linux上的时候
    # 导入
    # conda env create -f env_test.yml

    # docker
    # https://docs.docker.com/engine/install/debian/#install-using-the-repository
    sudo apt update -y
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove -y $pkg; done #卸载冲突的包
    sudo apt autoremove -y

    # Set up Docker's `apt` repository
    # Add Docker's official GPG key:
    sudo apt-get update -y && sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update -y

    # Install the Docker packages
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    # Verify
    sudo docker run hello-world
    sudo docker images
    sudo docker container ls -a

    # 以非 root 用户身份管理 Docker;
    # 创建一个名为`docker`的 Unix 组并向其中添加用户。当 Docker 守护进程启动时，它会创建一个可供`docker`组成员访问的 Unix 套接字
    sudo groupadd docker || true  # 创建`docker`组
    sudo usermod -aG docker $USER # 将您的用户添加到`docker`组
    newgrp docker                 # 执行这条命令也可以立即切换到新组
    # sudo reboot                   # 或者注销并重新登录，以便重新评估您的组成员身份
    # docker run hello-world        # 验证您是否可以在没有`sudo`情况下运行`docker`命令
    # 如果在分配用户组之前 用sudo权限 执行过 docker CLI 中的如 docker login 这类命令, 会创建 ~/.docker 目录;
    # 在上述的情况下, 分配用户组后, 用普通用户直接执行 docker 命令, 有可能会报错, 因为 ~/.docker 的权限是 root 用户的; 报错信息可能为:
    # WARNING: Error loading config file: /home/user/.docker/config.json -stat /home/user/.docker/config.json: permission denied
    # 解决方式一: 删除`~/.docker/`目录（它会自动重新创建，但所有自定义设置都会丢失）
    # 方式二:
    # sudo chown "$USER":"$USER" /home/"$USER"/.docker -R # 将这个文件夹的 拥有者 和 所属组 设为当前用户;-R：递归修改，即包括子目录和文件
    # sudo chmod g+rwx "$HOME/.docker" -R                 # 为 .docker 目录及其内容增加组权限，使所属组的成员可以读取（read）、写入（write）、执行（execute）文件。
    # 在 Debian 和 Ubuntu 上，Docker 服务(守护进程)(不是指的容器) 默认在启动时启动
    sudo systemctl status docker.service     # 这是 Docker 的主服务，负责管理 Docker 守护进程（dockerd），提供核心功能，包括容器管理、镜像拉取和存储等
    sudo systemctl status containerd.service # 这是 containerd 容器运行时服务，是一个独立的守护进程，用于管理容器的生命周期

    # sudo systemctl enable docker.service
    # sudo systemctl enable containerd.service

    # 禁止开机启动;但是当使用docker命令时,这两个服务会自动启动
    sudo systemctl disable docker.service
    sudo systemctl disable containerd.service

    # 其他安装
    sudo apt install -y shellcheck shfmt tmux universal-ctags
    _log_end
}

# 安装 文件上传下载服务-dufs-filebrowser
function _install_file_server() {
    _log_start "_install_file_server"
    source "$HOME/.zshrc"
    mkdir -p ~/share

    # 安装 dufs
    cargo install dufs
    mkdir -p ~/share/dufs
    sudo ufw allow 5000
    # dufs                          # 以只读模式提供当前目录,只允许查看和下载;默认在前台执行
    # nohup dufs >output.log 2>&1 & # 后台启动
    # jobs -l                       # 查看后台启动程序; kill PID
    # dufs -A                       # 允许所有操作，如上传/删除/搜索/创建/编辑
    # dufs --allow-upload           # 只允许查看和下载和上传操作
    # --allow-archive 允许文件夹打包下载; --allow-search 允许搜索
    # dufs ~/share/dufs                # 指定某个目录
    # dufs linux-distro.iso            # 指定单个文件
    # dufs -a admin:123@/:rw           # 指定用户名admin/密码123
    # dufs -b 127.0.0.1 -p 80          # 监听特定ip和端口
    # dufs --hidden .git,.DS_Store,tmp # 隐藏目录列表中的路径
    # dufs --hidden '.*'               # hidden dotfiles
    # dufs --hidden '*/'               # hidden all folders
    # dufs --hidden '*.log,*.lock'     # hidden by exts
    # dufs --hidden '*.log' --hidden '*.lock'
    # dufs --render-index # 使用index.html 提供静态网站
    # dufs --render-spa   # 提供像 React/Vue 这样的单页应用程序

    ############################
    # 安装 filebrowser docker模式
    mkdir -p ~/share/filebrowser
    mkdir -p ~/share/filebrowser/files
    touch ~/share/filebrowser/filebrowser.db
    touch ~/share/filebrowser/filebrowser.json

    cat >~/share/filebrowser/filebrowser.json <<EOF
{
  "port": 80,
  "baseURL": "",
  "address": "",
  "log": "stdout",
  "database": "/database/filebrowser.db",
  "root": "/srv"
}
EOF
    sudo ufw allow 12786
    docker run -d \
        -v ~/share/filebrowser/files:/srv \
        -v ~/share/filebrowser/filebrowser.db:/database/filebrowser.db \
        -v ~/share/filebrowser/filebrowser.json:/.filebrowser.json \
        -u $(id -u):$(id -g) \
        -p 12786:80 \
        filebrowser/filebrowser
    _log_end
}

# 开启 SFTP 服务
function _enable_sftp() {
    _log_start "_enable_sftp"
    # 确保系统已安装 OpenSSH 服务器 默认应该都存在并启动了sftp服务的
    sudo apt update -y
    sudo apt install -y openssh-server
    # 检查 SSH 服务状态
    sudo systemctl status ssh

    # 查看 /etc/ssh/sshd_config 这个文件内是否存在:
    # override default of no subsystems
    # Subsystem sftp /usr/lib/openssh/sftp-server
    # 若存在则自动为所有创建的用户打开sftp服务,root能访问和修改所有文件; 普通用户能查看所有文件,但是只能修改自己有权限的文件
    # 所以为了安全性,可以添加一个只能sftp连接不能ssh登录shell的用户,并限制这个用户 使用 SFTP 能使用的目录;主要目的是为了不暴露普通用户密码给别人

    # ChrootDirectory 指定的目录及其父目录必须满足以下条件:1、由 root 拥有;2、不可被其他用户写入（即权限中不能有 write 权限分配给非 root 用户）;这意味着普通用户的主目录（比如 /home/sftpuser），无法直接作为 ChrootDirectory，因为主目录通常是由该用户自己拥有的，而不是 root
    # 解决办法:1、创建一个由 root 拥有的顶层目录（例如 /var/sftp），保证它不可写;2、在顶层目录下创建一个子目录（例如 /var/sftp/sftpuser），将该子目录的所有权赋予用户（例如 sftpuser），以允许用户上传文件
    sudo useradd -s /sbin/nologin sftpuser # 创建一个新用户，该用户仅被授予对服务器的文件传输访问权限; 不能登录shell,没有home目录
    # -m 会创建home目录; -d <path> 自定义home目录
    notice "set sftpuser password. \n"
    sudo passwd sftpuser # 添加密码    123456
    sudo mkdir -p /var/sftp/sftpuser
    sudo chown root:root /var/sftp
    sudo chmod 755 /var/sftp                        # root用户为7所有权限; 同组用户和不同组的用户为5只允许读和执行; 4:读 2:写 1:执行
    sudo chown sftpuser:sftpuser /var/sftp/sftpuser # 将目录的所有权更改为您刚刚创建的用户
    sudo chmod 775 /var/sftp/sftpuser               # 同组用户可以读和写(目录必须有执行权限才能cd进入);其他用户只读
    sudo usermod -aG sftpuser $(whoami)             # 把当前用户加入 sftpuser 用户组,让当前用户可以操作`分享目录`,就让当前用户可以将自己的文件复制到这个`分享目录中`了
    getent group sftpuser                           # 查看用户组中有哪些用户
    # 权限组生效要重新登录

    ## 修改 SSH 服务器配置以禁止sftpuser用户的终端访问，但允许文件传输访问
    # sudo vim /etc/ssh/sshd_config # 滚动到文件的最底部并添加以下配置片段;
    # 或者检查 /etc/ssh/sshd_config 中是否存在 Include /etc/ssh/sshd_config.d/*.conf 字样; 可如下方加一个新文件被引入
    ################################
    sudo touch /etc/ssh/sshd_config.d/sftp.conf
    # su
    sudo tee /etc/ssh/sshd_config.d/sftp.conf >/dev/null <<EOF
Match User sftpuser
    ForceCommand internal-sftp
    PasswordAuthentication yes
    ChrootDirectory /var/sftp
    PermitTunnel no
    AllowAgentForwarding no
    AllowTcpForwarding no
    X11Forwarding no
EOF

    ################################
    # su helq
    sudo sshd -t                # 测试
    sudo systemctl restart sshd # 重启或重新加载 SSH 服务
    # 到 其他机器上 :
    # 验证ssh是否关闭
    # ssh sftpuser@your_server_ip # 会收到 This service allows sftp connections only.表示连接失败,无法再使用 SSH 访问 shell
    # 验证sftp是否开启
    # sftp sftpuser@your_server_ip # 此命令将生成带有交互式提示的成功登录消息;可以在提示符中使用`ls`列出目录内容
    ############## 或者可以通过 sftp客户端界面(Cyberduck或FileZilla等) 连接访问

    # Match User sftpuser            告诉 SSH 服务器仅将以下命令应用于指定的用户
    # ForceCommand internal-sftp     强制 SSH 服务器在登录时运行 SFTP 服务器，确保其只能上传/下载文件,禁止 shell 登录访问。
    # PasswordAuthentication yes     允许该用户进行密码验证;不然可能需要用户使用基于密钥的验证
    # ChrootDirectory /var/sftp/     确保不允许用户访问/var/sftp目录之外的任何内容,/var/sftp 必须由 root 拥有，且不可被其他用户写入,在 /var/sftp 内，可以创建用户有写权限的子目录，如 /var/sftp/sftpuser
    # PermitTunnel                   禁止 SSH 隧道功能,提高安全性，防止用户滥用隧道功能绕过网络限制
    # AllowAgentForwarding           禁止 SSH 代理转发功能,端口转发、隧道和 X11 转发,进一步限制用户的功能，防止代理滥用
    # AllowTcpForwarding             禁止 TCP 转发功能,防止用户通过 SSH 隧道代理访问内部网络或外部服务器
    # X11Forwarding                  禁止 X11 图形界面转发,减少不必要的功能支持，提高安全性
    # 这组命令从Match User开始，也可以为不同的用户复制和重复。确保相应地修改Match User行中的用户名
    _log_end
}

# 安装 FTP 服务
function _enable_FTP() {
    _log_start "_enable_FTP"
    sudo apt update -y && sudo apt install -y vsftpd # 默认应该都是没有安装的
    # 开放端口;为 FTP 打开端口`20`和`21`;在启用 TLS 时打开端口`990`; pasv_max_port pasv_min_port 限制可用于被动 FTP 的端口范围40000到50000
    sudo ufw status
    sudo ufw allow from any to any port 20,21,990,40000:50000 proto tcp
    sudo ufw status

    # 创建只用于 ftp 的用户;不允许登录shell
    # chroot_local_user=YES时, ftp要求用户要有home目录,并且home目录不可写
    sudo useradd -s /sbin/nologin -d /var/ftp ftpuser # -m 会创建home目录; -d <path> 自定义home目录
    sudo sh -c 'echo "/sbin/nologin" >> /etc/shells'  # ftp会检查登录的用户的shell是否正常; 这里让 /sbin/nologin 变为有效的登录 shell
    sudo mkdir -p /var/ftp/ftpuser
    sudo chmod 555 /var/ftp            # 让home目录不可写; 4:读 2:写 1:执行
    sudo chown nobody:nogroup /var/ftp # 限制权限，确保进程或服务无法访问不必要的系统资源
    notice "set ftpuser password. \n"
    sudo passwd ftpuser                           # 添加密码    123456
    sudo chown ftpuser:ftpuser /var/ftp/ftpuser   # 将目录的所有权更改为您刚刚创建的用户
    sudo chmod 775 /var/ftp/ftpuser               # 同组用户可以读和写(目录必须有执行权限才能cd进入);其他用户只读
    sudo usermod -aG ftpuser $(whoami)            # 把当前用户加入 ftpuser 用户组,让当前用户可以操作`分享目录`,就让当前用户可以将自己的文件复制到这个`分享目录中`了
    getent group ftpuser                          # 查看用户组中有哪些用户
    sudo useradd -r -M -s /sbin/nologin ftpsecure # 创建一个供nopriv_user使用的低权限用户
    # 权限组生效要重新登录

    sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak # 备份原始文件
    # su
    ####################################################################
    sudo tee /etc/vsftpd.conf >/dev/null <<EOF
# NO: 表示 vsftpd 不会以独立的守护进程方式运行;用于资源受限的系统; 因为 inetd 或 xinetd 在没有连接时不会启动 FTP 服务,从而减少资源占用
# 当 listen=YES 时,vsftpd 只会在 IPv4 地址 上启动并监听 FTP 连接, listen_ipv6就必须为 NO
listen=YES

# 启用对 IPv6 的支持,同时接受来自 IPv4 和 IPv6 的连接
listen_ipv6=NO

# 允许系统中的本地用户使用 FTP 登录
local_enable=YES

# 启用此选项后,所有本地用户在登录时将被限制在他们的HOME目录内,他们无法访问其他系统目录
chroot_local_user=YES
# 用于指定哪些本地用户可以不受 chroot_local_user 功能限制;可以在 chroot_list_file 中列出特定用户
# chroot_list_enable=YES
# chroot_list_file=/etc/vsftpd.chroot_list

# 允许用户使用写操作; 如 上传文件 删除文件
write_enable=YES

# 实际权限 = 默认权限(文件的默认权限是666; 目录的默认权限是777) - umask
local_umask=022

# 每当用户切换到某个目录时,vsftpd 会检查该目录下是否存在一个名为 .message 的文件;如果 .message 文件存在,其内容会显示给用户,作为该目录的欢迎消息或说明
dirmessage_enable=YES

# 目录列表(例如 ls 命令)中的时间戳将显示为服务器本地时区时间
use_localtime=YES

# 启用上传和下载操作的日志记录功能;默认在/var/log/vsftpd.log; 可由选项xferlog_file自定义
xferlog_enable=YES
# 用于指定 vsftpd 的日志文件位置
# xferlog_file=/var/log/vsftpd.log
# 如果启用此选项,日志将采用标准 xferlog 格式,通常与传统 FTP 服务的日志格式兼容;日志文件的默认存储路径会更改为 /var/log/xferlog
# xferlog_std_format=YES

# 指定 FTP 数据连接的来源端口为 20;(21 端口:用于控制连接;接收用户命令并返回响应)
connect_from_port_20=YES

# 默认开启被动模式;需要服务端开放40000-50000的端口,所以对客户端的防火墙很友好
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=50000

# 设置空闲会话的超时时间,单位为秒;如果客户端在此期间没有任何活动(如上传、下载、浏览目录等),则服务器会自动关闭该会话
idle_session_timeout=3600

# 设置数据连接的超时时间,单位为秒;指定了 vsftpd 等待数据连接(例如文件上传、下载等)时的最大空闲时间;如果在这个时间内没有数据传输,连接会被断开
data_connection_timeout=600

# 当 vsftpd 需要执行与 FTP 客户端相关的非特权操作时,它会以 nopriv_user 的身份运行子进程或线程,可以有效地减少可能的安全漏洞
nopriv_user=ftpsecure

# 自定义的登录横幅信息
ftpd_banner=Welcome to blah FTP service.


# 禁用匿名登录,只有本地用户可以登录
anonymous_enable=NO
# 禁止匿名用户上传文件
anon_upload_enable=NO
# 禁止匿名用户创建目录
anon_mkdir_write_enable=NO
# 控制匿名用户上传的文件的所有权设置;用于加强安全性和便于管理;默认情况下,匿名用户上传的文件的所有者是 ftp 或 nobody;通过启用此选项,可以将文件的所有者更改为指定的用户
# chown_uploads=YES
# chown_username=whoever

# 指定一个空目录,作为 vsftpd 的 chroot() 监狱;chroot() 是一个将进程及其子进程的根目录改为指定目录的系统调用。
# 在 vsftpd 中,使用 chroot() 可以将某些用户限制在某个目录（或目录树）中,使得这些用户无法访问系统的其他部分
# 当 FTP 用户登录时,通常会被限制在他们的家目录内。如果启用了 chroot_local_user 或其他类似设置,FTP 用户将无法访问他们家目录以外的文件和目录
# 该目录并不是为用户上传和下载文件的目录,而是用于保护和增强安全性。在一些特定情况下,vsftpd 会切换到该目录,并限制其对文件系统的访问
secure_chroot_dir=/var/run/vsftpd/empty

# 告诉 vsftpd 在进行用户登录认证时,使用 PAM(可插拔认证模块)来进行验证;简单来说,它指定了 FTP 服务器在验证用户身份时,应该使用什么样的认证规则
# PAM 就是一个管理系统登录、密码验证等认证工作的工具;vsftpd 需要验证用户是否能登录,pam_service_name=vsftpd 就是告诉它：在验证时,去找一个专门为 vsftpd 配置的认证规则文件,通常这个文件叫 vsftpd,会放在 /etc/pam.d/ 文件夹里
pam_service_name=vsftpd

# 是否开启 FTPS
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO

# 使用 UTF-8 编码的文件系统
utf8_filesystem=YES

# FTP 服务器将异步处理 ABOR 请求,提高处理效率,但可能存在安全风险
# async_abor_enable=YES

# 专门用于文本文件,启用该选项后,FTP 服务器会在上传/下载文件时进行 ASCII 处理(即转换换行符),可能会增加 CPU 负担和安全隐患
# ascii_upload_enable=YES
# ascii_download_enable=YES

# 启用此选项后,vsftpd 将检查匿名 FTP 用户的电子邮件地址,如果该地址在禁止列表中,用户将无法登录
# deny_email_enable=YES
# 这是存储被禁止的电子邮件地址列表的文件。vsftpd 会检查该文件中的电子邮件地址,并阻止这些地址的匿名用户登录。每行一个电子邮件地址
# banned_email_file=/etc/vsftpd.banned_emails

# 用户使用 ls 命令时,FTP 服务器会列出当前目录及其所有子目录的内容,出于性能考虑,最好保持默认的禁用状态
# ls_recurse_enable=YES
EOF

    #####################################################################

    sudo systemctl restart vsftpd
    _log_end
}

function _install_end() {
    _log_start "_install_end"
    rm -rf ~/Data/Config
    git clone https://github.com/loganoxo/Config.git ~/Data/Config
    _log_end
}

_install_system_tools # 安装必备工具
_install_CLI_tools    # 安装 命令行工具
_install_file_server  # 安装 文件上传下载服务-dufs-filebrowser
_enable_sftp          # 开启 SFTP 服务
_enable_FTP           # 安装 FTP 服务
_install_end          # 重新下载 Config
notice "All Done....... \n"
