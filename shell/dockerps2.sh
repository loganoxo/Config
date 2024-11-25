#!/bin/bash
function print_head_line() {
  # 使用 tput 设置文本颜色为红色
  red_text=$(tput setaf 1)
  reset_style=$(tput sgr0)

  # 使用 printf 生成带颜色的分隔线
  printf "${red_text}%*s${reset_style}\n" "$1" "" | tr ' ' '——'
}

function print_content_line() {
  # 使用 tput 设置文本颜色为灰色
  gray_text=$(tput setaf 8)
  reset_style=$(tput sgr0)

  # 使用 printf 生成带颜色的分隔线
  printf "${gray_text}%*s${reset_style}\n" "$1" "" | tr ' ' '-'
}

# 获取终端宽度（90%）
terminal_width=$(tput cols)
separator_width=$((terminal_width * 80 / 100))

header_1="ID"
header_2="Name"
header_3="Image"
header_4="Status"
header_5="Ip"
header_6="Ports"
header_7="Command"
# 初始化最大值为0
width_header=0
width_header=$((width_header > ${#header_1} ? width_header : ${#header_1}))
width_header=$((width_header > ${#header_2} ? width_header : ${#header_2}))
width_header=$((width_header > ${#header_3} ? width_header : ${#header_3}))
width_header=$((width_header > ${#header_4} ? width_header : ${#header_4}))
width_header=$((width_header > ${#header_5} ? width_header : ${#header_5}))
width_header=$((width_header > ${#header_6} ? width_header : ${#header_6}))
width_header=$((width_header > ${#header_7} ? width_header : ${#header_7}))

# 输出分隔线
print_head_line "$terminal_width"

# 获取所有 Docker 容器的 ID
container_ids=$(docker ps -q)
if [ "$1" = "-a" ]; then
  exited_container_ids=$(docker ps -a --format "{{.ID}}" --filter "status=exited")
  container_ids="${container_ids} ${exited_container_ids}"
fi

for container_id in $container_ids; do
  # 输出行
  printf "%-*s | %s\n" \
    "$width_header" "${header_1}" \
    "${container_id}"
  # 输出分隔线
  print_content_line "$separator_width"

  # 获取容器的名称
  container_name=$(docker inspect --format '{{.Name}}' "$container_id")
  # 去掉容器名前面的斜杠
  container_name=${container_name:1}
  printf "%-*s | %s\n" \
    "$width_header" "${header_2}" \
    "${container_name}"
  print_content_line "$separator_width"

  # 获取容器的镜像名称
  container_image=$(docker inspect --format '{{.Config.Image}}' "$container_id")
  printf "%-*s | %s\n" \
    "$width_header" "${header_3}" \
    "${container_image}"
  print_content_line "$separator_width"

  # 获取容器的状态
  container_status=$(docker inspect --format '{{.State.Status}}' "$container_id")
  printf "%-*s | %s\n" \
    "$width_header" "${header_4}" \
    "${container_status}"
  print_content_line "$separator_width"

  # 获取容器的ip信息
  container_ip=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_id")
  printf "%-*s | %s\n" \
    "$width_header" "${header_5}" \
    "${container_ip}"
  print_content_line "$separator_width"

  # 获取容器的端口映射信息
  container_ports=$(docker port "$container_id")
  container_ports=$(echo -n "$container_ports" | tr '\n' ' ')
  printf "%-*s | %s\n" \
    "$width_header" "${header_6}" \
    "${container_ports}"

  print_content_line "$separator_width"
  # 获取容器的内部启动命令
  container_commands=$(docker container ls -a --no-trunc --format "{{.ID}}:{{.Command}}" | awk -F ':' "/$container_id/{print $2}")
  printf "%-*s | %s\n" \
    "$width_header" "${header_7}" \
    "${container_commands}"
  print_head_line "$terminal_width"
done
