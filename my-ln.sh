#!/bin/bash
# ln -sf source_dir link_name  ---创建一个名为 link_name 的符号链接，指向 source_dir
# -s: 表示创建符号链接（软链接）。软链接是一个指向另一个文件或目录的引用
# 软链接特点：可以跨越不同的文件系统。可以链接目录。删除软链接不会影响原始文件或目录。
# 不使用任何选项即可创建硬链接。语法为 ln source.txt link.txt
# 硬链接特点：只能链接文件，不能链接目录。必须位于同一文件系统中。删除硬链接不会影响原始文件的访问权限和内容，只有在所有链接都被删除后，文件才会被系统释放并回收磁盘空间。
# 硬链接：1、修改link.txt后，source.txt 同步被修改；2、删除source.txt，link.txt还存在，并且文件内容还在；所以硬链接适合做文件备份
# -f: 表示强制操作，即如果目标文件已经存在，强制删除它，然后创建新的链接

export __PATH_MY_CNF="$HOME/Data/Config"                    # 我自己的配置文件目录
export __PATH_MY_SOFT="$HOME/Data/Software"                 # 我自己的软件目录
export __PATH_MY_CNF_SENSITIVE="$HOME/Data/ConfigSensitive" # 本地敏感数据目录
export __PATH_HOME_CONFIG="$HOME/.config"                   # 默认配置目录

mkdir -p "$HOME/.aria2" "$HOME/.docker" "$HOME/.config" "$HOME/.ssh"

# zsh
ln -sf "${__PATH_MY_CNF}/zsh/zshrc" "$HOME/.zshrc"
ln -sf "${__PATH_MY_CNF}/zsh/zprofile" "$HOME/.zprofile"
ln -sf "${__PATH_MY_CNF}/zsh/zshenv" "$HOME/.zshenv"
ln -sf "${__PATH_MY_CNF}/zsh/themes/lib" "$HOME/.oh-my-zsh/custom/themes/lib"
ln -sf "${__PATH_MY_CNF}/zsh/themes/mydracula.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/mydracula.zsh-theme"

# ssh
ln -sf "${__PATH_MY_CNF}/zsh/ssh/config_linux" "$HOME/.ssh/config"
os_type=$(uname) #获取操作系统类型
if [ "$os_type" = "Darwin" ]; then
    # mac
    ln -sf "${__PATH_MY_CNF}/zsh/ssh/config_mac" "$HOME/.ssh/config"
elif [ "$os_type" = "Linux" ]; then
    # linux
    ln -sf "${__PATH_MY_CNF}/zsh/ssh/config_linux" "$HOME/.ssh/config"
    # 进一步判断是否为 Debian
#    if [ -f /etc/debian_version ]; then
#        echo "当前系统是 Debian"
#    else
#        echo "当前系统是 Linux, 但不是 Debian"
#    fi
else
    echo "创建 ssh/config 软链接时, 未知的操作系统: $os_type"
fi

# starship
ln -sf "${__PATH_MY_CNF}/zsh/starship" "$HOME/.config/starship"

# fastfetch
ln -sf "${__PATH_MY_CNF}/others/fastfetch" "$HOME/.config/fastfetch"

# bash
ln -sf "${__PATH_MY_CNF}/bash/bash_profile" "$HOME/.bash_profile"
ln -sf "${__PATH_MY_CNF}/bash/bashrc" "$HOME/.bashrc"

# git
ln -sf "${__PATH_MY_CNF}/git/gitconfig" "$HOME/.gitconfig"
ln -sf "${__PATH_MY_CNF}/git/gitignore_global" "$HOME/.gitignore_global"
ln -sf "${__PATH_MY_CNF}/git/hgignore_global" "$HOME/.hgignore_global"
ln -sf "${__PATH_MY_CNF}/git/stCommitMsg" "$HOME/.stCommitMsg"

# shell
ln -sf "${__PATH_MY_CNF}/shell/zk.sh" "${__PATH_MY_SOFT}/zookeeper3.8.0/zk.sh"

# ohmyzsh->z.lua
# ln -sf  "/Users/logan/Data/Software/z.lua"  "/Users/logan/.oh-my-zsh/custom/plugins/z.lua"

# vim
ln -sf "${__PATH_MY_CNF}/vim/vimrc" "$HOME/.vimrc"
ln -sf "${__PATH_MY_CNF}/vim/idea/ideavimrc" "$HOME/.ideavimrc"
# 自定切换输入法,为了快速,直接把input-source-vim文件夹复制到HOME下
cp -r "${__PATH_MY_CNF}/vim/input-source-vim" "$HOME/.input-source-vim"
touch "$HOME/.input-source-vim/data"
echo -n 0 >"$HOME/.input-source-vim/data"

# others
ln -sf "${__PATH_MY_CNF}/others/tmux/tmux.conf" "$HOME/.tmux.conf"
# ln -sf "${__PATH_MY_CNF}/others/ranger" "$HOME/.config/ranger"
ln -sf "${__PATH_MY_CNF}/others/aria2/aria2.conf" "$HOME/.aria2/aria2.conf"
ln -sf "${__PATH_MY_CNF}/others/docker/config.json" "$HOME/.docker/config.json"
ln -sf "${__PATH_MY_CNF}/others/docker/daemon.json" "$HOME/.docker/daemon.json"
# navi
mkdir -p "$HOME/.config/navi" && ln -sf "${__PATH_MY_CNF}/others/navi/config.yaml" "$HOME/.config/navi/config.yaml"
for file in "${__PATH_MY_CNF}"/others/navi/*.cheat; do
    if [ -e "$file" ]; then
        # -e判断目录和文件是否存在；-f判断文件是否存在，并且是一个普通文件（而不是目录或其他类型的特殊文件）
        name=$(basename "$file")
        ln -sf "$file" "$HOME/.config/navi/$name"
    fi
done
