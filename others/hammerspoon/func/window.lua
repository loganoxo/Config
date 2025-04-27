--- 窗口大小调整

-- 大小合适的窗口
local function suitable()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + 15
    f.y = max.y + 2
    f.w = max.w - 70
    f.h = max.h - 5
    win:setFrame(f)
end

-- 全屏
local function fullScreen()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end

local function window_resize()
    -- 左半屏
    hs.hotkey.bind(HYPER_KEY, "Left", "左半屏", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        -- 在左侧没有菜单栏等控件占据时,就为0
        f.x = max.x
        -- 因为上方有菜单栏,所以y不为0
        f.y = max.y
        -- 计算窗口的最大宽度和高度
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    end)
    -- 右半屏
    hs.hotkey.bind(HYPER_KEY, "Right", "右半屏", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        f.x = max.x + (max.w / 2)
        f.y = max.y
        f.w = max.w / 2
        f.h = max.h
        win:setFrame(f)
    end)

    -- 上半屏
    hs.hotkey.bind(HYPER_KEY, "Up", "上半屏", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h / 2
        win:setFrame(f)
    end)

    -- 下半屏
    hs.hotkey.bind(HYPER_KEY, "Down", "下半屏", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        f.x = max.x
        f.y = max.y + (max.h / 2)
        f.w = max.w
        f.h = max.h / 2
        win:setFrame(f)
    end)

    -- 全屏
    hs.hotkey.bind(HYPER_KEY, "space", "全屏", function()
        fullScreen()
    end)

    -- 大小合适的窗口
    hs.hotkey.bind(HYPER_KEY, "return", "大小合适的窗口", function()
        suitable()
    end)
end
window_resize()

-- 四个角 hyperKey+两个方向键
local eventtap = hs.eventtap
local eventTypes = eventtap.event.types
-- 保存当前方向键的状态
local leftPressed = false
local rightPressed = false
local upPressed = false
local downPressed = false
local otherPressed = false

WindowKeyEventListener = eventtap.new({ eventTypes.keyDown, eventTypes.keyUp }, function(event)
    local keyCode = event:getKeyCode()
    local char = event:getCharacters()
    local isDown = event:getType() == eventTypes.keyDown
    local flags = event:getFlags()
    local ifHyper = IsHyperKey(flags)
    local modifiers = PrintFlags(flags)

    -- keyCode 对应表：https://www.hammerspoon.org/docs/hs.keycodes.html#map
    if keyCode == hs.keycodes.map.left then
        leftPressed = isDown
    elseif keyCode == hs.keycodes.map.right then
        rightPressed = isDown
    elseif keyCode == hs.keycodes.map.up then
        upPressed = isDown
    elseif keyCode == hs.keycodes.map.down then
        downPressed = isDown
    else
        otherPressed = isDown
    end

    --print(string.format(
    --    "keyCode: %s, char: %s, isDown: %s, leftPressed: %s, rightPressed: %s, upPressed: %s, downPressed: %s, otherPressed: %s,ifHyper: %s",
    --    keyCode, char, isDown, leftPressed, rightPressed, upPressed, downPressed, otherPressed, ifHyper))

    if isDown and ifHyper and not otherPressed then
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        if leftPressed and upPressed and not downPressed and not rightPressed then
            -- 左上角
            f.x = max.x
            f.y = max.y
            f.w = max.w / 2
            f.h = max.h / 2
            win:setFrame(f)
            return true -- 阻止默认行为(可选)
        elseif leftPressed and downPressed and not rightPressed and not upPressed then
            -- 左下角
            f.x = max.x
            f.y = max.y + (max.h / 2)
            f.w = max.w / 2
            f.h = max.h / 2
            win:setFrame(f)
            return true -- 阻止默认行为(可选)
        elseif rightPressed and upPressed and not leftPressed and not downPressed then
            -- 右上角
            f.x = max.x + (max.w / 2)
            f.y = max.y
            f.w = max.w / 2
            f.h = max.h / 2
            win:setFrame(f)
            return true -- 阻止默认行为(可选)
        elseif rightPressed and downPressed and not leftPressed and not upPressed then
            -- 右下角
            f.x = max.x + (max.w / 2)
            f.y = max.y + (max.h / 2)
            f.w = max.w / 2
            f.h = max.h / 2
            win:setFrame(f)
            return true -- 阻止默认行为(可选)
        end
    end

    return false -- 允许其他事件继续传播
end)

WindowKeyEventListener:start()


--- Modal模式(窗口)
-- 定义一个新的 modal 环境，命名为 "winModal"
ModalMgr:new("winModal")

-- 获取名为 "winModal" 的 modal 环境对象
local winModal = ModalMgr.modal_list["winModal"]
-- 绑定快捷键
ModalMgr.supervisor:bind("ctrl", "W", "🟢 进入窗口模式", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    ModalMgr:activate({ "winModal" }, "#FFBD2E", true) -- 激活名为 "winModal" 的 modal 模式,并设置右下角圆形的填充颜色,并直接显示快捷键面板
end)
winModal:bind("", "escape", "👋 退出窗口模式", function()
    ModalMgr:deactivate({ "winModal" })
    -- ModalMgr.supervisor:enter() -- 重新进入主模态
    -- 直接退出吧
    ModalMgr.supervisor:exit()
end)

-- 窗口移动绑定快捷键
local function window_move_bind()
    -- 按比例移动
    local function move(direction, ratio)
        local win = hs.window.focusedWindow()
        local screen = win:screen()
        local max = screen:frame()
        local stepX = max.w / ratio
        local stepY = max.h / ratio

        local f = win:frame()
        if direction == "left" then
            f.x = f.x - stepX
        elseif direction == "right" then
            f.x = f.x + stepX
        elseif direction == "up" then
            f.y = f.y - stepY
        elseif direction == "down" then
            f.y = f.y + stepY
        end
        win:setFrame(f)
    end
    local ratioX = 45
    local ratioY = 45
    winModal:bind("", "left", "窗口左移", function()
        move("left", ratioX)
    end, nil, function()
        -- 按住不放
        move("left", ratioX + 1)
    end)

    winModal:bind("", "right", "窗口右移", function()
        move("right", ratioX)
    end, nil, function()
        -- 按住不放
        move("right", ratioX + 1)
    end)

    winModal:bind("", "up", "窗口上移", function()
        move("up", ratioY)
    end, nil, function()
        -- 按住不放
        move("up", ratioY + 1)
    end)

    winModal:bind("", "down", "窗口下移", function()
        move("down", ratioY)
    end, nil, function()
        -- 按住不放
        move("down", ratioY + 1)
    end)
end
-- 执行
window_move_bind()

-- 窗口按 factorW(宽度) 比例居中
local function centerX(factorW, win)
    -- 居中
    if not win then
        win = hs.window.focusedWindow()
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local frameW = max.w * factorW
    local padding = (max.w - frameW) / 2
    f.x = max.x + padding
    f.y = f.y
    f.w = frameW
    f.h = f.h
    win:setFrame(f)
    return true -- 阻止默认行为(可选)
end

-- 窗口按 factorH(高度) 比例居中
local function centerY(factorH, win)
    -- 居中
    if not win then
        win = hs.window.focusedWindow()
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local frameH = max.h * factorH
    local padding = (max.h - frameH) / 2
    f.x = f.x
    f.y = max.y + padding
    f.w = f.w
    f.h = frameH
    win:setFrame(f)
    return true -- 阻止默认行为(可选)
end

-- 其他窗口变化
local function window_other()
    for i = 1, 9 do
        winModal:bind("", tostring(i), "窗口按 " .. i / 10 .. "(宽度) 比例居中", function()
            centerX(i / 10)
        end)
    end
    for i = 1, 9 do
        winModal:bind("ctrl", tostring(i), "窗口按 " .. i / 10 .. "(高度) 比例居中", function()
            centerY(i / 10)
        end)
    end
    winModal:bind("", "0", "宽度更大", function()
        centerX(9.8 / 10)
    end)
    winModal:bind("ctrl", "0", "高度更大", function()
        centerY(9.8 / 10)
    end)

    --winModal:bind("", "W", "手动输入比例(宽)居中", function()
    --    local win = hs.window.frontmostWindow();
    --    local buttonStr, val = hs.dialog.textPrompt("输入宽度比例 ( 1到9 ) ", "", "", "OK", "Esc")
    --    if buttonStr == "OK" then
    --        local num = tonumber(val)
    --        if num then
    --            centerX(num / 10, win)
    --        else
    --            LOGAN_ALERT("输入的不是有效数字", 2)
    --        end
    --    else
    --        LOGAN_ALERT("已取消", 2)
    --    end
    --end)
    --
    --winModal:bind("", "H", "手动输入比例(高)居中", function()
    --    local win = hs.window.frontmostWindow();
    --    local buttonStr, val = hs.dialog.textPrompt("输入高度比例 ( 1到9 ) ", "", "", "OK", "Esc")
    --    if buttonStr == "OK" then
    --        local num = tonumber(val)
    --        if num then
    --            centerY(num / 10, win)
    --        else
    --            LOGAN_ALERT("输入的不是有效数字", 2)
    --        end
    --    else
    --        LOGAN_ALERT("已取消", 2)
    --    end
    --end)

    -- 全屏
    winModal:bind("", "space", "全屏", function()
        fullScreen()
    end)

    -- 大小合适的窗口
    winModal:bind("", "return", "大小合适的窗口", function()
        suitable()
    end)
end
window_other()

-- 吸附屏幕边缘
local function stickToScreen(direction)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    if direction == "up" then
        f.y = max.y
        win:setFrame(f)
    elseif direction == "down" then
        f.y = max.y + (max.h - f.h)
        win:setFrame(f)
    elseif direction == "left" then
        f.x = max.x
        win:setFrame(f)
    elseif direction == "right" then
        f.x = max.x + (max.w - f.w)
        win:setFrame(f)
    else
        hs.alert.show("Unknown direction: " .. direction)
    end
end
local function stickToScreenBind()
    winModal:bind("alt", "left", "移动到屏幕的左边", function()
        stickToScreen("left")
    end)
    winModal:bind("alt", "right", "移动到屏幕的右边", function()
        stickToScreen("right")
    end)
    winModal:bind("alt", "up", "移动到屏幕的上边", function()
        stickToScreen("up")
    end)
    winModal:bind("alt", "down", "移动到屏幕的下边", function()
        stickToScreen("down")
    end)

    -- 直接绑定右alt键,不需要模态
    LeftRightHotkey:bind({ "rAlt" }, "left", "移动到屏幕的左边", function()
        stickToScreen("left")
    end)
    LeftRightHotkey:bind({ "rAlt" }, "right", "移动到屏幕的右边", function()
        stickToScreen("right")
    end)
    LeftRightHotkey:bind({ "rAlt" }, "up", "移动到屏幕的上边", function()
        stickToScreen("up")
    end)
    LeftRightHotkey:bind({ "rAlt" }, "down", "移动到屏幕的下边", function()
        stickToScreen("down")
    end)

end
stickToScreenBind()


-- 移动到其他屏幕
function moveToScreen(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        if direction == "up" then
            cwin:moveOneScreenNorth()
        elseif direction == "down" then
            cwin:moveOneScreenSouth()
        elseif direction == "left" then
            cwin:moveOneScreenWest()
        elseif direction == "right" then
            cwin:moveOneScreenEast()
        elseif direction == "next" then
            cwin:moveToScreen(cscreen:next())
        else
            hs.alert.show("Unknown direction: " .. direction)
        end
    else
        hs.alert.show("No focused window!")
    end
end
winModal:bind("ctrl", "left", "移动到左边的屏幕", function()
    moveToScreen("left")
end)
winModal:bind("ctrl", "right", "移动到右边的屏幕", function()
    moveToScreen("right")
end)
winModal:bind("ctrl", "up", "移动到上边的屏幕", function()
    moveToScreen("up")
end)
winModal:bind("ctrl", "down", "移动到下边的屏幕", function()
    moveToScreen("down")
end)
winModal:bind("ctrl", "N", "移动到下一个屏幕", function()
    moveToScreen("next")
end)

-- 右option键+W 打开窗口模态
LeftRightHotkey:bind({ "rAlt" }, "W", "打开窗口模态", function()
    ModalMgr:activate({ "winModal" }, "#FFBD2E", true)
end)
