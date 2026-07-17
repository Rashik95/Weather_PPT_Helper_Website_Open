

;=========================================================
; ১.৯ - Chrome Background Launch
;=========================================================

ChromePath := "chrome.exe"

WebsiteList := [
    "https://www.windy.com/-Waves-waves?waves,22.132,91.269,9",
    "https://ffwc.gov.bd/app/home",
    "https://mail.google.com/mail/u/0/?tab=rm&ogbl#search/WEATHER",
    "http://old.ffwc.gov.bd/images/fsumm.pdf"
]

;=========================================================
; Chrome Command তৈরি
;=========================================================

ChromeCommand := ChromePath " --new-window --start-minimized "

for URL in WebsiteList
    ChromeCommand .= '"' URL '" '

;=========================================================
; Chrome চালু
;=========================================================

try
{
    Run ChromeCommand
}
catch
{
    MsgBox(
        "Google Chrome পাওয়া যায়নি।`n`n"
        "অনুগ্রহ করে Chrome Install করুন।",
        AppName,
        "Icon!"
    )

    ExitApp
}

;=========================================================
; Chrome Ready হওয়ার জন্য অপেক্ষা
;=========================================================

if WinWait("ahk_exe chrome.exe", , 15)
{
    ; Chrome প্রস্তুত
}
else
{
    MsgBox(
        "Chrome নির্ধারিত সময়ের মধ্যে চালু হয়নি।",
        AppName,
        "Icon!"
    )
}

;=========================================================
; ১.১০ এখানে শুরু হবে
;
; কাজ:
; ✔ Splash Screen Close
; ✔ Chrome Restore
; ✔ Chrome সামনে আনা
; ✔ Launcher Finish
;=========================================================

;=========================================================
; ১.১০ - Finish Splash & Show Chrome
;=========================================================

; Chrome Ready হওয়ার জন্য একটু অপেক্ষা
Sleep 1000

;---------------------------------------------------------
; Chrome সামনে আনা
;---------------------------------------------------------
if WinExist("ahk_exe chrome.exe")
{
    try
    {
        WinRestore("ahk_exe chrome.exe")
        WinActivate("ahk_exe chrome.exe")
    }
    catch
    {
        ; কোনো Error হলে Launcher বন্ধ হবে না
    }
}

;---------------------------------------------------------
; Splash Screen Close
;---------------------------------------------------------
try
{
    Splash.Destroy()
}
catch
{
}

;=========================================================
; Launcher Finished Successfully
;=========================================================

ExitApp

;=========================================================
; ২.০ এখানে শুরু হবে
;
; ✔ Auto Update System
; ✔ Version Compare
; ✔ Update Notification
; ✔ GitHub Releases
; ✔ Download Page
;=========================================================
