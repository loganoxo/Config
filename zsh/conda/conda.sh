# conda
__conda_bin="$HOME/.miniconda3/bin/conda"
if [ -x "$__conda_bin" ]; then
    # _logan_if_bash 和 _logan_if_zsh 必须写在if里; 如果用 && 的形式,后面$?的判断可能会有问题
    if _logan_if_bash; then
        __conda_setup="$("$__conda_bin" 'shell.bash' 'hook' 2>/dev/null)"
    elif _logan_if_zsh; then
        __conda_setup="$("$__conda_bin" 'shell.zsh' 'hook' 2>/dev/null)"
    fi
fi

if [ $? -eq 0 ]; then
    if [[ -n "${__conda_setup+x}" && -n "$__conda_setup" ]]; then
        eval "$__conda_setup"
    fi
else
    if [ -f "$HOME/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
