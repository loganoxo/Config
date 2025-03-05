--- @sync entry
return {
    -- 让 yazi 支持上下循环移动光标
    entry = function(_, job)
        local current = cx.active.current
        local new = (current.cursor + job.args[1]) % #current.files
        ya.manager_emit("arrow", {new - current.cursor})
    end
}
