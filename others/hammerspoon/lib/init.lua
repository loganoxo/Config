-- ~/.hammerspoon/lib/init.lua

local modules = {
    "spoon",
    "util",
    "whenActive"
}

for _, m in ipairs(modules) do
    local ok, err = pcall(function()
        require("lib." .. m)
    end)
end
