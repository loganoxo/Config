--- @sync entry
return {
    -- 如果当前选中的是文件夹, 按 t 创建新的标签页时,会在新标签页中直接进入当前选中的文件夹
    entry = function()
        local h = cx.active.current.hovered
        ya.mgr_emit("tab_create", h and h.cha.is_dir and { h.url } or { current = true })
    end,
}
