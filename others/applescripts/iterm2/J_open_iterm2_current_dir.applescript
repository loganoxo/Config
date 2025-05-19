-- Open with finder dir

global open_in_new_window
global open_in_new_tab
global cd_command

-- Handlers
on send_text_without_execute(the_window, custom_text)
	tell application id "com.googlecode.iterm2" to tell the_window to tell current session to write text custom_text newline no
end send_text_without_execute

on send_text_and_execute(the_window, custom_text)
	tell application id "com.googlecode.iterm2" to tell the_window to tell current session to write text custom_text
end send_text_and_execute

on is_running()
	return application id "com.googlecode.iterm2" is running
end is_running

on has_windows()
	set exist_window to missing value
	if not is_running() then return exist_window
	tell application id "com.googlecode.iterm2"
		set allWindows to every window
		repeat with theWindow in allWindows
			tell theWindow
				set is_hot to (is hotkey window)
			end tell
			if not is_hot then
				set exist_window to theWindow
				exit repeat
			end if
		end repeat
	end tell
	return exist_window
end has_windows

-- timeout protection
on wait_until_iterm_ready(timeout_seconds)
	set exist_window to has_windows()
	if exist_window is not missing value then return exist_window
	
	set waitCount to 0
	set maxWait to (timeout_seconds * 10)
	repeat
		delay 0.1
		set exist_window to has_windows()
		if exist_window is not missing value then exit repeat
		set waitCount to waitCount + 1
		if waitCount > maxWait then
			display notification "iTerm2 failed to start" with title "Error"
			error "iTerm2 failed to start"
		end if
	end repeat
	
	return exist_window
end wait_until_iterm_ready

on activate_app_wait()
	set open_in_new_tab to false
	set cd_command to missing value
	tell application id "com.googlecode.iterm2" to activate
	return wait_until_iterm_ready(5)
end activate_app_wait

on new_window()
	set open_in_new_tab to false
	set cd_command to missing value
	tell application id "com.googlecode.iterm2"
		set exist_window to create window with default profile
	end tell
	delay 0.2
	return exist_window
end new_window

on new_tab(the_window)
	set cd_command to missing value
	tell application id "com.googlecode.iterm2" to tell the_window to create tab with default profile
	delay 0.2
end new_tab

on activate_app()
	tell application id "com.googlecode.iterm2" to activate
end activate_app

on get_window()
	if is_running() then
		if open_in_new_window then
			return new_window()
		end if
	else
		return activate_app_wait()
	end if
	
	set exist_window to has_windows()
	if exist_window is missing value then
		return new_window()
	else
		tell application id "com.googlecode.iterm2"
			if miniaturized of exist_window is true then
				set miniaturized of exist_window to false
				delay 0.1
			end if
		end tell
		return exist_window
	end if
end get_window

on cd_command_from_finder()
	if windows of application "Finder" is not {} then
		tell application "Finder" to set pathList to (quoted form of POSIX path of (target of front window as alias))
		set cd_command to "clear; cd " & pathList
	end if
end cd_command_from_finder

on run argv
	-- variables
	set open_in_new_window to false
	set open_in_new_tab to true
	set cd_command to "clear; cd ~/Temp"
	
	-- Main
	set the_current_window to get_window()
	if open_in_new_tab then
		new_tab(the_current_window)
	end if
	cd_command_from_finder()
	if cd_command is not missing value then
		send_text_and_execute(the_current_window, cd_command)
	end if
	delay 0.2
	activate_app()
end run
