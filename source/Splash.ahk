#Requires AutoHotkey v2.0

;=========================================================
; Splash.ahk
; Weather PPT Helper
; Splash Screen Module
;=========================================================

global SplashGui := ""
global SplashPicture := ""
global SplashText := ""

;---------------------------------------------------------
; Show Splash Screen
;---------------------------------------------------------
ShowSplash()
{
    global SplashGui
    global SplashPicture
    global SplashText
    global AppName
    global AppVersion

    SplashGui := Gui("-Caption +AlwaysOnTop +ToolWindow")

    SplashGui.BackColor := "FFFFFF"

    ;---------------------------------------------
    ; Logo
    ;---------------------------------------------
    LogoFile := GetCurrentLogo()

    if (LogoFile != "")
    {
        SplashPicture := SplashGui.AddPicture(
            "x70 y20 w220 h220",
            LogoFile
        )
    }

    ;---------------------------------------------
    ; Application Name
    ;---------------------------------------------
    SplashGui.SetFont("s18 Bold", "Segoe UI")

    SplashGui.AddText(
        "Center x20 y255 w320",
        AppName
    )

    ;---------------------------------------------
    ; Version
    ;---------------------------------------------
    SplashGui.SetFont("s10", "Segoe UI")

    SplashGui.AddText(
        "Center x20 y285 w320",
        "Version " AppVersion
    )

    SplashGui.Show("w360 h340 Center")
}
