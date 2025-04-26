-- 1、模拟键盘粘贴; 一些程序和网站非常努力地阻止你粘贴文本;发出伪造的键盘事件来输入剪贴板内容绕过这个问题
hs.hotkey.bind(HYPER_KEY, "V", function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
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
local Pinyin = 'com.apple.inputmethod.SCIM.ITABC'
hs.hotkey.bind({ "alt" }, "A", function()
    local currentSourceID = hs.keycodes.currentSourceID()
    -- 切换到中文输入法
    if currentSourceID ~= Pinyin then
        hs.timer.doAfter(0.2, function()
            hs.keycodes.currentSourceID(Pinyin)
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

