-- 加载比较通用的,在其他地方都有可能用到的 spoon

-- 区分左右修饰键 的快捷键绑定
--mods - A table containing as elements the keyboard modifiers required, which should be one or more of the following:
--"lCmd", "lCommand", or "l⌘" for the left Command modifier
--"rCmd", "rCommand", or "r⌘" for the right Command modifier
--"lCtrl", "lControl" or "l⌃" for the left Control modifier
--"rCtrl", "rControl" or "r⌃" for the right Control modifier
--"lAlt", "lOpt", "lOption" or "l⌥" for the left Option modifier
--"rAlt", "rOpt", "rOption" or "r⌥" for the right Option modifier
--"lShift" or "l⇧" for the left Shift modifier
--"rShift" or "r⇧" for the right Shift modifier

--- LeftRightHotkey:bind(mods, key, [message,] pressedfn, releasedfn, repeatfn) -> LeftRightHotkeyObject  这是一个包装函数，用于执行 LeftRightHotkey:new(...):enable()
--- LeftRightHotkey:deleteAll(mods, key)
--- LeftRightHotkey:disableAll(mods, key)
--- LeftRightHotkey:disableAll(mods, key)
--- LeftRightHotkey:new(mods, key, [message,] pressedfn, releasedfn, repeatfn) -> LeftRightHotkeyObject
--- LeftRightHotkey:start() -> self
--- LeftRightHotkey:stop() -> self
LeftRightHotkey = hs.loadSpoon("LeftRightHotkey")
LeftRightHotkey:start()
