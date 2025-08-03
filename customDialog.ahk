#Requires AutoHotkey v2.0

/*
 !             NAME  :   customDialog
 !           AUTHOR  :   OWHS
 !          VERSION  :   0.9
 !      DESCRIPTION  :       
 :                       Creates a highly customizable, non-native GUI dialog box.
 :                       This function allows for extensive control over appearance, layout, and behavior,
 :                       making it a versatile replacement for standard message boxes.
 :                       It returns an object containing the user's choice and the GUI object itself.
*/

/**
 *
 * @param {Object} info An object containing properties to configure the dialog.
 * @param {Object} defaults An optional object with default properties. This allows you to define "presets"
 * and then override specific properties with the `info` object for cleaner calls.
 *
 * --------------------------------
 * ----- SETUP PROPERTIES -----
 * --------------------------------
 * 
 * -----------------------
 * -- Window & Layout --
 * -----------------------
 * -----------------------
 * 
 * @property {Integer} width            - The total width of the dialog window in pixels. Default: 600.
 * @property {Integer} height           - A fixed height for the dialog. If 0 or omitted, height is calculated automatically based on content. Default: 0.
 * @property {Boolean} forceLegacyRadius- If true, forces the use of legacy (GDI) rounded corners even on Windows 11. Default: false.
 * @property {Integer} win11Radius      - The corner roundness value for Windows 11's DWM attribute. Default: 3.
 * @property {Integer} legacyRadius     - The corner roundness for legacy windows (GDI region). Default: 5.
 * @property {String}  align            - Alignment for the main message text. Can be "Left", "Center", or "Right". Default: "" (Left).
 * @property {Integer} messageTop       - Adds extra vertical padding (in pixels) above the main message text. Default: 0.
 *
 * -----------------------
 * -- Content & Text --
 * -----------------------
 * -----------------------
 * 
 * @property {String}  title            - The text displayed in the dialog's title bar. Default: "Alert".
 * @property {String}  message          - The main message/text content of the dialog. Default: "Message".
 * @property {String}  detail           - Optional supplementary text displayed in a read-only, scrollable box. Default: "".
 * @property {Integer} detailRows       - The number of visible text rows for the `detail` box. Default: 9.
 * @property {String}  icon             - A single character/emoji to display as an icon to the left of the message. Default: "".
 *
 * -----------------------
 * -- Buttons --
 * -----------------------
 * -----------------------
 * @property {Array}   buttons          - An array of strings for the button labels (e.g., ["&Yes", "&No", "&Cancel"]). The '&' creates a keyboard shortcut. Default: ["&OK"].
 * @property {String}  button           - A shorthand property to create a single button. Overridden by `buttons` if both are present.
 * @property {Integer} btn_w            - The width of each button in pixels. Default: 80.
 * @property {Integer} btn_h            - The height of each button in pixels. Default: 30.
 * @property {Integer} btn_margin       - The horizontal margin between buttons in pixels. Default: 10.
 *
 * -----------------------
 * -- Color Properties --
 * -----------------------
 * - (Accepts 6-digit hex strings, e.g., "RRGGBB")
 * -----------------------
 * 
 * @property {String}  background       - The main background color of the dialog. Default: "1A1A1A".
 * @property {String}  backgroundAlt    - The background color for buttons and the `detail` box. Default: "0e0e0e".
 * @property {String}  fontColor        - The default color for all text elements. Can be overridden by specific color properties. Default: "FFFFFF".
 * @property {String}  titleColor       - The color of the `title` text. Inherits `fontColor` if not set.
 * @property {String}  titlebarBG       - The background color of the title bar. Default: "0e0e0e".
 * @property {String}  messageColor     - The color of the `message` text. Inherits `fontColor` if not set.
 * @property {String}  detailColor      - The color of the `detail` text. Inherits `fontColor` if not set.
 * @property {String}  detailBorder     - The color of the border around the `detail` box and buttons. Default: "333333".
 * @property {String}  iconColor        - The color of the `icon` character. Default: "FF4C4C".
 * @property {String}  buttonColor      - The color of the button text. Inherits `fontColor` if not set.
 * @property {String}  exitColor        - The color of the 'x' close button text. Inherits `fontColor` if not set.
 * @property {String}  exitBG           - The background color of the 'x' close button. Default: "250d0d".
 *
 * -----------------------
 * -- Behavior & Functionality --
 * -----------------------
 * -----------------------
 * @property {Boolean} exitEnabled      - If true, displays a custom 'x' button to close the dialog. Default: true.
 * @property {Integer} exitWidth        - The width of the 'x' close button area. Default: 40.
 * @property {Boolean} popupSound       - If true, plays a system sound when the dialog appears. Default: true.
 * @property {Boolean} popupAltSound    - If true, plays the "Asterisk" sound (0x10); if false, plays "Exclamation" (0x30). Default: false (plays 0x30).
 * @property {Integer} ownerHwnd        - The HWND of a window to own this dialog. Makes the dialog modal to its owner. Default: 0.
 * @property {Boolean} forceParent      - If true and `ownerHwnd` is 0, automatically sets the active window as the owner. Default: true.
 * @property {Boolean} waitForResponse  - If true, the script will pause until the dialog is closed. If false, the script continues, and the dialog runs asynchronously. Default: true.
 * @property {Boolean} alwaysOnTop      - If true, the dialog stays on top of other non-topmost windows. Default: true.
 * @property {Boolean} noAltF4          - If true, disables the Alt+F4 hotkey for closing the window. Default: false.
 *
 * -----------------------
 * -- RETURN --
 * -----------------------
 * -----------------------
 * @returns {Object} An object with two properties:
 * - `value`: The text of the button clicked by the user (e.g., "OK", "Cancel"). Returns "" if closed via the 'x' button or Esc.
 * - `gui`: The AHK Gui object. This is useful for advanced manipulation when `waitForResponse` is false.
 */
customDialog(info := {}, defaults := {}) {

    ;#region 0. Initialize Default Properties
    ; This section establishes the base values for every property.
    ; It checks if a property exists in the `defaults` object first, otherwise it uses a hardcoded fallback.
    defaultProperties := {
        width: defaults.HasProp("width") && defaults.width ? defaults.width : 600,
        height: defaults.HasProp("height") && defaults.height ? defaults.height : 0,

        forceLegacyRadius: defaults.HasProp("forceLegacyRadius") && defaults.forceLegacyRadius ? true : false,
        win11Radius: defaults.HasProp("win11Radius") && defaults.win11Radius ? defaults.win11Radius : 3,
        legacyRadius: defaults.HasProp("legacyRadius") && (defaults.legacyRadius || defaults.legacyRadius == 0) ? defaults.legacyRadius : 5,

        background: defaults.HasProp("background") && defaults.background ? defaults.background : "1A1A1A",
        backgroundAlt: defaults.HasProp("backgroundAlt") && (defaults.backgroundAlt || defaults.backgroundAlt == "000000") ? defaults.backgroundAlt : "0e0e0e",
        fontColor: defaults.HasProp("fontColor") && (defaults.fontColor || defaults.fontColor == "000000") ? defaults.fontColor : "FFFFFF",
        detailBorder: defaults.HasProp("detailBorder") && (defaults.detailBorder || defaults.detailBorder == "000000") ? defaults.detailBorder : "333333",

        title: defaults.HasProp("title") && defaults.title ? defaults.title : "Alert",
        titleColor: defaults.HasProp("titleColor") && (defaults.titleColor || defaults.titleColor == "000000") ? defaults.titleColor : "",
        titlebarHeight: defaults.HasProp("titlebarHeight") && defaults.titlebarHeight ? defaults.titlebarHeight : 30,
        titlebarBG: defaults.HasProp("titlebarBG") && defaults.titlebarBG ? defaults.titlebarBG : "0e0e0e",

        message: defaults.HasProp("message") && defaults.message ? defaults.message : "Message",
        messageColor: defaults.HasProp("messageColor") && (defaults.messageColor || defaults.messageColor == "000000") ? defaults.messageColor : "",
        align: defaults.HasProp("align") && defaults.align ? defaults.align : "",
        messageTop: defaults.HasProp("messageTop") && (defaults.messageTop) ? defaults.messageTop : 0,

        detail: defaults.HasProp("detail") && defaults.detail ? defaults.detail : "",
        detailColor: defaults.HasProp("detailColor") && (defaults.detailColor || defaults.detailColor == "000000") ? defaults.detailColor : "",
        detailRows: defaults.HasProp("detailRows") && (defaults.detailRows || defaults.detailRows == 0) ? defaults.detailRows : 9,

        icon: defaults.HasProp("icon") && defaults.icon ? defaults.icon : "",
        iconColor: defaults.HasProp("iconColor") && (defaults.iconColor || defaults.iconColor == "000000") ? defaults.iconColor : "FF4C4C",

        buttons: defaults.HasProp("buttons") && defaults.buttons ? defaults.buttons : ["&OK"],
        buttonColor: defaults.HasProp("buttonColor") && (defaults.buttonColor || defaults.buttonColor == "000000") ? defaults.buttonColor : "",

        exitEnabled: defaults.HasProp("exitEnabled") && defaults.exitEnabled == false ? false : true,
        exitWidth: defaults.HasProp("exitWidth") && defaults.exitWidth ? defaults.exitWidth : 40,
        exitBG: defaults.HasProp("exitBG") && defaults.exitBG ? defaults.exitBG : "250d0d",
        exitColor: defaults.HasProp("exitColor") && (defaults.exitColor || defaults.exitColor == "000000") ? defaults.exitColor : "",

        popupSound: defaults.HasProp("popupSound") && defaults.popupSound == false ? false : true,
        popupAltSound: defaults.HasProp("popupAltSound") && defaults.popupAltSound ? 0x10 : 0x30,

        ownerHwnd: defaults.HasProp("ownerHwnd") && defaults.ownerHwnd ? defaults.ownerHwnd : 0,
        waitForResponse: defaults.HasProp("waitForResponse") && defaults.waitForResponse == false ? false : true,
        alwaysOnTop: defaults.HasProp("alwaysOnTop") && defaults.alwaysOnTop ? true : false,
        forceParent: defaults.HasProp("forceParent") && defaults.forceParent == false ? false : true,
        noAltF4: defaults.HasProp("noAltF4") && defaults.noAltF4 ? true : false,
    }
    ;#endregion

    ;#region 1. Initialize Properties
    ; This section resolves the final properties by checking the `info` object first,
    ; and falling back to the `defaultProperties` map if a property isn't provided.
    width := info.HasProp("width") && info.width ? info.width : defaultProperties.width
    height := info.HasProp("height") && info.height ? info.height : defaultProperties.height
    forceLegacyRadius := info.HasProp("forceLegacyRadius") && info.forceLegacyRadius ? true : defaultProperties.forceLegacyRadius
    win11Radius := info.HasProp("win11Radius") && info.win11Radius ? info.win11Radius : defaultProperties.win11Radius
    legacyRadius := info.HasProp("legacyRadius") && (info.legacyRadius || info.legacyRadius == 0) ? info.legacyRadius : defaultProperties.legacyRadius

    background := info.HasProp("background") && info.background ? info.background : defaultProperties.background
    backgroundAlt := info.HasProp("backgroundAlt") && (info.backgroundAlt || info.backgroundAlt == "000000") ? info.backgroundAlt : defaultProperties.backgroundAlt
    fontColor := info.HasProp("fontColor") && (info.fontColor || info.fontColor == "000000") ? info.fontColor : defaultProperties.fontColor
    detailBorder := info.HasProp("detailBorder") && (info.detailBorder || info.detailBorder == "000000") ? info.detailBorder : defaultProperties.detailBorder

    title := info.HasProp("title") && info.title ? info.title : defaultProperties.title
    titleColor := info.HasProp("titleColor") && (info.titleColor || info.titleColor == "000000") ? info.titleColor : defaultProperties.titleColor ? defaultProperties.titleColor : fontColor
    titlebarHeight := info.HasProp("titlebarHeight") && info.titlebarHeight ? info.titlebarHeight : defaultProperties.titlebarHeight
    titlebarBG := info.HasProp("titlebarBG") && info.titlebarBG ? info.titlebarBG : defaultProperties.titlebarBG

    message := info.HasProp("message") && info.message ? info.message : defaultProperties.message
    messageColor := info.HasProp("messageColor") && (info.messageColor || info.messageColor == "000000") ? info.messageColor : defaultProperties.messageColor ? defaultProperties.messageColor : fontColor
    align := info.HasProp("align") && info.align ? info.align : defaultProperties.align
    messageTop := info.HasProp("messageTop") && (info.messageTop) ? info.messageTop : defaultProperties.messageTop

    detail := info.HasProp("detail") && info.detail ? info.detail : defaultProperties.detail
    detailColor := info.HasProp("detailColor") && (info.detailColor || info.detailColor == "000000") ? info.detailColor : defaultProperties.detailColor ? defaultProperties.detailColor : fontColor
    detailRows := info.HasProp("detailRows") && (info.detailRows || info.detailRows == 0) ? info.detailRows : defaultProperties.detailRows

    icon := info.HasProp("icon") && info.icon ? info.icon : defaultProperties.icon
    iconColor := info.HasProp("iconColor") && (info.iconColor || info.iconColor == "000000") ? info.iconColor : defaultProperties.iconColor

    buttons := info.HasProp("buttons") && info.buttons ? info.buttons : defaultProperties.buttons
    buttonColor := info.HasProp("buttonColor") && (info.buttonColor || info.buttonColor == "000000") ? info.buttonColor : defaultProperties.buttonColor ? defaultProperties.buttonColor : fontColor

    exitEnabled := info.HasProp("exitEnabled") && info.exitEnabled == false ? false : defaultProperties.exitEnabled
    exitWidth := info.HasProp("exitWidth") && info.exitWidth ? info.exitWidth : defaultProperties.exitWidth
    exitBG := info.HasProp("exitBG") && info.exitBG ? info.exitBG : defaultProperties.exitBG
    exitColor := info.HasProp("exitColor") && (info.exitColor || info.exitColor == "000000") ? info.exitColor : defaultProperties.exitColor ? defaultProperties.exitColor : fontColor

    popupSound := info.HasProp("popupSound") && info.popupSound == false ? false : defaultProperties.popupSound
    popupAltSound := info.HasProp("popupAltSound") && info.popupAltSound ? 0x10 : defaultProperties.popupAltSound

    ownerHwnd := info.HasProp("ownerHwnd") && info.ownerHwnd ? info.ownerHwnd : defaultProperties.ownerHwnd
    waitForResponse := info.HasProp("waitForResponse") && info.waitForResponse == false ? false : defaultProperties.waitForResponse
    alwaysOnTop := info.HasProp("alwaysOnTop") && info.alwaysOnTop == false ? false : defaultProperties.alwaysOnTop
    forceParent := info.HasProp("forceParent") && info.forceParent == false ? false : defaultProperties.forceParent
    noAltF4 := info.HasProp("noAltF4") && info.noAltF4 ? true : defaultProperties.noAltF4

    ; Handles the `button` shorthand property for creating a single button.
    if info.HasProp("button") && !info.HasProp("buttons") {
        buttons := [info.button]
    }
    ;#endregion

    ;#region 2. Initialize GUI
    ; Configures and creates the main GUI window object.

    if (popupSound == true) {
        DllCall("user32\MessageBeep", "uint", popupAltSound)
    }

    ; Base GUI options: no caption, tool window style (no taskbar icon), and a system menu.
    guiOptions := (alwaysOnTop == true ? "+AlwaysOnTop " : "") "-Caption +ToolWindow +SysMenu"

    ; Set window ownership to create a modal dialog experience.
    if (forceParent || ownerHwnd != 0) {
        if (ownerHwnd == 0)
            ownerHwnd := WinExist("A") ; Get the active window if no owner is specified.

        if (ownerHwnd && DllCall("IsWindow", "Ptr", ownerHwnd)) {
            try guiOptions .= " +Owner" ownerHwnd
        }
    }

    dlg := Gui(guiOptions, title)
    dlg.BackColor := "0x" background
    dlg.SetFont("s10 c" fontColor, "Segoe UI")
    ;#endregion

    ;#region 3. Build Layout
    ; This section dynamically builds the dialog's content from top to bottom.

    ; Button dimensions
    btn_w := info.HasProp("btn_w") && info.btn_w ? info.btn_w : 80
    btn_h := info.HasProp("btn_h") && info.btn_h ? info.btn_h : 30
    btn_margin := info.HasProp("btn_margin") && info.btn_margin ? info.btn_margin : 10

    dialogReturn := "" ; This will store the clicked button's text upon closing.

    currentY := 0
    dlg.SetFont("s10 c" titleColor, "Segoe UI")

    ; Title Bar (a styled Text control)
    titlebar := dlg.AddText("x0 y0 w" width " h" titlebarHeight " Background" titlebarBG " Center +0x200", title)
    currentY := titlebarHeight + 15 + messageTop ; Set base Y position for content below the title bar.

    ; Custom 'x' close button in the top-right corner.
    if (exitEnabled) {
        dlg.SetFont("s13 c" exitColor, "Segoe UI")
        exitBtn := dlg.AddText("x" width - exitWidth " y0 w" exitWidth " h" titlebarHeight " Background" exitBG " Center +0x200", "x")
        exitBtn.OnEvent("click", ButtonClick.Bind("")) ; Clicking it returns an empty string.
        dlg.SetFont("s10", "Segoe UI") ; Reset font for other controls.
    }

    ; --- Icon and Message Area ---
    iconWidth := icon ? 40 : 0
    iconMargin := icon ? 10 : 0
    contentX := 15 ; Left padding

    ; Add the icon if one is specified.
    if icon {
        dlg.SetFont("s20", "Segoe UI Symbol") ; Use a font that supports emoji/symbols.
        dlg.AddText("x" contentX " y" currentY " w" iconWidth " h40 Center c" iconColor " +0x200", icon)
        contentX += iconWidth + iconMargin ; Indent the message text to make room for the icon.
        dlg.SetFont("s10", "Segoe UI") ; Reset font.
    }

    dlg.SetFont("c" messageColor)
    ; Calculate message width based on alignment and presence of an icon.
    messageW := align = "Center" && icon ? (width - contentX - 65) : (width - contentX - 15)
    messageX := align = "Center" && !icon ? 0 : contentX
    messageW := align = "Center" && !icon ? width : messageW
    currentY += messageTop

    ; Add the main message text. It will auto-size vertically.
    msgCtrl := dlg.AddText("x" messageX " y" currentY " w" messageW " " align, message)
    msgCtrl.GetPos(,,, &msgH) ; Get its rendered height.

    ; Update currentY to be below the taller of the icon or the message text.
    contentHeight := Max(msgH, (icon ? 40 : 0))
    currentY += contentHeight + 15

    ; --- Detail Text Area (if specified) ---
    if detail {
        detailW := width - 30
        detailX := 15

        ; Add a decorative border behind the Edit control. It's added first to appear underneath.
        
        ; The Edit control for the detailed text.
        editCtrl := dlg.AddEdit("x" detailX " y" currentY " w" detailW " r" detailRows " ReadOnly -TabStop -VScroll Background" backgroundAlt " c" detailColor " -E0x200")
        editCtrl.Value := detail
        editCtrl.GetPos(,,, &editH)

        dlg.AddText("x" (detailX - 1) " y" (currentY - 1) " w" (detailW + 2) " h" (editH+2) " Background" detailBorder " -E0x200")

        currentY += editH + 15
    }
    ;#endregion

    ;#region 4. Build Buttons
    ; This section lays out the buttons, centering them horizontally.

    btnY := currentY
    finalHeight := btnY + btn_h + 15 ; Calculate final dialog height based on content.

    ; If a fixed height is specified, override auto-calculation and anchor buttons to the bottom.
    if height > 0 {
        finalHeight := height
        btnY := finalHeight - btn_h - 15
    }

    ; Calculate the starting X position to center the block of buttons.
    totalButtonsWidth := (buttons.Length * btn_w) + ((buttons.Length - 1) * btn_margin)
    currentX := Floor((width - totalButtonsWidth) / 2)
    firstBtnCtrl := ""

    dlg.SetFont("c" buttonColor)
    for i, btnText in buttons {
        returnValue := StrReplace(btnText, "&") ; The return value is the text without the accelerator key marker.

        ; Border (a Text control placed behind the button for a "faux border" effect).
        btnBorder := dlg.AddText("x" (currentX - 1) " y" (btnY - 1) " w" (btn_w + 2) " h" (btn_h + 2) " +Background" detailBorder)

        ; Button (a styled, clickable Text control).
        btnCtrl := dlg.AddText("x" currentX " y" btnY " w" btn_w " h" btn_h " +Tabstop Background" backgroundAlt " Center 0x8000 +0x200", btnText)
        btnCtrl.OnEvent("Click", ButtonClick.Bind(returnValue))

        ; The first button is the default action for the "Enter" key.
        if (i = 1) {
            firstBtnCtrl := btnCtrl ; Save first button to set focus later.
            defaultReturnValue := returnValue
        }

        currentX += btn_w + btn_margin
    }
    ;#endregion

    ;#region 5. Event Functions
    ; These are the callback functions that handle GUI events and hotkeys.

    ; This message handler allows the GUI to be dragged by its custom title bar.
    HandleNCHitTest(wParam, lParam, msg, hwnd) {
        if (hwnd != dlg.Hwnd) {
            return ; Message is not for this GUI.
        }
        lParamY := lParam >> 16
        dlg.GetPos(,&winY)
        ; Check if the cursor is within the title bar's vertical area.
        if (lParamY >= winY && lParamY < winY + (titlebarHeight - 1)) {
            PostMessage(0x00A1, 2) ; WM_NCLBUTTONDOWN, HTCAPTION (tells Windows to treat it as a click on the caption bar).
        }
    }

    ; Central cleanup function to destroy hotkeys, message handlers, and the GUI.
    CleanupAndDestroy(*) {
        Hotkey("Enter", "Off")
        if (exitEnabled == true)
            Hotkey("Escape", "Off")

        if (noAltF4 == true)
            Hotkey("!F4", "Off")

        OnMessage(0x84, HandleNCHitTest, 0) ; Turn off message handler.
        dlg.Destroy()
    }

    ; Handles clicks on any button.
    ButtonClick(returnValue, *) {
        dialogReturn := returnValue
        CleanupAndDestroy()
    }

    ; Handles the Enter key, triggering the first button's action.
    DefaultButtonAction(key) {
        ButtonClick(defaultReturnValue)
    }

    ; Handles the Escape key, simulating a click on the 'x' button.
    ExitButtonAction(key) {
        ButtonClick("")
    }

    ; Register the message handler and GUI events.
    OnMessage(0x84, HandleNCHitTest) ; WM_NCHITTEST for draggable title bar.
    dlg.OnEvent("Close", CleanupAndDestroy) ; Handles closing via system menu, Alt+F4 (if enabled), etc.
    ;#endregion

    ;#region 6. Show & Configure Focused Control
    ; Final steps before the dialog is displayed.

    dlg.Show("w" width " h" finalHeight " Center")
    ; If a detail box exists, its Z-order needs to be managed to appear on top of its border.
    ; Focusing it and then focusing the button seems to be a reliable way to do this.
    if (IsSet(editCtrl) && IsObject(editCtrl)) {
        ControlFocus(editCtrl.Hwnd, dlg.Hwnd)
        ControlFocus(firstBtnCtrl.Hwnd, dlg.Hwnd)
    }
    ;#endregion

    ;#region 7. Catch Keys & Final Borders
    ; Set up context-sensitive hotkeys and apply window border radius.

    HotIfWinActive "ahk_id " dlg.Hwnd
    Hotkey("Enter", DefaultButtonAction)
    if (exitEnabled == true) {
        HotIfWinActive "ahk_id " dlg.Hwnd
        Hotkey("Escape", ExitButtonAction)
    }

    if (noAltF4 == true) {
        HotIfWinActive "ahk_id " dlg.Hwnd
        Hotkey("!F4", (*)=>{}) ; Intercept and do nothing.
    }

    ; Apply border radius. Uses the modern DWM attribute on Win11+ unless forced to use legacy.
    static ver := DllCall("GetVersion", "UInt")
    build := (ver >> 16) & 0xFFFF
    if (build >= 22000 && forceLegacyRadius == false) {
        DllCall("Dwmapi.dll\DwmSetWindowAttribute", "Ptr", dlg.Hwnd, "UInt", 33, "Ptr*", win11Radius, "UInt", 4)
    } else {
        if (legacyRadius > 0) {
            hRgn := DllCall("CreateRoundRectRgn", "Int", 0, "Int", 0, "Int", width, "Int", finalHeight, "Int", legacyRadius, "Int", legacyRadius, "Ptr")
            DllCall("SetWindowRgn", "Ptr", dlg.Hwnd, "Ptr", hRgn, "Int", true)
        }
    }
    ;#endregion

    ;#region 8. Wait for Close & Return
    ; Pauses script execution if required and returns the result.

    if (waitForResponse == true)
        WinWaitClose(dlg.Hwnd)

    return {
        value: dialogReturn,
        gui: dlg
    }
    ;#endregion

}