--- @sync entry
return {
    -- 智能粘贴;选中目录后,直接把复制的内容粘贴到文件夹下,不用进入文件夹了
    entry = function()
        local h = cx.active.current.hovered
        if h and h.cha.is_dir then
            ya.mgr_emit("enter", {})
            ya.mgr_emit("paste", {})
            ya.mgr_emit("leave", {})
        else
            ya.mgr_emit("paste", {})
        end
    end,
}
