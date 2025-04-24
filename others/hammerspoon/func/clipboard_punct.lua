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
        return
    end

    -- 遍历替换表进行替换
    for zh, en in pairs(ClipboardPunctReplaceMap) do
        content = content:gsub(zh, en)
    end

    -- 设置回剪切板
    hs.pasteboard.setContents(content)
    LOGAN_ALERT("标点已替换")
end
