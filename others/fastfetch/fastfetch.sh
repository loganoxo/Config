# 执行fastfetch
fastfetch_if_run=0 # 1为执行
fastfetch_config_path=""
if _logan_if_mac; then
    fastfetch_if_run=0
    fastfetch_config_path="$HOME/.config/fastfetch/config_mac.jsonc"
elif _logan_if_linux; then
    fastfetch_if_run=0
    fastfetch_config_path="$HOME/.config/fastfetch/config_linux.jsonc"
fi
if _logan_if_command_exist "fastfetch"; then
    alias fastfetch='command fastfetch -c "$fastfetch_config_path"'
fi
# 自动执行
if [ -f "$fastfetch_config_path" ] && [ $fastfetch_if_run -eq 1 ] && _logan_if_command_exist "fastfetch"; then
    if _logan_if_mac; then
        supported_terms=("iTerm.app" "Apple_Terminal" "WezTerm" "Tabby")
        for term in "${supported_terms[@]}"; do
            if [ "$TERM_PROGRAM" = "$term" ]; then
                command fastfetch -c "$fastfetch_config_path"
                break
            fi
        done
    elif _logan_if_linux; then
        command fastfetch -c "$fastfetch_config_path"
    fi
fi
