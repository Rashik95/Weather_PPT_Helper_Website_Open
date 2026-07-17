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
;=========================================================
; STEP 2.2 - File & Folder Utility Functions
;=========================================================

;---------------------------------------------------------
; Check File Exists
;---------------------------------------------------------
FileExistsEx(FilePath)
{
    return FileExist(FilePath) ? true : false
}

;---------------------------------------------------------
; Check Folder Exists
;---------------------------------------------------------
FolderExistsEx(FolderPath)
{
    return DirExist(FolderPath) ? true : false
}

;---------------------------------------------------------
; Safe Delete File
;---------------------------------------------------------
SafeDelete(FilePath)
{
    try
    {
        if FileExist(FilePath)
            FileDelete(FilePath)
    }
    catch
    {
    }
}

;---------------------------------------------------------
; Safe Delete Folder
;---------------------------------------------------------
SafeDeleteFolder(FolderPath)
{
    try
    {
        if DirExist(FolderPath)
            DirDelete(FolderPath, true)
    }
    catch
    {
    }
}

;---------------------------------------------------------
; Safe Create Folder
;---------------------------------------------------------
SafeCreateFolder(FolderPath)
{
    try
    {
        if !DirExist(FolderPath)
            DirCreate(FolderPath)
    }
    catch
    {
    }
}

;---------------------------------------------------------
; Safe Move File
;---------------------------------------------------------
SafeMove(Source, Destination)
{
    try
    {
        FileMove(Source, Destination, true)
        return true
    }
    catch
    {
        return false
    }
}

;---------------------------------------------------------
; Safe Copy File
;---------------------------------------------------------
SafeCopy(Source, Destination)
{
    try
    {
        FileCopy(Source, Destination, true)
        return true
    }
    catch
    {
        return false
    }
}
