#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * customDialog Generator / Customizer
 * A tool to visually configure and generate code for the customDialog AHK v2 library.
 */

; --- PRESETS ---
Presets := Map(
    "Default (Dark)", {background: "1A1A1A", backgroundAlt: "0E0E0E", buttonHoverColor:"333333", fontColor: "FFFFFF", titleColor: "FFFFFF", exitBG:"250D0D", titlebarBG: "0E0E0E", iconColor: "FF4C4C", detailBorder: "333333", exitColor: "FF8080", exitBGHover:"701C1C"},
    "Windows Light", {background: "F3F3F3", backgroundAlt: "FAFAFA", buttonHoverColor:"FFFFFF", fontColor: "000000", titleColor: "000000", exitBG:"E9C9C9", titlebarBG: "E5E5E5", iconColor: "0078D7", detailBorder: "CCCCCC", exitColor: "D20000", exitBGHover:"EAAAAA"},
    "Warning (Yellow)", {background: "FFF9C4", backgroundAlt: "FFFDE7", buttonHoverColor:"FFFFFF", titleColor:"840000", fontColor: "333333", titlebarBG: "FBC02D", exitBG:"F9A32F", iconColor: "F57F17", detailBorder: "F9A825", exitColor: "840000", exitBGHover:"FC4A2C"},
    "Critical (Red)", {background: "FFEBEE", backgroundAlt: "FFFBFC", buttonHoverColor:"FFFFFF",titleColor:"FFDDDD", fontColor: "B71C1C", titlebarBG: "D32F2F", exitBG:"F43333",iconColor: "B71C1C", detailBorder: "EF9A9A", exitColor: "FFDDDD", exitBGHover:"FF1717"}
)

Main := Gui("-Resize -MaximizeBox", "customDialog Studio")
Main.SetFont("s9", "Segoe UI")

Tabs := Main.Add("Tab3", "w650 h430", ["General", "Content", "Progress", "Theme", "Behavior", "Export"])

; --- TAB 1: GENERAL & LAYOUT ---
Tabs.UseTab(1)
Main.Add("GroupBox", "x20 y50 w630 h130", "Window Dimensions")
Main.Add("Text", "x40 y75", "Width (px):")
EdWidth := Main.Add("Edit", "x120 y72 w60 Number", "400")
Main.Add("Text", "x200 y75", "Height (0 = Auto):")
EdHeight := Main.Add("Edit", "x300 y72 w60 Number", "0")

Main.Add("Text", "x40 y110", "Win11 Frame:")
EdW11Rad := Main.Add("DropDownList", "x120 y107 w240", ["1 - No Rounding, No Shadow", "2 - Large Rounding, Big Shadow", "3 - Small Rounding, Small Shadow", "4 - Large Rounding, Small Shadow"])
EdW11Rad.Text := "3 - Small Rounding, Small Shadow"

Main.Add("Text", "x33 y145", "Legacy Radius:")
EdLegRad := Main.Add("Edit", "x120 y142 w60 Number Disabled", "5")
ChkForceLeg := Main.Add("Checkbox", "x220 y145", "Force Legacy Radius (No Shadow)")

toggle(){
    EdW11Rad.Enabled := !ChkForceLeg.Value
    EdLegRad.Enabled := ChkForceLeg.Value
}
ChkForceLeg.OnEvent("Click", (*) =>toggle())

y := 190
Main.Add("GroupBox", "x20 y" y " w630 h90", "Input Mode")
ChkHasInput := Main.Add("Checkbox", "x40 y" . y+25, "Enable Input")

defLbl := Main.Add("Text", "x40 y" (y+60) " Disabled", "Default Input:")
EdInputDef := Main.Add("Edit", "x130 y" (y+57) " w150 Disabled", "")
EdPlaceholder := Main.Add("Edit", "x380 y" (y+57) " w150 Disabled", "Type here...")

plcLbl := Main.Add("Text", "x310 y" (y+60) " Disabled", "Placeholder:")
ChkMaskInput := Main.Add("Checkbox", "x130 y" (y+25) " Disabled", "Mask Input (Password)")

ChkHasInput.OnEvent("Click", (*) => 
    defLbl.Enabled := ChkHasInput.Value
    plcLbl.Enabled := ChkHasInput.Value
    EdInputDef.Enabled := ChkHasInput.Value
    EdPlaceholder.Enabled := ChkHasInput.Value
    ChkMaskInput.Enabled := ChkHasInput.Value
)


y := 290
Main.Add("GroupBox", "x20 y" y " w630 h95", "Button Settings")
Main.Add("Text", "x40 y" (y+23), "Labels:")
EdBtnList := Main.Add("Edit", "x100 y" (y+20) " w500", "&OK, &Cancel")
Main.Add("Text", "x40 y" (y+58), "Width:")
EdBtnW := Main.Add("Edit", "x100 y" (y+55) " w50 Number", "80")
Main.Add("Text", "x170 y" (y+58), "Height:")
EdBtnH := Main.Add("Edit", "x230 y" (y+55) " w50 Number", "30")
Main.Add("Text", "x300 y" (y+58), "Margin:")
EdBtnM := Main.Add("Edit", "x360 y" (y+55) " w50 Number", "10")

; --- TAB 2: CONTENT & INPUT ---
Tabs.UseTab(2)

Main.Add("Text", "x40 y55 w80 Right ", "Title Text:")
EdTitle := Main.Add("Edit", "x130 y52 w480", "Alert")

Main.Add("Text", "x40 y90 w80 Right", "Icon:")
EdIcon := Main.Add("Edit", "x130 y87 w40", "ℹ️")
DDLIconPresets := Main.Add("DropDownList", "x180 y87 w120", ["Quick Select", "ℹ️ Info", "⚠️ Warning", "❌ Error", "✋ Stop", "🚫 Cancel", "✏️ Edit", "⏳ Wait", "❓ Question", "💡 Idea", "✅ Success"])
DDLIconPresets.Text := "Quick Select"
Main.Add("Text", "x320 y92 c6b6b6b", "Empty for none, free type an icon or text")


y := 130
Main.Add("GroupBox", "x20 y" y " w630 h130", "Main Message")

Main.Add("Text", "x40 y" (y+30) " w80 Right", "Main Message:")
EdMsg := Main.Add("Edit", "x140 y" (y+27) " w480 r2", "This is your custom message content.")

y := y+50
Main.Add("Text", "x40 y" (y+30) " w80 Right", "Message Align:")
DDLAlign := Main.Add("DropDownList", "x140 y" (y+27) " w100", ["Left", "Center", "Right"])
DDLAlign.Text := "Center"

Main.Add("Text", "x280 y" (y+30), "Message Top Padding:")
EdMsgTop := Main.Add("Edit", "x400 y" (y+27) " w60 Number", "10")
Main.SetFont("s8")
Main.Add("Text", "x280 y" (y+53) " c6b6b6b", "Offset '10' for single line main messages, set to 0 for multi-line")
Main.SetFont("s9")



y := 270
Main.Add("GroupBox", "x20 y" y " w630 h150", "Selectable Detail Section")
Main.Add("Text", "x40 y" (y + 30) " w80 Right", "Detail Text:")
EdDetail := Main.Add("Edit", "x130 y" (y + 27) " w480 r5", "")
Main.Add("Text", "x40 y" (y+120) " w80 Right", "Detail Rows:")
EdDetRows := Main.Add("Edit", "x130 y" (y+117) " w40 Number", "9")


icoChng(ctrl, *){
    try EdIcon.Value := StrSplit(ctrl.Text, " ")[1]
    DDLIconPresets.Text := "Quick Select"
}
DDLIconPresets.OnEvent("Change", icoChng)




; --- TAB 3: PROGRESS BARS ---
Tabs.UseTab(3)
tW := 630
; Progress Group 1
Main.Add("GroupBox", "x20 y50 w" . tw . " h90", "Primary Progress Bar")
ChkProg1 := Main.Add("Checkbox", "xp+20 yp+25", "Active")
Main.Add("Text", "x+20 yp", "Start %:")
EdP1Val := Main.Add("Edit", "x+5 yp-3 w40 Number", "50")
Main.Add("Text", "x+15 yp+3", "Text:")
EdP1Text := Main.Add("Edit", "x+5 yp-3 w140", "Processing...")
Main.Add("Text", "x+15 yp+3", "Subtext:")
EdP1Sub := Main.Add("Edit", "x+5 yp-3 w140", "Please wait...")
Main.Add("Text", "x40 y+15", "Hex Color:")
EdP1Col := Main.Add("Edit", "x+10 yp-3 w80", "FF4C4C")
BtnP1Col := Main.Add("Button", "x+5 yp w30 h24", "...")

; Progress Group 2
Main.Add("GroupBox", "x20 y+20 w" . tw . " h90", "Secondary Progress Bar")
ChkProg2 := Main.Add("Checkbox", "xp+20 yp+25", "Active")
Main.Add("Text", "x+20 yp", "Start %:")
EdP2Val := Main.Add("Edit", "x+5 yp-3 w40 Number", "25")
Main.Add("Text", "x+15 yp+3", "Text:")
EdP2Text := Main.Add("Edit", "x+5 yp-3 w140", "Overall Task")
Main.Add("Text", "x+15 yp+3", "Subtext:")
EdP2Sub := Main.Add("Edit", "x+5 yp-3 w140", "Step 1 of 4")
Main.Add("Text", "x40 y+15", "Hex Color:")
EdP2Col := Main.Add("Edit", "x+10 yp-3 w80", "888888")
BtnP2Col := Main.Add("Button", "x+5 yp w30 h24", "...")

ToggleProg1(ctrl, *) {
    s := ChkProg1.Value
    EdP1Val.Enabled := s, EdP1Text.Enabled := s, EdP1Sub.Enabled := s, EdP1Col.Enabled := s, BtnP1Col.Enabled := s
}
ChkProg1.OnEvent("Click", ToggleProg1)
ToggleProg1(0)

ToggleProg2(ctrl, *) {
    s := ChkProg2.Value
    EdP2Val.Enabled := s, EdP2Text.Enabled := s, EdP2Sub.Enabled := s, EdP2Col.Enabled := s, BtnP2Col.Enabled := s
}
ChkProg2.OnEvent("Click", ToggleProg2)
ToggleProg2(0)

; --- TAB 4: STYLING ---
Tabs.UseTab(4)
Main.Add("Text", "x20 y55", "Quick Theme Presets:")
DDLTheme := Main.Add("DropDownList", "x150 y52 w200", ["Default (Dark)", "Windows Light", "Warning (Yellow)", "Critical (Red)"])
DDLTheme.OnEvent("Change", ApplyTheme)


Main.Add("GroupBox", "x20 y+20 w630 h100", "Surface && Text Colors")
ColorEdits := Map()
C_Surf := [
    {label: "Background:", prop: "background", def: "1A1A1A"},
    {label: "Background Alt:", prop: "backgroundAlt", def: "0E0E0E"},
    {label: "Main Font:", prop: "fontColor", def: "FFFFFF"},
    {label: "Title Color:", prop: "titleColor", def: "FFFFFF"},
    {label: "Titlebar BG:", prop: "titlebarBG", def: "0E0E0E"},
    {label: "Detail Border:", prop: "detailBorder", def: "333333"}
]

Main.Add("GroupBox", "x20 y+30 w630 h100", "Interactive && UI Elements")
C_Inter := [
    {label: "Icon Primary:", prop: "iconColor", def: "FF4C4C"},
    {label: "Btn Hover:", prop: "buttonHoverColor", def: "333333"},
    {label: "Exit (X) Color:", prop: "exitColor", def: "FF8080"},
    {label: "Exit BG:", prop: "exitBG", def: "250D0D"},
    {label: "Exit BG Hover:", prop: "exitBGHover", def: "701C1C"}
]

; Loop to create color inputs
CreateColorGrid(items, startX, startY) {
    curX := startX, curY := startY
    for i, item in items {
        Main.Add("Text", "x" curX " y" curY+3 " w90 Right", item.label)
        ed := Main.Add("Edit", "x" curX+95 " y" curY " w65", item.def)
        ColorEdits[item.prop] := ed
        Main.Add("Button", "x" curX+165 " y" curY " w25 h24", "...").OnEvent("Click", PickColor.Bind(ed))
        
        if (Mod(i, 3) == 0) {
            curX := startX
            curY += 35
        } else {
            curX += 200
        }
    }
}
CreateColorGrid(C_Surf, 40, 115)
CreateColorGrid(C_Inter, 40, 265)


; --- TAB 5: BEHAVIOR ---
Tabs.UseTab(5)
Main.Add("GroupBox", "x20 y50 w" . tw . " h110", "System Behavior")
Main.Add("Text", "xp+20 yp+30", "Wait for Response:")
DDLWait := Main.Add("DropDownList", "x+10 yp-3 w100", ["True", "False"])
DDLWait.Text := "True"
Main.Add("Text", "x+10 yp+3 c6b6b6b", "(False returns HWND immediately)")

exitEnb := Main.Add("Checkbox", "x40 y+20 vExitEnabled Checked", "Exit (X) Button Enabled")
Main.Add("Text", "x+20 yp", "X-Btn Size:")
exBtnSize := Main.Add("Edit", "x+5 yp-3 w50 Number", "40")
exitEnb.OnEvent("Click", (*) => exBtnSize.Enabled := exitEnb.Value)

Main.Add("GroupBox", "x20 y+30 w" . tw . " h110", "Window Interaction")
modChk := Main.Add("Checkbox", "xp+20 yp+30 vModal Checked", "Modal Window (Lock Parent)")
Main.Add("Checkbox", "x+20 yp vAlwaysOnTop", "Always On Top")
Main.Add("Checkbox", "x40 y+15 vNoAltF4", "Disable Alt+F4")

Main.Add("GroupBox", "x20 y+20 w" . tw . " h80", "Audio")
popSoun := Main.Add("Checkbox", "xp+20 yp+30 vPopupSound Checked", "System Sound")
altPopSoun := Main.Add("Checkbox", "x+20 yp vPopupAlt", "Use 'Asterisk' vs 'Exclamation'")
popSoun.OnEvent("Click", (*) => altPopSoun.Enabled := popSoun.Value)

waitCh(){
    ;if ()
        modChk.Value := DDLWait.Text!="False"
    ;else
    modChk.Enabled := DDLWait.Text == "True"
}
DDLWait.OnEvent("Change", (*) => waitCh())

; --- TAB 7: EXPORT ---
Tabs.UseTab(6)
Main.Add("Text", "x20 y55", "Generated Script Code:")
EdCodeGen := Main.Add("Edit", "x20 y75 w630 h280 ReadOnly", "Click 'Refresh Code' to generate...")
BtnRefresh := Main.Add("Button", "x20 y370 w150 h40", "Refresh Code")
BtnRefresh.OnEvent("Click", (*) => GenerateCode())
BtnSave := Main.Add("Button", "x180 y370 w150 h40", "Save as .ahk")
BtnSave.OnEvent("Click", SaveToFile)

; --- BOTTOM BUTTONS ---
Tabs.UseTab()
BtnPreview := Main.Add("Button", "x20 y450 w200 h40 Default", "Live Preview")
BtnPreview.OnEvent("Click", RunPreview)

resultChk := Main.Add("Checkbox", "x240 y450 w200 h40 Checked", "Show Result")


Main.OnEvent("Close", (*) => ExitApp())
Main.Show()

; --- LOGIC FUNCTIONS ---

PickColor(editCtrl, *) {
    initial := "0x" . editCtrl.Value
    if (initial == "0x") initial := "0xFFFFFF"
    
    ; Setup CHOOSECOLOR struct
    structSize := A_PtrSize * 9
    cc := Buffer(structSize, 0)
    NumPut("UInt", structSize, cc, 0)
    NumPut("Ptr", Main.Hwnd, cc, A_PtrSize)
    
    ; Custom colors (persistent for this session)
    static customColors := Buffer(64, 0)
    NumPut("Ptr", customColors.Ptr, cc, A_PtrSize * 4)
    
    ; Convert Hex (RRGGBB) to BGR for Windows, default to white
    try{
        r := "0x" . SubStr(editCtrl.Value, 1, 2)
        g := "0x" . SubStr(editCtrl.Value, 3, 2)
        b := "0x" . SubStr(editCtrl.Value, 5, 2)
        bgr := (b << 16) | (g << 8) | r
    } catch {
        bgr := (0xFF << 16) | (0xFF << 8) | 0xFF
    }
        
        NumPut("UInt", bgr, cc, A_PtrSize * 3)
        NumPut("UInt", 0x1 | 0x2, cc, A_PtrSize * 5) ; CC_RGBINIT | CC_FULLOPEN
    
    if DllCall("comdlg32\ChooseColor", "Ptr", cc.Ptr) {
        color := NumGet(cc, A_PtrSize * 3, "UInt")
        ; Convert BGR back to Hex RRGGBB
        hex := Format("{1:02X}{2:02X}{3:02X}", color & 0xFF, (color >> 8) & 0xFF, (color >> 16) & 0xFF)
        editCtrl.Value := hex
    }
}

ApplyTheme(ctrl, *) {
    if !Presets.Has(ctrl.Text)
        return
    theme := Presets[ctrl.Text]
    ; Use .OwnProps() to iterate over standard object properties in AHK v2
    for prop, val in theme.OwnProps() {
        if ColorEdits.Has(prop)
            ColorEdits[prop].Value := val
    }
}

GetConfig() {
    config := {}
    config.width := Integer(EdWidth.Value)
    config.height := Integer(EdHeight.Value)
    config.win11Radius := Integer(SubStr(EdW11Rad.Value, 1, 1))
    config.legacyRadius := Integer(EdLegRad.Value)
    config.forceLegacyRadius := ChkForceLeg.Value
    config.align := DDLAlign.Text
    config.messageTop := Integer(EdMsgTop.Value)
    config.title := EdTitle.Value
    config.message := EdMsg.Value ;StrReplace(EdMsg.Value,"`n", "``n")
    config.detail := EdDetail.Value ;StrReplace(EdDetail.Value,"`n", "``n")
    config.detailRows := Integer(EdDetRows.Value)
    config.icon := EdIcon.Value
    
    if ChkHasInput.Value {
        config.input := EdInputDef.Value != "" ? EdInputDef.Value : true
        config.placeholder := EdPlaceholder.Value
        config.maskInput := ChkMaskInput.Value
    }

    if ChkProg1.Value {
        config.progress := Integer(EdP1Val.Value)
        config.progressText := EdP1Text.Value
        config.progressSubText := EdP1Sub.Value
        config.progressColor := EdP1Col.Value
    }
    if ChkProg2.Value {
        config.progress2 := Integer(EdP2Val.Value)
        config.progress2Text := EdP2Text.Value
        config.progress2SubText := EdP2Sub.Value
        config.progress2Color := EdP2Col.Value
    }

    for prop, ctrl in ColorEdits {
        if ctrl.Value != ""
            config.%prop% := ctrl.Value
    }

    btns := StrSplit(EdBtnList.Value, ",")
    config.buttons := []
    for b in btns
        config.buttons.Push(Trim(b))
    
    config.btn_w := Integer(EdBtnW.Value)
    config.btn_h := Integer(EdBtnH.Value)
    config.btn_margin := Integer(EdBtnM.Value)

    settings := Main.Submit(false)
    config.exitEnabled := settings.ExitEnabled
    config.exitWidth := Integer(exBtnSize.Value)

    config.popupSound := settings.PopupSound
    config.popupAltSound := settings.PopupAlt
    config.alwaysOnTop := settings.AlwaysOnTop
    config.modal := settings.Modal
    config.noAltF4 := settings.NoAltF4
    
    if (DDLWait.Text != "Auto")
        config.waitForResponse := DDLWait.Text == "True"

    return config
}

;;StrReplace(val,"`n", "``n")


GenerateCode(*) {
    cfg := GetConfig()
    code := "#Requires AutoHotkey v2.0`n#Include customdialog.ahk`n`n"
    code .= "result := customDialog({`n"
    props := []
    for prop, val in cfg.OwnProps() {
        formattedVal := (Type(val) == "String") ? '"' . StrReplace(val,"`n", "``n") . '"' : (Type(val) == "Array") ? '["' . StrJoin(val, '", "') . '"]' : (val = true ? "true" : (val = false ? "false" : val))
        props.Push("    " . prop . ": " . formattedVal)
    }
    code .= StrJoin(props, ",`n") . "`n})`n"
    EdCodeGen.Value := code
    Tabs.Value := 6
    return code
}

StrJoin(arr, sep) {
    str := ""
    for i, v in arr
        str .= v . (i < arr.Length ? sep : "")
    return str
}

SaveToFile(*) {
    code := GenerateCode()
    path := FileSelect("S16", "dialog_call.ahk", "Save", "AHK Script (*.ahk)")
    if path {
        if FileExist(path) FileDelete(path)
        FileAppend(code, path)
    }
}

RunPreview(*) {
    cfg := GetConfig()
    ;Main.Opt("+Disabled") ; Disable the main window to simulate a modal call properly
    try {
        result := customDialog(cfg)

        if resultChk.Value && DDLWait.Text == "True"
            MsgBox "Clicked: '" result.value "'" (ChkHasInput.Value ?"`nInput Value: '" result.input "'" : ""),"Preview Dialog Result"
        else if resultChk.Value && DDLWait.Text == "False"
            MsgBox "Popup Hwnd: " result.gui.Hwnd
    } catch Error as e {
        MsgBox("Preview Error: " e.Message)
    } finally {
        ; Re-enable main interface even if customDialog crashed
        ;Main.Opt("-Disabled")
        try WinSetEnabled(true, Main.Hwnd)
        Main.Show()
    }
}

isGUI := true

; ==============================================================================
; CORE LIBRARY FUNCTION (Optimized for Canvas/Closure use)
; ==============================================================================
#Include customDialog.ahk