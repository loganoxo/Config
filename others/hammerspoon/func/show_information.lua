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

-- 显示应用程序的信息
function ShowAppInfoStart()
    ApplicationWatcherSubscribeFirst("ShowInformationWatcher", showAppInformation)
    ApplicationWatcherStart()
end

-- 显示按键信息
function ShowKeyInfoStart()
    if not KeyInformationListener then
        KeyInformationListener = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
            showKeyInformation(event)
            return false -- 允许其他事件继续传播
        end)
    end
    KeyInformationListener:start()
end

-- /opt/homebrew/bin/hs -c 'ShowInformationStart()'
function ShowInformationStart()
    -- 显示应用程序的信息
    ShowAppInfoStart()

    -- 显示按键信息
    ShowKeyInfoStart()

    LOGAN_ALERT("成功开启")

end


-- 停止显示应用程序的信息
function ShowAppInfoStop()
    ApplicationWatcherUnSubscribe("ShowInformationWatcher")
end

-- 停止显示按键信息
function ShowKeyInfoStop()
    KeyInformationListener:stop()
    KeyInformationListener = nil
end

-- /opt/homebrew/bin/hs -c 'ShowInformationStop()'
function ShowInformationStop()
    ShowAppInfoStop()
    ShowKeyInfoStop()
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

---------------------- 加入模态
--- 显示应用详情(实时)
ModalMgr:new("showAppInfoModal")
local showAppInfoModal = ModalMgr.modal_list["showAppInfoModal"]
ModalMgr.supervisor:bind("ctrl", "A", "🟢 显示应用详情(实时)", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    ModalMgr:activate({ "showAppInfoModal" }, "#5F8B4C")
end)
showAppInfoModal:bind('', 'escape', '👋 退出应用详情(实时)', function()
    ModalMgr:deactivate({ "showAppInfoModal" })
    ModalMgr.supervisor:enter() -- 重新进入主模态
end)

showAppInfoModal.entered = function()
    ShowAppInfoStart()
end

showAppInfoModal.exited = function()
    ShowAppInfoStop()
end

--- 显示按键信息(实时)
ModalMgr:new("showKeyInfoModal")
local showKeyInfoModal = ModalMgr.modal_list["showKeyInfoModal"]
ModalMgr.supervisor:bind("ctrl", "K", "🟢 显示按键信息(实时)", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    ModalMgr:activate({ "showKeyInfoModal" }, "#261FB3")
end)
showKeyInfoModal:bind('', 'escape', '👋 退出按键信息(实时)', function()
    ModalMgr:deactivate({ "showKeyInfoModal" })
    ModalMgr.supervisor:enter() -- 重新进入主模态
end)

showKeyInfoModal.entered = function()
    ShowKeyInfoStart()
end

showKeyInfoModal.exited = function()
    ShowKeyInfoStop()
end
