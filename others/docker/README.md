## orbstack的配置文件

- ~/.orbstack/config
- 类似 daemon.json
- 通过 ~/.docker/config 找到 orbstack

## daemon.json

- 配置 Docker 守护进程 (dockerd) 的行为，影响服务端功能，例如配置镜像加速、镜像存储路径、网络设置等。
- Linux: /etc/docker/daemon.json
- Windows: %ProgramData%\docker\config\daemon.json
- macOS (Docker Desktop): 通过 GUI 设置;~/Library/Group Containers/group.com.docker/settings.json
- docker安装后不会自动创建这个文件

```json
{
    "registry-mirrors": [
        "https://hub-mirror.c.163.com"
    ],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "data-root": "/var/lib/docker",
    "default-address-pools": [
        {
            "base": "192.168.0.0/16",
            "size": 24
        }
    ]
}
```

## config.json

- 配置 Docker 客户端 (docker CLI) 的行为，例如用户认证信息、默认输出格式等。
- Docker 客户端 的配置
- 只用命令行的话,如果用户没有执行过需要生成配置的操作（如 docker login 或设置客户端选项），此文件不会被自动创建
- docker安装后不会自动创建这个文件
- 当你使用 docker login 命令登录到 Docker Hub 或其他 Docker 镜像仓库时，Docker 会自动创建 ~/.docker/config.json 文件并保存登录凭据

```json
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "dXNlcm5hbWU6cGFzc3dvcmQ="
        }
    },
    "credsStore": "desktop",
    "psFormat": "table {{.ID}}\t{{.Image}}\t{{.Status}}"
}
```
