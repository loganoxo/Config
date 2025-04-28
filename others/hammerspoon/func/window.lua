--------------------------------------------------- 窗口大小调整

------------------------------------------- Modal模式(窗口)
-- 定义一个新的 modal 环境，命名为 "winModal"
ModalMgr:new("winModal")
-- 获取名为 "winModal" 的 modal 环境对象
local winModal = ModalMgr.modal_list["winModal"]

-- 绑定快捷键 (模态外: 右option键+W 打开窗口模态; 模态内: Ctrl+W 进入窗口模式; Esc: 退出窗口模式  )
local function win_modal_bind()
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
    -- 右option键+W 打开窗口模态
    LeftRightHotkey:bind({ "rAlt" }, "W", "打开窗口模态", function()
        ModalMgr:activate({ "winModal" }, "#FFBD2E", true)
    end)

end
win_modal_bind()

-- 调整边距的modal
ModalMgr:new("winPaddingModal")
local winPaddingModal = ModalMgr.modal_list["winPaddingModal"]
local ifRightAlt = false

local function enterWinPaddingModal()
    -- ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    ModalMgr:activate({ "winModal" }, "#FFBD2E")
    ModalMgr:activate({ "winPaddingModal" }, "#604652", true)
end

winPaddingModal:bind('', 'escape', '👋 退出调整边距的modal', function()
    ModalMgr:deactivate({ "winPaddingModal" })
    if ifRightAlt then
        ModalMgr.supervisor:exit()
        ifRightAlt = false
    else
        ModalMgr:activate({ "winModal" }, "#FFBD2E", true)
    end
end)

------------------------------------------- 通用方法
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
local function full_screen()
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

-- 窗口直接居中
local function center(win)
    -- 居中
    if not win then
        win = hs.window.focusedWindow()
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local padding_left_right = (max.w - f.w) / 2
    local padding_up_down = (max.h - f.h) / 2
    f.x = max.x + padding_left_right
    f.y = max.y + padding_up_down
    win:setFrame(f)
    return true -- 阻止默认行为(可选)
end

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

-- 窗口按 factor(宽高) 比例居中
local function centerXY(factorW, factorH, win)
    -- 居中
    if not win then
        win = hs.window.focusedWindow()
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local frameW = max.w * factorW
    local frameH = max.h * factorH
    local paddingW = (max.w - frameW) / 2
    local paddingH = (max.h - frameH) / 2
    f.x = max.x + paddingW
    f.y = max.y + paddingH
    f.w = frameW
    f.h = frameH
    win:setFrame(f)
    return true -- 阻止默认行为(可选)
end

-- 按比例移动当前窗口的位置
local function window_move(direction, ratio, win)
    if not win then
        win = hs.window.focusedWindow()
    end
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


-- 移动窗口,以显示桌面边缘
LastEdgeFrames = {}
local function window_edge()
    local win = hs.window.focusedWindow()
    if not win or not win:isStandard() or not win:isVisible() or win:isMinimized() or win:isFullScreen() then
        LOGAN_ALERT("没有可用窗口", 2)
        return
    end
    local winId = win:id()
    if LastEdgeFrames[winId] then
        -- 有记录，复原
        win:setFrame(LastEdgeFrames[winId])
        LastEdgeFrames[winId] = nil
    else
        -- 没有记录，保存并移动
        LastEdgeFrames[winId] = win:frame()
        window_move("left", 10, win)
    end
end

-- 按比例调整窗口 向 上下左右 扩展/缩小
local function adjust_window_padding(direction, ratio)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local stepX = max.w / ratio
    local stepY = max.h / ratio
    -- 以下运算按 窗口大小增大的方式; 如果减少,则把ratio传参为负数
    if f.w + stepX - 400 > 0 then
        if direction == "left" then
            f.x = f.x - stepX
            f.w = f.w + stepX
        elseif direction == "right" then
            f.w = f.w + stepX
        end
    end

    if f.h + stepY - 50 > 0 then
        if direction == "up" then
            f.y = f.y - stepY
            f.h = f.h + stepY
        elseif direction == "down" then
            f.h = f.h + stepY
        end
    end
    win:setFrame(f)
end

-- 移动到屏幕边缘
local function stick_to_screen(direction)
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

-- 移动到其他屏幕(多屏幕时)
local function move_to_screen(direction)
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen()
        if direction == "up" then
            win:moveOneScreenNorth()
        elseif direction == "down" then
            win:moveOneScreenSouth()
        elseif direction == "left" then
            win:moveOneScreenWest()
        elseif direction == "right" then
            win:moveOneScreenEast()
        elseif direction == "next" then
            win:moveToScreen(screen:next())
        else
            hs.alert.show("Unknown direction: " .. direction)
        end
    else
        hs.alert.show("No focused window!")
    end
end

-- 打乱一个数组
local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(1, i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

-- 找出同一个app的所有可视窗口
local function same_application()
    local focusedWindow = hs.window.focusedWindow()
    local application = focusedWindow:application()
    -- 当前屏幕
    local focusedScreen = focusedWindow:screen()
    -- 同一应用的所有窗口
    local visibleWindows = application:visibleWindows()
    for k, visibleWindow in ipairs(visibleWindows) do
        -- 关于 Standard window 可参考：http://www.hammerspoon.org/docs/hs.window.html#isStandard
        -- 例如打开 Finder 就一定会存在一个非标准窗口，这种窗口需要排除
        if not visibleWindow:isStandard() then
            table.remove(visibleWindows, k)
        end
        if visibleWindow ~= focusedWindow then
            -- 将同一应用的其他窗口移动到当前屏幕
            visibleWindow:moveToScreen(focusedScreen)
        end
    end
    return visibleWindows
end

-- 找出当前桌面空间下的所有可视窗口(hs.window.filter很慢)
local function same_space_slow()
    local window_filter = hs.window.filter.new():setOverrideFilter({
        visible = true,
        fullscreen = false,
        hasTitlebar = true,
        currentSpace = true,
        allowRoles = "AXStandardWindow",
    })

    local all_windows = window_filter:getWindows()

    local visibleWindows = {}
    for _, window in ipairs(all_windows) do
        if window ~= nil and window:isStandard() and not window:isMinimized() then
            table.insert(visibleWindows, window)
        end
    end
    return visibleWindows
end

-- 更快版本的 same_space
local function same_space()
    local allWindows = hs.window.visibleWindows()
    local visibleWindows = {}
    for _, window in ipairs(allWindows) do
        if window and window:isStandard() and not window:isMinimized() and not window:isFullScreen() then
            if window:screen() == hs.screen.mainScreen() then
                -- 只要当前屏幕的
                table.insert(visibleWindows, window)
            end
        end
    end
    return visibleWindows
end

-- 判断指定屏幕是否为竖屏
local function is_vertical_screen(screen)
    -- 获取屏幕旋转角度，90 或 270 代表竖屏
    local rotation = screen:rotate()
    return rotation == 90 or rotation == 270
end

local layout = {
    {
        num = 1,
        row = 1,
        column = 1,
    },
    {
        num = 2,
        row = 1,
        column = 2,
    },
    {
        num = 3,
        row = 2,
        column = 2,
    },
    {
        num = 4,
        row = 2,
        column = 2,
    },
    {
        num = 5,
        row = 2,
        column = 3,
    },
    {
        num = 6,
        row = 2,
        column = 3,
    },
    {
        num = 7,
        row = 2,
        column = 4,
    },
    {
        num = 9,
        row = 3,
        column = 3,
    }
}

-- 网格布局：将窗口按最合适的行列数，尽量填满屏幕(当台前调度开启时,会有问题,会分别分屏,没在一个桌面下显示)
local function layout_grid(windows)
    shuffle(windows)  -- 打乱顺序

    -- 获取当前主屏幕
    local focusedScreen = hs.screen.mainScreen()
    local focusedScreenFrame = focusedScreen:frame()

    -- 窗口数量
    local windowNum = #windows
    if windowNum == 0 then
        return
    end

    if windowNum > 9 then
        LOGAN_ALERT("窗口过多")
        return
    end

    -- 选出最合适的行数和列数，保证窗口排列尽量紧凑
    local bestRow, bestColumn
    for _, item in ipairs(layout) do
        if windowNum == item.num then
            bestRow = item.row
            bestColumn = item.column
        end
    end

    -- 判断是否为竖屏
    if is_vertical_screen(focusedScreen) then
        -- 竖屏时，交换行列数
        bestRow, bestColumn = bestColumn, bestRow
    end

    -- 计算每个窗口的宽度和高度
    local widthForPerWindow = focusedScreenFrame.w / bestColumn
    local heightForPerWindow = focusedScreenFrame.h / bestRow

    -- 逐个窗口放置
    local elseH = focusedScreenFrame.h
    local nth = 1
    for c = 0, bestColumn - 1 do
        elseH = focusedScreenFrame.h
        for r = 0, bestRow - 1 do
            if nth > windowNum then
                break
            end
            local window = windows[nth]
            local windowFrame = window:frame()
            if nth == windowNum then
                windowFrame.y = focusedScreenFrame.y + (focusedScreenFrame.h - elseH)
                windowFrame.h = elseH

                -- 计算每个窗口的起始位置
                windowFrame.x = focusedScreenFrame.x + c * widthForPerWindow
                -- 设置窗口宽高，留出一点边距
                windowFrame.w = widthForPerWindow
            else
                -- 计算每个窗口的起始位置
                windowFrame.x = focusedScreenFrame.x + c * widthForPerWindow
                windowFrame.y = focusedScreenFrame.y + r * heightForPerWindow
                -- 设置窗口宽高，留出一点边距
                windowFrame.w = widthForPerWindow
                windowFrame.h = heightForPerWindow
                elseH = elseH - windowFrame.h
            end

            window:setFrame(windowFrame)
            -- 让窗口浮到最前
            window:focus()
            nth = nth + 1
        end
    end
end

-- hammerspoon自带的平铺api,这是实验性模块,API 可能随时改
-- https://www.hammerspoon.org/docs/hs.window.tiling.html#tileWindows
-- hs.window.tiling.tileWindows(windows,rect[,desiredAspect[,processInOrder[,preserveRelativeArea[,animationDuration]]]])
-- desiredAspect:宽高比,默认为1; processInOrder:窗口顺序,默认为false,不会根据传入的顺序排序;true:根据传入的顺序排序
-- preserveRelativeArea:true:保持窗口之间的相对面积,如果窗口 A 目前是窗口 B 的两倍大,那么平铺后仍然如此;false:尽可能保持一样大
-- animationDuration: 窗口移动/调整大小操作的动画时长,单位为秒;如果省略,则默认为 hs.window.animationDuration(0.2) 的值
local function layout_tile(windows)
    local screenFrame = hs.screen.mainScreen():frame()
    shuffle(windows)
    hs.window.tiling.tileWindows(windows, screenFrame, nil, true)
end

------------------------------------------------------------- 快捷键绑定

-- 绑定快捷键-半屏分屏
-- 模态外,用hyper键+方向键/空格/回车 分别设置当前窗口 半屏,全屏,合适大小
-- 模态内,直接按 空格/回车 分别设置当前窗口 全屏,合适大小
local function window_resize_bind()
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
        full_screen()
    end)

    -- 大小合适的窗口
    hs.hotkey.bind(HYPER_KEY, "return", "大小合适的窗口", function()
        suitable()
    end)

    -- 全屏(模态内)
    winModal:bind("", "space", "全屏", function()
        full_screen()
    end)

    -- 大小合适的窗口(模态内)
    winModal:bind("", "return", "大小合适的窗口", function()
        suitable()
    end)
end
window_resize_bind()

-- 绑定快捷键-角落分屏; 设置当前窗口 放在屏幕四个角 (模态外 hyperKey+两个方向键同时按)
local function window_corner_bind()
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
end
window_corner_bind()

-- 绑定快捷键-窗口移动 (模态内 只需要按方向键)
local function window_move_bind()
    local ratioX = 45
    local ratioY = 45
    winModal:bind("", "left", "窗口左移", function()
        window_move("left", ratioX)
    end, nil, function()
        -- 按住不放
        window_move("left", ratioX + 1)
    end)

    winModal:bind("", "right", "窗口右移", function()
        window_move("right", ratioX)
    end, nil, function()
        -- 按住不放
        window_move("right", ratioX + 1)
    end)

    winModal:bind("", "up", "窗口上移", function()
        window_move("up", ratioY)
    end, nil, function()
        -- 按住不放
        window_move("up", ratioY + 1)
    end)

    winModal:bind("", "down", "窗口下移", function()
        window_move("down", ratioY)
    end, nil, function()
        -- 按住不放
        window_move("down", ratioY + 1)
    end)

    -- 直接绑定右alt键,不需要模态
    LeftRightHotkey:bind({ "rAlt" }, "left", "窗口左移", function()
        window_move("left", ratioX)
    end, nil, function()
        -- 按住不放
        window_move("left", ratioX + 1)
    end)
    LeftRightHotkey:bind({ "rAlt" }, "right", "窗口右移", function()
        window_move("right", ratioX)
    end, nil, function()
        -- 按住不放
        window_move("right", ratioX + 1)
    end)
    LeftRightHotkey:bind({ "rAlt" }, "up", "窗口上移", function()
        window_move("up", ratioY)
    end, nil, function()
        -- 按住不放
        window_move("up", ratioY + 1)
    end)
    LeftRightHotkey:bind({ "rAlt" }, "down", "窗口下移", function()
        window_move("down", ratioY)
    end, nil, function()
        -- 按住不放
        window_move("down", ratioY + 1)
    end)

end
window_move_bind()

-- 绑定快捷键-移动到屏幕边缘 (移动到屏幕的 上/下/左/右 边)
-- 模态内: alt+方向键
-- 模态外: 右alt+方向键
local function stick_to_screen_bind()
    winModal:bind("alt", "left", "移动到屏幕的左边", function()
        stick_to_screen("left")
    end)
    winModal:bind("alt", "right", "移动到屏幕的右边", function()
        stick_to_screen("right")
    end)
    winModal:bind("alt", "up", "移动到屏幕的上边", function()
        stick_to_screen("up")
    end)
    winModal:bind("alt", "down", "移动到屏幕的下边", function()
        stick_to_screen("down")
    end)

    -- 直接绑定右cmd键,不需要模态
    LeftRightHotkey:bind({ "rCmd" }, "H", "移动到屏幕的左边", function()
        stick_to_screen("left")
    end)
    LeftRightHotkey:bind({ "rCmd" }, "L", "移动到屏幕的右边", function()
        stick_to_screen("right")
    end)
    LeftRightHotkey:bind({ "rCmd" }, "K", "移动到屏幕的上边", function()
        stick_to_screen("up")
    end)
    LeftRightHotkey:bind({ "rCmd" }, "J", "移动到屏幕的下边", function()
        stick_to_screen("down")
    end)

end
stick_to_screen_bind()

-- 绑定快捷键-窗口居中; 并且宽高按缩放比例调整 (模态内, <1-9>:调整宽度居中; ctrl+<1-9> 调整高度居中; 模态外用右option+数字键 )
-- 窗口直接居中: C (模态内) ; HYPER_KEY + C  (模态外)
local function window_center_bind()
    -- 模态内-比例居中
    for i = 1, 9 do
        winModal:bind("", tostring(i), "窗口按比例居中(" .. i / 10 .. ")", function()
            centerXY(i / 10, i / 10)
        end)
        winModal:bind("ctrl", tostring(i), "窗口按 " .. i / 10 .. "(宽度) 比例居中", function()
            centerX(i / 10)
        end)
        winModal:bind("cmd", tostring(i), "窗口按 " .. i / 10 .. "(高度) 比例居中", function()
            centerY(i / 10)
        end)
    end

    winModal:bind("", "0", "窗口按比例居中(0.98)", function()
        centerXY(9.8 / 10, 9.8 / 10)
    end)
    winModal:bind("ctrl", "0", "宽度更大", function()
        centerX(9.8 / 10)
    end)
    winModal:bind("cmd", "0", "高度更大", function()
        centerY(9.8 / 10)
    end)

    -- 模态外-宽高比例居中-右option+数字
    for i = 1, 9 do
        LeftRightHotkey:bind({ "rAlt" }, tostring(i), "窗口按比例居中(" .. i / 10 .. ")", function()
            centerXY(i / 10, i / 10)
        end)
    end
    LeftRightHotkey:bind({ "rAlt" }, "0", "窗口按比例居中(0.98)", function()
        centerXY(9.8 / 10, 9.8 / 10)
    end)

    -- 窗口直接居中(不改变宽高)
    hs.hotkey.bind(HYPER_KEY, "C", "窗口直接居中", function()
        center()
    end)
    winModal:bind("", "C", "窗口直接居中", function()
        center()
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
end
window_center_bind()

-- 绑定快捷键-移动到其他屏幕(多屏幕时)
-- 模态内: Ctrl+方向键 移动到 左/右/上/下 边的屏幕; Ctrl+N 移动到下一个屏幕
local function move_to_screen_bind()
    winModal:bind("ctrl", "left", "移动到左边的屏幕(多屏幕时)", function()
        move_to_screen("left")
    end)
    winModal:bind("ctrl", "right", "移动到右边的屏幕(多屏幕时)", function()
        move_to_screen("right")
    end)
    winModal:bind("ctrl", "up", "移动到上边的屏幕(多屏幕时)", function()
        move_to_screen("up")
    end)
    winModal:bind("ctrl", "down", "移动到下边的屏幕(多屏幕时)", function()
        move_to_screen("down")
    end)
    winModal:bind("ctrl", "N", "移动到下一个屏幕(多屏幕时)", function()
        move_to_screen("next")
    end)
end
move_to_screen_bind()

-- 绑定快捷键-按比例调整窗口 向 上下左右 扩展/缩小
-- 模态内:ctrl+kjhl 进入调整 上下左右 边距的modal; 然后用 ctrl+ <=> 和 <-> 调整窗口大小
-- 模态外: 右option+hjkl
AdjustPaddingDirection = nil
local function adjust_window_padding_bind()
    LeftRightHotkey:bind({ "rAlt" }, "H", "窗口左边扩展/缩小", function()
        AdjustPaddingDirection = "left"
        ifRightAlt = true
        enterWinPaddingModal()
    end)
    LeftRightHotkey:bind({ "rAlt" }, "L", "窗口右边扩展/缩小", function()
        AdjustPaddingDirection = "right"
        ifRightAlt = true
        enterWinPaddingModal()
    end)
    LeftRightHotkey:bind({ "rAlt" }, "K", "窗口上边扩展/缩小", function()
        AdjustPaddingDirection = "up"
        ifRightAlt = true
        enterWinPaddingModal()
    end)
    LeftRightHotkey:bind({ "rAlt" }, "J", "窗口下边扩展/缩小", function()
        AdjustPaddingDirection = "down"
        ifRightAlt = true
        enterWinPaddingModal()
    end)

    winModal:bind("ctrl", "H", "窗口左边扩展/缩小", function()
        AdjustPaddingDirection = "left"
        ifRightAlt = false
        enterWinPaddingModal()
    end)
    winModal:bind("ctrl", "L", "窗口右边扩展/缩小", function()
        AdjustPaddingDirection = "right"
        ifRightAlt = false
        enterWinPaddingModal()
    end)
    winModal:bind("ctrl", "K", "窗口上边扩展/缩小", function()
        AdjustPaddingDirection = "up"
        ifRightAlt = false
        enterWinPaddingModal()
    end)
    winModal:bind("ctrl", "J", "窗口下边扩展/缩小", function()
        AdjustPaddingDirection = "down"
        ifRightAlt = false
        enterWinPaddingModal()
    end)

    -- 在 边距的modal 中 用 + 和 - 调整边距
    winPaddingModal:bind("ctrl", "=", "扩展" .. "窗口", function()
        adjust_window_padding(AdjustPaddingDirection, 45)
    end, nil, function()
        adjust_window_padding(AdjustPaddingDirection, 45)
    end)
    winPaddingModal:bind("ctrl", "-", "缩小" .. "窗口", function()
        adjust_window_padding(AdjustPaddingDirection, -45)
    end, nil, function()
        adjust_window_padding(AdjustPaddingDirection, -45)
    end)
end
adjust_window_padding_bind()

-- 绑定快捷键-窗口自动布局-将窗口按最合适的行列数，尽量填满屏幕(当台前调度开启时,会有问题,会分别分屏,没在一个桌面下显示)
local function automatic_window_layout()
    -- 我自己的,可以用的
    winModal:bind("ctrl", "tab", "自动布局(当前空间)", function()
        layout_grid(same_space())
    end)
    winModal:bind("ctrl", "`", "自动布局(当前app)", function()
        layout_grid(same_application())
    end)

    -- hammerspoon的窗口平铺api,实验性,有可能会改(也不适用于台前调度开启时)
    winModal:bind("", "tab", "自动布局(当前空间)", function()
        layout_tile(same_space())
    end)
    winModal:bind("", "`", "自动布局(当前app)", function()
        layout_tile(same_application())
    end)
end
automatic_window_layout()

-- 绑定快捷键-移动窗口,以显示桌面边缘
local function window_edge_bind()
    hs.hotkey.bind(HYPER_KEY, "Z", "显示/回退桌面边缘", function()
        -- 调用 Rectangle Pro 的功能
        hs.execute('open -g "rectangle-pro://execute-action?name=reveal-desktop-edge"')

        -- 自己写的功能,没有上面的好
        --window_edge()
    end)
end
window_edge_bind()
