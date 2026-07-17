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
;=========================================================
; STEP 2.3 - Download & Text Functions
;=========================================================

;---------------------------------------------------------
; Safe Download File
;---------------------------------------------------------
SafeDownload(URL, SaveFile)
{
    try
    {
        Download(URL, SaveFile)

        if FileExist(SaveFile)
            return true
    }
    catch
    {
    }

    return false
}

;---------------------------------------------------------
; Read Text File
;---------------------------------------------------------
ReadText(FileName)
{
    try
    {
        if FileExist(FileName)
            return Trim(FileRead(FileName, "UTF-8"))
    }
    catch
    {
    }

    return ""
}

;---------------------------------------------------------
; Write Text File
;---------------------------------------------------------
WriteText(FileName, Text)
{
    try
    {
        FileDelete(FileName)
    }
    catch
    {
    }

    try
    {
        FileAppend(Text, FileName, "UTF-8")
        return true
    }
    catch
    {
        return false
    }
}

;---------------------------------------------------------
; Append Text File
;---------------------------------------------------------
AppendText(FileName, Text)
{
    try
    {
        FileAppend(Text "`r`n", FileName, "UTF-8")
        return true
    }
    catch
    {
        return false
    }
}

;---------------------------------------------------------
; Get Current Date Time
;---------------------------------------------------------
GetDateTime()
{
    return FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
}
;=========================================================
; STEP 2.4 - Random Logo Functions
;=========================================================

;---------------------------------------------------------
; Get All PNG Logo Files
;---------------------------------------------------------
GetLogoFiles()
{
    global LogoFolder

    LogoArray := []

    if !DirExist(LogoFolder)
        return LogoArray

    Loop Files, LogoFolder "\*.png", "F"
    {
        LogoArray.Push(A_LoopFileFullPath)
    }

    return LogoArray
}

;---------------------------------------------------------
; Select Random Logo
;---------------------------------------------------------
LoadRandomLogo()
{
    global SelectedLogo

    SelectedLogo := ""

    Logos := GetLogoFiles()

    if (Logos.Length = 0)
        return ""

    RandomIndex := Random(1, Logos.Length)

    SelectedLogo := Logos[RandomIndex]

    return SelectedLogo
}

;---------------------------------------------------------
; Logo Count
;---------------------------------------------------------
GetLogoCount()
{
    Logos := GetLogoFiles()
    return Logos.Length
}

;---------------------------------------------------------
; Has Any Logo?
;---------------------------------------------------------
HasLogo()
{
    return (GetLogoCount() > 0)
}

;---------------------------------------------------------
; Get Random Integer
;---------------------------------------------------------
RandomNumber(Min, Max)
{
    return Random(Min, Max)
}
;=========================================================
; STEP 2.5 - Log, Cleanup & System Functions
;=========================================================

;---------------------------------------------------------
; Write Log
;---------------------------------------------------------
WriteLog(Message)
{
    global LogFile

    try
    {
        TimeStamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        FileAppend(
            "[" TimeStamp "] " Message "`r`n",
            LogFile,
            "UTF-8"
        )
    }
    catch
    {
    }
}

;---------------------------------------------------------
; Clean Temp Folder
;---------------------------------------------------------
CleanTempFolder()
{
    global TempFolder

    if !DirExist(TempFolder)
        return

    Loop Files, TempFolder "\*", "FR"
    {
        try FileDelete(A_LoopFileFullPath)
    }

    Loop Files, TempFolder "\*", "D"
    {
        try DirDelete(A_LoopFileFullPath, true)
    }
}

;---------------------------------------------------------
; Restart Launcher
;---------------------------------------------------------
RestartLauncher()
{
    Run(A_ScriptFullPath)
    ExitApp
}

;---------------------------------------------------------
; Safe Exit
;---------------------------------------------------------
SafeExit()
{
    CleanTempFolder()
    ExitApp
}

;---------------------------------------------------------
; Debug Message
;---------------------------------------------------------
Debug(Text)
{
    ToolTip(Text)

    SetTimer(
        () => ToolTip(),
        -2000
    )
}
