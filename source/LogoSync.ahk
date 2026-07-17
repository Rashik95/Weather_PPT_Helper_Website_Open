#Requires AutoHotkey v2.0

;=========================================================
; LogoSync.ahk
; STEP 3.1 - GitHub Logo Sync
;=========================================================

global SelectedLogo := ""

;---------------------------------------------------------
; Sync Logos
;---------------------------------------------------------
SyncLogos()
{
    global IsOnline
    global LogoFolder
    global LogoListURL
    global GitHubRaw

    ; Offline হলে Sync করবে না
    if !IsOnline
        return

    SafeCreateFolder(LogoFolder)

    LogoListFile := LogoFolder "\logos.txt"

    ;-----------------------------------------------------
    ; Download logos.txt
    ;-----------------------------------------------------
    if !SafeDownload(LogoListURL, LogoListFile)
        return

    LogoList := ReadText(LogoListFile)

    if (LogoList = "")
        return

    DownloadLogoFiles(LogoList)
}
;---------------------------------------------------------
; Download All Logos
;---------------------------------------------------------
DownloadLogoFiles(LogoList)
{
    global GitHubRaw
    global LogoFolder

    Loop Parse, LogoList, "`n", "`r"
    {
        LogoName := Trim(A_LoopField)

        if (LogoName = "")
            continue

        LocalFile := LogoFolder "\" LogoName
        RemoteURL := GitHubRaw "logo/" LogoName

        ;-------------------------------------
        ; Download / Replace Logo
        ;-------------------------------------
        try
        {
            Download(RemoteURL, LocalFile)
            WriteLog("Downloaded : " LogoName)
        }
        catch
        {
            WriteLog("Download Failed : " LogoName)
        }
    }

    RemoveUnusedLogos(LogoList)
}
