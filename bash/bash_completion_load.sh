# 如果 $PS1 有值,表示当前是一个交互式 shell
if [[ $PS1 && -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]; then
    # macOS (Homebrew)
    . "/opt/homebrew/etc/profile.d/bash_completion.sh"
elif [[ $PS1 && -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
    # macOS 或其他 Homebrew 安装路径
    . "/usr/local/etc/profile.d/bash_completion.sh"
elif [[ $PS1 && -r "/etc/bash_completion" ]]; then
    # Linux (默认路径)
    . "/etc/bash_completion"
elif [[ $PS1 && -r "/usr/share/bash-completion/bash_completion" ]]; then
    # 一些 Linux 发行版可能使用这个路径
    . "/usr/share/bash-completion/bash_completion"
fi
