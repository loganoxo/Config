#!/opt/homebrew/bin/bash
# 需要bash版本>=4 mac下/bin/bash版本是3  可以用： #!/usr/bin/env bash ，自动去path找第一个bath
# declare -A container_info 关联数组，键值对 要bash版本>=4
# declare -a 一维数组，bash3也支持
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

function trim() {
  original_string=$1
  trimmed_string="${original_string#"${original_string%%[![:space:]]*}"}"
  trimmed_string="${trimmed_string%"${trimmed_string##*[![:space:]]}"}"
  echo "$trimmed_string"
}

# 获取终端宽度（90%）
terminal_width=$(tput cols)
separator_width=$((terminal_width * 90 / 100))

# 获取所有 Docker 容器的 ID
container_ids=$(docker ps -q)
if [ "$1" = "-a" ]; then
  exited_container_ids=$(docker ps -a --format "{{.ID}}" --filter "status=exited")
  container_ids="${container_ids} ${exited_container_ids}"
fi

# 初始化容器信息数组,关联数组，键值对
declare -A container_info
for container_id in $container_ids; do
  container_name=$(docker inspect --format '{{.Name}}' "$container_id")
  container_name=${container_name:1}
  container_image=$(docker inspect --format '{{.Config.Image}}' "$container_id")
  container_status=$(docker inspect --format '{{.State.Status}}' "$container_id")
  container_ip=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_id")
  container_ports=$(docker port "$container_id")
  # 去除IPV6的端口映射
  container_ports=$(echo "$container_ports" | grep -v '\[::\]')
  # 去除换行
  container_name=$(echo -n "$container_name" | tr '\n' ' ')
  container_image=$(echo -n "$container_image" | tr '\n' ' ')
  container_status=$(echo -n "$container_status" | tr '\n' ' ')
  container_ip=$(echo -n "$container_ip" | tr '\n' ' ')
  container_ports=$(echo -n "$container_ports" | tr '\n' ' ')

  # 去除行首行尾空格
  container_name=$(trim "$container_name")
  container_image=$(trim "$container_image")
  container_status=$(trim "$container_status")
  container_ip=$(trim "$container_ip")
  container_ports=$(trim "$container_ports")

  # 获取容器的名称
  container_info["$container_id,name"]=$container_name

  # 获取容器的镜像名称
  container_info["$container_id,image"]=$container_image

  # 获取容器的状态
  container_info["$container_id,status"]=$container_status

  # 获取容器的ip信息
  container_info["$container_id,ip"]=$container_ip

  # 获取容器的端口映射信息
  container_info["$container_id,ports"]=$container_ports

done

# 初始化列宽
container_id_width=0
container_name_width=0
container_image_width=0
container_status_width=0
container_ip_width=0
container_ports_width=0

# 计算每列的最大宽度
for container_id in $container_ids; do
  container_name="${container_info["$container_id,name"]}"
  container_image="${container_info["$container_id,image"]}"
  container_status="${container_info["$container_id,status"]}"
  container_ip="${container_info["$container_id,ip"]}"
  container_ports="${container_info["$container_id,ports"]}"

  # 计算每列的最大宽度
  container_id_width=$((${#container_id} > container_id_width ? ${#container_id} : container_id_width))
  container_name_width=$((${#container_name} > container_name_width ? ${#container_name} : container_name_width))
  container_image_width=$((${#container_image} > container_image_width ? ${#container_image} : container_image_width))
  container_status_width=$((${#container_status} > container_status_width ? ${#container_status} : container_status_width))
  container_ip_width=$((${#container_ip} > container_ip_width ? ${#container_ip} : container_ip_width))
  container_ports_width=$((${#container_ports} > container_ports_width ? ${#container_ports} : container_ports_width))
done
# 输出分隔线
print_head_line "$terminal_width"
# 输出表头
printf "%-*s | %-*s | %-*s | %-*s | %-*s | %s\n" \
  "$container_id_width" "Container ID" \
  "$container_name_width" "Name" \
  "$container_image_width" "Image" \
  "$container_status_width" "Status" \
  "$container_ip_width" "Ip" \
  "Ports"

# 输出分隔线
print_head_line "$terminal_width"

# 遍历容器并显示信息，根据列宽自适应对齐或换行
for container_id in $container_ids; do
  container_name="${container_info["$container_id,name"]}"
  container_image="${container_info["$container_id,image"]}"
  container_status="${container_info["$container_id,status"]}"
  container_ip="${container_info["$container_id,ip"]}"
  container_ports="${container_info["$container_id,ports"]}"

  # 输出表格行，根据列宽自适应对齐或换行
  printf "%-*s | %-*s | %-*s | %-*s | %-*s | %s\n" \
    "$container_id_width" "${container_id}" \
    "$container_name_width" "${container_name}" \
    "$container_image_width" "${container_image}" \
    "$container_status_width" "${container_status}" \
    "$container_ip_width" "${container_ip}" \
    "${container_ports}"

  # 输出分隔线
  print_content_line "$terminal_width"
done
