-- 显示各种信息

-- 显示应用程序的信息
local function showAppInformation(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        local content = "AppName:" .. appName .. " ; BundleID为: " .. appObject:bundleID()
        hs.pasteboard.setContents(content)
        LOGAN_ALERT(content, 7)
    end
end

-- 显示按键信息
KeyInformationListener = nil
local function showKeyInformation(event)
    local keyCode = event:getKeyCode()
    local char = event:getCharacters()
    local flags = event:getFlags()
    local ifHyper = IsHyperKey(flags)
    local modifiers = PrintFlags(flags)
    local content = string.format("keyCode: %s, char: %s, modifiers: %s ,ifHyper: %s,",
        keyCode, char, modifiers, ifHyper)
    hs.pasteboard.setContents(content)
    LOGAN_ALERT(content)
end

-- /opt/homebrew/bin/hs -c 'ShowInformationStart()'
function ShowInformationStart()
    -- 显示应用程序的信息
    ApplicationWatcherSubscribeFirst("ShowInformationWatcher", showAppInformation)
    ApplicationWatcherStart()

    -- 显示按键信息
    if not KeyInformationListener then
        KeyInformationListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
            showKeyInformation(event)
            return false -- 允许其他事件继续传播
        end)
    end

    KeyInformationListener:start()

    LOGAN_ALERT("成功开启")

end

-- /opt/homebrew/bin/hs -c 'ShowInformationStop()'
function ShowInformationStop()
    ApplicationWatcherUnSubscribe("ShowInformationWatcher")

    KeyInformationListener:stop()
    KeyInformationListener = nil

    LOGAN_ALERT("成功关闭")
end

-- /opt/homebrew/bin/hs -c 'ShowInformationStatus()'
function ShowInformationStatus()
    if ApplicationWatcherStatus("ShowInformationWatcher") and KeyInformationListener and KeyInformationListener:isEnabled() then
        return 1
    else
        return 0
    end
end
