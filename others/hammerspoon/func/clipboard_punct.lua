-- 将剪切板中的中文标点替换成英文标点

-- 符号表
ClipboardPunctReplaceMap = {
    ["“"] = "\"",
    ["‘"] = "'",
    ["，"] = ",",
    ["。"] = ".",
    ["「"] = "{",
    ["」"] = "}",
    ["【"] = "[",
    ["】"] = "]",
    ["；"] = ";",
    ["："] = ":",
    ["！"] = "!",
    ["？"] = "?",
    ["～"] = "~",
    ["（"] = "(",
    ["）"] = ")",
    ["｜"] = "|",
}

-- 执行剪切板内容替换的函数
-- /opt/homebrew/bin/hs -c 'Clipboard_Punct()'
function Clipboard_Punct()
    local content = hs.pasteboard.getContents()
    if not content or content == "" then
        LOGAN_ALERT("剪切板为空")
        return false
    end

    if type(content) == "string" then
        -- 遍历替换表进行替换
        for zh, en in pairs(ClipboardPunctReplaceMap) do
            content = content:gsub(zh, en)
        end
        -- 设置回剪切板
        hs.pasteboard.setContents(content)
        LOGAN_ALERT("标点已替换")
        return true
    else
        LOGAN_ALERT("未检测到纯文本")
        return false
    end
end

-- 快捷键绑定
hs.hotkey.bind(HYPER_KEY, "C", function()
    -- 清空剪贴板防止干扰
    hs.pasteboard.clearContents()
    hs.timer.doAfter(0.5, function()
        -- 模拟系统复制 (⌘+C)
        hs.eventtap.keyStroke({ "CMD" }, "C")
        -- 稍等复制动作完成（用 timer 延迟 0.2 秒）
        hs.timer.doAfter(0.2, function()
            Clipboard_Punct()
        end)
    end)
end)
