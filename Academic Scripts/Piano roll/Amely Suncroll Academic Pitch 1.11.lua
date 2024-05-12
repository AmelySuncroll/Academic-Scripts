-- @description Academic Pitch
-- @author Amely Suncroll
-- @version 1.11
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + v1.1 add pitch points to all notes before using script
--    + v.11 keep midi editor focused
-- @about Set pitch bend parametres with academic symbols
-- b = move pitch bend down by one semitone
-- # = move pitch bend up by one semitone

-- /b = the half of b 
-- /# = the half of #
  
-- you can type #/# and b/b, bb and ## also
-- b (or #) nat = natural b or # (before Bach)
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll
-- https://www.youtube.com/@yxo_composer

local reaper = reaper

local function switchToPitch()
    reaper.MIDIEditor_LastFocused_OnCommand(40366, false)
end

function saveNoteSelection(take)
    local _, noteCount = reaper.MIDI_CountEvts(take)
    local selection = {}
    for i = 0, noteCount - 1 do
        local _, selected, _, _, _, _, _, _ = reaper.MIDI_GetNote(take, i)
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
        local _, selected, _, startppqpos, endppqpos, _, _, _ = reaper.MIDI_GetNote(take, i)
        if selected and not pitchBendExists(take, startppqpos, endppqpos) then
            reaper.MIDI_InsertCC(take, false, false, startppqpos, 0xE0, 0, 64, 64) 
        end
    end

    restoreNoteSelection(take, initialSelection) 
end

function pitchBendExists(take, startppqpos, endppqpos)
    local _, ccCount = reaper.MIDI_CountEvts(take)
    for i = 0, ccCount - 1 do
        local _, _, _, ppqpos, chanmsg, _, _, _ = reaper.MIDI_GetCC(take, i)
        if chanmsg == 224 and ppqpos >= startppqpos and ppqpos <= endppqpos then
            return true 
        end
    end
    return false 
end

function selectAllNotes(take)
    local _, noteCount = reaper.MIDI_CountEvts(take)
    for i = 0, noteCount - 1 do
        reaper.MIDI_SetNote(take, i, true, nil, nil, nil, nil, nil, nil, true) 
    end
end

function main()
    local editor = reaper.MIDIEditor_GetActive() 
    if editor == nil then return end
    local take = reaper.MIDIEditor_GetTake(editor) 
    if take == nil then return end

    reaper.Undo_BeginBlock() 
    reaper.MIDI_DisableSort(take) 

    local initialSelection = saveNoteSelection(take) 
    selectAllNotes(take)
    insertPitchBendOnSelectedNotesIfNotExist(take)
    restoreNoteSelection(take, initialSelection)

    reaper.MIDI_Sort(take) 
    reaper.Undo_EndBlock("Insert Pitch Bend with Inverted Selection", -1) 
end

main()



local pitchBendValues = {
    ["bb"] = 0,
    ["b/b"] = 2048,
    ["b"] = 4096,
    ["b nat"] = 5460,
    ["/b"] = 6144,
    ["0"] = 8192,
    ["/#"] = 10240,
    ["# nat"] = 10922,
    ["#"] = 12288,
    ["#/#"] = 14336,
    ["##"] = 16383
}

local function deletePreviousPitchBend(take, startppqpos, endppqpos)
    local _, countCC, _, _ = reaper.MIDI_CountEvts(take)
    for i = countCC - 1, 0, -1 do
        local _, _, _, ppqpos, _, _, _, _ = reaper.MIDI_GetCC(take, i)
        if ppqpos >= startppqpos and ppqpos <= endppqpos then
            reaper.MIDI_DeleteCC(take, i)
        end
    end
end

local command_id = 40153

local function shortenSelectedNotes()
    reaper.MIDIEditor_LastFocused_OnCommand(40445, false)
end

local function lengthenSelectedNotes()
    reaper.MIDIEditor_LastFocused_OnCommand(40444, false)
end

local function applyPitchBend(bendValue)
    local itemCount = reaper.CountSelectedMediaItems(0)
    if itemCount == 0 then
        reaper.ShowMessageBox("No notes are selected. Please select some notes and try again.", ":(", 0)
        return
    end
    
    local lastNoteEndPPQPos = nil

    for i = 0, itemCount - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local take = reaper.GetActiveTake(item)
        if take and reaper.TakeIsMIDI(take) then
            local _, noteCount, _, _ = reaper.MIDI_CountEvts(take)
            for j = 0, noteCount - 1 do
                local _, selected, _, startppqpos, endppqpos, _, _, _ = reaper.MIDI_GetNote(take, j)
                if selected then
                    deletePreviousPitchBend(take, startppqpos, endppqpos)
                    reaper.MIDI_InsertCC(take, false, false, startppqpos, 0xE0, 0, bendValue & 0x7F, (bendValue >> 7) & 0x7F)
                    lastNoteEndPPQPos = math.max(lastNoteEndPPQPos or 0, endppqpos)
                end
            end
        end
    end
    
    reaper.UpdateArrange()
end

local function getUserInput()
    local retval, userInput = reaper.GetUserInputs("Academic Pitch 1.11", 1, "Enter pitch value or accidentals:", "")
    if not retval then
        return nil 
    end

    local bendValue = pitchBendValues[userInput] or tonumber(userInput)

    if bendValue and bendValue >= 0 and bendValue <= 16383 then
        return bendValue 
    else
        reaper.ShowMessageBox("Invalid input! \n \nPlease enter a valid number between 0 and 16383 or next accidentals: bb, b/b, b, /b, 0, /#, #, #/#, ##;  also b or # nat.", ":(", 0)
        return false
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
        local bendValue = getUserInput()
        if bendValue == nil then 
            lengthenSelectedNotes()
            return
        elseif bendValue ~= false then 
            applyPitchBend(bendValue)
            break
        end
    end

    lengthenSelectedNotes()
end

main()
focusMidiEditor()
