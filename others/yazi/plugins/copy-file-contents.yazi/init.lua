-- https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi
-- 获取选中的文件或文件夹路径
local selected_files = ya.sync(function()
    local tab, paths = cx.active, {}
    for _, u in pairs(tab.selected) do
        paths[#paths + 1] = tostring(u)
    end
    if #paths == 0 and tab.current.hovered and not tab.current.hovered.cha.is_dir then
        paths[1] = tostring(tab.current.hovered.url)
    end
    return paths
end)


-- 判断是否可以被复制
local function can_copy_to_clipboard(content)
    -- 检查内容是否为空
    if type(content) ~= "string" or #content == 0 then
        return false
    end

    -- 检查是否包含有效 UTF-8（兼容 MacOS 剪贴板要求）
    local is_valid_utf8 = pcall(function()
        for _ in utf8.codes(content) do
        end
    end)
    if not is_valid_utf8 then
        return false
    end

    -- 检查内容是否包含过多不可打印字符
    local non_printable = content:gsub("[%g%s]", "") -- 去掉可打印字符和空格后的剩余字符
    if #non_printable / #content > 0.2 then
        -- 如果不可打印字符超过 20%，认为是二进制文件，跳过
        return false
    end

    return true
end

local function notify(str)
    ya.notify({
        title = "Copy-file-contents",
        content = str,
        timeout = 3,
        level = "info"
    })
end

local function notify_error(str)
    ya.notify({
        title = "Copy-file-contents",
        content = str,
        timeout = 3,
        level = "error"
    })
end




local state_option = ya.sync(function(state, attr)
    return state[attr]
end)

local function entry()
    local files = selected_files()
    if #files == 0 then
        return
    end

    -- call the attributes from setup
    local append_char, notification = state_option("append_char"), state_option("notification")

    local text = ""
    for i, file in ipairs(files) do
        -- 判断是否为文件夹
        local cha, err = fs.cha(Url(file))
        if cha and cha.is_dir then
            notify_error("Cannot copy directory to clipboard")
            return
        end
        local f = io.open(file, "r")
        if f then
            local file_content = f:read("*a")
            -- Remove trailing newline before file appending
            file_content = file_content:gsub("%s+$", "")
            text = text .. file_content
            if i < #files then
                text = text .. append_char
            end
            f:close()
        end
    end

    -- -- 如果文件内容不是UTF-8格式 或者 如果最终内容为空字符串，通知用户并直接返回
    if can_copy_to_clipboard(text) then
        -- 复制到剪贴板
        ya.clipboard(text)
        -- 通知用户已完成复制
        if notification then
            notify("Copied " .. #files .. " file(s) contents to clipboard")
        end
    else
        notify_error("No valid UTF-8 content to copy to clipboard")
    end
end

return {
    setup = function(state, options)
        -- Append character at the end of each file content
        state.append_char = options.append_char or "\n"
        -- Enable notification
        state.notification = options.notification and true
    end,
    entry = entry
}
