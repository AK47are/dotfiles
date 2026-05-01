#Requires AutoHotkey v2.0
#SingleInstance Force 

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
+Backspace:: Send "{Delete}" ; Shift+Backspace → Delete

*>^[::Send "{Escape}" ; 右Ctrl + [ = ESC

; <====================  词级键 ====================>

>^!h::Send "^{Backspace}"		 ; 右Ctrl+Alt+h → 删除左侧单词
^+Backspace:: Send "^{Delete}"		; Ctrl + Shift + Backspace → 删除右侧单词
>^!,::Send "^{Left}"       ; 右Ctrl+Alt+, → 左移一个单词（类似Ctrl+←）
>^!.::Send "^{Right}"      ; 右Ctrl+Alt+. → 右移一个单词（类似Ctrl+→）

; 检查 CapsLock 状态
checkCapsLockState() {
    if GetKeyState("CapsLock", "T") {
      Reload()
      TrayTip "CapsLock 状态修正", "已强制关闭 CapsLock", 50
    }
}
