-- **************************************************
-- 根据 App 自动切换输入法
-- **************************************************

-- --------------------------------------------------
AutoSwitch_LastSourceId = nil

-- 定义你自己想要自动切换输入法的 app
local APP_TO_IME = {
    ['com.googlecode.iterm2'] = CurrentABC,
    ['com.apple.Terminal'] = CurrentABC,
    ['com.bastiaanverreijt.Transnomino'] = CurrentABC,
    ['com.google.Chrome'] = CurrentPinyin,
    ['com.hezongyidev.Bob'] = CurrentPinyin,
    ['com.tencent.qq'] = CurrentPinyin,
    ['com.tencent.xinWeChat'] = CurrentPinyin,
    ['com.openai.chat'] = CurrentPinyin,
    ['company.thebrowser.Browser'] = CurrentPinyin,
}

local exclude = {
    ["jacklandrin.OnlySwitch"] = true,
    ["com.surteesstudios.Bartender"] = true,
    ["com.bjango.istatmenus.status"] = true,
    ["cc.ffitch.shottr"] = true,
    ["com.runningwithcrayons.Alfred"] = true,
    ["org.hammerspoon.Hammerspoon"] = true,
    ["com.lwouis.alt-tab-macos"] = true,
    ["com.xunyong.1capture"] = true,
    ["com.knollsoft.Hookshot"] = true, --Rectangle Pro
    ["com.apple.Preview"] = true,
    ["com.apple.Spotlight"] = true,
    ["com.apple.systempreferences"] = true,
    ["com.apple.loginwindow"] = true,
    ["com.apple.finder"] = true
}

-- --------------------------------------------------

local function updateFocusedAppInputMethod(bundleID)
    local ime = APP_TO_IME[bundleID]
    local currentSourceID = hs.keycodes.currentSourceID()
    -- ~= 为 不等号
    if ime then
        -- 目标应用有明确指定输入法
        if ime ~= currentSourceID then
            AutoSwitch_LastSourceId = currentSourceID
            hs.keycodes.currentSourceID(ime)
        end
    else
        -- 没有指定输入法的情况
        if AutoSwitch_LastSourceId and AutoSwitch_LastSourceId ~= currentSourceID and not exclude[bundleID] then
            hs.keycodes.currentSourceID(AutoSwitch_LastSourceId)
            AutoSwitch_LastSourceId = nil
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
