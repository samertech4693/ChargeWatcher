; ChargeWatcher+ - plays plug/unplug sounds and lets you toggle startup
; by Samer Tech ⚡

#Persistent
prevStatus := GetBatteryStatus()

; Tray setup
Menu, Tray, NoStandard
Menu, Tray, Add, Run at Startup, ToggleStartup
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Icon, shell32.dll, 44
Menu, Tray, Tip, ChargeWatcher ⚡

SetTimer, CheckCharger, 250
return

CheckCharger:
    newStatus := GetBatteryStatus()
    if (newStatus != prevStatus) {
        if (newStatus = "AC")
            SoundPlay, %A_WinDir%\Media\Windows Hardware Insert.wav
        else
            SoundPlay, %A_WinDir%\Media\Windows Hardware Remove.wav
        prevStatus := newStatus
    }
return

GetBatteryStatus()
{
    VarSetCapacity(powerStatus, 12, 0)
    DllCall("GetSystemPowerStatus", "UInt", &powerStatus)
    ACLineStatus := NumGet(powerStatus, 0, "UChar")
    if (ACLineStatus = 1)
        return "AC"
    else
        return "DC"
}

ToggleStartup:
    startupPath := A_Startup "\ChargeWatcher.lnk"
    if FileExist(startupPath) {
        FileDelete, %startupPath%
        Menu, Tray, Uncheck, Run at Startup
        TrayTip, ChargeWatcher, Removed from startup ❌, 2, 17
    } else {
        FileCreateShortcut, %A_ScriptFullPath%, %startupPath%
        Menu, Tray, Check, Run at Startup
        TrayTip, ChargeWatcher, Added to startup ✅, 2, 17
    }
return

ExitScript:
    ExitApp
