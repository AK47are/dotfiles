#Requires AutoHotkey v2.0
#SingleInstance Force 

; Win+Ctrl+T 窗口置顶
#^t::WinSetAlwaysOnTop(-1, "A")

; 右Ctrl+Alt+[ 切换最近窗口，基于系统 API，重载不会消失
>^![::activateLastActiveWindow()

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
  if (dwExStyle & 0x00000080)
    return false

  if isWindowCloaked(hWnd)
    return false

  return true
}

isWindowCloaked(hwnd) {
  cloaked := 0
  return DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "int", 14, "ptr", cloaked, "int", 4) >= 0 && cloaked
}

; 窗口绑定切换，重载会消失 https://meta.appinn.net/t/topic/39693
Wins := {}
WinKeys := ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
For Key, Value in WinKeys {
realKey := "#^" . Value
           Wins.%realKey% := ""
           Hotkey realKey, bindWindow
}

bindWindow(key) {
  DetectHiddenWindows(true) ; 检查被 WinHide() 隐藏的窗口
  if (Wins.%key% == "") {
    Wins.%key% := WinGetID("A")
  } else if (WinExist("ahk_id " . Wins.%key%) && Wins.%key% !== WinGetID("A")) {
    WinShow "ahk_id " . Wins.%key%
    WinActivate "ahk_id " . Wins.%key%
  } else {
    SoundBeep 888, 300
    Wins.%key% := ""
  }
  DetectHiddenWindows(false)
}

; 窗口隐藏，默认从环境变量寻找
#^w::toggleWindowVisibility("org.wezfurlong.wezterm", "wezterm-gui.exe")
#^o::toggleWindowVisibility("Chrome_WidgetWin_1", "Obsidian.exe")
#^z::toggleWindowVisibility("MozillaWindowClass", "zen.exe")

toggleWindowVisibility(cls, exe) {
  DetectHiddenWindows(true)
  winSpec := "ahk_class " cls " ahk_exe " exe
  if WinExist(winSpec) {
    if WinActive(winSpec) {
      WinHide(winSpec)
      Send("!{Esc}")
    } else {
      WinShow(winSpec)
      WinActivate(winSpec)
    }
  } else {
    Run(exe)
  }
  DetectHiddenWindows(false)
}
