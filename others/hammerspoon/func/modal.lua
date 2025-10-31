-- 快捷键写在load前
-- hsupervisor_keys = { HYPER_KEY, "0" } -- 设置 supervisor(主模态) 激活快捷键
hshelp_keys = { "ctrl", "/" }         -- 设置切换帮助面板的快捷键

-- 加载 ModalMgr 模块
DisableModalMgrInit = true
ModalMgr = hs.loadSpoon("ModalMgr")
ModalSupervisorEnable = false
local mainTrayColor = "#FF0000"
local backgroundColor = "#000000"

-- 重新初始化
local function reInit()
    -- 面板宽高占屏幕的比例
    ModalMgr.width_factor = 0.80
    ModalMgr.height_factor = 0.70
    -- 面板最小宽高
    ModalMgr.min_width = 700
    ModalMgr.min_height = 400

    ModalMgr.alignmentRightColumn = 'right'
    ModalMgr.fillByRow = true

    -- 主窗口(模态)
    -- ModalMgr.supervisor = hs.hotkey.modal.new(hsupervisor_keys[1], hsupervisor_keys[2], '进入主模态')
    -- ModalMgr.supervisor:bind(hsupervisor_keys[1], hsupervisor_keys[2], "👋 退出主模态", function()
    --     ModalMgr.supervisor:exit()
    -- end)
    ModalMgr.supervisor = hs.hotkey.modal.new(nil, nil, '进入主模态')
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
    ModalSupervisorEnable = true
end

-- 退出主模态时
ModalMgr.supervisor.exited = function()
    ModalSupervisorEnable = false
    ModalMgr:deactivateAll()
    LOGAN_ALERT("主模态已退出", 5)
end

-- 右option键+A 进入或退出主模态
LeftRightHotkey:bind({ "rAlt" }, "A", function()
    if ModalSupervisorEnable or next(ModalMgr.active_list) then
        ModalMgr.supervisor:exit()
        LOGAN_ALERT("退出主模态", 2)
    else
        LOGAN_ALERT("进入主模态", 2)
        ModalMgr.supervisor:enter()
    end
end)
