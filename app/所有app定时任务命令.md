1、为 reset-navicat.sh 文件授予可执行权限

```shell
chmod u+x "${__PATH_MY_CNF}/app/bcompare/reset-bcompare.sh"
chmod u+x "${__PATH_MY_CNF}/app/navicat/reset-navicat.sh"
chmod u+x "${__PATH_MY_CNF}/app/typora/reset-typora.sh"
```

2、将 plist 复制到~/Library/LaunchAgents 文件夹中，当前用户登录后便会自动加载该定时任务

```shell
cp "${__PATH_MY_CNF}/app/bcompare/com.logan.reset.bcompare.trial.period.plist" ~/Library/LaunchAgents/
cp "${__PATH_MY_CNF}/app/jetbrains/jetbrains.vmoptions.plist" ~/Library/LaunchAgents/
cp "${__PATH_MY_CNF}/app/navicat/com.logan.reset.navicat.premium.trial.period.plist" ~/Library/LaunchAgents/
cp "${__PATH_MY_CNF}/app/typora/com.logan.reset.typora.trial.period.plist" ~/Library/LaunchAgents/
# aria2
cp "${HOME}/Data/ConfigSensitive/aria2/com.logan.aria2.plist" ~/Library/LaunchAgents/
# 可能会有系统通知: 有新的登录项. 可以去 设置-通用-登录项 查看
```

3、加载定时任务，如果没有报错则任务就加载成功了，会按照计划执行重置脚本，如果上面开启了加载即执行任务和任务日志输出，此时可以去查看日志文件，获取脚本执行情况 ,-w 表示重新登录或重新启动时就加载该服务

```shell
launchctl load -w ~/Library/LaunchAgents/com.logan.reset.bcompare.trial.period.plist
launchctl load -w ~/Library/LaunchAgents/jetbrains.vmoptions.plist
launchctl load -w ~/Library/LaunchAgents/com.logan.reset.navicat.premium.trial.period.plist
launchctl load -w ~/Library/LaunchAgents/com.logan.reset.typora.trial.period.plist
# aria2
launchctl load -w ~/Library/LaunchAgents/com.logan.aria2.plist
```

4、如果要调整 plist 文件或是停止任务，请执行以下命令后再进行调整

```shell
launchctl list | grep com.logan.reset.navicat.premium.trial.period
launchctl stop com.logan.reset.navicat.premium.trial.period
launchctl kill com.logan.reset.navicat.premium.trial.period
launchctl unload -w ~/Library/LaunchAgents/com.logan.reset.navicat.premium.trial.period.plist
```
