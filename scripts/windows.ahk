#Requires AutoHotkey v2.0
#SingleInstance Force

; Win+Ctrl+T 窗口置顶，置顶窗口边框染红（Win11 22H2+ DWM 原生，随窗口自动对齐/跟随）
#^t::togglePinTop()

; 置顶前边框色的快照（按 hwnd），取消置顶时还原
pinBorders := Map()

togglePinTop() {
  hwnd := WinGetID("A")
  if !hwnd
    return
  if (WinGetExStyle(hwnd) & 0x8) {
    WinSetAlwaysOnTop(0, hwnd)
    setBorderColor(hwnd, pinBorders.Has(hwnd) ? pinBorders[hwnd] : 0xB5B5B5)  ; 还原置顶前边框色（无快照时回退中性灰）
  } else {
    pinBorders[hwnd] := snapshotBorderColor(hwnd)
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
; 采样窗口边框顶边中心颜色作为置顶前快照；采样无效时回退中性灰 0xB5B5B5
snapshotBorderColor(hwnd) {
  if !WinExist("ahk_id " hwnd)
    return 0xB5B5B5
  WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)
  if (w < 20 || h < 20)
    return 0xB5B5B5
  px := x + w // 2
  py := y
  if !pointOnScreen(px, py)
    return 0xB5B5B5
  try {
    c := PixelGetColor(px, py, "RGB")
  } catch
    return 0xB5B5B5
  c := StrReplace(c, "0x", "")
  if (StrLen(c) != 6)
    return 0xB5B5B5
  val := Integer("0x" c)
  r := (val >> 16) & 0xFF, g := (val >> 8) & 0xFF, b := val & 0xFF
  ; 纯白采样不可靠（无有效边框绘制），回退中性灰
  if (r >= 0xF5 && g >= 0xF5 && b >= 0xF5)
    return 0xB5B5B5
  return val & 0xFFFFFF
}

pointOnScreen(x, y) {
  Loop MonitorGetCount() {
    MonitorGet(A_Index, &l, &t, &r, &b)
    if (x >= l && x <= r && y >= t && y <= b)
      return true
  }
  return false
}

; 右Ctrl+Alt+[ 切换最近窗口，基于系统 API，重载不会消失
>^![::activateLastActiveWindow()

; 本段代码来自 https://www.autohotkey.com/boards/viewtopic.php?style=23&p=548496# 让我们心怀感激之情！
activateLastActiveWindow() {
  oid := WinGetList()
  Loop oid.Length {
    this_ID := oid[A_Index]
    if WinActive("ahk_id " this_ID) || !isWindow(this_ID)
      continue
    WinActivate("ahk_id " . this_ID)
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
  ; DWMWA_CLOAKED=14，输出为 4 字节 BOOL，需传变量地址而非值
  return DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "int", 14, "int*", &cloaked, "int", 4) >= 0 && cloaked
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

; Alt+` 切换当前应用的下一个窗口（同 exe 的 z-order 顺序，最小化窗口自动还原）
; 参考 https://gist.github.com/mattheworres/e6a98b00f5a93a6bf3514a872b0d1ed0
!`::switchAppWindow(1)
!+`::switchAppWindow(-1)

switchAppWindow(direction) {
  activeId := WinGetID("A")
  if !activeId
    return
  try exe := WinGetProcessName(activeId)
  catch
    return
  ids := WinGetList("ahk_exe " exe)
  n := ids.Length
  if n <= 1
    return
  index := 0
  for i, id in ids {
    if id = activeId {
      index := i
      break
    }
  }
  if index = 0
    return
  i := index
  loop n {
    i := direction > 0 ? (i = n ? 1 : i + 1) : (i = 1 ? n : i - 1)
    if i != index && isWindow(ids[i]) {
      WinActivate("ahk_id " . ids[i])
      return
    }
  }
}
