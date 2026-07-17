#Requires AutoHotkey v2.0

;=========================================================
; Utils.ahk
; Common Utility Functions
;=========================================================

;---------------------------------------------------------
; Initialize Folder Structure
;---------------------------------------------------------
Initialize()
{
    global AppFolder
    global LogoFolder
    global TempFolder

    if !DirExist(AppFolder)
        DirCreate(AppFolder)

    if !DirExist(LogoFolder)
        DirCreate(LogoFolder)

    if !DirExist(TempFolder)
        DirCreate(TempFolder)
}

;---------------------------------------------------------
; Internet Connection Check
;---------------------------------------------------------
CheckInternet()
{
    global IsOnline

    IsOnline := false

    try
    {
        Download(
            "https://www.google.com/favicon.ico",
            A_Temp "\internet.tmp"
        )

        if FileExist(A_Temp "\internet.tmp")
        {
            FileDelete(A_Temp "\internet.tmp")
            IsOnline := true
        }
    }
    catch
    {
        IsOnline := false
    }

    return IsOnline
}
