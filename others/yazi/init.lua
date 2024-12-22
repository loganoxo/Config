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

-- 在状态栏显示文件或者夹所属用户组
Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil or ya.target_family() ~= "unix" then
        return ""
    end

    return ui.Line { ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"), ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"), " " }
end, 500, Status.RIGHT)



-- 复制文件内容的插件配置-插件: copy-file-contents.yazi
-- append_char; 设置要附加在每个复制的文件内容末尾的字符,默认为"\n"
-- notification; 复制内容后启用/禁用通知; 默认为true
require("copy-file-contents"):setup({
    append_char = "\n",
    notification = true
})

-- 添加边框-插件: full-border.yazi
require("full-border"):setup {
    -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
    type = ui.Border.ROUNDED,
}

-- 添加git支持-插件: git.yazi
THEME.git = THEME.git or {}
THEME.git.added = ui.Style():fg("magenta"):bold()
THEME.git.untracked = ui.Style():fg("cyan"):bold()
THEME.git.modified = ui.Style():fg("blue"):bold()
THEME.git.deleted = ui.Style():fg("red"):bold()
THEME.git.modified_sign = " M "
THEME.git.untracked_sign = " ? "
THEME.git.deleted_sign = " D "
THEME.git.added_sign = " A "
require("logan-git"):setup({ order = 1 })

-- 显示 starship
require("logan-starship"):setup()

-- 在标题中显示用户名和主机名, 用starship显示了
-- Header:children_add(function()
--     if ya.target_family() ~= "unix" then
--         return ""
--     end
--     return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. " 📂 "):fg("green")
-- end, 500, Header.LEFT)
