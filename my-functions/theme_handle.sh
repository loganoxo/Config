# 描述: starship 的一些 功能函数
# shellcheck disable=SC2154

order_index=0
STARSHIP_THEME_PATHS=() # 主题文件绝对路径

# 执行主函数
function run_starship_handle() {
    # 当starship_path未设置时,直接退出,不能用return
    if [[ -z "${starship_path+x}" ]]; then
        return 1
    fi

    if [ -z "$1" ]; then
        str0="\033[31m          starship 自定义功能                \033[0m \n"
        str1="\033[31m[ 1 ] 按顺序切换到下一个主题. \033[0m \n"
        str2="\033[31m[ 2 ] 自选主题.\033[0m \n"
        str3="\033[31m[ 3 ] Exit. \033[0m \n"
        echo -e "$str0$str1$str2$str3"
        echo -n "Input your choice :"
        read -r choice
    else
        choice="$1"
    fi

    if [ "$choice" = "1" ]; then
        starship_change_theme_in_order
    elif [ "$choice" = "2" ]; then
        starship_change_theme_select
    elif [ "$choice" = "3" ]; then
        echo -e "\033[31m exit.....\033[0m"
        return 0
    else
        echo -e "\033[31m !!!error: There is no such choice,please input the right number.\033[0m"
        return 1
    fi
}

# 找出目录下的所有主题文件
function starship_find_themes() {
    if [ ${#STARSHIP_THEME_PATHS[@]} -gt 0 ]; then
        return 0
    fi

    for file in $(find -L "$starship_path" -type f -name "*.toml" | sort); do
        STARSHIP_THEME_PATHS+=("$file")
    done
}

# 按顺序切换到下一个主题
function starship_change_theme_in_order() {
    starship_find_themes
    if [ ${#STARSHIP_THEME_PATHS[@]} -eq 0 ]; then
        echo "$starship_path 下没有主题文件"
        return 0
    fi

    # zsh数组索引是从1开始,bash是从0开始
    if _logan_if_zsh; then
        # zsh
        if [ $order_index -eq 0 ]; then
            order_index=1
        fi
        if [ $order_index -gt ${#STARSHIP_THEME_PATHS[@]} ]; then
            # 索引大于数组长度时
            order_index=1
        fi
    else
        if [ $order_index -ge ${#STARSHIP_THEME_PATHS[@]} ]; then
            # 索引大于等于数组长度时
            order_index=0
        fi
    fi
    starship_change_theme $order_index
    ((order_index++))
}

# 自选主题
function starship_change_theme_select() {
    starship_find_themes
    if [ ${#STARSHIP_THEME_PATHS[@]} -eq 0 ]; then
        echo "$starship_path 下没有主题文件"
        return 0
    fi

    str="\033[31m           starship 切换主题                \033[0m \n"

    local index=0
    for star_path in "${STARSHIP_THEME_PATHS[@]}"; do
        star_basename=$(basename "$star_path")
        star_basename=${star_basename%.*}
        str+="\033[31m [ $index ] <$star_basename> \033[0m \n"
        ((index++))
    done

    str+="\033[31m [ q ] Exit. \033[0m \n"
    echo -e "$str"
    echo -n "Input your choice :"
    read -r choice

    if [ "$choice" = "q" ]; then
        echo -e "\033[31m exit.....\033[0m"
        return 0
    fi

    _logan_if_zsh && ((choice++))

    starship_change_theme "$choice"

}

function starship_change_theme() {
    star_path=${STARSHIP_THEME_PATHS[$1]}
    export STARSHIP_CONFIG="$star_path"
    if [[ $logan_starship_load -eq 0 ]]; then
        # starship还未加载过
        _starship_load
    fi
    star_basename=$(basename "$star_path")
    star_basename=${star_basename%.*}
    echo -e "\033[31m new theme:  <$star_basename> \033[0m "
}
