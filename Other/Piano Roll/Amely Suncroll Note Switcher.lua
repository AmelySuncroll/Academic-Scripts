--[[

  ReaScript Name: Note Switcher
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: Select notes and replace it. Don't select notes and replace them all.

  Input example:
  x=y
  x#=y#
  xb=yb

  or:
  x=y, x#=y#, xb=yb (up to three notes to replace)

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

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function getNoteName(pitch)
    local notes = {"c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"}
    return notes[(pitch % 12) + 1]
end

function getNoteNumber(originalPitch, newNoteBase)
    local noteMap = {
        c = 0, ["c#"] = 1, db = 1,
        d = 2, ["d#"] = 3, eb = 3,
        e = 4, f = 5, ["f#"] = 6, gb = 6,
        g = 7, ["g#"] = 8, ab = 8,
        a = 9, ["a#"] = 10, bb = 10,
        b = 11
    }

    local originalOctave = math.floor(originalPitch / 12) * 12
    local newPitchBase = noteMap[newNoteBase] or 0
    return originalOctave + newPitchBase
end

function replaceNotes(substitutions)
    local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    if not take or not substitutions then return end

    reaper.MIDI_DisableSort(take)
    local _, num_items = reaper.MIDI_CountEvts(take)
    local hasSelectedNotes = false

    for i = 0, num_items - 1 do
        local retval, selected = reaper.MIDI_GetNote(take, i)
        if retval and selected then
            hasSelectedNotes = true
            break
        end
    end

    for i = 0, num_items - 1 do
        local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
        if retval and (selected or not hasSelectedNotes) then  
            local noteName = getNoteName(pitch)
            local baseNoteName = noteName:match("^%D+")  
            if substitutions[baseNoteName] then
                local newPitch = getNoteNumber(pitch, substitutions[baseNoteName])
                reaper.MIDI_SetNote(take, i, true, muted, startppqpos, endppqpos, chan, newPitch, vel, true)
            end
        end
    end

    reaper.MIDI_Sort(take)
    reaper.UpdateArrange()  
end


function getUserInput()
    local ret, user_input = reaper.GetUserInputs("Note Switcher", 1, "Replace by x=y (up to 3 after ',')", "")
    if not ret then return nil end
    user_input = user_input:lower()  

    local substitutions = {}
    local count = 0
    for pair in user_input:gmatch("[^,]+") do
        if count >= 3 then  -- if you want to get more input counts then up this number
            break
        end
        local original, replacement = pair:match("([^=]+)=([^=]+)")
        if original and replacement then
            substitutions[trim(original)] = trim(replacement)
            count = count + 1
        end
    end

    if count == 0 then
        reaper.ShowMessageBox("No valid note changes were entered.", ":(", 0)
        return nil
    end

    return substitutions
end


function focusMidiEditor()
    local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
    reaper.Main_OnCommand(focus_midi_editor, 0)
  end

function main()
    local substitutions = getUserInput()
    if not substitutions then return end
    replaceNotes(substitutions)
    reaper.UpdateArrange()
end

main()
focusMidiEditor()