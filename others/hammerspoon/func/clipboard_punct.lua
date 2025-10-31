-- 将剪切板中的中文标点替换成英文标点

-- 符号表
ClipboardPunctReplaceMap = {
    ["“"] = "\"",
    ["‘"] = "'",
    ["，"] = ",",
    ["。"] = ";",
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

-- 遍历替换表进行替换
function Replace_Punct(content)
    for zh, en in pairs(ClipboardPunctReplaceMap) do
        content = content:gsub(zh, en)
    end
    return content
end

-- 执行剪切板内容替换的函数
-- /opt/homebrew/bin/hs -c 'Clipboard_Punct()'
function Clipboard_Punct()
    local content = hs.pasteboard.getContents()
    if (not content) or (content == "") then
        LOGAN_ALERT("剪切板为空", 2)
        return
    end

    local old_content = content
    if type(content) == "string" then
        -- 遍历替换表进行替换
        local new_content = Replace_Punct(content)
        -- 设置回剪切板
        if old_content ~= new_content then
            hs.pasteboard.setContents(new_content)
            LOGAN_ALERT("标点已替换", 2)
        else
            LOGAN_ALERT("无中文标点", 2)
        end
        return
    else
        LOGAN_ALERT("未检测到纯文本", 2)
        return
    end
end

-- 快捷键绑定
hs.hotkey.bind({ "ctrl", "shift" }, "C", function()
    -- 清空剪贴板防止干扰
    hs.pasteboard.clearContents()
    hs.timer.doAfter(0.4, function()
        -- 模拟系统复制 (⌘+C)
        hs.eventtap.keyStroke({ "CMD" }, "C")
        -- 稍等复制动作完成（用 timer 延迟 0.2 秒）
        hs.timer.doAfter(0.2, function()
            Clipboard_Punct()
        end)
    end)
end)

-- 剪贴板标点实时监控
PasteboardListener = nil
IsProcessing = false
-- /opt/homebrew/bin/hs -c 'PasteboardPunctListenerStart()'
function PasteboardPunctListenerStart()
    -- 设置监听剪贴板的轮询间隔为 0.2 秒
    hs.pasteboard.watcher.interval(0.2)
    -- 创建一个剪切板监听器
    if not PasteboardListener then
        PasteboardListener = hs.pasteboard.watcher.new(function(content)
            if isProcessing then
                -- 防止递归触发
                return
            end

            if (not content) or (content == "") then
                return
            end

            local old_content = content
            if type(content) == "string" then
                -- 遍历替换表进行替换
                local new_content = Replace_Punct(content)
                -- 设置回剪切板
                if old_content ~= new_content then
                    IsProcessing = true -- 防止递归触发
                    hs.pasteboard.setContents(new_content)
                    LOGAN_ALERT_BOTTOM("标点已替换", 1)
                    hs.timer.doAfter(0.3, function()
                        IsProcessing = false
                    end) -- 稍微延迟，避免短时间重复触发
                end
                return
            end
        end)
    end
    -- 启动监听器
    if not PasteboardListener:running() then
        PasteboardListener:start()
    end
    LOGAN_ALERT("剪贴板实时监控已开启")
end

-- /opt/homebrew/bin/hs -c 'PasteboardPunctListenerStop()'
function PasteboardPunctListenerStop()
    if PasteboardListener then
        PasteboardListener:stop()
        PasteboardListener = nil
        IsProcessing = false
        LOGAN_ALERT("剪贴板实时监控已关闭")
    end
end

-- /opt/homebrew/bin/hs -c 'PasteboardPunctListenerStatus()'
function PasteboardPunctListenerStatus()
    if PasteboardListener and PasteboardListener:running() then
        return 1
    else
        return 0
    end
end
