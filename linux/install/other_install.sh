#!/usr/bin/env bash
#
# 脚本名称: install.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux其他工具的安装
# shellcheck disable=SC2317
# 防止直接执行
set -eu
echo "This script is not meant to be executed directly."
exit 0
return 0

# 安装 fastfetch
mkdir -p "$HOME/software/fastfetch" && wget -P "$HOME/software/fastfetch" https://github.com/fastfetch-cli/fastfetch/releases/download/2.31.0/fastfetch-linux-aarch64.deb
sudo apt update && sudo dpkg -i "$HOME/software/fastfetch/fastfetch-linux-aarch64.deb"
fastfetch --version && which -a fastfetch
git -C "$HOME/Data/Config" pull

# ssh 连接时,不要打印 系统版本和版权信息
touch "$HOME/.hushlogin"

# ffmpeg 安装
sudo apt install -y ffmpeg
# 下载 m3u8 视频
# ffmpeg -i "https://aa.ww.bb/mixed.m3u8" -c copy -bsf:a aac_adtstoasc output.mp4

################################################## End At 2024-12-05 ##################################################

############################### 安装 open-vm-tools
sudo apt install -y open-vm-tools
# 针对于带有桌面的linux(open-vm-tools-desktop中包含了open-vm-tools)
# KDE桌面环境如果要启用文件拖拽和剪切板公用,必须在登录界面选择 Plasma (X11)
sudo apt install -y open-vm-tools-desktop

# 挂载的命令(linux内核版本大于4.0): /usr/bin/vmhgfs-fuse .host:/ /mnt/hgfs -o subtype=vmhgfs-fuse,allow_other
# 使用systemd 服务; 开机自动挂载
sudo mkdir -p /mnt/hgfs
sudo chmod 755 /mnt/hgfs
sudo touch /etc/systemd/system/mnt.hgfs.service

sudo tee /etc/systemd/system/mnt.hgfs.service >/dev/null <<EOF
[Unit]
Description=Mount VMware Shared Folders
Requires=open-vm-tools.service
After=open-vm-tools.service network.target
ConditionPathExists=.host:/
ConditionVirtualization=vmware

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/vmhgfs-fuse .host:/ /mnt/hgfs -o subtype=vmhgfs-fuse,allow_other,auto_unmount
ExecStop=/bin/umount /mnt/hgfs

[Install]
WantedBy=multi-user.target

EOF

sudo systemctl daemon-reload
sudo systemctl enable mnt.hgfs.service
sudo systemctl start mnt.hgfs.service
sudo systemctl status mnt.hgfs.service

####################### debian12 + KDE 安装ibus中文输入法
sudo apt install ibus-libpinyin # or other engine(s) you want
# logout and re-login
ibus-setup # add input methods you want
or add input source in Settings - in GNOME desktop. >Keyboard

################################################## End At 2024-12-06 ##################################################
gpc

# 安装 aria2
mkdir -p "$HOME/Logs" "$HOME/Downloads" "$HOME/.aria2"
if [ ! -f "$HOME/.aria2/aria2.session" ]; then
    touch "$HOME/.aria2/aria2.session"
fi
sudo apt update && sudo apt install -y aria2
aria2c --version

# tmux
ln -sf "${__PATH_MY_CNF}/tmux/tmux.conf" "$HOME/.tmux.conf"
mkdir -p ~/.tmux/plugins
sudo apt update && sudo apt install -y tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# lsd
[ ! -d "$HOME/.config/lsd" ] && ln -sf "${__PATH_MY_CNF}/others/lsd" "$HOME/.config/lsd"
cargo install lsd
################################################## End At 2024-12-17 ##################################################
# thefuck 好久不更新, python3.12后 移除了 distutils 和 imp 模块, 导致thefuck执行报错;
# mac上不用担心,查看rb文件的代码,homebrew安装时会自动修改thefuck中的代码
uv tool install --python 3.11 thefuck

################################################## End At 2024-12-27 ##################################################
tm_ssh -f ./ssh-hosts.txt #开启tmux连接虚拟机
Ctrl-s + Ctrl-t #开启同步
gpc #拉取最新配置

# 安装yazi
rustup update
mkdir -p "$HOME/.config/yazi"
ln -sf "${__PATH_MY_CNF}/others/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"
ln -sf "${__PATH_MY_CNF}/others/yazi/keymap.toml" "$HOME/.config/yazi/keymap.toml"
ln -sf "${__PATH_MY_CNF}/others/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
ln -sf "${__PATH_MY_CNF}/others/yazi/flavors" "$HOME/.config/yazi/flavors"
ln -sf "${__PATH_MY_CNF}/others/yazi/init.lua" "$HOME/.config/yazi/init.lua"
ln -sf "${__PATH_MY_CNF}/others/yazi/plugins" "$HOME/.config/yazi/plugins"
cargo install --locked yazi-fm yazi-cli

# uv
mkdir -p "$HOME/.config/uv"
ln -sf "${__PATH_MY_CNF}/others/uv/uv.toml" "$HOME/.config/uv/uv.toml"
uv self update #uv升级
uv tool install toolong  #安装查看日志的工具
################################################## End At 2025-04-22 ##################################################
