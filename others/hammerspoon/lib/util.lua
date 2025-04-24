-- 通用气泡通知
function LOGAN_ALERT(msg, duration)
    duration = duration or 5 -- 默认 5 秒
    hs.alert.show(msg, hs.alert.defaultStyle, hs.screen.mainScreen(), duration)
end

-- 读取台前调度状态
function IsStageManagerEnabled()
    local output, status = hs.execute("defaults read com.apple.WindowManager GloballyEnabled", false)
    return status and tonumber(output) == 1
end
