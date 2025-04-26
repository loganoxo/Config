--- 窗口大小调整
local function window_resize()
    -- 左半屏
    hs.hotkey.bind(HYPER_KEY, "Left", function()
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
    hs.hotkey.bind(HYPER_KEY, "Right", function()
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
    hs.hotkey.bind(HYPER_KEY, "Up", function()
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
    hs.hotkey.bind(HYPER_KEY, "Down", function()
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
    hs.hotkey.bind(HYPER_KEY, "space", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        f.x = max.x
        f.y = max.y
        f.w = max.w
        f.h = max.h
        win:setFrame(f)
    end)

    -- 大小合适的窗口
    hs.hotkey.bind(HYPER_KEY, "return", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        f.x = max.x + 2
        f.y = max.y + 2
        f.w = max.w - 70
        f.h = max.h - 5
        win:setFrame(f)
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


--- Modal模式(窗口移动)
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
    ModalMgr.supervisor:enter() -- 重新进入主模态
end)

-- 窗口移动绑定快捷键
local function window_move()
    winModal:bind("", "left", "窗口左移", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        f.x = f.x - 40
        win:setFrame(f)
    end)

    winModal:bind("", "right", "窗口右移", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        f.x = f.x + 40
        win:setFrame(f)
    end)

    winModal:bind("", "up", "窗口上移", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        f.y = f.y - 30
        win:setFrame(f)
    end)

    winModal:bind("", "down", "窗口下移", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        f.y = f.y + 30
        win:setFrame(f)
    end)
end

window_move()
