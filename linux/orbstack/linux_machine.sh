#!/usr/bin/env bash
#
# 脚本名称: linux_machine.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: orbstack 安装的 linux_machine(类似于WSL) 的初始化脚本

# 默认情况下:
#       OrbStack 创建一个与您的 macOS 用户同名的用户，且未设置密码。 sudo 配置为以 root 身份运行命令而不要求输入密码
#       默认域名为: test.orb.local
#       您在 Linux 计算机中运行的任何服务器都可以从 Mac 访问。例如，如果您在 Linux 中的端口 8000 上运行 Web 服务器，则可以从 Mac 上的localhost:8000访问它
#       您可以使用 host.orb.internal 主机名连接到在 Mac 上运行的服务器

# 1、创建 linux_machine;
# orb create debian:bookworm test
# 2、创建 linux_machine时 ,可以指定用户名
# orb create -u helq debian:bookworm test
# 3、您还可以在创建机器时设置默认密码
# orb create -u helq --set-password debian:bookworm test

# 4、进入 linux_machine ,默认无密码
# orb -m test -u root  或者  orb -u root
# 5、执行 初始化脚本
# orb -m test ./linux_machine.sh

# 6、设置密码(可选)
# orb sudo passwd $USER
# 7、登录默认机器
# ssh orb
# 8、要使用特定机器或用户
# ssh machine@orb
# ssh user@orb
# ssh user@machine@orb
# 9、使用 orb default 更改默认机器

# 脚本使用:
# 1、cd ~ ; mac pull /Users/logan/Data/Config/linux/orbstack/linux_machine.sh;
# 2、bash ./linux_machine.sh "${ZSH_VERSION:-nozsh}" "$USER" 0
# 3、重启虚拟机
# 4、bash ./linux_machine.sh "${ZSH_VERSION:-nozsh}" "$USER" 1

set -e
flag="$1"
user_name="$2"
step="$3"
MAC_HOME="/Users/logan"
export PATH=$PATH:/usr/sbin
GITHUB_TOKEN=""

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

function _logan_source() {
    set +e
    source "$HOME/.bashrc" || true
    set -e
}

function judge() {
    _log_start "judge"
    if [ -z "$user_name" ]; then
        echo "don't have user_name"
        exit 1
    fi

    if [ "$user_name" = "root" ]; then
        echo "don't use root"
        exit 1
    fi

    if [ -z "$step" ]; then
        echo "need step!"
        exit 1
    fi

    if [[ ! "$step" =~ ^[0-9]+$ ]]; then
        echo "Step must be number."
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
    y | Y) return 0 ;;
    *)
        echo "skip!"
        return 1 #跳过
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

function _get_asset_id() {
    OWNER="$1"
    REPO="$2"
    TAG="$3"
    FILE_NAME="$4"
    URL="https://api.github.com/repos/${OWNER}/${REPO}/releases/tags/${TAG}"
    ASSET_ID=$(
        curl --retry 10 --retry-all-errors --retry-delay 10 \
            -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            -H "Accept: application/vnd.github.v3+json" \
            -fsSL "${URL}" |
            jq -r ".assets | .[] | select(.name == \"$FILE_NAME\") | .id"
    )
    if [ -z "$ASSET_ID" ] || [ "$ASSET_ID" = "null" ]; then
        echo "Error: Could not find ASSET_ID for file '${FILE_NAME}' in release '${TAG}'."
    fi
    echo "$ASSET_ID"
}

# 用 github api 下载文件
function _download_release_from_github() {
    local url="$1"
    local alternate_url="$2"
    local file="$3"
    if [ -n "$GITHUB_TOKEN" ]; then
        if [ -n "$file" ]; then
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -H "Accept: application/octet-stream" \
                -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                -fSLo "$file" "$url"
        else
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -H "Accept: application/octet-stream" \
                -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                -fSLO "$url"
        fi
    else
        if [ -n "$file" ]; then
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -fSLo "$file" "$alternate_url"
        else
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -fSLO "$alternate_url"
        fi
    fi
}

# 下载某个文件
function _download_single_file_from_github() {
    local url="$1" # https://api.github.com/repos/OWNER/REPO/contents/PATH ; api 的 url 后面 加 ?ref=develop 可以指定分支
    local alternate_url="$2"
    local file="$3"
    if [ -n "$GITHUB_TOKEN" ]; then
        if [ -n "$file" ]; then
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -H "Accept: application/vnd.github.raw" \
                -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                -fSLo "$file" "$url"
        else
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -H "Accept: application/vnd.github.raw" \
                -H "Authorization: Bearer ${GITHUB_TOKEN}" \
                -fSLO "$url"
        fi
    else
        if [ -n "$file" ]; then
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -fSLo "$file" "$alternate_url"
        else
            curl --retry 10 --retry-all-errors --retry-delay 10 \
                -fSLO "$alternate_url"
        fi
    fi
}

# 用 github api 获取文件内容
function _get_content_from_github() {
    local url="$1" # https://api.github.com/repos/OWNER/REPO/contents/PATH ; api 的 url 后面 加 ?ref=develop 可以指定分支
    local alternate_url="$2"
    if [ -n "$GITHUB_TOKEN" ]; then
        curl --retry 10 --retry-all-errors --retry-delay 10 \
            -H "Accept: application/vnd.github.raw" \
            -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            -fsSL "$url"
    else
        curl --retry 10 --retry-all-errors --retry-delay 10 \
            -fsSL "$alternate_url"
    fi
}

# 准备git
function _git_pre() {
    _log_start "_git_pre"
    sudo apt update -y
    cd "$HOME"
    # 安装 git
    sudo apt install -y git
    git --version
    sudo apt install -y jq

    # github token
    notice "Use GITHUB_TOKEN ?" " (y/n):"
    read -r cho </dev/tty
    if [ "$cho" = "y" ] || [ "$cho" = "Y" ]; then
        echo -n "Please Input The GITHUB_TOKEN:"
        read -r GITHUB_TOKEN </dev/tty
        if [ -z "$GITHUB_TOKEN" ]; then
            echo "Operation cancelled. Script stopped."
            exit 1 #脚本停止
        fi
        notice "Use GITHUB_TOKEN : $GITHUB_TOKEN\n"
    fi
    _log_end
    sleep 1
}

# 预安装配置
function ___pre() {
    sudo apt update -y && sudo apt-get update -y
    sudo apt full-upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean -y
    sudo apt install -y wget net-tools build-essential curl unzip zip tree cmake jq
    sudo apt install -y shellcheck shfmt tmux universal-ctags
    if for_sure "Next Step : Language Config  ? (y/n):"; then
        _log_start "Language Config"
        sudo dpkg-reconfigure locales
        notice "locale : \n"
        locale
        notice "locale -a : \n"
        locale -a
        _log_end
    fi

    _log_start "Install zsh"
    sudo apt install -y zsh
    zsh --version
    chsh -s "$(which zsh)"
    sudo chsh -s "$(which zsh)"
    notice "install zsh success\n"
    _log_end
}

# 安装shell插件
function step1() {
    _log_start "step1"
    sh -c "$(_get_content_from_github "https://api.github.com/repos/ohmyzsh/ohmyzsh/contents/tools/install.sh" \
        "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh")" "" --unattended
    sleep 2
    git clone git@github.com:zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    sleep 2
    git clone git@github.com:zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    rm -f "$HOME/.zshrc.pre-oh-my-zsh"
    sleep 2

    # 如果您将 Oh My Bash 安装脚本作为自动安装的一部分运行，则可以将--unattended标志传递给install.sh脚本。这将不会尝试更改默认 shell，并且在安装完成后也不会运行bash
    bash -c "$(_get_content_from_github "https://api.github.com/repos/ohmybash/oh-my-bash/contents/tools/install.sh" \
        "https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh")" --unattended
    rm -f "$HOME/.bashrc.omb-backup-*"
    curl --retry 10 --retry-all-errors --retry-delay 10 -sS https://starship.rs/install.sh | sh -s -- -y
    _log_end
    sleep 2
}

function step2() {
    # 搭建环境
    _log_start "step2"
    mkdir -p "$HOME/Data"
    mac pull "$MAC_HOME/Data/Config" "$HOME/Data/Config"
    mkdir -p "$HOME/.aria2" "$HOME/.config" "$HOME/.ssh" "$HOME/.shell_bak" "$HOME/software" "$HOME/Data" "$HOME/Share"
    mkdir -p "$HOME/.local/bin" "$HOME/.config/navi" "$HOME/.zoxide" "$HOME/.undodir" "$HOME/.vim" "$HOME/Temp" "$HOME/Logs" "$HOME/Downloads"
    mv "$HOME/.bashrc" "$HOME/.shell_bak/" || true
    mv "$HOME/.profile" "$HOME/.shell_bak/" || true
    mv "$HOME/.zshrc" "$HOME/.shell_bak/" || true
    bash "$HOME/Data/Config/my-ln.sh"
    _logan_source
    _log_end
}

function step3() {
    _log_start "step3"
    # 安装 nginx
    sudo apt install -y nginx
    #sudo systemctl list-unit-files --state=enabled #查看所有自启动的软件
    sudo systemctl disable nginx.service #禁止nginx开机自启
    sudo systemctl start nginx
    curl http://127.0.0.1:80 #测试
    sudo systemctl stop nginx
    sudo systemctl status nginx --no-pager || true

    # 安装 go
    sudo apt install -y golang-go
    go version
    sleep 2

    # 安装 bat
    sudo apt install -y bat #这样安装的bat会因为避免名字冲突而让他的命令变为 batcat, 所以需要符号链接
    mkdir -p "$HOME/.local/bin"
    ln -s /usr/bin/batcat "$HOME/.local/bin/bat"

    # 安装fzf
    # sudo apt install -y fzf #版本太低了
    mkdir -p "$HOME/software"
    git clone git@github.com:junegunn/fzf.git "$HOME/software/fzf"
    # wget --tries=10 --waitretry=10 -P "$HOME/software/fzf/" https://github.com/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-linux_arm64.tar.gz
    fzf_id=""
    if [ -n "$GITHUB_TOKEN" ]; then
        fzf_id=$(_get_asset_id "junegunn" "fzf" "v0.56.3" "fzf-0.56.3-linux_arm64.tar.gz")
    fi
    _download_release_from_github \
        "https://api.github.com/repos/junegunn/fzf/releases/assets/$fzf_id" \
        "https://github.com/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-linux_arm64.tar.gz" \
        "$HOME/software/fzf/fzf-0.56.3-linux_arm64.tar.gz"

    tar -xzf "$HOME/software/fzf/fzf-0.56.3-linux_arm64.tar.gz" -C "$HOME/software/fzf"
    ln -sf "$HOME/software/fzf/fzf" "$HOME/.local/bin/fzf"
    sleep 2

    # 安装fd
    sudo apt install -y fd-find
    ln -s "$(which fdfind)" "$HOME/.local/bin/fd"

    # 安装zoxide
    mkdir -p "$HOME/.zoxide"
    _get_content_from_github "https://api.github.com/repos/ajeetdsouza/zoxide/contents/install.sh" \
        "https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh" | sh
    _log_end
    sleep 2
}

function step4() {
    _log_start "step4"
    # 安装vim
    mkdir -p "$HOME/.undodir" "$HOME/.vim/autoload"
    sudo apt install -y vim
    _download_single_file_from_github \
        "https://api.github.com/repos/junegunn/vim-plug/contents/plug.vim" \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
        "$HOME/.vim/autoload/plug.vim"
    mac pull "$MAC_HOME/.vim/plugged" "$HOME/.vim/plugged"
    _logan_source
    echo "############ vim done #####################"
    sleep 2

    # 安装fnm
    curl --retry 10 --retry-all-errors --retry-delay 10 -sSfL https://fnm.vercel.app/install | bash -s -- --skip-shell #不修改zshrc 和 bashrc
    ln -s "$HOME/.local/share/fnm/fnm" "$HOME/.local/bin/fnm"
    _logan_source
    fnm -V               #查看fnm的版本
    fnm ls               #查看本地已安装的nodejs的版本
    fnm current          #打印当前使用的node版本
    fnm install --lts    #安装最新的LTS版本,会自动加别名 default, lts-latest
    fnm install --latest #安装最新的版本,会自动加别名 latest
    fnm default lts-latest
    fnm alias lts-latest lts
    sleep 2
    which -a npm
    npm -g install nrm pm2 prettier yarn yrm
    npm list -g
    nrm ls
    nrm use taobao

    # 安装sdkman
    curl --retry 10 --retry-all-errors --retry-delay 10 -sSfL "https://get.sdkman.io?rcupdate=false" | bash #不修改zshrc 和 bashrc
    _logan_source
    sdk version
    yes n | sdk install java 8.0.432.fx-zulu
    sleep 2
    yes n | sdk install java 11.0.25.fx-zulu
    sleep 2
    yes n | sdk install java 17.0.13.fx-zulu
    sleep 2
    yes n | sdk install java 17.0.13-zulu
    sleep 2
    yes n | sdk install java 17.0.12-oracle #设为默认
    sleep 2
    yes n | sdk install java 17.0.13-tem
    sleep 2
    yes n | sdk default java 17.0.12-oracle
    yes n | sdk install maven 3.9.9
    sleep 2
    sdk default maven 3.9.9
    sdk default java 17.0.12-oracle
    _log_end
}

function step5() {
    _log_start "step5"
    # 安装rust
    curl --retry 10 --retry-all-errors --retry-delay 10 --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    _logan_source
    rustc --version
    sleep 2

    # 安装navi
    cargo install --locked navi
    sleep 2

    # tldr
    cargo install tealdeer
    tldr --update
    tldr bat
    tldr -L zh tree
    sleep 2

    # glow
    mkdir -p "$HOME/software"
    glow_id=""
    if [ -n "$GITHUB_TOKEN" ]; then
        glow_id=$(_get_asset_id "charmbracelet" "glow" "v2.0.0" "glow_2.0.0_Linux_arm64.tar.gz")
    fi
    _download_release_from_github \
        "https://api.github.com/repos/charmbracelet/glow/releases/assets/$glow_id" \
        "https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Linux_arm64.tar.gz" \
        "$HOME/software/glow_2.0.0_Linux_arm64.tar.gz"

    tar xvzf "$HOME/software/glow_2.0.0_Linux_arm64.tar.gz" -C "$HOME/software/"
    mv "$HOME/software/glow_2.0.0_Linux_arm64" "$HOME/software/glow"
    ln -s "$HOME/software/glow/glow" "$HOME/.local/bin/glow"
    sleep 2

    # the_silver_searcher
    sudo apt install -y silversearcher-ag
    _log_end
}

function step6() {
    _log_start "step6"
    # trash-cli https://github.com/andreafrancia/trash-cli
    sudo apt install -y python3 python3-pip python3-venv
    sudo apt install -y trash-cli # 版本很低
    #    sudo mkdir --parent /.Trash
    #    sudo chmod a+rw /.Trash
    #    sudo chmod +t /.Trash
    sleep 2

    # uv
    curl --retry 10 --retry-all-errors --retry-delay 10 -LsSf https://astral.sh/uv/install.sh | sh # 默认在 $HOME/.local/share/uv/
    _logan_source
    export UV_PYTHON_PREFERENCE="only-managed"
    uv python install # 默认在 $HOME/.local/share/uv/python/
    uv python install 3.12
    uv tool install ruff
    ruff --version

    # 安装miniconda  linux 静默安装
    mkdir -p "$HOME/Temp"
    #    wget --tries=10 --waitretry=10 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O $HOME/Temp/miniconda.sh
    curl --retry 10 --retry-all-errors --retry-delay 10 \
        -fSLo "$HOME/Temp/miniconda.sh" \
        https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh
    bash "$HOME/Temp/miniconda.sh" -b -u -p "$HOME/.miniconda3" # -b:不对 shell 脚本进行 PATH 修改,以非交互模式（静默模式）运行安装; -u:如果指定的安装路径（通过 -p）已有 Miniconda 安装，它会更新而不是报错或覆盖安装; -p: 指定安装路径
    rm "$HOME/Temp/miniconda.sh"
    _logan_source
    conda --version
    conda create -y -n env_test python=3.9 # -n 是创建的环境的名字
    conda activate env_test
    python3 -V
    conda activate # 默认是base环境
    python3 -V
    conda deactivate || true
    conda deactivate || true
    conda deactivate || true
    _log_end
    sleep 2
}

function step7() {
    _log_start "step7"
    # 删除之前先clone,不然直接删 ssh/config也没了,因为做了软链接
    git clone git@github.com:loganoxo/Config.git "$HOME/Temp/Config"
    rm -rf "$HOME/Data/Config"
    mv "$HOME/Temp/Config" "$HOME/Data/Config"
    cd "$HOME/Data/Config" && git pull

    # 安装 fastfetch
    mkdir -p "$HOME/software/fastfetch" && wget -P "$HOME/software/fastfetch" https://github.com/fastfetch-cli/fastfetch/releases/download/2.31.0/fastfetch-linux-aarch64.deb
    sudo apt update && sudo dpkg -i "$HOME/software/fastfetch/fastfetch-linux-aarch64.deb"
    fastfetch --version && which -a fastfetch

    # ssh 连接时,不要打印 系统版本和版权信息
    touch "$HOME/.hushlogin"

    # ffmpeg 安装
    sudo apt install -y ffmpeg

    # 安装 aria2
    mkdir -p "$HOME/Logs" "$HOME/Downloads" "$HOME/.aria2"
    if [ ! -f "$HOME/.aria2/aria2.session" ]; then
        touch "$HOME/.aria2/aria2.session"
    fi
    sudo apt update
    sudo apt install -y aria2
    aria2c --version

    _log_end
    sleep 2
}

# 安装其他工具 从mac中复制环境到linux
# 不需要手动设置 GitHub 私钥, orbstack 做好了
function ___install() {
    # 预先判断
    if [ -z "$flag" ] || [ "$flag" = "nozsh" ]; then
        echo "only run in zsh"
        exit 1
    fi
    _git_pre
    if [ "$step" -le 1 ]; then
        step1
    fi
    if [ "$step" -le 2 ]; then
        step2
    fi
    if [ "$step" -le 3 ]; then
        step3
    fi
    if [ "$step" -le 4 ]; then
        step4
    fi
    if [ "$step" -le 5 ]; then
        step5
    fi
    if [ "$step" -le 6 ]; then
        step6
    fi
    if [ "$step" -le 7 ]; then
        step7
    fi

}

function run() {
    # 预先判断
    judge

    if [ "$step" -eq 0 ]; then
        ___pre
    fi

    if [ "$step" -gt 0 ]; then
        ___install
    fi

    notice "All Done....... \n"
    echo "######################################################"
}

run
