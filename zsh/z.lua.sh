# z.lua 目录跳转 不用了
eval "$(lua "${__PATH_MY_SOFT}"/z.lua/z.lua --init zsh once enhanced fzf)"
export _ZL_CMD="z"
export _ZL_DATA="$HOME/.zlua"
export _ZL_ADD_ONCE="1"
export _ZL_MAXAGE="10000"
export _ZL_ECHO="1"
export _ZL_MATCH_MODE="1"
export _ZL_ROOT_MARKERS=".idea,.git,.svn,.hg,.root,package.json"
