--[[

  ReaScript Name: Delete selected chords except the highest note
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: Delete all chord's notes except highest

  
  Запрошую долучитися: https://t.me/reaper_ua
      
  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

function count_chords_and_notes(take, notecnt)
    local notes = {}
    local chordCount = 0
    local singleNotes = 0
    local startPositions = {}
    local notesToDelete = {}
    local timeThreshold = 200

    for i = 0, notecnt - 1 do
        local _, selected, _, startpos, endpos, _, pitch, vel = reaper.MIDI_GetNote(take, i)
        if selected then
            notes[i] = {startpos, endpos, pitch, vel, index=i}
            local found = false
            for pos, notesAtPos in pairs(startPositions) do
                if math.abs(pos - startpos) <= timeThreshold then
                    table.insert(notesAtPos, notes[i])
                    found = true
                    break
                end
            end
            if not found then
                startPositions[startpos] = {notes[i]}
            end
        end
    end

    for _, notesAtPos in pairs(startPositions) do
        if #notesAtPos > 1 then
            chordCount = chordCount + 1
            table.sort(notesAtPos, function(a, b) return a[3] > b[3] end)  
            for i = 2, #notesAtPos do  
                table.insert(notesToDelete, notesAtPos[i].index)
            end
        else
            singleNotes = singleNotes + 1
        end
    end

    return chordCount, singleNotes, startPositions, notesToDelete, notes
end

function main()
    local editor = reaper.MIDIEditor_GetActive()
    local take = reaper.MIDIEditor_GetTake(editor)

    if not take or not reaper.ValidatePtr(take, "MediaItem_Take*") then
        reaper.ShowMessageBox("No active MIDI take found.", "Error", 0)
        return
    end

    local notecnt, _, _ = reaper.MIDI_CountEvts(take)

    local _, _, _, notesToDelete, _ = count_chords_and_notes(take, notecnt)

    table.sort(notesToDelete, function(a, b) return a > b end) 

    for _, noteIdx in ipairs(notesToDelete) do
        reaper.MIDI_DeleteNote(take, noteIdx)
    end

    reaper.MIDI_Sort(take)
    reaper.MIDIEditor_OnCommand(editor, 40435)  -- Unselect all notes
    reaper.Undo_OnStateChange("Delete all notes in selected chords except the highest note")
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Delete selected chords except the highest note", -1)
