# export VISUAL=nano
export PAGER=bat # 预览

if [ -n "$RANGER_LEVEL" ]; then export PS1="[ranger]$PS1"; fi
export RANGER_LOAD_DEFAULT_RC=FALSE # 不再使用默认的设置
