-- 从finder目录下打开

-- 是否打开新窗口
property open_in_new_window : false
-- 是否打开新标签页
property open_in_new_tab : true

-- Handlers
on new_window()
	tell application id "com.googlecode.iterm2" to create window with default profile
end new_window

on new_tab()
	tell application id "com.googlecode.iterm2" to tell the front window to create tab with default profile
end new_tab

on call_forward()
	tell application id "com.googlecode.iterm2" to activate
end call_forward

on is_running()
	return application id "com.googlecode.iterm2" is running
end is_running

on has_windows()
	if not is_running() then return false
	if windows of application id "com.googlecode.iterm2" is {} then return false
	return true
end has_windows

on has_finderWindows()
	if windows of application "Finder" is {} then return false
	return true
end has_finderWindows

on send_text(custom_text)
	tell application id "com.googlecode.iterm2" to tell the first window to tell current session to write text custom_text
end send_text

-- 超时保护
on wait_until_iterm_ready(timeout_seconds)
	set waitCount to 0
	set maxWait to (timeout_seconds * 10)
	repeat until has_windows()
		delay 0.1
		set waitCount to waitCount + 1
		if waitCount > maxWait then
			display notification "iTerm2 启动失败或窗口未能正常创建" with title "iTerm 自动跳转失败"
			return false
		end if
	end repeat
	return true
end wait_until_iterm_ready

on run argv
	
	if has_finderWindows() then
		tell application "Finder" to set pathList to (quoted form of POSIX path of (folder of front window as alias))
		set command to "clear; cd " & pathList
	else
		set command to "clear; cd ~/Temp"
	end if
	
	-- Main
	if has_windows() then
		if open_in_new_window then
			new_window()
			delay 0.2
		else if open_in_new_tab then
			new_tab()
			delay 0.2
		end if
		send_text(command)
		call_forward()
	else
		if is_running() then
			new_window()
			if wait_until_iterm_ready(5) then
				send_text(command)
				call_forward()
			end if
		else
			call_forward()
			if wait_until_iterm_ready(5) then
				send_text(command)
			end if
		end if
	end if
	
end run