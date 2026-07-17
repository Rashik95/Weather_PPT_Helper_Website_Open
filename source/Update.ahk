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
;=========================================================
; STEP 4.2 - Update Dialog
;=========================================================

ShowUpdateDialog(NewVersion)
{
    global GitHubRelease
    global ChangelogURL
    global TempFolder

    ChangeLogFile := TempFolder "\changelog.txt"

    ;-----------------------------------------------------
    ; Download Latest Changelog
    ;-----------------------------------------------------
    SafeDownload(ChangelogURL, ChangeLogFile)

    ChangeLog := ReadText(ChangeLogFile)

    if (ChangeLog = "")
        ChangeLog := "No changelog available."

    Result := MsgBox(
        "A new version is available.`n`n"
        . "Current Version : " AppVersion "`n"
        . "Latest Version  : " NewVersion "`n`n"
        . ChangeLog "`n`n"
        . "Do you want to open the download page?",
        "Update Available",
        "YesNo Iconi"
    )

    if (Result = "Yes")
    {
        OpenUpdatePage()
    }
    else
    {
        WriteLog("User skipped update.")
    }
}

;---------------------------------------------------------
; Open GitHub Release Page
;---------------------------------------------------------
OpenUpdatePage()
{
    global GitHubRelease

    try
    {
        Run(GitHubRelease)
        WriteLog("Opened GitHub Release Page")
    }
    catch
    {
        MsgBox(
            "Unable to open the download page.",
            "Update",
            "Iconx"
        )

        WriteLog("Failed to open GitHub Release Page")
    }
}
