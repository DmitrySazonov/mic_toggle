#Requires AutoHotkey v2.0
; === Mic Toggle Helper (AutoHotkey v2) ===
; Num Lock toggles microphone mute/unmute
; Tray icon shows red (muted) / green (unmuted)
; LED NumLock mirrors mic state (ON = muted, OFF = unmuted)
; OSD popup appears ~1s on each toggle

; ----------- Config -----------
global mic_exe := "C:\Tools\mic_toggle\mic_toggle.exe"

; Put these .ico files next to this .ahk (or adjust paths)
global ico_red   := A_ScriptDir . "\circle-red32.ico"     ; 🔴 mute
global ico_green := A_ScriptDir . "\circle-green32.ico"   ; 🟢 unmute

; ----------- OSD GUI -----------
global osd := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
osd.BackColor := "Black"
osd.SetFont("s20 bold", "Segoe UI")
global osdText := osd.AddText("cWhite Center w260 h72", "")

; ----------- Tray menu -----------
A_TrayMenu.Delete()
A_TrayMenu.Add("Toggle Mic", (*) => ToggleMic())
A_TrayMenu.Add("Status",     (*) => ShowStatus())
A_TrayMenu.Add()
A_TrayMenu.Add("Exit",       (*) => ExitApp())

; ----------- Startup sync -----------
if !FileExist(mic_exe) {
    MsgBox "mic exe not found:`n" mic_exe, "Error", 16
} else {
    muted := GetMuted()
    UpdateTray(muted)
    ApplyLed(muted)
    ; Optionally show OSD at startup:
    ; ShowOSD(muted ? "🔴 Muted" : "🟢 Unmuted", muted ? "Red" : "Green")
}

; ----------- Hotkey: NumLock -----------
*NumLock::
{
    ToggleMic()
}
return

; ========== FUNCTIONS ==========

ToggleMic() {
    global mic_exe
    RunWait(mic_exe " toggle", , "Hide")

    muted := GetMuted()
    UpdateTray(muted)
    ApplyLed(muted)
    ShowOSD(muted ? "🔴 Muted" : "🟢 Unmuted", muted ? "Red" : "Green")
}

ShowStatus() {
    muted := GetMuted()
    ShowOSD(muted ? "🔴 Muted" : "🟢 Unmuted", muted ? "Red" : "Green")
}

GetMuted() {
    global mic_exe
    status_file := A_Temp . "\mic_status.txt"
    cmd := Format('{} /c ""{}" status > "{}""', A_ComSpec, mic_exe, status_file)
    RunWait(cmd, , "Hide")

    if !FileExist(status_file)
        return false
    text := FileRead(status_file)
    return InStr(StrLower(text), "true") != 0
}

ApplyLed(muted) {
    ; LED NumLock mirrors mic: ON = muted, OFF = unmuted
    if muted
        SetNumLockState("On")
    else
        SetNumLockState("Off")
}

UpdateTray(muted) {
    try {
        if muted && FileExist(ico_red)
            TraySetIcon(ico_red)
        else if !muted && FileExist(ico_green)
            TraySetIcon(ico_green)
    }
    A_IconTip := muted ? "Mic: Muted" : "Mic: Unmuted"
}

ShowOSD(text, color) {
    global osd, osdText
    osd.BackColor := color
    osdText.Value := text
    osd.Show("NoActivate Center y200")
    SetTimer HideOSD, -1000
}

HideOSD() {
    global osd
    try osd.Hide()
}
