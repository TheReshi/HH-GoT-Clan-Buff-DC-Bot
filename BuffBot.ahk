#SingleInstance, Force
#Include, ahk\Resources.ahk
SetWorkingDir, %A_ScriptDir%
SendMode, Event
;SetKeyDelay, %keyDelay%, %pressDuration%
SetMouseDelay, %mouseDelay%
SetDefaultMouseSpeed, 0
CoordMode, Mouse, Client
CoordMode, Pixel, Client

PgDn::
Reload
return

PgUp::
CheckBuffNeeded()