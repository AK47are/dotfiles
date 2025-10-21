#Requires AutoHotkey v2.0

; Win+Ctrl+T 窗口置顶
#^t::toggleAlwaysOnTop()

; 右Ctrl+Alt+[ 切换最近窗口，基于系统 API，重载不会消失
>^![::activateLastActiveWindow()

; === 窗口置顶函数 ===
toggleAlwaysOnTop() {
  try {
    currentWindow := WinGetID("A")
    if !currentWindow
        return
    isTopmost := WinGetExStyle(currentWindow) & 0x8
    WinSetAlwaysOnTop (!isTopmost), currentWindow
    ; TrayTip "窗口置顶", isTopmost ? "已取消置顶" : "已置顶", 500
  }
}

; 本段代码来自 https://www.autohotkey.com/boards/viewtopic.php?style=23&p=548496# 让我们心怀感激之情！
activateLastActiveWindow() {
  oid := WinGetlist(, , "Find",)

  Loop oid.Length {
    this_ID := oid[A_Index]
    if WinActive("ahk_id " this_ID) || !isWindow(this_ID)
      continue
    WinActivate("ahk_id " . this_ID)
    DllCall("SetForegroundWindow", "UInt", this_ID)
    break
  }
}

isWindow(hWnd) {
  dwStyle := WinGetStyle("ahk_id " . hWnd)
 if ((dwStyle & 0x08000000) || !(dwStyle & 0x10000000))
    return false

  dwExStyle := WinGetExStyle("ahk_id " . hWnd)
  if ((dwExStyle & 0x00000080) || (dwExStyle & 0x00040000) || (dwExStyle & 0x00000008))
    return false

  if isWindowCloaked(hWnd)
    return false

  return true
}

isWindowCloaked(hwnd) {
  cloaked := 0
  return DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "int", 14, "ptr", cloaked, "int", 4) >= 0 && cloaked
}
