#Requires AutoHotkey v2.0

#Include capslock.ahk
#Include windows.ahk

^+!F12:: {
    Reload()         
    TrayTip "重载脚本", "已重载脚本", 50
}
