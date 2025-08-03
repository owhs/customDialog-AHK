#Requires AutoHotkey v2.0
#Include customDialog.ahk

examples() {

    ; --- Template Dialog Types (Presets) ---
    ; By defining these "defaults" objects, we can create consistent dialog styles
    ; and call them with much less code.

    darkPreset := {
        background: "1A1A1A",
        backgroundAlt: "0e0e0e",
        fontColor: "FFFFFF",
        detailBorder: "333333",
        titlebarBG: "0e0e0e"
    }

    errorPreset := {
        icon: "⚠️",
        width: 400,
        background: "4e1515",
        backgroundAlt: "5a0c0c",
        titlebarBG: "290909",
        fontColor: "ff8585",
        iconColor: "ffa600",
        detailBorder: "750404",
        exitBG: "410606",
        popupAltSound: true
    }

    criticalErrorDetailPreset := {
        icon: "⚠️",
        width: 400,
        background: "4e1515",
        backgroundAlt: "5a0c0c",
        titlebarBG: "290909",
        fontColor: "ff8585",
        iconColor: "ffa600",
        detailBorder: "750404",
        exitBG: "410606",
        popupAltSound: true,
        icon: "🚫",
        title: "Critical Error",
        height: 400,
        detailRows: 14,
        width: 600,
        buttons: ["&Close"],
    }

    successPreset := {
        icon: "✅",
        width: 400,
        messageTop: 9,
        background: "044d25",
        backgroundAlt: "0c2b0a",
        titlebarBG: "0d1f0c",
        fontColor: "9ceeab",
        iconColor: "37ff58",
        detailBorder: "1f681a",
        buttonColor: "d2ffb4",
        exitColor: "ffabab",
        exitBG: "331111",
        align: "Center"
    }

    confirmPreset := {
        icon: "❓",
        align: "Center",
        messageTop: 9,
        iconColor: "66A3FF",
        width: 430,
        buttons: ["&Yes", "&No"]
    }

    lightPreset := {
        align: "Center",
        background: "b9b9b9",
        backgroundAlt: "988fcc",
        titlebarBG: "5d539b",
        titleColor: "FFFFFF",
        detailBorder: "635a97",
        fontColor: "1f1f1f",
        exitEnabled: false,
        btn_w: 200,
        iconColor: "000000",
        button: "&Ok",
        width: 300
    }

    ; --- Using the Presets ---

    ; Example 1: A themed success dialog.
    customDialog({
        title: "Success",
        message: "The operation completed successfully."
    }, successPreset)

    ; Example 2: A themed error dialog, overriding some preset properties for a more complex layout.
    customDialog({
        message: "There was a critical error found before saving!`nThe following error was found in the board file:",
        detail: "MESSAGE: 0x0000000`n`nThis is a very long error message that will definitely wrap around to`nmultiple lines`n`n`nto test the selection functionality and ensure`n that it works`ncorrectly `nacross all visible text within the control's boundaries.`n`n`n`n`n`n`n`n`n`n`n`n`n`n`nSecret Message",
    }, criticalErrorDetailPreset)

    ; Example 3: A confirmation dialog.
    customDialog({
        title: "Confirmation",
        message: "Are you sure you want to proceed with this action?"
    }, confirmPreset)

    ; Example 4: A light-themed save confirmation.
    customDialog({
        title: "Woah There!",
        message: "You shouldn't be able to close this using Alt+F4!",
        icon: "✋",
        noAltF4: true,
    }, lightPreset)

    ; Example 5: A dark-themed dialog using the default dark preset.
    customDialog({
        icon: "💾",
        align: "Center",
        exitEnabled: false,
        messageTop: 5,
        title: "File Saved",
        iconColor: "17ee34",
        button: "&Ok",
        width: 300,
        message: "The operation completed successfully."
    }, darkPreset)
}

examples()
ExitApp
