#Requires AutoHotkey v2.0
#SingleInstance Force

; Win+Ctrl+T 窗口置顶，置顶窗口边框染红（Win11 22H2+ DWM 原生，随窗口自动对齐/跟随）
#^t::togglePinTop()

togglePinTop() {
  hwnd := WinGetID("A")
  if !hwnd
    return
  if (WinGetExStyle(hwnd) & 0x8) {
    WinSetAlwaysOnTop(0, hwnd)
    setBorderColor(hwnd, 0xFFFFFFFF)  ; DWMWA_COLOR_DEFAULT 还原系统默认
  } else {
    WinSetAlwaysOnTop(1, hwnd)
    setBorderColor(hwnd, 0xE53935)   ; 红
  }
}

; DWMWA_BORDER_COLOR = 34，参数为 BGR 顺序的 COLORREF
setBorderColor(hwnd, color) {
  static attr := 34
  bgr := ((color & 0xFF) << 16) | (color & 0xFF00) | ((color >> 16) & 0xFF)
  DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", attr, "int*", bgr, "int", 4)
}

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
#^o::toggleWindowVisibility("Chrome_WidgetWin_1", "Obsidian.exe", EnvGet("USERPROFILE") . "\scoop\apps\obsidian\current\Obsidian.exe")
#^z::toggleWindowVisibility("MozillaWindowClass", "zen.exe")

toggleWindowVisibility(cls, exe, launchPath := "") {
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
    if (launchPath == "")
      launchPath := exe
    Run(launchPath)
  }
  DetectHiddenWindows(false)
}
