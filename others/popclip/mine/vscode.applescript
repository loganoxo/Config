-- #popclip
-- name: Open_Vscode
-- identifier: com.logan.popclip.extension.vscode
-- description: 将文本发送到vscode
-- icon: square filled VS
-- requirements: ["text"]
-- before: copy
-- language: applescript

do shell script "\\open -a 'Visual Studio Code'"
delay 0.5
tell application id "com.microsoft.VSCode" to activate
tell application "System Events"
    tell process "Code"
        keystroke "n" using {command down}
        delay 0.5
        keystroke "v" using {command down}
    end tell
end tell
