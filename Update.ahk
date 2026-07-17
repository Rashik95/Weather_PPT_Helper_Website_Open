
;=========================================================
; Update.ahk
; STEP 2.0 - Auto Update Framework
;=========================================================

;---------------------------------------------------------
; Launcher Version
;---------------------------------------------------------
CurrentVersion := AppVersion

;---------------------------------------------------------
; GitHub Files
;---------------------------------------------------------
VersionURL   := GitHubRaw "version.txt"
ChangelogURL := GitHubRaw "changelog.txt"

VersionFile   := AppFolder "\version.txt"
ChangelogFile := AppFolder "\changelog.txt"

RemoteVersion := ""
ChangeLog := ""

UpdateAvailable := false

;---------------------------------------------------------
; GitHub Release Page
;---------------------------------------------------------
ReleasePage := GitHubRelease

;=========================================================
; STEP 2.1 এখানে শুরু হবে
;
; কাজ:
; ✔ version.txt Download
; ✔ changelog.txt Download
; ✔ Offline Support
;=========================================================

;=========================================================
; STEP 2.1 - Download Version & Changelog
;=========================================================

if IsOnline
{
    ;---------------------------------------
    ; version.txt Download
    ;---------------------------------------
    try
    {
        Download(VersionURL, VersionFile)

        if FileExist(VersionFile)
            RemoteVersion := Trim(FileRead(VersionFile, "UTF-8"))
    }
    catch
    {
        ; Download ব্যর্থ হলেও লোকাল ফাইল ব্যবহার
        if FileExist(VersionFile)
            RemoteVersion := Trim(FileRead(VersionFile, "UTF-8"))
    }

    ;---------------------------------------
    ; changelog.txt Download
    ;---------------------------------------
    try
    {
        Download(ChangelogURL, ChangelogFile)

        if FileExist(ChangelogFile)
            ChangeLog := Trim(FileRead(ChangelogFile, "UTF-8"))
    }
    catch
    {
        if FileExist(ChangelogFile)
            ChangeLog := Trim(FileRead(ChangelogFile, "UTF-8"))
    }
}
else
{
    ;---------------------------------------
    ; Offline Mode
    ;---------------------------------------

    if FileExist(VersionFile)
        RemoteVersion := Trim(FileRead(VersionFile, "UTF-8"))

    if FileExist(ChangelogFile)
        ChangeLog := Trim(FileRead(ChangelogFile, "UTF-8"))
}

;=========================================================
; Debug (Development Mode)
;=========================================================
; MsgBox(
;     "Current Version : " CurrentVersion
;     . "`nRemote Version : " RemoteVersion
;     . "`nOnline : " IsOnline
; )

;=========================================================
; STEP 2.2 এখানে শুরু হবে
;
; কাজ:
; ✔ Professional Version Compare
; ✔ 1.0.9 → 1.0.10 সঠিকভাবে তুলনা
; ✔ UpdateAvailable নির্ধারণ
;=========================================================

;=========================================================
; STEP 2.2 - Professional Version Compare
;=========================================================

;---------------------------------------------------------
; Version Compare Function
;---------------------------------------------------------
IsNewerVersion(CurrentVersion, RemoteVersion)
{
    Cur := StrSplit(CurrentVersion, ".")
    Rem := StrSplit(RemoteVersion, ".")

    MaxParts := (Cur.Length > Rem.Length) ? Cur.Length : Rem.Length

    Loop MaxParts
    {
        CurValue := (A_Index <= Cur.Length) ? Integer(Cur[A_Index]) : 0
        RemValue := (A_Index <= Rem.Length) ? Integer(Rem[A_Index]) : 0

        if (RemValue > CurValue)
            return true

        if (RemValue < CurValue)
            return false
    }

    return false
}

;---------------------------------------------------------
; Update Check
;---------------------------------------------------------
UpdateAvailable := false

if (RemoteVersion != "")
{
    UpdateAvailable := IsNewerVersion(CurrentVersion, RemoteVersion)
}

;=========================================================
; Debug (Development Mode)
;=========================================================
; MsgBox(
;     "Current Version : " CurrentVersion
;     . "`nRemote Version : " RemoteVersion
;     . "`nUpdate Available : " UpdateAvailable
; )

;=========================================================
; STEP 2.3 এখানে শুরু হবে
;
; কাজ:
; ✔ Update Available Dialog
; ✔ Current Version দেখাবে
; ✔ Latest Version দেখাবে
; ✔ Changelog দেখাবে
; ✔ Update Now
; ✔ Later
;=========================================================

;=========================================================
; STEP 2.3 - Update Notification
;=========================================================

if UpdateAvailable
{
    Message :=
    (
    "A new version of " AppName " is available.`n`n"
    "Current Version : " CurrentVersion "`n"
    "Latest Version  : " RemoteVersion "`n`n"
    "What's New:`n"
    "--------------------------------`n"
    ChangeLog "`n`n"
    "Do you want to download the latest version now?"
    )

    Result := MsgBox(
        Message,
        AppName " - Update Available",
        "YesNo Icon!"
    )

    if (Result = "Yes")
    {
        ;-------------------------------------------------
        ; GitHub Releases Page খুলুন
        ;-------------------------------------------------
        try
        {
            Run ReleasePage
        }
        catch
        {
            MsgBox(
                "Unable to open the download page.",
                AppName,
                "Icon!"
            )
        }

        ; Launcher বন্ধ
        ExitApp
    }

    ; যদি Later চাপেন তাহলে Launcher স্বাভাবিকভাবে চলবে
}

;=========================================================
; STEP 2.4 এখানে শুরু হবে
;
; কাজ:
; ✔ ব্যবহারকারী "Later" চাপলে
; ✔ নির্দিষ্ট সময় পর্যন্ত পুনরায় নোটিফিকেশন না দেখানো
; ✔ lastcheck.ini / config.ini ব্যবহার
;=========================================================

;=========================================================
; STEP 2.4 - Update Reminder System
;=========================================================

ReminderFile := AppFolder "\update.ini"

; কত ঘণ্টা পরে আবার Reminder দেখাবে
ReminderHours := 24

CanShowReminder := true

if FileExist(ReminderFile)
{
    LastCheck := FileGetTime(ReminderFile, "M")

    DiffSeconds := DateDiff(A_Now, LastCheck, "Seconds")

    if (DiffSeconds < (ReminderHours * 3600))
        CanShowReminder := false
}

;---------------------------------------------------------
; Update Dialog
;---------------------------------------------------------
if UpdateAvailable && CanShowReminder
{
    Message :=
    (
    "A new version of " AppName " is available.`n`n"
    "Current Version : " CurrentVersion "`n"
    "Latest Version  : " RemoteVersion "`n`n"
    "What's New:`n"
    "--------------------------------`n"
    ChangeLog "`n`n"
    "Do you want to download the latest version now?"
    )

    Result := MsgBox(
        Message,
        AppName " - Update Available",
        "YesNo Icon!"
    )

    if (Result = "Yes")
    {
        Run ReleasePage
        ExitApp
    }
    else
    {
        ; পরে মনে করিয়ে দেওয়ার সময় সংরক্ষণ
        FileAppend("", ReminderFile)
        FileSetTime(A_Now, ReminderFile, "M")
    }
}

;=========================================================
; STEP 2.5 এখানে শুরু হবে
;
; কাজ:
; ✔ Skip This Version
; ✔ Remind Me Tomorrow
; ✔ Never Remind Again (ঐচ্ছিক)
;=========================================================

;=========================================================
; STEP 2.5 - Skip This Version
;=========================================================

SkipVersionFile := AppFolder "\skip_version.txt"

SkipVersion := ""

;---------------------------------------
; Skip করা Version পড়ো
;---------------------------------------
if FileExist(SkipVersionFile)
{
    SkipVersion := Trim(FileRead(SkipVersionFile, "UTF-8"))
}

;---------------------------------------
; যদি এই Version Skip করা থাকে
; তাহলে Update Message দেখাবে না
;---------------------------------------
if (RemoteVersion = SkipVersion)
{
    UpdateAvailable := false
}

;=========================================================
; Helper Function
;=========================================================

SkipCurrentVersion()
{
    global SkipVersionFile, RemoteVersion

    try
    {
        FileDelete(SkipVersionFile)
    }
    catch
    {
    }

    FileAppend(RemoteVersion, SkipVersionFile)
}

;=========================================================
; STEP 2.6 এখানে শুরু হবে
;
; কাজ:
; ✔ Custom Update Window
; ✔ Update Now
; ✔ Later
; ✔ Skip This Version
; ✔ সুন্দর Windows 11 Style UI
;=========================================================

;=========================================================
; STEP 2.7 - Settings System
;=========================================================

SettingsFile := AppFolder "\settings.ini"

;---------------------------------------------------------
; প্রথমবার Run হলে Default Settings তৈরি
;---------------------------------------------------------
if !FileExist(SettingsFile)
{
    IniWrite(AppVersion, SettingsFile, "General", "Version")
    IniWrite("0", SettingsFile, "Update", "SkipVersion")
    IniWrite("1", SettingsFile, "Update", "CheckOnStartup")
    IniWrite("24", SettingsFile, "Update", "ReminderHours")
    IniWrite("Light", SettingsFile, "Appearance", "Theme")
}

;---------------------------------------------------------
; Settings Load
;---------------------------------------------------------
InstalledVersion := IniRead(SettingsFile, "General", "Version", AppVersion)

SkipVersion := IniRead(SettingsFile, "Update", "SkipVersion", "0")

CheckOnStartup := IniRead(SettingsFile, "Update", "CheckOnStartup", "1")

ReminderHours := IniRead(SettingsFile, "Update", "ReminderHours", "24")

Theme := IniRead(SettingsFile, "Appearance", "Theme", "Light")

;=========================================================
; STEP 2.8 এখানে শুরু হবে
;
; কাজ:
; ✔ Settings Save Function
; ✔ Version Update
; ✔ Skip Version Save
; ✔ Theme Save
;=========================================================

;=========================================================
; STEP 2.8 - Settings Save Functions
;=========================================================

;---------------------------------------------------------
; Save Installed Version
;---------------------------------------------------------
SaveInstalledVersion(Version)
{
    global SettingsFile

    IniWrite(Version, SettingsFile, "General", "Version")
}

;---------------------------------------------------------
; Save Skip Version
;---------------------------------------------------------
SaveSkipVersion(Version)
{
    global SettingsFile

    IniWrite(Version, SettingsFile, "Update", "SkipVersion")
}

;---------------------------------------------------------
; Save Theme
;---------------------------------------------------------
SaveTheme(ThemeName)
{
    global SettingsFile

    IniWrite(ThemeName, SettingsFile, "Appearance", "Theme")
}

;---------------------------------------------------------
; Save Reminder Hours
;---------------------------------------------------------
SaveReminderHours(Hours)
{
    global SettingsFile

    IniWrite(Hours, SettingsFile, "Update", "ReminderHours")
}

;---------------------------------------------------------
; Enable / Disable Auto Update Check
;---------------------------------------------------------
SaveAutoUpdate(Status)
{
    global SettingsFile

    IniWrite(Status, SettingsFile, "Update", "CheckOnStartup")
}

;=========================================================
; STEP 2.9 এখানে শুরু হবে
;
; কাজ:
; ✔ Update History
; ✔ Last Update Time
; ✔ Last Check Time
; ✔ Update Log
;
;=========================================================

;=========================================================
; STEP 2.9 - Update History & Statistics
;=========================================================

HistoryFile := AppFolder "\update.log"

;---------------------------------------------------------
; Launcher Start Count
;---------------------------------------------------------
LaunchCount := IniRead(SettingsFile, "Statistics", "LaunchCount", 0)
LaunchCount++

IniWrite(LaunchCount, SettingsFile, "Statistics", "LaunchCount")

;---------------------------------------------------------
; Last Launch Time
;---------------------------------------------------------
IniWrite(A_Now, SettingsFile, "Statistics", "LastLaunch")

;---------------------------------------------------------
; Last Update Check
;---------------------------------------------------------
IniWrite(A_Now, SettingsFile, "Update", "LastCheck")

;---------------------------------------------------------
; Log Function
;---------------------------------------------------------
WriteLog(Message)
{
    global HistoryFile

    TimeStamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")

    FileAppend(
        "[" TimeStamp "] " Message "`n",
        HistoryFile,
        "UTF-8"
    )
}

;---------------------------------------------------------
; Startup Log
;---------------------------------------------------------
WriteLog("Launcher Started")

if IsOnline
    WriteLog("Internet : Online")
else
    WriteLog("Internet : Offline")

WriteLog("Current Version : " CurrentVersion)

if (RemoteVersion != "")
    WriteLog("Latest Version : " RemoteVersion)

if UpdateAvailable
    WriteLog("Update Available")
else
    WriteLog("Launcher is Up To Date")

;=========================================================
; Update Module Completed
;=========================================================

