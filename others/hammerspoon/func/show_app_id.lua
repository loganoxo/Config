-- 显示应用BundleID
-- 开启:    open -g 'hammerspoon://ShowAppBundleID?enable=true'
-- 关闭:    open -g 'hammerspoon://ShowAppBundleID?enable=false'
-- 状态:    /opt/homebrew/bin/hs -c 'ReturnShowAppBundleIDFlag()'
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

function ReturnShowAppBundleIDFlag()
    return ShowAppBundleIDFlag
end
