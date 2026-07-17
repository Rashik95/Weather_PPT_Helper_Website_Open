#Requires AutoHotkey v2.0
#SingleInstance Force

;=========================================================
; Weather Launcher Framework
; Version 1.0.0
; Developed by Md Redoanul Islam
;=========================================================

;=========================
; Application Information
;=========================
AppName := "Weather Launcher"
AppVersion := "1.0.0"

DeveloperName := "Developed by Md Redoanul Islam"

;=========================
; GitHub Repository
;=========================
GitHubRaw := "https://raw.githubusercontent.com/Rashik95/Redoan/main/"
GitHubRelease := "https://github.com/Rashik95/Redoan/releases/latest"

;=========================
; Local Folder
;=========================
AppFolder := A_AppData "\WeatherLauncher"
LogoFolder := AppFolder "\Logos"
TempFolder := AppFolder "\Temp"

VersionFile := AppFolder "\version.txt"
LogoListFile := AppFolder "\logos.txt"

;=========================
; Splash Settings
;=========================
LogoSize := 180
TextHeight := 60
