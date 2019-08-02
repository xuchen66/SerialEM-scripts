;; AutoIT script to wait for SerialEM Message Windows popping up.
;; Based on the message text content, it runs different functions,
;; to get shutter state and aperture conbination ready.
;; SerialEM script two lines for each action is below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;SetupScopeMessage 0 0 K2-shutter
;ShowMessageOnScope SEM

;SetupScopeMessage 0 0 C2_150-OBJ_out
;ShowMessageOnScope SEM

;SetupScopeMessage 0 0 C2_70-OBJ_70
;ShowMessageOnScope SEM

;SetupScopeMessage 0 0 C2_50-OBJ_70
;ShowMessageOnScope SEM

;SetupScopeMessage 0 0 C2_50-OBJ_100
;ShowMessageOnScope SEM

;SetupScopeMessage 0 0 Turbo_ON
;ShowMessageOnScope SEM

;SetupScopeMessage 0 0 Turbo_OFF
;ShowMessageOnScope SEM

; etc...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -Chen Xu <chen.xu@umassmed.edu> Jan-29-2017
;; updated @ April 18, 2019
#include <MsgBoxConstants.au3>

; Set the Escape hotkey to terminate the script.
HotKeySet("{ESC}", "Terminate");

; make sure the "Camera" tab is at fromt
;MouseClick("primary",210,36,10)        ;make sure to very left
;MouseClick("primary",227,40,2)     ;come back twice, so "camera" is there
;MouseClick("primary",118,41,1)     ;click on the camera

; C2 = 150, 70, 50, 30
; Obj = 70, 100, Ph P1, Ph P2, Ph P3, Ph P4, Ph p5, Ph P6

Main()

Func Main()

    While 1
    WinWait("[TITLE:SEM; CLASS:#32770]")
If WinExists("[TITLE:SEM; CLASS:#32770]") Then
    WinActivate ("[TITLE:SEM; CLASS:#32770]")
    Local $sText = WinGetText("[ACTIVE]")
EndIf

If StringInStr($sText,"C2_150-OBJ_out") Then
    Call("C2", "150")
    Call("OBJ_out")
	Call ("Dismiss")
    Sleep(5000)
Elseif StringInStr($sText,"C2_70-OBJ_100") Then
    Call("C2","70")
    Call("OBJ","100")
	Call ("Dismiss")
    Sleep(5000)
Elseif StringInStr($sText,"C2_50-OBJ_100") Then
    Call("C2","50")
    Call("OBJ","100")
	Call ("Dismiss")
    Sleep(5000)
Elseif StringInStr($sText,"C2_30-OBJ_100") Then
    Call("C2","30")
    Call("OBJ","100")
	Call ("Dismiss")
    Sleep(5000)
Elseif StringInStr($sText,"C2_70-OBJ_70") Then
    Call("C2","70")
    Call("OBJ","70")
	Call ("Dismiss")
    Sleep(5000)
Elseif StringInStr($sText,"C2_50-OBJ_70") Then
    Call("C2","50")
    Call("OBJ","70")
	Call ("Dismiss")
    Sleep(5000)
Elseif StringInStr($sText,"C2_30-OBJ_70") Then
    Call("C2","30")
    Call("OBJ","70")
	Call ("Dismiss")
    Sleep(5000)
ElseIf StringInStr($sText,"K2-shutter") Then
    Call ("K2_shutter")
	Call ("Dismiss")
    Sleep (5000)
ElseIf StringInStr($sText,"Turbo_ON") Then
    Call ("Turbo_ON")
	Call ("Dismiss")
    Sleep (5000)
ElseIf StringInStr($sText,"Turbo_OFF") Then
    Call ("Turbo_OFF")
	Call ("Dismiss")
    Sleep (5000)
EndIf
     Sleep (500)
     WEnd
EndFunc


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func C2($C2)
    WinActivate ("[TITLE:Apertures; CLASS:#32770; W:243; H:225]")
    ControlCommand ("Apertures", "", "[CLASS:ComboBox; INSTANCE:1]", "ShowDropDown", "")
    ControlCommand ("Apertures", "", "[CLASS:ComboBox; INSTANCE:1]", "SelectString", $C2)
    ControlSend ("Apertures", "","ComboBox1", "{ENTER}")
    Sleep (6000)
EndFunc     ;==>C2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func OBJ($OBJ)
    WinActivate ("[TITLE:Apertures; CLASS:#32770; W:243; H:225]")
    ControlCommand ("Apertures", "", "[CLASS:ComboBox; INSTANCE:2]", "ShowDropDown", "")
    ControlCommand ("Apertures", "", "[CLASS:ComboBox; INSTANCE:2]", "SelectString", $OBJ)
    ControlSend ("Apertures", "","ComboBox2", "{ENTER}")
    Sleep (6000)
EndFunc     ;==>OBJ

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func OBJ_out()
	MouseClick("primary",210,36,10)        ;make sure to very left
	MouseClick("primary",227,40,2)     ;come back twice, so "camera" is there
	MouseClick("primary",118,41,1)     ;click on the camera
	Sleep(2000)							; must have this
    If pixelgetcolor(25,381) = 0xFFFF80 Then ; 0xFFFF80 -> Yellow
		ControlClick("Aperture", "", "[CLASS:Button; INSTANCE:2]")
        Sleep(2000)
    Else
        Sleep (1)
    Endif
EndFunc     ;==>OBJ_out


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func K2_shutter()
; select fake K2 camera
ControlCommand("CCD/TV Camera", "", "[CLASS:ComboBox; INSTANCE:1]", "SelectString", "BM-Falcon")
Sleep(3000)     ; needed

; make sure the Insert is "yellow"
If pixelgetcolor(48,270) = 0xD4D0C8 Then
    ;Sleep (1000)
    ;MsgBox(0, "Not Yellow, Click!", "","")
    WinActivate ("CCD/TV Camera", "[CLASS:#32770]")
    ControlClick("CCD/TV Camera", "", "[CLASS:Button; INSTANCE:4]")
    ControlClick("CCD/TV Camera", "", "[CLASS:Button; INSTANCE:4]")
    Sleep (3000)    ;needed
Else
    Sleep (4000)
EndIf

EndFunc     ;==>K2_shutter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func Turbo_ON()
 WinWait("[TITLE:SEM; CLASS:#32770]")
 If WinExists("[TITLE:SEM; CLASS:#32770]") Then
     WinActivate ("Autoloader (User)", "[CLASS:#32770]")
ControlClick("Autoloader (User)", "", "[CLASS:Button; INSTANCE:12]")
ControlClick("SEM", "", "[CLASS:Button; INSTANCE:1]")
 EndIf
 EndFunc    ;==>Turbo_ON

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func Turbo_OFF()
 WinWait("[TITLE:SEM; CLASS:#32770]")
 If WinExists("[TITLE:SEM; CLASS:#32770]") Then
     WinActivate ("Autoloader (User)", "[CLASS:#32770]")
ControlClick("Autoloader (User)", "", "[CLASS:Button; INSTANCE:11]")
ControlClick("SEM", "", "[CLASS:Button; INSTANCE:1]")
 EndIf
EndFunc    ;==>Turbo_OFF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func Dismiss()
    ; dismiss SerialEM message window
WinActivate ("[TITLE:SEM; CLASS:#32770]")
ControlClick("SEM", "", "[CLASS:Button; INSTANCE:1]")
EndFunc     ;==>Dismiss

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func Terminate()
    Exit
EndFunc     ;==>Terminate
