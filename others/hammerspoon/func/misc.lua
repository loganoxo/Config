-- 1、模拟键盘粘贴; 一些程序和网站非常努力地阻止你粘贴文本;发出伪造的键盘事件来输入剪贴板内容绕过这个问题
hs.hotkey.bind(HYPER_KEY, "V", "模拟键盘粘贴", function()
    if Smart_Punct_Status() == 1 then
        LOGAN_ALERT("需要先关闭智能标点")
    else
        hs.eventtap.keyStrokes(hs.pasteboard.getContents())
    end
end)

-- 2、激活Finder时,自动使所有Finder窗口在前面
ApplicationWatcherSubscribeAppend("FinderWatcher", function(appName, eventType, appObject)
    -- LOGAN_ALERT("FinderWatcher")
    -- 监听应用程序的激活事件
    if (eventType == hs.application.watcher.activated) then
        if (appObject:bundleID() == "com.apple.finder") then
            -- 前台调度未开启时才激活这个功能
            if not IsStageManagerEnabled() then
                -- 如果激活的是Finder应用程序,则模拟点击菜单栏的"Window" -> "Bring All to Front"
                -- 这将使所有Finder窗口在前面
                -- 搜索菜单项,区分中英文
                appObject:selectMenuItem({ "窗口", "前置全部窗口" })
            end
        end
    end
end)
ApplicationWatcherStart()


-- 3、外部提示(URL方式)
-- 使用 URL 执行 Hammerspoon中的脚本; open -g 'hammerspoon://ExternalAlertUrl?msg=someAlert'
-- 另一种方式是使用ipc命令行工具; /opt/homebrew/bin/hs -c "LOGAN_ALERT('Received someAlert')"
-- 使用URL方式传参数时,如果参数里有特殊字符!&?等时,会有问题; 这时就要用hs.ipc命令行工具
hs.urlevent.bind("ExternalAlertUrl", function(eventName, params)
    local msg = params["msg"] or "无内容"
    LOGAN_ALERT(msg)
end)

-- 4、Option+A 快捷键打开bob翻译窗口时,自动切换输入法到中文
hs.hotkey.bind({ "alt" }, "A", "bob", function()
    local currentSourceID = hs.keycodes.currentSourceID()
    -- 切换到中文输入法
    if currentSourceID ~= CurrentPinyin then
        hs.timer.doAfter(0.2, function()
            hs.keycodes.currentSourceID(CurrentPinyin)
        end)
    end
    -- 启动bob
    local js = [[
        bob = Application("com.hezongyidev.Bob")
        bob.request(JSON.stringify({
            "path": "translate",
            "body": {
                "action": "inputTranslate",
            }
        }))
    ]]

    hs.osascript.javascript(js)
end)

-- 5、按住 CMD+Q 一段时间 才会退出应用程序
MyHoldToQuit = hs.loadSpoon("MyHoldToQuit")
MyHoldToQuit:start()

-- 6、重载hammerspoon(全局方法,供外部使用)
-- /opt/homebrew/bin/hs -c 'MY_RELOAD()'
function MY_RELOAD()
    -- 要先返回,异步执行重载,否则onlySwitch不能保存成功
    hs.timer.doAfter(0.1, function()
        hs.reload()
    end)
end


--------------  以下为主模态中可以执行的快捷键

-- 1、显示当前App的详细信息
local function showAppInformation()
    local win = hs.window.focusedWindow()
    local app = win:application()
    local str = "App name:      " .. app:name() .. "\n"
        .. "App path:      " .. app:path() .. "\n"
        .. "App bundle:    " .. app:bundleID() .. "\n"
        .. "App pid:       " .. app:pid() .. "\n"
        .. "Win title:     " .. win:title() .. "\n"
        .. "输入法ID:       " .. hs.keycodes.currentSourceID() .. "\n"
        .. "键盘布局:       " .. hs.keycodes.currentLayout() .. "\n"
        .. "输入法名称:      " .. hs.keycodes.currentMethod() .. "\n"
    hs.pasteboard.setContents(str)
    LOGAN_ALERT_BOTTOM(str, 10)
end
ModalMgr.supervisor:bind("ctrl", "A", "🟢 显示当前App的信息(hyperKey+A)", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    showAppInformation()
    ModalMgr.supervisor:enter() -- 重新进入主模态
end)
-- 额外绑定一个非模态下的快捷键
hs.hotkey.bind(HYPER_KEY, "A", "显示当前App的信息", function()
    showAppInformation()
end)

-- 2、应用程序菜单搜索窗
local MC = hs.loadSpoon("MenuChooser")
ModalMgr.supervisor:bind("ctrl", "M", "🟢 应用程序菜单搜索窗", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    MC.chooseMenuItem()
    ModalMgr.supervisor:exit() -- 直接退出主模态
end)

-- 3、显示注册的所有快捷键
local HSKeybindings = hs.loadSpoon("HSKeybindings")
ModalMgr:new("hSKeybindingsModal")
local hSKeybindingsModal = ModalMgr.modal_list["hSKeybindingsModal"]
ModalMgr.supervisor:bind("ctrl", "H", "🟢 显示注册的所有快捷键", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    ModalMgr:activate({ "hSKeybindingsModal" }, "#166678")
end)
hSKeybindingsModal:bind("", "escape", "👋 退出显示", function()
    ModalMgr:deactivate({ "hSKeybindingsModal" })
    ModalMgr.supervisor:enter() -- 重新进入主模态
end)
hSKeybindingsModal.entered = function()
    HSKeybindings:show()
end
hSKeybindingsModal.exited = function()
    HSKeybindings:hide()
end

-------------- 弃用
-- 专注模式
if false then
    local fhl = hs.loadSpoon("FocusHighlight")
    local function toggleFocusMode()
        if hs.settings.get("focusModeEnable") then
            -- hs.window.highlight.stop()
            fhl:stop()
            hs.settings.set("focusModeEnable", false)
        else
            -- hs.window.highlight.ui.overlay = true
            -- hs.window.highlight.ui.flashDuration = 0.1
            -- hs.window.highlight.start()
            fhl.color = "#f9bc34"
            fhl.windowFilter = hs.window.filter.default
            fhl.arrowSize = 128
            fhl.arrowFadeOutDuration = 1
            fhl.highlightFadeOutDuration = 2
            fhl.highlightFillAlpha = 0.3
            fhl:start()
            hs.settings.set("focusModeEnable", true)
        end
    end
    ModalMgr.supervisor:bind("ctrl", "F", "🟢 开启/关闭专注模式", function()
        ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
        toggleFocusMode()
        ModalMgr.supervisor:exit() -- 直接退出主模态
    end)
end
