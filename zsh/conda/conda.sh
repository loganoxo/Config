# conda
__logan_conda_home="$HOME/.miniconda3"
__conda_bin="${__logan_conda_home}/bin/conda"
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

# 切换conda到默认环境
LOGAN_DEFAULT_ENV_NAME="env_test"
#LOGAN_CONDA_ENV_DIR="${__logan_conda_home}/envs"

if _logan_if_command_exist "conda"; then
    # 检查是否已经在pyenv虚拟环境中
    if [[ -z "$VIRTUAL_ENV" ]]; then
        # 检查环境是否存在
        if conda env list | grep -q "^$LOGAN_DEFAULT_ENV_NAME\s"; then
            conda activate "$LOGAN_DEFAULT_ENV_NAME"
            # 确保 Conda 环境路径优先
            CONDA_ENV_PATH="$(conda info --base)/envs/$LOGAN_DEFAULT_ENV_NAME/bin"
            if [[ "$PATH" != "$CONDA_ENV_PATH:"* ]]; then
                export PATH="$CONDA_ENV_PATH:$PATH"
            fi
        else
            echo "Environment '$LOGAN_DEFAULT_ENV_NAME' does not exist."
        fi
    fi
fi

# <<< conda initialize <<<
