-- 全局变量配置

-- 默认中/英文输入法ID
MacPinyin = 'com.apple.inputmethod.SCIM.ITABC' -- mac原生中文输入法ID
WxPinyin = 'com.tencent.inputmethod.wetype.pinyin' -- 微信输入法
DefaultPinyin = WxPinyin
DefaultABC = 'com.apple.keylayout.ABC'

-- 当前正在使用的中/英文输入法ID (settings.json中配置)
CurrentPinyin = DefaultPinyin
CurrentABC = DefaultABC
if GetMySetting("CurrentPinyin") then
    CurrentPinyin = GetMySetting("CurrentPinyin")
end
if GetMySetting("CurrentABC") then
    CurrentABC = GetMySetting("CurrentABC")
end

-- 中文输入法 source id 列表
ChineseInputMethodIds = {
    ["com.tencent.inputmethod.wetype.pinyin"] = true,
    ["com.apple.inputmethod.SCIM.ITABC"] = true,
    ["com.apple.inputmethod.Pinyin"] = true
}
