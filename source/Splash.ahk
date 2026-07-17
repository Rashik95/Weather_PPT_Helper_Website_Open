
;=========================================================
; ১.৭ - Splash Screen Initialize
;=========================================================

; Splash Screen তৈরি
Splash := Gui("-Caption +AlwaysOnTop +ToolWindow")

; Background Color
Splash.BackColor := "C2185B"

; Full Screen
Splash.Show(
    "x0 y0 w" A_ScreenWidth
    " h" A_ScreenHeight
)

;=========================
; Font
;=========================
Splash.SetFont("s34 Bold", "Segoe UI")

;=========================
; Developer Name Position
;=========================
TextY := (A_ScreenHeight // 2) - 150

Splash.Add(
    "Text",
    "x0 y" TextY
    " w" A_ScreenWidth
    " h60 Center cFFFFFF",
    DeveloperName
)

;=========================
; Logo Position
;=========================
LogoX := (A_ScreenWidth - LogoSize) // 2
LogoY := TextY + 90

;=========================
; Random Logo Display
;=========================
if (SelectedLogo != "")
{
    Splash.Add(
        "Picture",
        "BackgroundTrans x" LogoX
        " y" LogoY
        " w" LogoSize
        " h" LogoSize,
        SelectedLogo
    )
}

;=========================================================
; ১.৮ এখানে শুরু হবে
;
; কাজ:
; ✔ Fade In Animation
; ✔ Loading Effect
; ✔ Progress Bar (Optional)
; ✔ Welcome Animation
;=========================================================

;=========================================================
; ১.৮ - Splash Animation
;=========================================================

;-------------------------------
; Loading Text
;-------------------------------
LoadingText := Splash.Add(
    "Text",
    "x0 y" (LogoY + LogoSize + 25)
    " w" A_ScreenWidth
    " h30 Center cFFFFFF",
    "Loading..."
)

;=========================================================
; Loading Animation (Dots)
;=========================================================

Loop 30
{
    DotCount := Mod(A_Index, 4)

    Dots := ""

    Loop DotCount
        Dots .= "."

    LoadingText.Text := "Loading" Dots

    Sleep 100
}

;=========================================================
; এখানে ভবিষ্যতে যোগ করা হবে
;
; ✔ Fade In Effect
; ✔ Fade Out Effect
; ✔ Progress Bar
; ✔ Welcome Animation
;=========================================================

;=========================================================
; ১.৯ এখানে শুরু হবে
;
; কাজ:
; ✔ Chrome Background Launch
; ✔ Multiple Website Open
; ✔ Chrome Ready হওয়া পর্যন্ত অপেক্ষা
;=========================================================