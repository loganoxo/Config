-- 加载 ModalMgr 模块
ModalMgr = hs.loadSpoon("ModalMgr")

local mainTrayColor = "#FF0000"
local backgroundColor = "#000000"

-- 重新初始化
local function reInit()
    hsupervisor_keys = { HYPER_KEY, "0" } -- 设置 supervisor(主模态) 激活快捷键
    hshelp_keys = { "ctrl", "/" }         -- 设置切换帮助面板的快捷键

    -- 面板宽高占屏幕的比例
    ModalMgr.width_factor = 0.50
    ModalMgr.height_factor = 0.40
    -- 面板最小宽高
    ModalMgr.min_width = 700
    ModalMgr.min_height = 400

    -- 主窗口(模态)
    ModalMgr.supervisor = hs.hotkey.modal.new(hsupervisor_keys[1], hsupervisor_keys[2], '进入主窗口')
    ModalMgr.supervisor:bind(hsupervisor_keys[1], hsupervisor_keys[2], "👋 退出主窗口", function()
        ModalMgr.supervisor:exit()
    end)

    -- 帮助面板
    ModalMgr.supervisor:bind(hshelp_keys[1], hshelp_keys[2], "🟢 打开/关闭帮助面板", function()
        ModalMgr:toggleCheatsheet({ all = ModalMgr.supervisor })
    end)

    -- 右下角的圆形标志
    ModalMgr.modal_tray = hs.canvas.new({ x = 0, y = 0, w = 0, h = 0 })
    ModalMgr.modal_tray:level(hs.canvas.windowLevels.tornOffMenu)
    ModalMgr.modal_tray[1] = {
        type = "circle",
        action = "fill",
        fillColor = { hex = mainTrayColor, alpha = 0.7 }, -- 红色
    }

    -- 主窗口(模态)的背景面板的设置
    ModalMgr.which_key = hs.canvas.new({ x = 0, y = 0, w = 0, h = 0 })
    ModalMgr.which_key:level(hs.canvas.windowLevels.tornOffMenu) -- 窗口层级

    -- 重新设置面板背景
    ModalMgr.which_key[1] = {
        type = "rectangle", -- 圆角矩形
        action = "fill",
        fillColor = { hex = backgroundColor, alpha = 0.6 }, -- 黑色,变得更透明
        roundedRectRadii = { xRadius = 15, yRadius = 15 }, -- 圆角
    }
end

reInit()

-- 重新显示主模态面板和在右下角标志
function ShowMainModal()
    -- 显示右下角的圆形标志
    ModalMgr:activate({}, mainTrayColor, false)
    -- 显示主模态面板
    ModalMgr:toggleCheatsheet({ all = ModalMgr.supervisor }, true)
end

-- 进入主模态时
ModalMgr.supervisor.entered = function()
    ShowMainModal()
end

-- 退出主模态时
ModalMgr.supervisor.exited = function()
    ModalMgr:deactivateAll()
end


--------------  以下为主模态中可以执行的快捷键

-- 1、显示当前App的详细信息
local function showAppInformation()
    local win = hs.window.focusedWindow()
    local app = win:application()
    local str = "App name:      " .. app:name() .. "\n"
        .. "App path:      " .. app:path() .. "\n"
        .. "App bundle:    " .. app:bundleID() .. "\n"
        .. "App pid:       " .. app:pid() .. "\n"
        .. "Win title:     " .. win:title() .. "\n"
        .. "输入法ID:       " .. hs.keycodes.currentSourceID() .. "\n"
    hs.pasteboard.setContents(str)
    LOGAN_ALERT_BOTTOM(str, 10)
end
ModalMgr.supervisor:bind("ctrl", "P", "🟢 显示当前App的详细信息", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    showAppInformation()
    ModalMgr.supervisor:enter() -- 重新进入主模态
end)
-- 额外绑定一个非模态下的快捷键
hs.hotkey.bind(HYPER_KEY, "P", function()
    showAppInformation()
end)

-- 2、专注模式
local fhl = hs.loadSpoon("FocusHighlight")
local function toggleFocusMode()
    if hs.settings.get("focusModeEnable") then
        -- hs.window.highlight.stop()
        fhl:stop()
        hs.settings.set("focusModeEnable", false)
    else
        -- hs.window.highlight.ui.overlay = true
        -- hs.window.highlight.ui.flashDuration = 0.1
        -- hs.window.highlight.start()
        fhl.color = "#f9bc34"
        fhl.windowFilter = hs.window.filter.default
        fhl.arrowSize = 128
        fhl.arrowFadeOutDuration = 1
        fhl.highlightFadeOutDuration = 2
        fhl.highlightFillAlpha = 0.3
        fhl:start()
        hs.settings.set("focusModeEnable", true)
    end
end
ModalMgr.supervisor:bind("ctrl", "F", "🟢 开启/关闭专注模式", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    toggleFocusMode()
    ModalMgr.supervisor:exit() -- 直接退出主模态
end)
