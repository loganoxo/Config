--- === InputMethodIndicator ===
--- 输入法状态指示器模块
-- 在屏幕中心位置显示彩色圆点指示当前输入法状态
-- 英文输入法显示绿点,非英文输入法显示红点

-- 默认配置参数
InputMethodIndicatorObj = {
    ABCColor = "#62C555",           -- ABC输入法颜色(绿色)
    LocalLanguageColor = "#ED6A5E", -- 其他语言输入法颜色(红色)
    showOnChangeDuration = 5,       -- 变化显示时长(秒)
    dotSize = 25,                   -- 圆点尺寸
    deltaY = 18,                    -- 垂直偏移量(距离光标位置)
    deltaX = 10,                    -- 水平偏移量(距离光标位置)
}

local exclude = {
    ["com.apple.finder"] = true, -- Finder
    ["jacklandrin.OnlySwitch"] = true,
    ["com.surteesstudios.Bartender"] = true,
    ["com.bjango.istatmenus.status"] = true,
    ["cc.ffitch.shottr"] = true,
    ["com.runningwithcrayons.Alfred"] = true,
    ["org.hammerspoon.Hammerspoon"] = true,
    ["com.apple.systemevents"] = true,
    ["com.apple.Preview"] = true,
    ["com.apple.Spotlight"] = true,
    ["com.apple.systempreferences"] = true,
}


local function hideOrDeleteCanvas(str)
    if str == "hide" then
        if InputMethodIndicatorObj.canvas then
            InputMethodIndicatorObj.canvas:hide() -- 删除画布
        end
        if InputMethodIndicatorObj.hideCanvasTimer then
            InputMethodIndicatorObj.hideCanvasTimer:stop() -- 停止定时器
        end
    else
        if InputMethodIndicatorObj.canvas then
            InputMethodIndicatorObj.canvas:delete() -- 删除画布
            InputMethodIndicatorObj.canvas = nil    -- 清空画布对象
        end
        if InputMethodIndicatorObj.hideCanvasTimer then
            InputMethodIndicatorObj.hideCanvasTimer:stop() -- 停止定时器
            InputMethodIndicatorObj.hideCanvasTimer = nil  -- 清空定时器对象
        end
    end
end

--- 模块初始化 创建画布对象并设置初始状态
local function showCanvas()
    local win = hs.window.focusedWindow()
    local frame = nil
    if win then
        if exclude[win:application():bundleID()] then
            if InputMethodIndicatorObj.canvas then
                hideOrDeleteCanvas("hide")
            end
        else
            -- LOGAN_ALERT(win:application():bundleID())
            frame = win:frame() -- 获取窗口的位置和尺寸
        end
    else
        -- 获取主屏幕的信息
        local screen = hs.screen.mainScreen()
        frame = screen:frame() -- 获取屏幕大小和位置
    end
    if frame then
        -- 计算窗口中心点
        local centerX = frame.x + frame.w / 2 -- 中心 X 坐标
        local centerY = frame.y + frame.h / 2 -- 中心 Y 坐标
        -- LOGAN_ALERT(win:title() .. "的窗口中心:" .. centerX .. "----" .. centerY)

        -- 创建画布并显示在屏幕中心
        if not InputMethodIndicatorObj.canvas then                 -- 首次初始化时创建画布
            InputMethodIndicatorObj.canvas = hs.canvas.new({       -- 创建新画布
                x = centerX - InputMethodIndicatorObj.dotSize / 2, -- 水平居中
                y = centerY - InputMethodIndicatorObj.dotSize / 2, -- 垂直居中
                w = InputMethodIndicatorObj.dotSize,               -- 宽度
                h = InputMethodIndicatorObj.dotSize                -- 高度
            })
        else
            InputMethodIndicatorObj.canvas:topLeft({               -- 设置画布位置
                x = centerX - InputMethodIndicatorObj.dotSize / 2, -- X偏移
                y = centerY - InputMethodIndicatorObj.dotSize / 2  -- Y偏移
            })
        end

        -- 获取当前输入法并设置初始颜色
        local sourceID = hs.keycodes.currentSourceID()
        if sourceID == "com.apple.keylayout.ABC" then
            InputMethodIndicatorObj.color = InputMethodIndicatorObj.ABCColor
        else
            InputMethodIndicatorObj.color = InputMethodIndicatorObj.LocalLanguageColor
        end

        -- 配置画布元素(圆形)
        InputMethodIndicatorObj.canvas[1] = {
            action = "fill",                                     -- 填充图形
            type = "circle",                                     -- 圆形类型
            fillColor = { hex = InputMethodIndicatorObj.color }, -- 填充颜色
            frame = {                                            -- 圆形尺寸和位置
                x = 0,
                y = 0,
                h = InputMethodIndicatorObj.dotSize, -- 高度
                w = InputMethodIndicatorObj.dotSize  -- 宽度
            }
        }
        InputMethodIndicatorObj.canvas:show() -- 显示画布
        -- 重置定时器
        if InputMethodIndicatorObj.hideCanvasTimer then
            InputMethodIndicatorObj.hideCanvasTimer:stop()
            InputMethodIndicatorObj.hideCanvasTimer:start()
        else
            InputMethodIndicatorObj.hideCanvasTimer = hs.timer.doAfter(InputMethodIndicatorObj.showOnChangeDuration,
                function()
                    InputMethodIndicatorObj.canvas:hide()
                end)
        end
    end
end


-- /opt/homebrew/bin/hs -c 'MyInputMethodIndicatorStart()'
function MyInputMethodIndicatorStart()
    -- 监听输入法切换,延迟显示
    hs.keycodes.inputSourceChanged(function()
        local realChange = false
        local currentSourceID = hs.keycodes.currentSourceID()
        -- print("a1:" .. currentSourceID)
        -- print("a2:" .. (InputMethodIndicatorObj.lastSourceId or "nil"))
        if InputMethodIndicatorObj.lastSourceId and InputMethodIndicatorObj.lastSourceId == currentSourceID then
            realChange = false
        else
            InputMethodIndicatorObj.lastSourceId = hs.keycodes.currentSourceID()
            realChange = true
        end

        if realChange then
            if InputMethodIndicatorObj.canvas and InputMethodIndicatorObj.canvas:isShowing() then
                showCanvas()
            else
                hs.timer.doAfter(0.2, function()
                    showCanvas()
                end)
            end
        end
    end)

    -- 监听应用程序激活事件
    ApplicationWatcherSubscribeAppend("MyInputMethodIndicatorWatcher", function(appName, eventType, appObject)
        if (eventType == hs.application.watcher.activated) then
            local currentSourceID = hs.keycodes.currentSourceID()
            local canvasVisible = InputMethodIndicatorObj.canvas and InputMethodIndicatorObj.canvas:isShowing()
            -- print("b1:" .. currentSourceID)
            -- print("b2:" .. (InputMethodIndicatorObj.lastSourceId or "nil"))
            local realChange = false
            if InputMethodIndicatorObj.lastSourceId and InputMethodIndicatorObj.lastSourceId == currentSourceID then
                realChange = false
            else
                InputMethodIndicatorObj.lastSourceId = hs.keycodes.currentSourceID()
                realChange = true
            end
            if canvasVisible and realChange then
                hideOrDeleteCanvas("hide")
                hs.timer.doAfter(0.2, function()
                    showCanvas()
                end)
            elseif not canvasVisible then
                hs.timer.doAfter(0.2, function()
                    showCanvas()
                end)
            end
        end
    end)
    ApplicationWatcherStart()
end

-- /opt/homebrew/bin/hs -c 'MyInputMethodIndicatorStop()'
function MyInputMethodIndicatorStop()
    ApplicationWatcherUnSubscribe("MyInputMethodIndicatorWatcher")
    hs.keycodes.inputSourceChanged(nil) -- 停止监听输入法变化
    -- 清除画布
    hideOrDeleteCanvas("delete")
end

-- /opt/homebrew/bin/hs -c 'MyInputMethodIndicatorStatus()'
function MyInputMethodIndicatorStatus()
    if ApplicationWatcherStatus("MyInputMethodIndicatorWatcher") then
        return 1
    else
        return 0
    end
end

MyInputMethodIndicatorStart()
