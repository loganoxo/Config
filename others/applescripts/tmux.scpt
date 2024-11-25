-- Handlers
on new_window()
	tell application "iTerm" to create window with profile "tmux"
end new_window


on call_forward()
	tell application "iTerm" to activate
end call_forward

on is_running()
	application "iTerm" is running
end is_running

on has_windows()
	if not is_running() then return false
	if windows of application "iTerm" is {} then return false
	true
end has_windows


	
-- Main
if is_running() then
    new_window()
else
    call_forward()
    repeat until has_windows()
        delay 0.01
    end repeat
    new_window()
end if

