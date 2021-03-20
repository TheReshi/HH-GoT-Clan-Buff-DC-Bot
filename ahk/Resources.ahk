#SingleInstance, Force
#Include, ahk\Config.ahk
SendMode, Event
;SetKeyDelay, %keyDelay%, %pressDuration%
SetMouseDelay, %mouseDelay%
SetDefaultMouseSpeed, 0
CoordMode, Mouse, Client
CoordMode, Pixel, Client

GetImgCoords(coordArray, variation, imgName, position, max_wait := 140) {
    imgCoords := WaitForImg(coordArray, variation, imgName, max_wait)
    if (imgCoords == -1) {
        return -1
    }

    if (position = 0) {
        centerCoords := GetCenterImgCoords(imgName, imgCoords[1], imgCoords[2])
        return [centerCoords[1], centerCoords[2]]
    }
    return [imgCoords[1], imgCoords[2]]
}

WaitForImg(coordArray, variation, imgName, max_wait) {
    foundImg = 0
    counter = 0
    Loop, {
        Sleep, 50
        ImageSearch, FoundX, FoundY, coordArray[1][1], coordArray[1][2], coordArray[2][1], coordArray[2][2], % " *" . variation . " " . imgName
        if (FoundX != "") {
            foundImg = 1
        }
        counter += 1
        Sleep, 200
    } Until (foundImg == 1 || counter >= max_wait)
    if (counter >= max_wait) {
        return -1
    }
    return [FoundX, FoundY]
}

GetCenterImgCoords(imgFile, FoundX, FoundY) {
    static myPic
    Gui, imageDim: New
    Gui, imageDim:add, picture, vmyPic, %imgFile%
    GuiControlGet, myPic, imageDim:Pos
    gui, imageDim:destroy
    
    FoundX += Floor(myPicW/2)
    FoundY += Floor(myPicH/2)
    return [FoundX, FoundY]
}

GetBuffArea(buff) {
    buffCoords = -1
    if (buff = "cb") {
        buffCoords := GetImgCoords(screenArea, 100, CBicon, 1)
    } else if (buff = "gm") {
        buffCoords := GetImgCoords(screenArea, 100, GMicon, 1)
    }
    return buffCoords
}

GetBuffButtonArea(buff) {
    buffArea := GetBuffArea(buff)
    return [[buffArea[1], buffArea[2]], [buffArea[1] + buffWidth, buffArea[2] + buffHeight]]
}

RemoveBuff(buff) {
    buffButtonArea := GetBuffButtonArea(buff)
    removeButtonCoord := GetImgCoords(buffButtonArea, 80, removeIcon, 0)
    MouseClick, Left, removeButtonCoord[1], removeButtonCoord[2], 1, 0
}

AddBuff(buff, name) {
    ;RemoveBuff(buff)
    buffButtonArea := GetBuffButtonArea(buff)
    addButtonCoord := GetImgCoords(buffButtonArea, 100, conferIcon, 0)
    if (addButtonCoord == -1) {
        return -1
    }
    MouseClick, Left, addButtonCoord[1], addButtonCoord[2], 1, 0
    searchField := GetImgCoords(searchArea, 70, searchAreaIcon, 0)
    if (searchField == -1) {
        return -1
    }
    MouseClick, Left, searchField[1], searchField[2], 1, 0
    Sleep, 1000
    Send, %name%
    searchButton := GetImgCoords(searchArea, 70, searchIcon, 0)
    if (searchButton == -1) {
        return -1
    }
    MouseClick, Left, searchButton[1], searchButton[2], 1, 0
    addBuffButton := GetImgCoords(searchArea, 70, addBuffIcon, 0)
    if (addBuffButton == -1) {
        CloseSearchWindow()
        return -1
    }
    MouseClick, Left, addBuffButton[1], addBuffButton[2], 1, 0
    WriteCurrentBuffs(buff, name)
}

WriteCurrentBuffs(buffType, name) {
    if (buffType == "cb") {
        currentBuffFile := currentCBBuff
    } else if (buffType == "gm") {
        currentBuffFile := currentGMBuff
    } else {
        return -1
    }

    closeWindowButton := GetImgCoords(searchArea, 70, closeWindowIcon, 0, 5)
    if (closeWindowButton == -1) {
        outFile := FileOpen(currentBuffFile, "w")
        outFile.Write(buffType . "," . name)
        outFile.Close()
    }
}

ReadFirstLine(buffType) {
    firstLine = -1
    textbuilder := []

    if (buffType == "cb") {
        logFile := cbBuffsLog
        backupFile := cbBuffsBackup
    } else if (buffType == "gm") {
        logFile := gmBuffsLog
        backupFile := gmBuffsBackup
    } else {
        return -1
    }

    Loop, Read, %logFile%
    if (A_Index = 1) {
        firstLine = %A_LoopReadLine%
    } else {
        textbuilder.Push(A_LoopReadLine)
    }

    if (firstLine == -1) {
        return -1
    }

    outFile := FileOpen(backupFile, "w")
    for index, currentLine in textbuilder {
        if (index < textbuilder.MaxIndex()) {
            outFile.Write(currentLine . "`n")
        } else {
            outFile.Write(currentLine)
        }
    }
    outFile.Close()
    FileMove, %backupFile%, %logFile%, 1
    firstLine := StrSplit(firstLine, ",")
    return [firstLine[1], firstLine[2]]
}

CloseSearchWindow() {
    closeWindowButton := GetImgCoords(searchArea, 70, closeWindowIcon, 0, 3)
    if (closeWindowButton != -1) {
        MouseClick, Left, closeWindowButton[1], closeWindowButton[2], 1, 0
    }
}

CheckCBBuff() {
    cbBuffNeeded := ReadFirstLine("cb")
    if (cbBuffNeeded != "-1") {
        AddBuff(cbBuffNeeded[1], cbBuffNeeded[2])
    }
}

CheckGMBuff() {
    gmBuffNeeded := ReadFirstLine("gm")
    if (gmBuffNeeded != "-1") {
        AddBuff(gmBuffNeeded[1], gmBuffNeeded[2])
    }
}

ActivateGoT() {
    if !WinActive("Gtarcade") {
        WinActivate, Gtarcade
        WinActivate, Gtarcade
        Sleep, 500
    }
}

CheckBuffNeeded() {
    ActivateGoT()
	CloseSearchWindow()
    RemoveBuff("cb")
    RemoveBuff("gm")
    CloseSearchWindow()
    CheckCBBuff()
    Sleep, 500
    CloseSearchWindow()
    CheckGMBuff()
    Sleep, buffDelay
    CheckBuffNeeded()
}