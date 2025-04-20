-- 模拟键盘粘贴; 一些程序和网站非常努力地阻止你粘贴文本;发出伪造的键盘事件来输入剪贴板内容绕过这个问题
hs.hotkey.bind(HYPER_KEY, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
