-- ~/.hammerspoon/lib/init.lua

local modules = {
    "my_settings",
    "global",
    "spoon",
    "util",
    "whenActive",
}

for _, m in ipairs(modules) do
    local ok, err = pcall(function()
        require("lib." .. m)
    end)
end
