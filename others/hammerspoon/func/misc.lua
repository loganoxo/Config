-- 1、模拟键盘粘贴; 一些程序和网站非常努力地阻止你粘贴文本;发出伪造的键盘事件来输入剪贴板内容绕过这个问题
hs.hotkey.bind(HYPER_KEY, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- 2、激活Finder时,自动使所有Finder窗口在前面
local finderWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
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
finderWatcher:start()


-- 3、外部提示(URL方式)
-- 使用 URL 执行 Hammerspoon中的脚本; open -g 'hammerspoon://ExternalAlertUrl?msg=someAlert'
-- 另一种方式是使用ipc命令行工具; /opt/homebrew/bin/hs -c "LOGAN_ALERT('Received someAlert')"
-- 使用URL方式传参数时,如果参数里有特殊字符!&?等时,会有问题; 这时就要用hs.ipc命令行工具
hs.urlevent.bind("ExternalAlertUrl", function(eventName, params)
    local msg = params["msg"] or "无内容"
    LOGAN_ALERT(msg)
end)

-- 4、显示应用BundleID
-- open -g 'hammerspoon://ShowAppBundleID?enable=true'
-- open -g 'hammerspoon://ShowAppBundleID?enable=false'
ShowAppBundleIDFlag = 0
ShowAppBundleIDWatcher = nil
hs.urlevent.bind("ShowAppBundleID", function(eventName, params)
    local enable = params["enable"]
    if enable == "true" then
        if ShowAppBundleIDWatcher == nil then
            ShowAppBundleIDWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
                -- 监听应用程序的激活事件
                if (eventType == hs.application.watcher.activated) then
                    LOGAN_ALERT("AppName:" .. appName .. " ; BundleID为: " .. appObject:bundleID(), 7)
                end
            end)
        end
        ShowAppBundleIDWatcher:start()
        LOGAN_ALERT("成功开启")
        ShowAppBundleIDFlag = 1
    else
        if ShowAppBundleIDWatcher then
            ShowAppBundleIDWatcher:stop()
            ShowAppBundleIDWatcher = nil
            ShowAppBundleIDFlag = 0
            LOGAN_ALERT("成功关闭")
        else
            LOGAN_ALERT("未开启,无法关闭")
        end
    end
end)
-- /opt/homebrew/bin/hs -c 'ReturnShowAppBundleIDFlag()'
function ReturnShowAppBundleIDFlag()
    return ShowAppBundleIDFlag
end
