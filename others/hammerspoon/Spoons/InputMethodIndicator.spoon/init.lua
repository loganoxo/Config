--- === InputMethodIndicator ===
--- 输入法状态指示器模块
-- 在鼠标或光标位置显示彩色圆点指示当前输入法状态
-- 英文输入法显示绿点,非英文输入法显示红点
-- 支持三种显示模式:
-- nearMouse: 始终跟随鼠标
-- onChange: 输入法变化时显示几秒
-- adaptive: 自适应模式(表示输入时指示器将显示在文本框附近,否则将显示在鼠标附近,不完美)
-- https://github.com/Hammerspoon/Spoons/blob/master/Source/InputMethodIndicator.spoon/init.lua#L200
-- https://www.hammerspoon.org/Spoons/InputMethodIndicator.html
-- 用法:
-- hs.loadSpoon("InputMethodIndicator")
-- spoon.InputMethodIndicator:start(nil)

local obj = {}           -- 创建模块对象
local _store = {}        -- 用于属性存储
setmetatable(obj, {      -- 设置元表实现属性管理
    __index = function(_, k)
        return _store[k] -- 从存储中读取属性
    end,
    __newindex = function(t, k, v)
        rawset(_store, k, v)      -- 存储属性值
        if t._init_done then      -- 如果已经初始化过
            if t._attribs[k] then -- 如果是配置属性发生变化
                t:init()          -- 重新初始化
            end
        end
    end
})
obj.__index = obj -- 设置对象索引

-- 模块元信息
obj.name = "InputMethodIndicator"                         -- 模块名称
obj.version = "1.0"                                       -- 版本号
obj.author = "lunaticsky <2013599@mail.nankai.edu.cn>"    -- 作者
obj.homepage = "https://github.com/Hammerspoon/Spoons"    -- 主页
obj.license = "MIT - https://opensource.org/licenses/MIT" -- 许可证

local logger = hs.logger.new("InputMethodIndicator")      -- 创建日志记录器
obj.logger = logger                                       -- 将日志记录器挂载到模块

-- 默认配置参数
obj._attribs = {
    ABCColor = "#62C555",           -- ABC输入法颜色(绿色)
    LocalLanguageColor = "#ED6A5E", -- 其他语言输入法颜色(红色)
    mode = "nearMouse",             -- 默认模式
    showOnChangeDuration = 3,       -- 变化显示时长(秒)
    checkInterval = 0.05,           -- 输入法检查间隔(秒)
    dotSize = 12,                   -- 圆点尺寸
    deltaY = 18,                    -- 垂直偏移量(距离光标位置)
    deltaX = 10,                    -- 水平偏移量(距离光标位置)
    eventMouseThreshold = 10,       -- 鼠标事件触发阈值(像素)
}

-- 初始化默认配置参数
for k, v in pairs(obj._attribs) do
    obj[k] = v
end

--- 模块初始化 创建画布对象并设置初始状态
--- InputMethodIndicator:init()
--- Returns:
---  * The InputMethodIndicator object
function obj:init()
    local mousePosition = hs.mouse.absolutePosition() -- 获取当前鼠标位置
    if not self.canvas then                           -- 首次初始化时创建画布
        self.canvas = hs.canvas.new({                 -- 创建新画布
            x = mousePosition.x - 2 * self.deltaX,    -- X坐标偏移
            y = mousePosition.y - 2 * self.deltaY,    -- Y坐标偏移
            w = self.dotSize,                         -- 宽度
            h = self.dotSize                          -- 高度
        })
    end

    -- 获取当前输入法并设置初始颜色
    local sourceID = hs.keycodes.currentSourceID()
    if sourceID == "com.apple.keylayout.ABC" then
        self.color = self.ABCColor
    else
        self.color = self.LocalLanguageColor
    end
    self.lastLayout = sourceID -- 记录当前输入法

    -- 配置画布元素(圆形)
    self.canvas[1] = {
        action = "fill",                  -- 填充图形
        type = "circle",                  -- 圆形类型
        fillColor = { hex = self.color }, -- 填充颜色
        frame = {                         -- 圆形尺寸和位置
            x = 0,
            y = 0,
            h = self.dotSize, -- 高度
            w = self.dotSize  -- 宽度
        }
    }
    self._init_done = true -- 标记初始化完成
    return self
end

--- 创建隐藏画布的定时器
-- 在输入法变化后延迟隐藏指示器
function obj:hideCanvasTimer()
    return hs.timer.doAfter(self.showOnChangeDuration, function()
        self.canvas:hide()
    end)
end

--- 输入法变化时显示指示器
-- 检测输入法变化并更新颜色,显示指示器
function obj:showCanvasOnChanged()
    local sourceID = hs.keycodes.currentSourceID()
    if sourceID == self.lastLayout then return end -- 无变化时退出

    self:setColor(sourceID)                        -- 更新颜色
    self.canvas:show()                             -- 显示画布

    -- 管理隐藏定时器
    if not self.hideCanvasTimer:running() then
        self.hideCanvasTimer:start()
    else
        -- 重置定时器
        self.hideCanvasTimer:stop()
        self.hideCanvasTimer:start()
    end
end

--- 设置指示器颜色
-- 根据输入法ID更新颜色配置
function obj:setColor(sourceID)
    self.color = (sourceID == "com.apple.keylayout.ABC")
        and self.ABCColor
        or self.LocalLanguageColor
    self.lastLayout = sourceID                      -- 记录当前输入法
    self.canvas[1].fillColor = { hex = self.color } -- 更新画布颜色
end

--- 跟随鼠标显示模式
-- 更新指示器位置到鼠标附近
function obj:showNearMouse()
    local cp = hs.mouse.absolutePosition() -- 获取当前鼠标位置
    self.canvas:topLeft({                  -- 设置画布位置
        x = cp.x - 2 * self.deltaX,        -- X偏移
        y = cp.y - 2 * self.deltaY         -- Y偏移
    })
end

--- 自适应模式位置调整
-- 根据当前输入框位置自动调整指示器位置
function obj:adaptiveChangePosition()
    local systemWideElement = hs.axuielement.systemWideElement()
    local focusedElement = systemWideElement.AXFocusedUIElement -- 获取焦点元素

    if focusedElement then
        local selectedRange = focusedElement.AXSelectedTextRange -- 获取选中范围
        if selectedRange then
            -- 获取选中范围的边界信息
            local selectionBounds = focusedElement:parameterizedAttributeValue("AXBoundsForRange", selectedRange)
            if selectionBounds then
                -- 根据选择框位置调整指示器
                if selectionBounds.h == 0 or selectionBounds.y < 0 then
                    self:showNearMouse() -- 无效位置时跟随鼠标
                else
                    self.canvas:topLeft({
                        x = selectionBounds.x - self.deltaX, -- X偏移
                        y = selectionBounds.y - self.deltaY  -- Y偏移
                    })

                    -- self:showNearMouse() -- 一直在鼠标附近显示一个圆点
                end
            else
                self:showNearMouse()
            end
        else
            self:showNearMouse()
        end
    else
        self:showNearMouse()
    end
end

--- 创建自适应模式定时器
-- 定时更新位置和输入法状态
function obj:adaptiveTimer()
    return hs.timer.doEvery(self.checkInterval, function()
        self:adaptiveChangePosition()                -- 调整位置
        self:setColor(hs.keycodes.currentSourceID()) -- 更新颜色
    end)
end

--- 创建变化检测定时器
-- 用于onChange模式下的定时检测
function obj:showOnChangeTimer()
    return hs.timer.doEvery(self.checkInterval, function()
        self:adaptiveChangePosition() -- 调整位置
        self:showCanvasOnChanged()    -- 检测变化
    end)
end

--- 创建鼠标跟随定时器
-- 用于nearMouse模式下的位置更新
function obj:showNearMouseTimer()
    -- CPU 占用率高
    return hs.timer.doEvery(self.checkInterval, function()
        self:showNearMouse()                         -- 更新鼠标位置
        self:setColor(hs.keycodes.currentSourceID()) -- 更新颜色
    end)
end

--- 创建鼠标事件驱动的位置更新
-- 用于mouseEvent模式下的位置更新
function obj:showMouseEvent()
    -- 使用事件驱动方案
    self:showNearMouse()
    local eventTap = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function(event)
        local newPos = hs.mouse.absolutePosition()

        if not self.lastX or not self.lastY then
            self.lastX, self.lastY = newPos.x, newPos.y
            self:showNearMouse()
        end

        -- 仅当位置变化超过阈值时更新（降低频次）
        if math.abs(newPos.x - self.lastX) > self.eventMouseThreshold or math.abs(newPos.y - self.lastY) > self.eventMouseThreshold then
            self:showNearMouse()
            self.lastX, self.lastY = newPos.x, newPos.y
        end
        -- 始终更新输入法状态（原逻辑）
        self:setColor(hs.keycodes.currentSourceID())
    end)
    eventTap:start()
    return eventTap
end

--- InputMethodIndicator:start(config)
--- 启动输入法指示器
-- @param config 配置参数表(可选)
function obj:start(config)
    -- 合并用户配置
    if config then
        if type(config) ~= "table" then
            hs.alert.show("Config must be a table")
            logger.e("配置必须是表格类型")
            return
        end
        for k, v in pairs(config) do
            if self[k] then
                self[k] = v -- 更新有效配置项
            else
                logger.e("无效配置项: " .. k)
            end
        end
    end

    -- 根据模式启动对应逻辑
    if self.mode == "onChange" then
        self.hideCanvasTimer = self:hideCanvasTimer()
        self.showOnChangeTimer = self:showOnChangeTimer()
    elseif self.mode == "adaptive" then
        self.canvas:show()
        self.adaptiveTimer = self:adaptiveTimer()
    elseif self.mode == "nearMouse" then
        self.canvas:show()
        self.showNearMouseTimer = self:showNearMouseTimer()
    elseif self.mode == "mouseEvent" then
        self.canvas:show()
        self.showMouseEvent = self:showMouseEvent()
    else
        hs.alert.show("无效模式")
        logger.e("无效模式: " .. self.mode)
        return
    end
end

--- 停止输入法指示器
function obj:stop()
    self.canvas:hide() -- 隐藏画布
    self.canvas = nil  -- 释放画布资源

    -- 停止所有定时器
    if self.showOnChangeTimer then
        self.showOnChangeTimer:stop()
        self.showOnChangeTimer = nil
    end
    if self.adaptiveTimer then
        self.adaptiveTimer:stop()
        self.adaptiveTimer = nil
    end
    if self.showNearMouseTimer then
        self.showNearMouseTimer:stop()
        self.showNearMouseTimer = nil
    end

    if self.showMouseEvent then
        self.showMouseEvent:stop()
        self.showMouseEvent = nil
    end
end

--- 检查指示器是否正在运行
-- @return 1表示已启动，0表示未启动
function obj:isStarted()
    if self.mode == "onChange" then
        return self.showOnChangeTimer and self.showOnChangeTimer:running() and 1 or 0
    elseif self.mode == "adaptive" then
        return self.adaptiveTimer and self.adaptiveTimer:running() and 1 or 0
    elseif self.mode == "nearMouse" then
        return self.showNearMouseTimer and self.showNearMouseTimer:running() and 1 or 0
    elseif self.mode == "mouseEvent" then
        return self.showMouseEvent and self.showMouseEvent:isEnabled() and 1 or 0
    end
    return 0
end

return obj
