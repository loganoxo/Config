MySettings = {}   -- 定义全局变量，默认是空表
MySettingsPath = os.getenv("HOME") .. "/.hammerspoon/settings.json"

function my_settings_load()
    -- 先判断文件是否存在
    if hs.fs.attributes(MySettingsPath) then
        local settings = hs.json.read(MySettingsPath)
        if not settings then
            hs.alert.show("读取 settings.json 失败,使用空配置")
            MySettings = {}
        else
            MySettings = settings
            hs.alert.show("已加载settings.json")
        end
    end
end
my_settings_load()

function GetMySetting(key)
    return MySettings[key]
end
