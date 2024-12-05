#!/usr/bin/env bash
#
# 脚本名称: install.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux其他工具的安装
# shellcheck disable=SC2317
# 防止直接执行
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
# 安装 open-vm-tools
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

################################################## End At 2024-12-06 ##################################################