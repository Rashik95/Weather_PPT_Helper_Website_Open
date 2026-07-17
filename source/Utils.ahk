
;=========================================================
; ১.২ - Folder Initialization
;=========================================================

; AppData ফোল্ডার না থাকলে তৈরি করো
if !DirExist(AppFolder)
    DirCreate(AppFolder)

; Logo Folder না থাকলে তৈরি করো
if !DirExist(LogoFolder)
    DirCreate(LogoFolder)

; Temp Folder না থাকলে তৈরি করো
if !DirExist(TempFolder)
    DirCreate(TempFolder)

;=========================================================
; Local Files
;=========================================================

VersionFile := AppFolder "\version.txt"
LogoListFile := AppFolder "\logos.txt"

;=========================================================
; Future Files (Reserved)
;=========================================================
; ConfigFile := AppFolder "\config.json"
; CacheFile  := AppFolder "\cache.dat"
; LogFile    := AppFolder "\launcher.log"

;=========================================================
; ১.৩ এখানে শুরু হবে
;
; কাজ:
; ✔ Internet Connection Check
; ✔ Online / Offline Mode নির্ধারণ
; ✔ GitHub Access পরীক্ষা
;=========================================================
;=========================================================
; ১.৩ - Internet Connection Check
;=========================================================

IsOnline := false

try
{
    ; GitHub থেকে একটি ছোট ফাইল ডাউনলোড করে
    ; ইন্টারনেট ও GitHub উভয়ই পরীক্ষা করা হবে

    TestFile := TempFolder "\connection.tmp"

    Download(
        GitHubRaw "version.txt",
        TestFile
    )

    if FileExist(TestFile)
    {
        IsOnline := true

        ; Test File Delete
        try FileDelete(TestFile)
    }
}
catch
{
    ; Offline Mode
    IsOnline := false
}

;=========================================================
; Status
;=========================================================

if IsOnline
{
    ConnectionStatus := "ONLINE"
}
else
{
    ConnectionStatus := "OFFLINE"
}

;=========================================================
; Debug (Development Mode)
;=========================================================
; MsgBox("Connection : " ConnectionStatus)

;=========================================================
; ১.৪ এখানে শুরু হবে
;
; কাজ:
; ✔ version.txt Download
; ✔ logos.txt Download
; ✔ Offline হলে Local File ব্যবহার
;=========================================================
