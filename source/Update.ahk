#Requires AutoHotkey v2.0

;=========================================================
; Update.ahk
; STEP 4.1 - Version Check System
;=========================================================

;---------------------------------------------------------
; Check For Updates
;---------------------------------------------------------
CheckForUpdates()
{
    global IsOnline
    global AppVersion
    global VersionURL
    global TempFolder

    ;-----------------------------------------
    ; Offline হলে Check করবে না
    ;-----------------------------------------
    if !IsOnline
        return false

    SafeCreateFolder(TempFolder)

    OnlineVersionFile := TempFolder "\version.txt"

    ;-----------------------------------------
    ; Download Latest Version
    ;-----------------------------------------
    if !SafeDownload(VersionURL, OnlineVersionFile)
        return false

    OnlineVersion := Trim(ReadText(OnlineVersionFile))

    if (OnlineVersion = "")
        return false

    ;-----------------------------------------
    ; Compare Version
    ;-----------------------------------------
    if (OnlineVersion != AppVersion)
    {
        WriteLog("Update Available : " OnlineVersion)
        ShowUpdateDialog(OnlineVersion)
    }
    else
    {
        WriteLog("Latest Version Installed")
    }

    return true
}
