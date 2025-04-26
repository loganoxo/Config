-- ~/.hammerspoon/func/init.lua
-- 所有模块统一加载点
local logger = NewLogger("func")

local modules = {
    "modal",
    "misc",
    "show_information",
    "smart_punct",
    "clipboard_punct",
    "auto_switch_input_method",
    "input_method_indicator",
    "window",
    "app_sheet",
    "test",
    "reload"
}

for _, m in ipairs(modules) do
    local ok, err = pcall(function()
        require("func." .. m)
    end)
    if not ok then
        logger.ef("加载模块[%s]失败:\n%s", m, err)
    else
        logger.f("加载模块[%s]成功", m)
    end
end
