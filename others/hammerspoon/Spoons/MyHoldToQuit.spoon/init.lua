--- === HoldToQuit ===
---
--- Instead of pressing ⌘Q, hold ⌘Q to close applications.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "HoldToQuit"
obj.version = "1.0"
obj.author = "Matthias Strauss <matthias.strauss@mayflower.de>"
obj.github = "@MattFromGer"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- HoldToQuit.duration
--- Variable
--- Integer containing the duration (in seconds) how long to hold
--- the hotkey. Default 1.
obj.duration = 1

--- HoldToQuit.defaultHotkey
--- Variable
--- Default hotkey mapping
obj.defaultHotkey = {
    quit = { { "cmd" }, "Q" }
}

--- HoldToQuit.hotkeyQbj
--- Variable
--- Hotkey object
obj.hotkeyQbj = nil

--- HoldToQuit.timer
--- Variable
--- Timer for counting the holding time
obj.timer = nil

-- 记录当前应用的ID
MyHoldToQuitBundleID = nil
MyHoldToQuitName = nil
MyHoldToQuitW = nil
MyHoldToQuitH = nil
MyHoldToQuitX = nil
MyHoldToQuitY = nil
MyHoldToQuitAlert = false

obj.exclude = {
    ["org.hammerspoon.Hammerspoon"] = true,
    ["com.apple.Preview"] = true,
    ["com.apple.Spotlight"] = true,
    ["com.apple.systempreferences"] = true,
    ["com.apple.loginwindow"] = true,
    ["com.apple.finder"] = true,
    ["com.tencent.WeTypeSettings"] = true,
}

obj.immediately = {
    ["com.apple.Stickies"] = true
}

function obj:check_window(win)
    if not win or not win:isStandard() or not win:isVisible() or win:isMinimized() then
        LOGAN_ALERT("没有可用窗口", 2)
        return false
    end
    return true
end

function obj:check_app(bundleID)
    if self.exclude[bundleID] then
        return false
    else
        return true
    end
end

function obj:if_immediately(bundleID)
    if self.immediately[bundleID] then
        return true
    else
        return false
    end
end

--- HoldToQuit.killCurrentApp()
--- Method
--- Kill the frontmost application
---
--- Parameters:
---  * None
function obj:killCurrentApp()
    local win = hs.window.focusedWindow()
    if obj:check_window(win) then
        local app = win:application()
        if not app then
            hs.alert.show("没有可退出的app")
        end
        local appBundleID = app:bundleID()
        if not obj:check_app(appBundleID) then
            hs.alert.show("当前app不能退出: " .. appBundleID)
            return
        end
        if appBundleID == MyHoldToQuitBundleID then
            MyHoldToQuitAlert = true
            hs.application.get("org.hammerspoon.Hammerspoon"):setFrontmost()
            hs.dialog.alert(MyHoldToQuitX + (MyHoldToQuitW - 260) / 2 + 125, MyHoldToQuitY + (MyHoldToQuitH / 2) - 98, function(result)
                MyHoldToQuitAlert = false
                if result == "OK" then
                    app:kill()
                    hs.alert.show("正在退出 " .. app:name() .. " ...")
                elseif result == "Cancel" then
                    hs.alert.show("已取消!")
                else
                    hs.alert.show("错误的按钮!")
                end
            end, "是否要退出 " .. app:name() .. " ?", "退出期间不能切换应用,否则会失败", "OK", "Cancel", "warn")

            -- 置顶alert
            hs.timer.doWhile(function()
                return MyHoldToQuitAlert
            end, function()
                if MyHoldToQuitAlert then
                    hs.application.get("org.hammerspoon.Hammerspoon"):setFrontmost()
                end
            end, 0.1)
        else
            hs.alert.show("App已被切换,不能退出! 按键时: " .. MyHoldToQuitName .. "; 当前: " .. app:name())
        end
    else
        hs.alert.show("没有聚焦窗口!")
    end
end

--- HoldToQuit:init()
--- Method
--- Initialize spoon
---
--- Parameters:
---  * None
function obj:init()
    self.timer = hs.timer.delayed.new(self.duration, self.killCurrentApp)
end

--- HoldToQuit:onKeyDown()
--- Method
--- Start timer on keyDown
---
--- Parameters:
---  * None
function obj:onKeyDown()
    if not MyHoldToQuitAlert then
        local win = hs.window.focusedWindow()
        if obj:check_window(win) then
            local app = win:application()
            local appBundleID = app:bundleID()
            if obj:if_immediately(appBundleID) then
                app:kill()
                return
            end
            if not obj:check_app(appBundleID) then
                hs.alert.show("当前app不能退出: " .. appBundleID)
                return
            end
            local max = win:frame()

            MyHoldToQuitBundleID = appBundleID --记录按下键时当前app的id,实际退出时进行判断
            MyHoldToQuitName = app:name() --记录按下键时当前app的id,实际退出时进行判断
            MyHoldToQuitW = max.w
            MyHoldToQuitH = max.h
            MyHoldToQuitX = max.x
            MyHoldToQuitY = max.y
            self.timer:start()
        end
    else
        hs.alert.show("一个一个退出!")
    end

end

--- HoldToQuit:onKeyUp()
--- Method
--- Stop Timer & show alert message
---
--- Parameters:
---  * None
function obj:onKeyUp()
    if self.timer:running() then
        self.timer:stop()
        local app = hs.application.frontmostApplication()
        hs.alert.show("Hold ⌘Q to quit " .. app:name())
    end
end

--- HoldToQuit:start()
--- Method
--- Start HoldToQuit with default hotkey
---
--- Parameters:
---  * None
function obj:start()
    if (self.hotkeyQbj) then
        self.hotkeyQbj:enable()
    else
        local mod = self.defaultHotkey["quit"][1]
        local key = self.defaultHotkey["quit"][2]
        self.hotkeyQbj = hs.hotkey.bind(mod, key, function()
            obj:onKeyDown()
        end, function()
            obj:onKeyUp()
        end)
    end
end

--- HoldToQuit:stop()
--- Method
--- Disable HoldToQuit hotkey
---
--- Parameters:
---  * None
function obj:stop()
    if (self.hotkeyQbj) then
        self.hotkeyQbj:disable()
    end
end

--- HoldToQuit:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for HoldToQuit
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * show - This will define the quit hotkey
function obj:bindHotkeys(mapping)
    if (self.hotkeyQbj) then
        self.hotkeyQbj:delete()
    end

    local mod = mapping["quit"][1]
    local key = mapping["quit"][2]
    self.hotkeyQbj = hs.hotkey.bind(mod, key, function()
        obj:onKeyDown()
    end, function()
        obj:onKeyUp()
    end)

    return self
end

return obj
