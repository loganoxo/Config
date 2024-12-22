-- 在每个文件的行尾加上 大小和修改时间
function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        time = ""
    elseif os.date("%Y", time) == os.date("%Y") then
        time = os.date("%b %d %H:%M", time)
    else
        time = os.date("%b %d  %Y", time)
    end

    local size = self._file:size()
    return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- 在状态栏显示软链接
function Status:name()
    local h = self._current.hovered
    if not h then
        return ""
    end
    local linked = ""
    if h.link_to ~= nil then
        linked = " -> " .. tostring(h.link_to)
    end
    return " " .. h.name:gsub("\r", "?", 1) .. linked
end
