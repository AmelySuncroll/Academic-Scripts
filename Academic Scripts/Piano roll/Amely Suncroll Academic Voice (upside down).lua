-- @description Academic Voice (upside down)
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Select any voice in selected tracks but upside down: 1 = bass + notes without chords, 2 = tenor, 3 = alto, 4 = soprano, then 5, 6, etc. 0 = all highest notes inside chords. 

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

function get_voice_from_user()
    local retval, user_input = reaper.GetUserInputs("Acamedic Voice (upside down)", 1, "Enter Note Number (inc. 0):", "")
    if not retval then return nil end
    local voice_num = tonumber(user_input)
    return voice_num
end

function count_chords_and_notes()
    local notes = {}
    local chordCount = 0
    local singleNotes = 0
    local startPositions = {}
    local notesToDelete = {}
    local timeThreshold = 200

    for i = 0, notecnt - 1 do
        local _, selected, _, startpos, endpos, _, pitch, vel = reaper.MIDI_GetNote(take, i)
        if selected then
            notes[i] = {startpos, endpos, pitch, vel}
            local found = false
            for pos, notesAtPos in pairs(startPositions) do
                if math.abs(pos - startpos) <= timeThreshold then
                    table.insert(notesAtPos, i)
                    found = true
                    break
                end
            end
            if not found then
                startPositions[startpos] = {i}
            end
        end
    end

    for _, indices in pairs(startPositions) do
        if #indices > 1 then
            chordCount = chordCount + 1
            for _, idx in ipairs(indices) do
                table.insert(notesToDelete, idx)
            end
        else
            singleNotes = singleNotes + 1
            table.insert(notesToDelete, indices[1])
        end
    end

    return chordCount, singleNotes, startPositions, notesToDelete, notes
end

function select_voice_notes(voice_num, startPositions, notes)
    reaper.MIDI_SelectAll(take, false) -- Deselect all notes
    for _, indices in pairs(startPositions) do
        if #indices > 1 then
            table.sort(indices, function(a, b) return notes[a][3] < notes[b][3] end) -- Sort by pitch
            if voice_num == 0 then
                reaper.MIDI_SetNote(take, indices[#indices], true, nil, nil, nil, nil, nil, nil, true)
            elseif voice_num <= #indices then
                reaper.MIDI_SetNote(take, indices[voice_num], true, nil, nil, nil, nil, nil, nil, true)
            end
        elseif voice_num == 1 then
            reaper.MIDI_SetNote(take, indices[1], true, nil, nil, nil, nil, nil, nil, true)
        end
    end
end

function focusMidiEditor()
    local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
    reaper.Main_OnCommand(focus_midi_editor, 0)
  end

  function main()
    take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    if not take then return end

    notecnt, _, _ = reaper.MIDI_CountEvts(take)

    local voice_num = get_voice_from_user()
    if not voice_num or voice_num < 0 then return end

    local chordCount, singleNotes, startPositions, notesToDelete, notes = count_chords_and_notes()
    
    select_voice_notes(voice_num, startPositions, notes)

    reaper.MIDI_Sort(take)
    reaper.Undo_EndBlock("Select voice notes in chords", -1)
end

reaper.Undo_BeginBlock()
main()
focusMidiEditor()
reaper.Undo_EndBlock("Select voice notes in chords", -1)
reaper.UpdateArrange()
