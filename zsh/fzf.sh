# 加载
if _logan_if_command_exist "fzf"; then
    if _logan_if_zsh; then
        eval "$(fzf --zsh)"
    elif _logan_if_bash; then
        eval "$(fzf --bash)"
    fi
fi

# fzf配置
export FZF_FD_EXCLUDE_OPTS="{.git,.mvn,.idea,.vscode,.sass-cache,node_modules,.DS_Store} "
export FZF_DEFAULT_COMMAND="fd -HLI --exclude=$FZF_FD_EXCLUDE_OPTS "

FZF_FACE_OPTS=" --height=85% --layout=reverse --border -m --tmux 82% " #m为多选

# 预览窗口在右方
FZF_PREVIEW_RIGHT_OPTS=" --preview '~/Data/Config/shell/fzf_preview.sh {}' --preview-window right,55%,border,nowrap "

# 预览窗口在上方
FZF_PREVIEW_UP_OPTS=" --preview '~/Data/Config/shell/fzf_preview.sh {}' --preview-window up,5,border,wrap "

FZF_PREVIEW_OPTS="$FZF_PREVIEW_RIGHT_OPTS"

# 默认情况下,预览窗口可以通过 shift+上下箭头 来上下移动
# ctrl-y 复制选项的内容到剪贴板,不通用, ctrl-r中可以正常使用;
# ctrl-w 预览窗口切换换行
# ctrl-s 切换预览窗口的位置
# ctrl-l 触发预览窗口的快捷键,改成ctrl-l,默认为ctrl-/
# ctrl-g 移动到第一行;  ctrl-d 向下翻页;  ctrl-u 向上翻页;
# <C-j> 或 <C-k> 或箭头键在结果列表中导航; <Tab>键可以进行多选;

FZF_BIND_OPTS=" --bind 'ctrl-w:toggle-preview-wrap,ctrl-s:change-preview-window(up,40%|right),ctrl-l:toggle-preview,ctrl-g:top,ctrl-d:page-down,ctrl-u:page-up' "
FZF_BIND_OPTS2=" --bind 'ctrl-y:execute-silent(echo -n {} | pbcopy)' "
# --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'  有+号,复制后直接退出

FZF_HEADER="C-y:copy C-w:wrap C-s:spin C-l:view Tab:mul C-g:top C-d:down C-u:up "
# 其他配置: fzf 行号/搜索项数/全部数 ; +S 表示排序模式已启用; (0) 表示当前的多选模式中已选择的条目数
FZF_INFO_OPTS="--info-command='echo \"\$FZF_POS/\$FZF_INFO 💛 $FZF_HEADER \"'"
if _logan_if_linux; then
    # FZF_INFO_OPTS=""
    :
fi

# fzf窗口的header提示信息,在FZF_INFO_OPTS下一行
FZF_HEADER_OPTS=" --color header:italic --header ' $FZF_HEADER' "
FZF_HEADER_OPTS=""

# catppuccin 的颜色
# bg+ fg+ 为选中的背景色和前景色
# marker selected-bg selected-fg 为用tab键多选 前面的竖线和背景色和前景色
# hl hl+ 为搜索词匹配的颜色
FZF_CATPPUCCIN_COLORS=" \
                      --color=bg+:#313244,fg+:yellow,spinner:#f5e0dc \
                      --color=fg:#cdd6f4,header:#f38ba8,info:magenta,pointer:#f5e0dc \
                      --color=marker:#EE66A6,selected-bg:#151515,selected-fg:green \
                      --color=prompt:blue,hl:#f38ba8,hl+:#f38ba8 "

FZF_DEFAULT_OPTS="$FZF_FACE_OPTS $FZF_CATPPUCCIN_COLORS \
                    $FZF_PREVIEW_OPTS $FZF_BIND_OPTS $FZF_BIND_OPTS2 \
                    $FZF_HEADER_OPTS $FZF_INFO_OPTS"

export FZF_DEFAULT_OPTS
export FZF_COMPLETION_TRIGGER="\\" # 默认为 **

# 默认功能
# fzf 查找当前目录下的所有文件和文件夹
# cd /path/to\<tab> 触发fzf; kill -9 \<TAB> Kill 命令提供了 PID 的模糊补全
# unset \<TAB> 和 export \<TAB> 和 unalias \<TAB>   显示环境变量/别名
# ssh \<TAB> 和 telnet \<TAB>    对于 ssh 和 telnet 命令，提供了主机名的模糊补全。这些名称是从 /etc/hosts 和 ~/.ssh/config 中提取的
# ctrl-r ; FZF_CTRL_R_OPTS; 获取历史命令到终端，不会自动回车，需要自己执行
# ctrl-t ; FZF_CTRL_T_OPTS; 选择当前目录的文件或目录，复制到终端，不会自动回车，需要自己修改
# alt-c ; FZF_ALT_C_OPTS; 列出当前目录下的所有目录(包含子目录),进入所选目录; 和alfred快捷键冲突,所以禁用;用 cd \<TAB>代替
# 和其他工具的配合
# ctrl-g 调用navi备忘录
# zz命令,快速切换目录

FZF_BIND_OPTS3=" --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)' "
export FZF_CTRL_R_OPTS=" --prompt='commands > ' $FZF_FACE_OPTS $FZF_CATPPUCCIN_COLORS \
  --preview 'echo {}' --preview-window up,3,border,wrap,hidden \
  $FZF_BIND_OPTS $FZF_BIND_OPTS3 $FZF_HEADER_OPTS $FZF_INFO_OPTS "

# 禁用ALT-C
export FZF_ALT_C_COMMAND=""
