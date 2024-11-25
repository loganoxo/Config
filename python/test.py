import subprocess

# 设置最大列宽
max_column_width = 30

# 获取终端宽度（90%）
terminal_width = subprocess.getoutput("tput cols")
separator_width = int(terminal_width) * 90 // 100

# 获取所有 Docker 容器的 ID
container_ids = subprocess.getoutput("docker ps -q").split()

# 初始化列宽
container_id_width = 0
container_name_width = 0
container_image_width = 0
container_status_width = 0
container_ports_width = 0

# 计算每列的最大宽度
for container_id in container_ids:
    # 获取容器的名称
    container_name = subprocess.getoutput(f"docker inspect --format '{{.Name}}' {container_id}")
    # 去掉容器名前面的斜杠
    container_name = container_name[1:]

    # 获取容器的镜像名称
    container_image = subprocess.getoutput(f"docker inspect --format '{{.Config.Image}}' {container_id}")

    # 获取容器的状态
    container_status = subprocess.getoutput(f"docker inspect --format '{{.State.Status}}' {container_id}")

    # 获取容器的端口映射信息
    container_ports = subprocess.getoutput(f"docker port {container_id}")

    # 计算每列的最大宽度，但不超过最大列宽
    container_id_width_line = len(container_id)
    container_name_width_line = len(container_name)
    container_image_width_line = len(container_image)
    container_status_width_line = len(container_status)
    container_ports_width_line = len(container_ports)

    container_id_width = min(max(container_id_width_line, container_id_width), max_column_width)
    container_name_width = min(max(container_name_width_line, container_name_width), max_column_width)
    container_image_width = min(max(container_image_width_line, container_image_width), max_column_width)
    container_status_width = min(max(container_status_width_line, container_status_width), max_column_width)
    container_ports_width = min(max(container_ports_width_line, container_ports_width), max_column_width)

# 输出分隔线
print("-" * separator_width)

# 输出表头
print(f"{ 'Container ID':<{container_id_width}} | { 'Name':<{container_name_width}} | { 'Image':<{container_image_width}} | { 'Status':<{container_status_width}} | { 'Ports':<{container_ports_width}} ")

# 输出分隔线
print("-" * separator_width)

# 遍历容器并显示信息，根据列宽自适应对齐或换行
for container_id in container_ids:
    # 获取容器的名称
    container_name = subprocess.getoutput(f"docker inspect --format '{{.Name}}' {container_id}")
    # 去掉容器名前面的斜杠
    container_name = container_name[1:]

    # 获取容器的镜像名称
    container_image = subprocess.getoutput(f"docker inspect --format '{{.Config.Image}}' {container_id}")

    # 获取容器的状态
    container_status = subprocess.getoutput(f"docker inspect --format '{{.State.Status}}' {container_id}")

    # 获取容器的端口映射信息
    container_ports = subprocess.getoutput(f"docker port {container_id}")

    # 输出表格行，根据列宽自适应对齐或换行
    print(f"{container_id[:max_column_width]:<{container_id_width}} | {container_name[:max_column_width]:<{container_name_width}} | {container_image[:max_column_width]:<{container_image_width}} | {container_status[:max_column_width]:<{container_status_width}} | {container_ports[:max_column_width]:<{container_ports_width}} ")

    # 输出分隔线
    print("-" * separator_width)
