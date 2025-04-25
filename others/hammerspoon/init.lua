-- ~/.hammerspoon/init.lua
-- 主入口

-- hyper_key
HYPER_KEY = { "cmd", "ctrl", "alt", "shift" }

-- 加载 hs.ipc 模块,否则命令行工具将无法工作;
-- 用法: 命令行中执行  /opt/homebrew/bin/hs -c "LOGAN_ALERT('Received someAlert')"
require("hs.ipc")

-- 加载lib
require('lib')

-- 加载功能
require('func')
