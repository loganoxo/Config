function LOGAN_ALERT(msg, duration)
    duration = duration or 5 -- 默认 5 秒
    hs.alert.show(msg, hs.alert.defaultStyle, hs.screen.mainScreen(), duration)
end
