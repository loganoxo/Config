KSheet = hs.loadSpoon("KSheet")

-- 定义一个新的 modal 环境，命名为 "sheetModal"
ModalMgr:new("sheetModal")
-- 获取名为 "sheetModal" 的 modal 环境对象
local sheetModal = ModalMgr.modal_list["sheetModal"]
-- 绑定快捷键
ModalMgr.supervisor:bind("ctrl", "S", "🟢 显示应用快捷键", function()
    ModalMgr:deactivateAll() --退出所有其他 modal 模式,确保只进入一个干净的模式环境
    ModalMgr:activate({ "sheetModal" }, "#8F87F1") -- 激活名为 "sheetModal" 的 modal 模式,并设置右下角圆形的填充颜色
end)

sheetModal:bind('', 'escape', '👋 退出应用快捷键', function()
    ModalMgr:deactivate({ "sheetModal" })
    ModalMgr.supervisor:enter() -- 重新进入主模态
end)

sheetModal.entered = function()
    KSheet:show()
end

sheetModal.exited = function()
    -- 按 hyper+0 直接退出主模态时, 隐藏KSheet
    KSheet:hide()
end


