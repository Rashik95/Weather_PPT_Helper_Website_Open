#Requires AutoHotkey v2.0
#SingleInstance Force

;=========================================================
; Config.ahk
; Weather PPT Helper Website Open
; Version 1.0.0
; Developed by Md Redoanul Islam
;=========================================================

;---------------------------------------------------------
; Application
;---------------------------------------------------------
AppName         := "Weather PPT Helper"
AppVersion      := "1.0.0"
DeveloperName   := "Developed by Md Redoanul Islam"

;---------------------------------------------------------
; GitHub
;---------------------------------------------------------
GitHubUser      := "Rashik95"
GitHubRepo      := "Weather_PPT_Helper_Website_Open"

GitHubRaw       := "https://raw.githubusercontent.com/"
                . GitHubUser "/"
                . GitHubRepo "/main/"

GitHubRelease   := "https://github.com/"
                . GitHubUser "/"
                . GitHubRepo "/releases/latest"

;---------------------------------------------------------
; Remote Files
;---------------------------------------------------------
VersionURL      := GitHubRaw "version.txt"
ChangelogURL    := GitHubRaw "changelog.txt"
LogoListURL     := GitHubRaw "logos.txt"

;---------------------------------------------------------
; Local Folder
;---------------------------------------------------------
AppFolder       := A_AppData "\WeatherPPTHelper"
LogoFolder      := AppFolder "\Logos"
TempFolder      := AppFolder "\Temp"

SettingsFile    := AppFolder "\config.ini"
VersionFile     := AppFolder "\version.txt"
LogoListFile    := AppFolder "\logos.txt"
LogFile         := AppFolder "\update.log"

;---------------------------------------------------------
; Splash
;---------------------------------------------------------
SplashColor     := "C2185B"
SplashFont      := "Segoe UI"
LogoSize        := 200
TextHeight      := 60

;---------------------------------------------------------
; Chrome
;---------------------------------------------------------
ChromePath      := "chrome.exe"

;---------------------------------------------------------
; Update
;---------------------------------------------------------
UpdateCheckOnStartup := true
ReminderHours        := 24
