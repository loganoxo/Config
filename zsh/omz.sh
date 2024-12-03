# shellcheck disable=SC2034
# ##################### ohmyzsh配置 ##########################
export ZSH="$HOME/.oh-my-zsh"
export DRACULA_ARROW_ICON="\uf061 "

# ZSH_THEME="mydracula"
# ZSH_THEME="jonathan"
# ZSH_THEME="random"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
export DRACULA_DISPLAY_CONTEXT=1

# ohmyzsh自动更新设置
zstyle ':omz:update' mode disabled # 关闭更新
# zstyle ':omz:update' mode auto      # 不提示，直接更新
# zstyle ':omz:update' mode reminder  # 提示更新

# zstyle ':omz:update' frequency 13 #ohmyzsh自动更新间隔
# 禁止更改标题  tab补全没有内容时显示红点 历史命令日期格式
DISABLE_AUTO_TITLE="true"

# 日期格式
HIST_STAMPS="yyyy-mm-dd" # 在history.sh 中有重新配置

plugins=(
    git
    colored-man-pages
    # fzf 自己执行
    docker
    docker-compose
    # kubectl
    # macos
    # 以下需要自己安装
    #~/.oh-my-zsh/custom/plugins,
    #https://github.com/zsh-users/zsh-syntax-highlighting
    zsh-syntax-highlighting
    #~/.oh-my-zsh/custom/plugins,
    #https://github.com/zsh-users/zsh-autosuggestions
    zsh-autosuggestions
    #brew install autojump
    # autojump
)

# 加载ohmyzsh
if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

#################################### ohmyzsh 加载后的配置 ###############################

#命令补全颜色 https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5f5f00,bg=#3a3a3a,bold,underline"
bindkey '^ ' autosuggest-accept

#去掉右箭头和autosuggestion的绑定--开始
temp_array=()
for ele in "${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[@]}"; do
    if [ "$ele" != "forward-char" ]; then
        temp_array+=("$ele")
    fi
done
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=()
for new_ele in "${temp_array[@]}"; do
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=("$new_ele")
done
#去掉右箭头和autosuggestion的绑定--结束

ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char) #右箭头一个一个接受,默认右箭头是直接接受全部
ZSH_AUTOSUGGEST_STRATEGY=(history completion)          #首先尝试从您的历史记录中查找建议,找不到匹配项,则会从补全引擎中查找建议
