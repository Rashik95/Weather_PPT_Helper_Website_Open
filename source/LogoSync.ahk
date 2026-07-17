
;=========================================================
; ১.৪ - Download Required Files
;=========================================================

RemoteVersion := ""
LogoList := ""

if IsOnline
{
    ;-------------------------------
    ; Download version.txt
    ;-------------------------------
    try
    {
        Download(
            GitHubRaw "version.txt",
            VersionFile
        )

        if FileExist(VersionFile)
            RemoteVersion := Trim(FileRead(VersionFile, "UTF-8"))
    }
    catch
    {
        ; Download ব্যর্থ হলে আগের version.txt ব্যবহার করো
        if FileExist(VersionFile)
            RemoteVersion := Trim(FileRead(VersionFile, "UTF-8"))
    }

    ;-------------------------------
    ; Download logos.txt
    ;-------------------------------
    try
    {
        Download(
            GitHubRaw "logos.txt",
            LogoListFile
        )

        if FileExist(LogoListFile)
            LogoList := FileRead(LogoListFile, "UTF-8")
    }
    catch
    {
        ; Download ব্যর্থ হলে আগের logos.txt ব্যবহার করো
        if FileExist(LogoListFile)
            LogoList := FileRead(LogoListFile, "UTF-8")
    }
}
else
{
    ;-------------------------------
    ; Offline Mode
    ;-------------------------------

    if FileExist(VersionFile)
        RemoteVersion := Trim(FileRead(VersionFile, "UTF-8"))

    if FileExist(LogoListFile)
        LogoList := FileRead(LogoListFile, "UTF-8")
}

;=========================================================
; Debug (Development Mode)
;=========================================================
; MsgBox("Current Version : " AppVersion
;     . "`nRemote Version : " RemoteVersion
;     . "`nOnline : " IsOnline)

;=========================================================
; ১.৫ এখানে শুরু হবে
;
; কাজ:
; ✔ logos.txt Parse করা
; ✔ GitHub Logo Sync
; ✔ Safe Download
; ✔ Temp Folder ব্যবহার
;=========================================================

;=========================================================
; ১.৫ - Safe Logo Sync
;=========================================================

if IsOnline && (LogoList != "")
{
    TempLogoFolder := TempFolder "\Logos"

    ; পুরোনো Temp Folder Delete
    if DirExist(TempLogoFolder)
        DirDelete(TempLogoFolder, true)

    DirCreate(TempLogoFolder)

    SyncOK := true

    ;---------------------------------------
    ; Step 1 : সব Logo Temp Folder-এ Download
    ;---------------------------------------
    Loop Parse, LogoList, "`n", "`r"
    {
        LogoName := Trim(A_LoopField)

        if (LogoName = "")
            continue

        try
        {
            Download(
                GitHubRaw LogoName,
                TempLogoFolder "\" LogoName
            )
        }
        catch
        {
            SyncOK := false
            break
        }
    }

    ;---------------------------------------
    ; Step 2 : Download সফল হলে Replace
    ;---------------------------------------
    if SyncOK
    {
        ; পুরোনো Logo Delete
        Loop Files, LogoFolder "\*.png"
        {
            try FileDelete(A_LoopFileFullPath)
        }

        ; নতুন Logo Move
        Loop Files, TempLogoFolder "\*.png"
        {
            try
            {
                FileMove(
                    A_LoopFileFullPath,
                    LogoFolder "\" A_LoopFileName,
                    true
                )
            }
            catch
            {
            }
        }
    }

    ; Temp Folder Delete
    try DirDelete(TempLogoFolder, true)
}

;=========================================================
; ১.৬ এখানে শুরু হবে
;
; কাজ:
; ✔ LogoFolder থেকে সব Logo সংগ্রহ
; ✔ Random Logo নির্বাচন
; ✔ Splash Screen-এ দেখানোর জন্য প্রস্তুত করা
;=========================================================

;=========================================================
; ১.৬ - Random Logo Selection
;=========================================================

SelectedLogo := ""

LogoFiles := []

;---------------------------------------
; Logo Folder থেকে সব PNG সংগ্রহ
;---------------------------------------
Loop Files, LogoFolder "\*.png"
{
    LogoFiles.Push(A_LoopFileFullPath)
}

;---------------------------------------
; Random Logo নির্বাচন
;---------------------------------------
if (LogoFiles.Length > 0)
{
    RandomIndex := Random(1, LogoFiles.Length)
    SelectedLogo := LogoFiles[RandomIndex]
}

;=========================================================
; Debug (Development Mode)
;=========================================================
; MsgBox(
;     "Total Logos : " LogoFiles.Length
;     . "`nSelected : " SelectedLogo
; )

;=========================================================
; ১.৭ এখানে শুরু হবে
;
; কাজ:
; ✔ Splash Screen Create
; ✔ Full Screen
; ✔ Background Color
; ✔ Developer Name
; ✔ Logo Display
;=========================================================
