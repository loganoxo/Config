#!/usr/bin/env bash
# e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行,需要对父脚本的全局变量操作，所以不加
set -e

# 预先判断
function verify() {
  if ! declare -p file_list >/dev/null 2>&1; then
    echo "!!!error: custom_rename.sh,file_list is not declared."
    exit 1
  fi
  if ! declare -p custom_list >/dev/null 2>&1; then
    echo "!!!error: custom_rename.sh,custom_list is not declared."
    exit 1
  fi

  set +u #需要对父脚本的全局变量操作
  if [ "${#file_list[@]}" -eq 0 ]; then
    echo "!!!error: custom_rename.sh,旧文件数组file_list为空数组，脚本停止运行"
    exit 1 #校验失败
  fi
}

######################## 自定义操作 ##################
function custom_operation() {
  verify     #先校验
  operation1 #执行操作
}

# 一、自定义操作-加序号
function operation1() {
  custom_list=()
  for ((i = 0; i < ${#file_list[@]}; i++)); do
    temp=$(printf "%03d" $((i + 1)))
    old="${file_list[i]}"
    new="$temp-$old"
    custom_list+=("$new")
  done
}

set -u #还原
