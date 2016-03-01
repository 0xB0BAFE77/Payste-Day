;Payste Day 2 Script
;AHK v1.1.23.01
;Written by 0xB0BAFE77 (Greg G.)
;Made 2016-02-29
;v1.3

;============================== Start Auto-Execution Section ==============================

; Keeps script permanently running
#Persistent

; Avoids checking empty variables to see if they are environment variables.
; Recommended for performance and compatibility with future AutoHotkey releases.
#NoEnv

; Ensures that there is only a single instance of this script running.
#SingleInstance, Force

; Makes a script unconditionally use its own folder as its working directory.
; Ensures a consistent starting directory.
SetWorkingDir %A_ScriptDir%

; sets title matching to search for "containing" isntead of "exact"
SetTitleMatchMode, 2

; sets the key send input type. Event is used to make use of KeyDelay.
SendMode, Event

; Sets delay between key strokes and how long a key should be pressed.
; SetKeyDelay KeyStrokeDelay, 
SetKeyDelay 15, 10

return

;============================== Payday 2 ==============================
#IfWinActive, ahk_exe payday2_win32_release.exe

;Custom paste function for Payday 2 since pasting isn't recognized natively.
;Ctrl+V pastes text into payday chat box.
^v::
	;Backup whatever is on the clipboard to var
	clipSave	:= ClipboardAll
	;Call paste function
	paydayPaste(Clipboard)
	;Returns original content to clipboard.
	Clipboard	:= clipSave
	;Clears clipSave variable. 
	clipSave	:= ""
	return


;Paste function. cb = clipboard
paydayPaste(cb)
{
	;Replaces carriage returns/line feeds with {Enter} tag
	;This ensures a line break.
	StringReplace, cb, cb, `r`n, %A_Space%{Enter}%A_Space%, all	
	
	;Removes formatting
	cb := cb

	;Payday 2's chat box can only accept a maximum of 78 characters
	charLeft	:= 78

	;Breaks clipboard text into substrings. Uses spaces as a delimiter.
	Loop, parse, cb, %A_Space%
	{
		;Gets the length of the substring plus 1 for the space added later.
		subStrLength := StrLen(A_LoopField) + 1
		
		;Checks to make sure the substring doesn't exceed the amount
		;of characters left
		if (subStrLength < charLeft)
		{
			;Used to put in line breaks where carriage returns were earlier
			if (A_LoopField = "{Enter}")
			{
				Send, {Enter}
				
				;Reset charLeft due to new line
				charLeft := 78
				continue
			}
			
			;Send next field along with a space at the end.
			SendInput, %A_LoopField%{Space}
			Sleep, 25
			
			;Update remaining characters left
			charLeft -= subStrLength
		}
		else
		{
			;Send final substring
			SendInput, %A_LoopField%{Space}
			Sleep, 75
			Send, {Enter}
			
			;reset and clear result
			charLeft	:= 78
			result		:= ""
		}
	}
	SendInput, %A_LoopField%{Space}
	Sleep, 75
	Send, {Enter}
	charLeft	:= 78
	result		:= ""
}
return

#IfWinActive

;============================== End Script ==============================