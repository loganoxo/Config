# shellcheck disable=SC2034
# ##################### ohmybash配置 ##########################

# 如果不是交互式 shell,什么都不做,避免执行不必要的脚本.
case $- in
*i*) ;;      # 如果包含 `i`,表示是交互式.
*) return ;; # 否则返回,不执行后续代码.
esac

# Path to your oh-my-bash installation.
export OSH=~/.oh-my-bash

# 主题,若设为random则随机主题
# OSH_THEME="font"
# OSH_THEME="powerbash10k"
THEME_SHOW_SUDO=true                # 显示当前环境是否有sudo权限;默认为true
THEME_SHOW_SCM=true                 # 显示git信息;默认为true:显示
THEME_SHOW_CLOCK=true               # 显示时间;默认为true:显示
THEME_SHOW_PYTHON=true              # 显示Python虚拟环境信息; 默认为false
THEME_SHOW_EXITCODE=true            # 显示上一条执行未成功的命令的返回值;默认为true:显示
__PB10K_PROMPT_LOCAL_USER_INFO=true # 隐藏本地用户的用户信息,仅在 SSH 会话中显示;默认为true:一直显示

THEME_SHOW_RUBY=false    # 显示Ruby虚拟环境信息; 默认为false
THEME_SHOW_TODO=false    # 显示 TO DO 的状态信息 (一个需要额外安装的工具) ; 默认为false
THEME_SHOW_BATTERY=false # 不显示电池电量;默认为false:不显示; 调用 $OSH/plugins/battery/battery.plugin.sh

#THEME_CLOCK_COLOR=$bold_cyan         # 显示时间的颜色;默认为$_omb_prompt_bold_white
#THEME_CLOCK_FORMAT="%H:%M:%S"        # 显示时间的格式

# PB10K主题的提示符的重新排序,通过以下三个环境变量
#__PB10K_TOP_LEFT="dir scm"
#__PB10K_TOP_RIGHT="exitcode cmd_duration user_info python ruby to[去掉空格]do clock battery"
#__PB10K_BOTTOM="char"

# If you set OSH_THEME to "random", 随机主题的范围
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")

# 默认大小写不敏感; 取消注释:大小写敏感
# OMB_CASE_SENSITIVE="true"

# 默认自动补全功能区分 - 和 _ ;取消注释,设为false,则视为等效(前提是OMB_CASE_SENSITIVE设为false或空)
# OMB_HYPHEN_SENSITIVE="false"

# 禁用每两周一次的自动更新检查
DISABLE_AUTO_UPDATE="true"

# 取消下面一行的注释以更改自动更新的频率(以天为单位)
# export UPDATE_OSH_DAYS=13

# 取消注释以下行以禁用ls中的颜色; 估计omb还没做
# DISABLE_LS_COLORS="true"

# 取消注释以下行以禁用自动设置终端标题; 估计omb还没做
# DISABLE_AUTO_TITLE="true"

# 取消注释以下行以启用命令自动更正; 估计omb还没做
# ENABLE_CORRECTION="true"

# 在等待完成时,取消注释以下行以显示红点; 估计omb还没做
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# 日期格式
HIST_STAMPS="yyyy-mm-dd" # 在history.sh 中有重新配置

# 不让omb创建定义在lib/*.sh的别名;可选项: disable: 直接返回,表示不创建或修改别名;check: 检查别名是否已存在,如果存在则返回而不创建新的别名;enable: 正常创建或修改别名
OMB_DEFAULT_ALIASES="disable"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# 禁用 oh-my-bash 中使用 sudo 的功能。默认情况下,如果 OMB_USE_SUDO 是空的,其值是 true;
# oh-my-bash 会在某些操作中使用 sudo。设置为 false 后,oh-my-bash 将不会使用 sudo,这可以避免自动提升权限
OMB_USE_SUDO=false

# 在 shell 提示符中显示当前 Python 虚拟环境或 Conda 环境的名称; 会影响的主题有font等,powerbash10k中需要用主题自己的配置变量
OMB_PROMPT_SHOW_PYTHON_VENV=true # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
    #    git
    #    composer
    ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
    #    general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    #    git
    #    bashmarks
)

# 按条件加载
# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

[[ -s "$OSH/oh-my-bash.sh" ]] && source "$OSH/oh-my-bash.sh"

# User configuration; MANPATH 是用来指定 man 命令搜索手册页的路径
# export MANPATH="/usr/local/man:$MANPATH"

# 控制界面语言的展示或输出等,在 init.sh 配置了
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# 设置编译标志 ARCHFLAGS,指定在编译 C/C++ 扩展或其他需要编译的程序时使用的架构选项
# export ARCHFLAGS="-arch x86_64"

# 指向默认的 SSH 私钥路径
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"
