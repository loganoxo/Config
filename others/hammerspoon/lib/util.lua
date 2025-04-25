-- 屏幕底部
function LOGAN_ALERT_BOTTOM(msg, duration)
    duration = duration or 5 -- 默认 5 秒
    local style = {
        strokeWidth = 2,
        strokeColor = { white = 1, alpha = 1 },
        fillColor = { white = 0, alpha = 0.75 },
        textColor = { white = 1, alpha = 1 },
        textFont = ".AppleSystemUIFont",
        textSize = 27,
        radius = 27,
        atScreenEdge = 2, -- 0:中间 1:上面 2:下面
        fadeInDuration = 0.15,
        fadeOutDuration = 0.15,
        padding = nil,
    }

    hs.alert.show(msg, style, hs.screen.mainScreen(), duration)
end

-- 屏幕中间
function LOGAN_ALERT(msg, duration)
    duration = duration or 5 -- 默认 5 秒
    hs.alert.show(msg, hs.alert.defaultStyle, hs.screen.mainScreen(), duration)
end

-- 读取台前调度状态
function IsStageManagerEnabled()
    local output, status = hs.execute("defaults read com.apple.WindowManager GloballyEnabled", false)
    return status and tonumber(output) == 1
end

-- 把table的key拼接成字符串,空格分隔
function TableToStringOnlyKey(table_temp)
    -- 格式化 flags 输出
    local keyStr = ""
    local count = 1
    if not table_temp then
        return keyStr
    end
    for k, v in pairs(table_temp) do
        if v then
            if count > 1 then
                keyStr = keyStr .. " "
            end
            keyStr = keyStr .. k
            count = count + 1
        end
    end
    return keyStr
end

-- 把table的Value拼接成字符串,空格分隔
function TableToStringOnlyValue(table_temp)
    -- 格式化 flags 输出
    local str = ""
    local count = 1
    if not table_temp then
        return str
    end
    for k, v in pairs(table_temp) do
        if v then
            if count > 1 then
                str = str .. " "
            end
            str = str .. v
            count = count + 1
        end
    end
    return str
end

-- 日志模块封装
function NewLogger(tag)
    local log = hs.logger.new(tag, "info")
    return log
end

-- 判断是不是hyper键
function IsHyperKey(flags)
    return type(flags) == "table"
        and flags.cmd == true
        and flags.alt == true
        and flags.ctrl == true
        and flags.shift == true
end

function PrintFlags(flags)
    local result = ""
    if flags then
        local count = 1
        for k, v in pairs(flags) do
            if v then
                if count > 1 then
                    result = result .. "+"
                end
                result = result .. k
                count = count + 1
            end
        end
    end
    return result
end
