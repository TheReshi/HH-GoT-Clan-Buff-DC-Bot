#SingleInstance, Force
#Include, ahk\Resources.ahk
SetWorkingDir, %A_ScriptDir%
SendMode, Event
;SetKeyDelay, %keyDelay%, %pressDuration%
SetMouseDelay, %mouseDelay%
SetDefaultMouseSpeed, 0
CoordMode, Mouse, Client
CoordMode, Pixel, Client

PgUp::
Run .\buffbot.py
Sleep, 10000
CheckBuffNeeded()

PgDn::
WinClose, C:\Windows\py.exe
Reload
return