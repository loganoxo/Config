-- hammerspoon测试

-- 1、气泡通知
local function test_alert()
    hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "B", function()
        hs.alert.show("Hello World!")
    end)
end

-- 2、mac原生通知
local function test_notify()
    hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "B", function()
        hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
    end)
end

-- 3、spoon使用(AClock) 显示时钟
local function test_aClock()
    hs.loadSpoon("AClock")
    hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "B", function()
        spoon.AClock:toggleShow()
    end)
end

-- 4、窗口移动
local function test_window_move()
    hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "B", function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        -- 将当前聚焦的窗口向左移动 10 像素
        f.x = f.x - 10
        win:setFrame(f)
    end)
end

-- 5、窗口大小调整
local function test_window_resize()
    -- 左半屏
    hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Left", function()
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
    hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "Right", function()
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
end

-- 6、窗口过滤器,性能很差
-- https://www.hammerspoon.org/docs/hs.window.filter.html
local function test_window_filter1()
    -- 过滤器,false表示创建一个空的窗口过滤器,然后设置只添加Chrome应用程序的窗口
    local filter = hs.window.filter.new(false):setAppFilter('Google Chrome')

    -- 过滤器的回调函数,第一个参数指的是能触发回调函数的窗口事件,有很多;
    filter:subscribe(hs.window.filter.windowFocused, function(window, appName, event)
        hs.alert.show("Window " .. window:title() .. " in " .. appName .. " is " .. event)
    end)
end

-- 7、菜单项(点击一次,标题数字+1)
local function test_menu()
    local menu = hs.menubar.new()
    local num = 0
    menu:setTitle("Click-" .. num)
    menu:setClickCallback(function()
        hs.alert.show("clicked!")
        num = num + 1
        menu:setTitle("Click-" .. num)
    end)
end

-- 8、下拉菜单
local function test_menu2()
    local menu = hs.menubar.new()
    menu:setTitle("🤟🏻")
    menu:setClickCallback(function()
        hs.alert.show("clicked!")
    end)
    menu:setMenu({
        { title = "my menu item",  fn = function() LOGAN_ALERT("you clicked my menu item!") end },
        { title = "-" },
        { title = "other item" },
        { title = "disabled item", disabled = true },
        { title = "checked item",  checked = true },
        {
            title = "切换外观",
            menu = {
                { title = "→ 明亮", },
                { title = "→ 暗黑" },
                { title = "→ 自动" },
            }
        },
    })
end

-- 9、创建/管理模态键盘快捷键环境
local function test_modal()
    k = hs.hotkey.modal.new('cmd-shift', 'd')
    function k:entered() hs.alert 'Entered mode' end

    function k:exited() hs.alert 'Exited mode' end

    k:bind('', 'escape', function() k:exit() end)
    k:bind('', 'J', 'Pressed J', function() print 'let the record show that J was pressed' end)
end

-- 测试
-- test_alert()


local function test_alert2()
    hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "/", function()
        hs.alert.show("Hello World!")
    end)
end

test_alert2()
