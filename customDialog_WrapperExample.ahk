
;- FOR ACCEPTING MAP OBJECTS
;- (EG JSON CONVERTED FROM A CALL FROM A WEBVIEW2 OBJECT)


;#Include <customDialog>
;#Include <JSON> ; @author thqby, HotKeyIt * @date 2024/02/24 * @version 1.0.7
;#Include <webView2> ; @ thqby * @date 2025/01/09 * @version 2.0.4


;- SETUP DIALOG TYPES WITHIN THE AHK2 CODE (OR FORM IT ALL AS A JS OBJ)
customDialogTypes := {
    saveError : {
        titlebarBG: "290909",
        iconColor: "c51f09",
        exitBG: "410606",
        buttonColor: "DDDDDD",
        messageColor: "CCCCCC",
        detailColor: "AAAAAA",
        icon: "⛔",
        title: "Save Failed",
        height: 215,
        detailRows: 3,
        width: 400,
        popupAltSound: true,
        buttons: ["&Close"],
        message:"Save stopped! Application breaking changes found!\nPlease fix the following error(s) before saving:",
    }
}


;- FORWARD CALLS
FN_customDialog(detailsStr:="{}",defaults:=""){
    details := JSON.parse(detailsStr)
    defaults := defaults ? defaults : {}

    return customDialog({
        width: details.Has("width") ? details["width"] : "",
        height: details.Has("height") ? details["height"] : "",

        forceLegacyRadius: details.Has("forceLegacyRadius") ? details["forceLegacyRadius"] : "",
        win11Radius: details.Has("win11Radius") ? details["win11Radius"] : "",
        legacyRadius: details.Has("legacyRadius") ? details["legacyRadius"] : "",

        background: details.Has("background") ? details["background"] : "",
        backgroundAlt: details.Has("backgroundAlt") ? details["backgroundAlt"] : "",
        fontColor: details.Has("fontColor") ? details["fontColor"] : "",
        detailBorder: details.Has("detailBorder") ? details["detailBorder"] : "",

        title: details.Has("title") ? details["title"] : "",
        titleColor: details.Has("titleColor") ? details["titleColor"] : "",
        titlebarHeight: details.Has("titlebarHeight") ? details["titlebarHeight"] : "",
        titlebarBG: details.Has("titlebarBG") ? details["titlebarBG"] : "",

        message: details.Has("message") ? details["message"] : "",
        messageColor: details.Has("messageColor") ? details["messageColor"] : "",
        align: details.Has("align") ? details["align"] : "",
        messageTop: details.Has("messageTop") ? details["messageTop"] : "",

        detail: details.Has("detail") ? details["detail"] : "",
        detailColor: details.Has("detailColor") ? details["detailColor"] : "",
        detailRows: details.Has("detailRows") ? details["detailRows"] : "",

        icon: details.Has("icon") ? details["icon"] : "",
        iconColor: details.Has("iconColor") ? details["iconColor"] : "",

        buttons: details.Has("buttons") ? details["buttons"] : "",
        buttonColor: details.Has("buttonColor") ? details["buttonColor"] : "",

        exitEnabled: details.Has("exitEnabled") ? details["exitEnabled"] : "",
        exitWidth: details.Has("exitWidth") ? details["exitWidth"] : "",
        exitBG: details.Has("exitBG") ? details["exitBG"] : "",
        exitColor: details.Has("exitColor") ? details["exitColor"] : "",

        popupSound: details.Has("popupSound") ? details["popupSound"] : "",
        popupAltSound: details.Has("popupAltSound") ? details["popupAltSound"] : "",

        ownerHwnd: details.Has("ownerHwnd") ? details["ownerHwnd"] : "",
        waitForResponse: details.Has("waitForResponse") ? details["waitForResponse"] : "",
        alwaysOnTop: details.Has("alwaysOnTop") ? details["alwaysOnTop"] : "",
        forceParent: details.Has("forceParent") ? details["forceParent"] : "",
        noAltF4: details.Has("noAltF4") ? details["noAltF4"] : "",
    },defaults)
}



;- IN AHK SETUP DIAGLOG TYPES, ADD CUSTOM CALLS TO THE BROWSER
/*
    customDialogTypes := {
        saveError : {
            titlebarBG: "290909",
            iconColor: "c51f09",
            exitBG: "410606",
            buttonColor: "DDDDDD",
            messageColor: "CCCCCC",
            detailColor: "AAAAAA",
            icon: "⛔",
            title: "Save Failed",
            height: 215,
            detailRows: 3,
            width: 400,
            popupAltSound: true,
            buttons: ["&Close"],
            message:"Save stopped! Application breaking changes found!`nPlease fix the following error(s) before saving:",
        }
    }
    webview2Instance.AddHostObjectToScript('customDialog', FN_customDialog)
    webview2Instance.AddHostObjectToScript('customDialogTypes', customDialogTypes)
*/


;- IN JS: AN EXAMPLE WRAPPER
/*

    const customDialog = async (details={}, defaults="") => {
        var isValidDefault = false;
        if (defaults) {
            try {
                await ahk.customDialogTypes[defaults].random;
                isValidDefault = true;
            } catch (e) {
                console.error("Invalid dialog type!\n\n", new Error("'" + defaults + "'\n"))
            }
        }
        return await ahk.customDialog(JSON.stringify(details), isValidDefault ? await ahk.customDialogTypes[defaults] : "").then(async x => await x.value)
    }
*/

;- IN JS: AN EXAMPLE CALL
;- (console log output should be the result of the dialog, eg button text, or blank if cancelled)
/*
    (async ()=>{
        console.log(
            await customDialog({
                detail: "SyntaxError: Unexpected token '-'",
                height: 240,
                detailRows: 4,
                width: 400,
            },"saveError")
        )
    })()
*/