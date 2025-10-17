#Requires AutoHotkey v2.0
#UseHook
SetCapsLockState "AlwaysOff"

; 定期检查 CapsLock 状态，确保 AlwaysOff
; SetTimer CheckCapsLockState, 1000

; 核心映射：CapsLock 永久作为 RCtrl 使用
CapsLock::RCtrl

; <==================== 导航键 ====================>

>^n::Send "{Down}"     ; 右Ctrl + n = 向下箭头
>^p::Send "{Up}"       ; 右Ctrl + p = 向上箭头
>^,::Send "{Left}"     ; 右Ctrl + , = 向左箭头
>^.::Send "{Right}"    ; 右Ctrl + . = 向右箭头

; <==================== 特殊键 ====================>

>^m::Send "{Enter}"    ; 右Ctrl + m = Enter
>^h::Send "{Backspace}"    ; 右Ctrl + h = Backspace
>^i::Send "{Tab}"   ; 右Ctrl + i = Tab
+Backspace:: Send "{Delete}"	; Shift+Backspace → Delete

; 右Ctrl + [ = ESC 以及 Alt + Escape 切换窗口（切换最近两个窗口，API 实现）。
*>^[::Send(GetKeyState("Alt") ? activateLastActiveWindow() : "{Escape}")

; <====================  词级键 ====================>

>^!h::Send "^{Backspace}"		 ; 右Ctrl+Alt+h → 删除左侧单词
^+Backspace:: Send "^{Delete}"		; Ctrl + Shift + Backspace → 删除右侧单词
>^!,::Send "^{Left}"       ; 右Ctrl+Alt+, → 左移一个单词（类似Ctrl+←）
>^!.::Send "^{Right}"      ; 右Ctrl+Alt+. → 右移一个单词（类似Ctrl+→）

; <====================  其它功能 ====================>

; Win+Ctrl+T 窗口置顶
#^t::ToggleAlwaysOnTop()

^+!F12:: {
    Reload()         
    TrayTip "重载脚本", "已重载脚本", 50
}

























; <====================  函数 ====================>
; 检查 CapsLock 状态
CheckCapsLockState()
{
    if GetKeyState("CapsLock", "T")
    {
	Reload()
        TrayTip "CapsLock 状态修正", "已强制关闭 CapsLock", 50
    }
}

; === 窗口置顶函数 ===
ToggleAlwaysOnTop() {
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

  Loop oid.Length
  {
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