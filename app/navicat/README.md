# navicat的试用时间重置脚本+定时任务(macos)

> 脚本通过`ShellCheck`检查, no warnings,no errors  
> 仅支持 macos ; navicat 16/17 版本

## 需要修改的内容

> reset.sh 里都是软件安装的默认目录,无特殊情况不用动
> com.logan.reset.navicat.premium.trial.period.plist 里的 Program 要修改成reset.sh的绝对路径
> 按需修改或删除日志记录的绝对路径: StandardOutPath StandardErrorPath

## plist应该放在哪个目录下?

`~/Library/LaunchAgents`                只对当前用户生效的启动项(推荐)

`/Library/LaunchAgents`                 由系统管理员安装的启动项

`/System/Library/LaunchAgents`          系统自带的启动项,由macos提供,不要动

`/Library/LaunchDaemons`                由管理员提供的系统级守护进程

`/System/Library/LaunchDaemons`         由macos提供的系统级守护程序,不要动

守护程序（Daemon）: 会在系统启动时就启动, 没有用户级别,无需用户登录, 并在系统运行期间一直存在;它们通常执行与系统操作或服务相关的任务，比如网络服务、定期备份等。

## 步骤

1、为reset.sh文件授予可执行权限

```shell
chmod u+x /Users/logan/Data/Config/app/navicat/reset.sh
```

2、将com.logan.reset.navicat.premium.trial.period.plist复制到~/Library/LaunchAgents文件夹中，当前用户登录后便会自动加载该定时任务

```shell
cp com.logan.reset.navicat.premium.trial.period.plist ~/Library/LaunchAgents/
# 可能会有系统通知: 有新的登录项. 可以去 设置-通用-登录项 查看
```

3、加载定时任务，如果没有报错则任务就加载成功了，会按照计划执行重置脚本，如果上面开启了加载即执行任务和任务日志输出，此时可以去查看日志文件，获取脚本执行情况 ,-w表示重新登录或重新启动时就加载该服务

```shell
launchctl load -w ~/Library/LaunchAgents/com.logan.reset.navicat.premium.trial.period.plist
```

4、如果要调整plist文件或是停止任务，请执行以下命令后再进行调整

```shell
launchctl list | grep com.logan.reset.navicat.premium.trial.period
launchctl stop com.logan.reset.navicat.premium.trial.period
launchctl kill com.logan.reset.navicat.premium.trial.period
launchctl unload -w ~/Library/LaunchAgents/com.logan.reset.navicat.premium.trial.period.plist
```
