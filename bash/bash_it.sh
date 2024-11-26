#!/usr/bin/env bash

#if [ -z "${_INIT_BASH_IT_LOADED}" ]; then
#    _INIT_BASH_IT_LOADED=1
#else
#    return
#fi

# 如果不是交互式 shell,什么都不做,避免执行不必要的脚本.
case $- in
*i*) ;;      # 如果包含 `i`,表示是交互式.
*) return ;; # 否则返回,不执行后续代码.
esac

# 指定 bash-it 的安装路径。
export BASH_IT="$HOME/.bash_it"

# 加载和使用自定义主题文件.
# 留空表示禁用主题.
# 位置 "$BASH_IT"/themes/
export BASH_IT_THEME='powerline'

# 一些主题(powerline)会在提示符中显示一个标识，以提醒用户他们拥有 sudo 权限。这可以帮助用户意识到自己有超级用户权限，以避免无意中执行有潜在风险的操作
THEME_CHECK_SUDO='true'

# (高级): 如果你用不同于 origin 的远程仓库克隆了 bash-it`,将此值改为你的远程仓库的名称; 用在bash-it更新
# export BASH_IT_REMOTE='origin'
# (高级): 如果你重命名了主开发分支或因某些原因更改了它,将此值改为主开发分支的名称;用在bash-it更新
# export BASH_IT_DEVELOPMENT_BRANCH='master'
# 配置自己使用的git服务 ;用在 插件 git.plugin.bash
# export GIT_HOSTING='git@git.domain.com'

# 在 Bash 默认会在终端每隔一定时间后自动检查用户的邮件文件是否更新; 避免这种自动检查,从而减少不必要的输出和资源使用
unset MAILCHECK

# IRC是一种用于实时在线聊天的协议; irssi 是一个流行的开源 IRC ,专为终端或命令行环境设计.
export IRC_CLIENT='irssi'

# 用在todo插件 todo.txt-cli
export TODO="t"

# 项目目录的配置,用在projects.plugin.bash插件中
#BASH_IT_PROJECT_PATHS="${HOME}/Projects:/Volumes/work/src"

# 是否在命令提示符中检查版本控制(git等)状态,用在所有主题中
export SCM_CHECK=true

# 用于指定 gitstatus 目录的实际位置. 如果你安装了 gitstatus(一个用于 Git 状态优化显示的工具),可以将其路径设置在这里.
# export SCM_GIT_GITSTATUS_DIR="$HOME/gitstatus"

# 设置 Xterm、screen 或 Tmux 的标题,显示短主机名. 如果未设置,会使用 $HOSTNAME.
# export SHORT_HOSTNAME=$(hostname -s)

# 设置 Xterm、screen 或 Tmux 的标题,显示短用户名. 如果注释掉或未设置,会使用完整的 $USER 名.
# export SHORT_USER=${USER:0:8}

# 启用此选项可以在终端标题中显示缩短后的命令和目录,使标题更简洁
# export SHORT_TERM_LINE=true

# 若主题支持,如果取消注释,将显示上一个命令的执行时间,用于了解命令耗时. 这在运行长时间任务时很有用.
# export BASH_IT_COMMAND_DURATION=true

# 设置显示命令持续时间的最小阈值,只有超过此秒数的命令才会显示执行时间.
# export COMMAND_DURATION_MIN_SECONDS=1

# 指定 vcprompt(https://github.com/djl/vcprompt) 可执行文件的路径,用于在命令提示符中显示高级版本控制信息(demula theme)
# export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# 取消注释后,当启用或禁用别名、插件、补全功能时,bash-it 会自动重新加载自身.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# 取消注释后,bash-it 将创建一个 重载bash-it 命令的别名(reload),用于重载配置.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$BASH_IT"/bash_it.sh
