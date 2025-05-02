-- **************************************************
-- 根据 App 自动切换输入法
-- **************************************************

-- --------------------------------------------------
local lastSourceId = hs.keycodes.currentSourceID()

-- 定义你自己想要自动切换输入法的 app
local APP_TO_IME = {
    ['com.googlecode.iterm2'] = CurrentABC,
    ['com.apple.Terminal'] = CurrentABC,
    ['com.google.Chrome'] = CurrentPinyin,
    ['com.hezongyidev.Bob'] = CurrentPinyin,
    ['com.tencent.qq'] = CurrentPinyin,
    ['com.tencent.xinWeChat'] = CurrentPinyin,
    ['com.openai.chat'] = CurrentPinyin,
}
-- --------------------------------------------------

local function updateFocusedAppInputMethod(bundleID)
    local ime = APP_TO_IME[bundleID]
    local currentSourceID = hs.keycodes.currentSourceID()
    if ime then
        if ime ~= currentSourceID then
            lastSourceId = currentSourceID
            hs.keycodes.currentSourceID(ime)
        end
    else
        if lastSourceId and lastSourceId ~= currentSourceID then
            hs.keycodes.currentSourceID(lastSourceId)
            lastSourceId = nil
        end
    end
end

-- /opt/homebrew/bin/hs -c 'AutoSwitchInputMethodStart()'
function AutoSwitchInputMethodStart()
    ApplicationWatcherSubscribeFirst("AutoSwitchInputMethodWatcher", function(appName, eventType, appObject)
        if (eventType == hs.application.watcher.activated) then
            hs.timer.doAfter(0.2, function()
                updateFocusedAppInputMethod(appObject:bundleID())
            end)
        end
    end)
    ApplicationWatcherStart()
end

-- /opt/homebrew/bin/hs -c 'AutoSwitchInputMethodStop()'
function AutoSwitchInputMethodStop()
    ApplicationWatcherUnSubscribe("AutoSwitchInputMethodWatcher")
end

-- /opt/homebrew/bin/hs -c 'AutoSwitchInputMethodStatus()'
function AutoSwitchInputMethodStatus()
    if ApplicationWatcherStatus("AutoSwitchInputMethodWatcher") then
        return 1
    else
        return 0
    end
end

AutoSwitchInputMethodStart()
