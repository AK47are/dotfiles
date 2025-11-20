; https://www.cnblogs.com/yf-zhao/p/16018481.html
#Requires AutoHotkey v2.0
#SingleInstance Force
DetectHiddenWindows True
hWnd := winGetID("A")
SendMessage(
    0x283, ; Message : WM_IME_CONTROL
    0x002, ; wParam : IMC_SETCONVERSIONMODE
    0,  ; lParam ：1025 - CN; 0 - EN
    ,
    "ahk_id " DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
)
