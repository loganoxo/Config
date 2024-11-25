# shellcheck disable=SC2034
# 为 zsh和bash 自定义历史命令配置

# 历史记录中时间戳的显示格式,放在omz和omb加载之前,在这里重复配置
HIST_STAMPS="yyyy-mm-dd"

function _my_history_for_zsh() {
    ######################################################## 历史命令相关配置 #########################################################
    # 只能放在zshrc中,因为只有交互式shell才有记录历史命令的需求,并且在mac中若在zprofile或zshenv中写,会被/etc/zshrc覆盖
    # 需要放在omz加载之后,覆盖omz中的lib/history.sh配置
    # 默认行为: 如果没有启用 append_history,Zsh 会在会话结束时将当前会话中的历史命令保存到历史文件中,覆盖历史文件中已有的内容.SAVEHIST最好不要超过HISTSIZE
    # 启用 append_history: 启用该选项后,Zsh 会在会话结束时将当前会话的历史命令追加到历史文件中,而不是覆盖已有的内容.这意味着每次会话都可以将命令记录持续累积到同一个历史文件中.
    HISTFILE=$HOME/.zsh_history # 历史文件保存的位置;这个文件的编码不用管,如果用vscode等应用将文件编码改成utf-8,反而在shell中不能正常回显包含中文字符的命令
    HISTSIZE=20000              # 内存中最多记录多少条历史,设置特别大会导致终端启动速度变慢;shell 将在交互式会话开始时从历史文件中读取$HISTSIZE行,并保存在会话结束时执行的最后$SAVEHIST行
    SAVEHIST=50000              # 历史文件中最多保存多少条历史命令.如果历史记录超过了这个数量,Zsh 会根据历史命令的保存策略（如删除最旧的记录）来保证历史文件中保存的命令数量不超过 SAVEHIST 设置的数量

    # 默认行为: Zsh会在会话开始时从历史文件中读取最多HISTSIZE条命令到内存,当前shell中敲击的新命令会存入内存,若超出HISTSIZE条,则较老的命令会在内存中被删除;
    # 会话结束时将当前内存中的(取HISTSIZE和SAVEHIST的最小值)条历史命令全覆盖保存到历史文件中. 所以默认配置下,SAVEHIST最好不要超过HISTSIZE;
    # 默认配置下 SAVEHIST == HISTSIZE 最佳; 以下三个选项开启任意一个或多个的情况下 HISTSIZE < SAVEHIST 最佳
    setopt APPEND_HISTORY     # 若开启,则会话退出时将 新(从HISTFILE中读取到内存中的命令不会重复添加到HISTFILE) 的命令历史附加到 HISTFILE 中,而不是覆盖历史文件的内容;
    setopt INC_APPEND_HISTORY # 若开启,则每条命令在执行时都会追加到HISTFILE中,而不是在 shell 退出时执行此操作
    setopt share_history      # 若开启,则更进一步,在所有 Zsh 会话中共享命令历史,也就是说,当你在一个终端会话中执行命令时,这些命令会立即出现在其他终端会话的历史中
    # 启用share_history后, 当你在一个 Zsh 会话中执行命令时,该命令会立刻被保存到 HISTFILE, 其他同时运行的 Zsh 会话会周期性地从 HISTFILE 中加载新添加的命令

    setopt extended_history       # 若开启,则记录每条命令的时间戳
    setopt hist_expire_dups_first # 若开启,则历史文件超过 HISTSIZE 限制时,优先删除历史记录中的重复命令
    setopt hist_ignore_dups       # 若开启,则忽略历史中重复的命令.如果当前命令与上一条命令相同,它不会被保存到历史记录中
    setopt hist_ignore_space      # 若开启,则任何以空格开头的命令都不会被保存到历史文件中;非常适合在需要避免某些命令被记录时使用,通过简单地在命令前加空格即可实现,便于保护隐私和减少不必要的历史记录
    setopt hist_verify            # 默认在zsh的shell中输入 !!+回车 会自动打印上一条命令并执行;启用这个选项后,会在执行之前先展示上一条命令,并等待用户确认再执行.(!$ 表示上一条命令的最后一个参数)

    # 可以用 unsetopt 取消之前的配置, 上面的配置都是omz中的默认配置, 要取消不能光注释这里,需要用 unsetopt 显式取消
    # 日期格式,重复配置
    case ${HIST_STAMPS-} in
    "mm/dd/yyyy") alias history='omz_history -f' ;;
    "dd.mm.yyyy") alias history='omz_history -E' ;;
    "yyyy-mm-dd") alias history='omz_history -i' ;;
    "") alias history='omz_history' ;;
    *) alias history="omz_history -t '$HIST_STAMPS'" ;;
    esac
    ###################################################################################################################################
}

function _my_history_for_bash() {
    ######################################################## 历史命令相关配置 #########################################################
    HISTFILE=$HOME/.bash_history             # 配置历史文件的位置
    HISTSIZE=20000                           # 内存中保存的最大历史命令数
    HISTFILESIZE=50000                       # 历史文件中保存的最大历史命令数
    HISTCONTROL="ignoredups:ignorespace"     # 忽略与上一条重复的命令和以空格开头的命令
    HISTIGNORE="exit:ls:bg:fg:history:clear" # 不将这些命令记录到历史文件中
    HISTTIMEFORMAT="%F %T "                  # 在历史记录中显示日期和时间,格式为 YYYY-MM-DD HH:MM:SS

    # shopt -u 为取消某个设置
    shopt -s histappend # 在 Bash 会话退出时将新命令追加到历史文件,而不是覆盖
    # 用于在命令行中进行失败的历史记录扩展时重新编辑命令行.具体来说,当你输入的命令包含有问题的历史记录扩展（如 ! 引用失败等）而导致错误时,启用 histreedit 会让 Bash 自动将该命令返回到命令行中,以便你可以直接修改和重新编辑,而不是简单地报错并清空命令行.
    # 这对调试和修改错误的历史记录扩展特别有用,可以避免重新输入整个命令
    shopt -s histreedit
    # 该选项启用时, 在执行历史扩展命令时, Bash 会将扩展后的结果重新加载到命令行, 而不是直接执行. 这使用户有机会在命令被执行之前进行检查和编辑
    shopt -s histverify

    shopt -s cmdhist # 将多行命令组合成一条历史记录; 例如 用\ 或 &换行的,默认会视为多个命令
    # 用于在保存 Bash 历史记录时,将多行命令(就是普通的代码块等等)保存在历史文件中时尽量使用换行符而不是分号,.这会使复杂命令（例如使用多行输入的命令块）在历史文件中保持原样的格式,而不是压缩成一行
    shopt -s lithist

    # 'history -a' 将新命令追加到历史文件
    # 'history -c' 清除当前会话的历史记录（防止重复加载）
    # 'history -r' 重新从历史文件读取历史记录,确保同步
    _omb_util_add_prompt_command 'history -a; history -c; history -r' #自动在每次命令后保存历史记录到文件,且可在会话中同步

    # 用上下箭头就可以根据已经输入的内容来查找匹配的历史命令
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\e[C": forward-char'
    bind '"\e[D": backward-char'

    # 日期格式,重复配置
    case $HIST_STAMPS in
    "[mm/dd/yyyy]") HISTTIMEFORMAT=$'\033[31m[%m/%d/%Y] \033[36m[%T]\033[0m ' ;;
    "[dd.mm.yyyy]") HISTTIMEFORMAT=$'\033[31m[%d.%m.%Y] \033[36m[%T]\033[0m ' ;;
    "[yyyy-mm-dd]") HISTTIMEFORMAT=$'\033[31m[%F] \033[36m[%T]\033[0m ' ;;
    "mm/dd/yyyy") HISTTIMEFORMAT='%m/%d/%Y %T ' ;;
    "dd.mm.yyyy") HISTTIMEFORMAT='%d.%m.%Y %T ' ;;
    "yyyy-mm-dd" | *) HISTTIMEFORMAT='%F %T ' ;;
    esac

    # 弃用的omb默认配置:
    # 1、omz默认配置如下,是为了让历史命令无限制,将 HISTSIZE 和 HISTFILESIZE 设置为极大值;接近 INT_MAX，但不会溢出，且适用于大多数实现;
    # HISTSIZE=-1;HISTFILESIZE=-1;这是官方支持的方法,但仅在 Bash 4.3 及以上版本中可用。在低于 4.3 的 Bash 中,会清空用户的历史记录
    #       export HISTSIZE=$((0x7FFF7FFF))
    #       export HISTFILESIZE=$((0x7FFF7FFF))
    # 2、omb原本_omb_util_add_prompt_command只添加了history -a; 不能同步,故在上面重复配置; history -a 可以重复执行
    #       _omb_util_add_prompt_command 'history -a'
    # 3、若不使用omb,则可用下面的方式来做:
    #       export PROMPT_COMMAND="history -a; history -c; history -r"
    # 4、erasedups:从历史记录中删除所有已存在的重复命令;只保留最新的; ignoredups:忽略与上一条命令重复的命令;
    #    ignorespace:忽略以空格开头的命令; ignoreboth:相当于同时设置 ignoredups 和 ignorespace;
    #    HISTCONTROL="erasedups:ignoreboth" 去掉erasedups

    ###################################################################################################################################
}

# 判断是 bash 还是 zsh
if [ -n "$BASH_VERSION" ]; then
    # 当前是 Bash
    # echo "bash"
    _my_history_for_bash
elif [ -n "$ZSH_VERSION" ]; then
    # 当前是 Zsh
    # echo "zsh"
    _my_history_for_zsh
fi
