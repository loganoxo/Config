-- 加载 ModalMgr 模块
ModalMgr = hs.loadSpoon("ModalMgr")

hsupervisor_keys = { HYPER_KEY, "0" } -- 设置 supervisor 激活快捷键
hshelp_keys = { "ctrl", "/" }         -- 设置帮助激活快捷键
ModalMgr:init()
ModalMgr.supervisor.entered = function()
    ModalMgr:toggleCheatsheet({ all = ModalMgr.supervisor })
end
ModalMgr.supervisor.exited = function()
    ModalMgr.which_key:hide()
    ModalMgr:deactivateAll()
end
