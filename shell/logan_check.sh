#!/usr/bin/env bash
#
# 脚本名称: logan_check.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: 检查多个git仓库的状态
set -eu

# 仓库路径列表
repos=(
    "$HOME/Data/Config"
    "$HOME/Data/ConfigSensitive"
    "$HOME/Documents/Note/bnotes"
    "$HOME/Documents/Note/anotes"
    "$HOME/Data/Docker"
)

for repo in "${repos[@]}"; do
    if_clean=1
    if_has_remote=1
    echo -e "\033[32mChecking $repo \033[0m......"
    cd "$repo" || {
        echo -e "    \033[31m Failed to access \033[0m"
        continue
    }

    if git remote | grep -q '.'; then
        # 有远程仓库
        git fetch origin >/dev/null 2>&1 || true
    else
        # 没有远程仓库
        if_has_remote=0
    fi

    untracked=$(git status --porcelain | grep -c '^??') || true
    if [ "$untracked" -gt 0 ]; then
        if_clean=0
        echo -e "    \033[35m UnTracked files:\033[0m $untracked"
    fi

    modified=$(git status --porcelain | grep -c '^[[:space:]]*[MADRC]') || true
    if [ "$modified" -gt 0 ]; then
        if_clean=0
        echo -e "    \033[35m UnCommited files:\033[0m $modified"
    fi

    # 如果有远程仓库
    if [ "$if_has_remote" -eq 1 ]; then
        # 检测未 push 的提交
        ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null) || true
        if [ "$ahead" -gt 0 ]; then
            if_clean=0
            echo -e "    \033[35m UnPushed commits:\033[0m $ahead"
        fi

        # 检测本地分支落后远程的情况
        behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null) || true
        if [ "$behind" -gt 0 ]; then
            if_clean=0
            echo -e "    \033[35m Local branch is behind upstream by\033[0m $behind\033[31m commits\033[0m"
        fi
    fi

    if [ "$if_clean" -eq 1 ]; then
        echo -e "    \033[33m everything is clean \033[0m"
    fi
    echo ""
    echo ""
done
