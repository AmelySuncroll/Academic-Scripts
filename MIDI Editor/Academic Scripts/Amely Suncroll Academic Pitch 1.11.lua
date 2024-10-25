-- @description Academic Pitch
-- @author Amely Suncroll
-- @version 2.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + v1.1 add pitch points to all notes before using script
--    + v.11 keep midi editor focused
--    + 2.0 add random function and four commands (r; r X; r X Y; r b #), add slide function (X to Y), change 'b nat' and '# nat' to 'bn' and '#n'
-- @about Use academic symbols such as "b" or "#" to change a pitch. You can get more with combinate them - bb, ##, /b, /#, b/b or #/#. Use b nat or # nat. Use numeral values from 1 to 16383.
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll

local reaper = reaper

math.randomseed(os.time())

local pitchBendValues = {
    ["bb"] = 0,
    ["b/b"] = 2048,
    ["b"] = 4096,
    ["bn"] = 5460,
    ["/b"] = 6144,
    ["0"] = 8192,
    ["/#"] = 10240,
    ["#n"] = 10922,
    ["#"] = 12288,
    ["#/#"] = 14336,
    ["##"] = 16383
}

local function switchToPitch()
    reaper.MIDIEditor_LastFocused_OnCommand(40366, false)
end

function saveNoteSelection(take)
    local _, noteCount = reaper.MIDI_CountEvts(take)
    local selection = {}
    for i = 0, noteCount - 1 do
        local _, selected = reaper.MIDI_GetNote(take, i)
        table.insert(selection, selected)
    end
    return selection
end

function restoreNoteSelection(take, selection)
    local _, noteCount = reaper.MIDI_CountEvts(take)
    for i = 0, noteCount - 1 do
        reaper.MIDI_SetNote(take, i, selection[i + 1], nil, nil, nil, nil, nil, nil, true)
    end
end

function insertPitchBendOnSelectedNotesIfNotExist(take)
    local initialSelection = saveNoteSelection(take) 

    local _, noteCount = reaper.MIDI_CountEvts(take)
    for i = 0, noteCount - 1 do
        local _, selected, _, startppqpos = reaper.MIDI_GetNote(take, i)
        if selected and not pitchBendExists(take, startppqpos) then
            reaper.MIDI_InsertCC(take, false, false, startppqpos, 0xE0, 0, 64, 64) 
        end
    end

    restoreNoteSelection(take, initialSelection) 
end

function pitchBendExists(take, ppqpos)
    local _, ccCount = reaper.MIDI_CountEvts(take)
    for i = 0, ccCount - 1 do
        local _, _, _, cc_ppqpos, chanmsg = reaper.MIDI_GetCC(take, i)
        if chanmsg == 224 and cc_ppqpos == ppqpos then
            return true 
        end
    end
    return false 
end

local function deletePreviousPitchBend(take, ppqpos)
    local _, countCC = reaper.MIDI_CountEvts(take)
    for i = countCC - 1, 0, -1 do
        local _, _, _, cc_ppqpos, chanmsg = reaper.MIDI_GetCC(take, i)
        if chanmsg == 224 and cc_ppqpos == ppqpos then
            reaper.MIDI_DeleteCC(take, i)
        end
    end
end

local function getExistingPitchBendValue(take, ppqpos)
    local _, ccCount = reaper.MIDI_CountEvts(take)
    for i = ccCount - 1, 0, -1 do
        local _, _, _, cc_ppqpos, chanmsg, _, msg2, msg3 = reaper.MIDI_GetCC(take, i)
        if chanmsg == 224 and cc_ppqpos <= ppqpos then
            local bendValue = msg2 + (msg3 << 7)
            return bendValue
        end
    end
    return 8192 -- If there is no existing pitch bend, return the default value
end

local function shortenSelectedNotes()
    reaper.MIDIEditor_LastFocused_OnCommand(40445, false)
end

local function lengthenSelectedNotes()
    reaper.MIDIEditor_LastFocused_OnCommand(40444, false)
end

local function parsePitchValue(input)
    input = input:lower()
    input = input:gsub("%s+", "")
    local value = pitchBendValues[input]
    if value then
        return value
    else
        value = tonumber(input)
        if value and value >= 0 and value <= 16383 then
            return value
        else
            return nil
        end
    end
end

local function applyPitchBend(bendValueData)
    local editor = reaper.MIDIEditor_GetActive()
    if not editor then
        reaper.ShowMessageBox("Failed to get active MIDI editor.", ":(", 0)
        return
    end

    local take = reaper.MIDIEditor_GetTake(editor)
    if not take then
        reaper.ShowMessageBox("Failed to get active take.", ":(", 0)
        return
    end

    local _, noteCount = reaper.MIDI_CountEvts(take)
    local selectedNoteExists = false
    for i = 0, noteCount - 1 do
        local _, selected = reaper.MIDI_GetNote(take, i)
        if selected then
            selectedNoteExists = true
            break
        end
    end

    if not selectedNoteExists then
        reaper.ShowMessageBox("No selected notes. Please select notes and try again.", ":(", 0)
        return
    end

    local selectedNoteIndex = 0
    local totalSelectedNotes = 0
    for i = 0, noteCount - 1 do
        local _, selected = reaper.MIDI_GetNote(take, i)
        if selected then
            totalSelectedNotes = totalSelectedNotes + 1
        end
    end

    for i = 0, noteCount - 1 do
        local _, selected, _, startppqpos = reaper.MIDI_GetNote(take, i)
        if selected then
            deletePreviousPitchBend(take, startppqpos)

            local newBendValue

            if bendValueData.type == 'fixed' then
                newBendValue = bendValueData.value
            elseif bendValueData.type == 'random' then
                local minValue, maxValue

                if bendValueData.stepsDownMax and bendValueData.stepsUpMax then
                    local stepsDownMax = bendValueData.stepsDownMax
                    local stepsUpMax = bendValueData.stepsUpMax

                    minValue = stepsDownMax
                    maxValue = stepsUpMax
                elseif bendValueData.minValue and bendValueData.maxValue then
                    minValue = bendValueData.minValue
                    maxValue = bendValueData.maxValue
                else
                    minValue = 0
                    maxValue = 16383
                end

                -- Swap values if necessary
                if minValue > maxValue then
                    minValue, maxValue = maxValue, minValue
                end

                newBendValue = math.random(math.floor(minValue), math.floor(maxValue))
            elseif bendValueData.type == 'slide' then
                local startValue = bendValueData.startValue
                local endValue = bendValueData.endValue
                newBendValue = math.floor(startValue + ((endValue - startValue) * (selectedNoteIndex / (totalSelectedNotes - 1))))
                selectedNoteIndex = selectedNoteIndex + 1
            end

            if selected then
                reaper.MIDI_InsertCC(take, false, false, startppqpos, 0xE0, 0, newBendValue & 0x7F, (newBendValue >> 7) & 0x7F)
            end
        end
    end

    reaper.UpdateArrange()
end

local function getUserInput()
    local retval, userInput = reaper.GetUserInputs("Academic Pitch 2.0", 1, "Enter pitch value or accidentals:", "")
    if not retval then
        return nil 
    end

    userInput = userInput:lower()

    local params = {}
    for word in userInput:gmatch("%S+") do
        table.insert(params, word)
    end

    if params[1] == 'r' then
        if #params == 3 then
            -- Handling 'r X Y'
            local xInput = params[2]
            local yInput = params[3]
            local stepsDownMax = parsePitchValue(xInput)
            local stepsUpMax = parsePitchValue(yInput)

            if stepsDownMax and stepsUpMax then
                return {type = 'random', stepsDownMax = stepsDownMax, stepsUpMax = stepsUpMax}
            else
                reaper.ShowMessageBox("Invalid input! \n\nPlease enter the command in the format 'r X Y', where X and Y are numerical values or alterations.", ":(", 0)
                return false
            end
        elseif #params == 2 then
            -- Handling 'r X'
            local xInput = params[2]
            local xValue = parsePitchValue(xInput)

            if xValue then
                local halfRange = xValue / 2
                local minValue = 8192 - halfRange
                local maxValue = 8192 + halfRange
                return {type = 'random', minValue = minValue, maxValue = maxValue}
            else
                reaper.ShowMessageBox("Invalid input! \n\nPlease enter the command in the format 'r X', where X is a numerical value or alteration.", ":(", 0)
                return false
            end
        elseif #params == 1 then
            -- Handling 'r'
            return {type = 'random', minValue = 1, maxValue = 16383}
        else
            reaper.ShowMessageBox("Invalid input! \n\nFor random pitch bend, enter 'r', 'r X', or 'r X Y', where X and Y are numerical values or alterations.", ":(", 0)
            return false
        end
    elseif #params == 3 and params[2] == 'to' then
        -- Handling 'X to Y'
        local xInput = params[1]
        local yInput = params[3]
        local startValue = parsePitchValue(xInput)
        local endValue = parsePitchValue(yInput)

        if startValue and endValue then
            return {type = 'slide', startValue = startValue, endValue = endValue}
        else
            reaper.ShowMessageBox("Invalid input! \n\nPlease enter the command in the format 'X to Y', where X and Y are numerical values or alterations.", ":(", 0)
            return false
        end
    else
        -- Handling fixed value
        local bendValue = parsePitchValue(userInput)
        if bendValue then
            return {type = 'fixed', value = bendValue}
        else
            reaper.ShowMessageBox("Invalid input! \n\nPlease enter a numerical value between 0 and 16383 or one of the following alterations: bb, b/b, b, /b, 0, /#, #, #/#, ##; also b nat or # nat.", ":(", 0)
            return false
        end
    end
end

function focusMidiEditor()
    local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
    reaper.Main_OnCommand(focus_midi_editor, 0)
end

local function main()
    switchToPitch()
    shortenSelectedNotes()

    while true do
        local bendValueData = getUserInput()
        if bendValueData == nil then 
            lengthenSelectedNotes()
            return
        elseif bendValueData ~= false then 
            applyPitchBend(bendValueData)
            break
        end
    end

    lengthenSelectedNotes()
end

main()
focusMidiEditor()
