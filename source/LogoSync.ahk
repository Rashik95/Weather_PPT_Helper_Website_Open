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
;---------------------------------------------------------
; Remove Old Logos
;---------------------------------------------------------
RemoveUnusedLogos(LogoList)
{
    global LogoFolder

    Loop Files, LogoFolder "\*.png", "F"
    {
        LocalLogo := A_LoopFileName

        if !InStr("`n" LogoList "`n", "`n" LocalLogo "`n")
        {
            try
            {
                FileDelete(A_LoopFileFullPath)
                WriteLog("Deleted : " LocalLogo)
            }
            catch
            {
                WriteLog("Delete Failed : " LocalLogo)
            }
        }
    }

    SelectRandomLogo()
}

;---------------------------------------------------------
; Select Random Logo
;---------------------------------------------------------
SelectRandomLogo()
{
    global LogoFolder
    global SelectedLogo

    Logos := []

    Loop Files, LogoFolder "\*.png", "F"
    {
        Logos.Push(A_LoopFileFullPath)
    }

    if (Logos.Length = 0)
    {
        SelectedLogo := ""
        return false
    }

    RandomIndex := Random(1, Logos.Length)

    SelectedLogo := Logos[RandomIndex]

    WriteLog("Random Logo : " SelectedLogo)

    return true
}
;=========================================================
; STEP 3.4 - Offline Support & Validation
;=========================================================

;---------------------------------------------------------
; Validate Selected Logo
;---------------------------------------------------------
ValidateLogo()
{
    global SelectedLogo

    if (SelectedLogo = "")
        return false

    if !FileExist(SelectedLogo)
    {
        SelectedLogo := ""
        return false
    }

    return true
}

;---------------------------------------------------------
; Load Logo (Online / Offline)
;---------------------------------------------------------
LoadLogo()
{
    global IsOnline

    ;-----------------------------------------
    ; Online হলে Sync করবে
    ;-----------------------------------------
    if IsOnline
        SyncLogos()

    ;-----------------------------------------
    ; Random Logo Select
    ;-----------------------------------------
    SelectRandomLogo()

    ;-----------------------------------------
    ; যদি Logo না থাকে
    ;-----------------------------------------
    if !ValidateLogo()
    {
        WriteLog("No Logo Available")
        return false
    }

    return true
}

;---------------------------------------------------------
; Get Current Logo
;---------------------------------------------------------
GetCurrentLogo()
{
    global SelectedLogo
    return SelectedLogo
}

;=========================================================
; END OF LOGOSYNC.AHK
;=========================================================
