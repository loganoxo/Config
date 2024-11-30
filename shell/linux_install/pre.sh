#!/usr/bin/env bash
#
# 脚本名称: batch_rename.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: linux装机前置脚本; 包括软件源的配置、网络静态IP和DNS等
# 使用: 1.用wget(debian默认安装)        su -c 'wget -O- https://raw.githubusercontent.com/loganoxo/Config/master/shell/linux_install/pre.sh | bash'
# 2.用curl(debian等linux可能没有预装)   su -c 'curl -fsSL https://raw.githubusercontent.com/loganoxo/Config/master/shell/linux_install/pre.sh | bash'

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行

apt update



