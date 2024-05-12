--[[

  ReaScript Name: Academic Dynamic
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 2.2

  About: Select notes and see how velocity will change by your magic fingers.

  ppp = set velocity of selected notes to 16 value
  pp = 32
  p = 48
  etc (up to fff)

  123 = set velocity of selected notes to 123 value
  to 123 = set THE FIRST selected note to 123 value and keep the ratio between others
  123 to 123 = set transition from 123 to 123 of selected notes velocity (up to four: A to B to X to Y)

  123 r 123 = random velocity with range from X (low value) to Y (high value)
  123 = 123 = replace velocity (approximately range of the note you want to replace is +-5)

  to ppp (or other) = set THE FIRST selected note to ppp value and keep the ratio between others
  mf to mp (up to 4) = set transition from mf to mp of selected notes velocity
  cresc (or dim) = set velocity transition from note BEFORE and note AFTER out of selection

  v2.0: add function random velocity
  v2.1: add function select midi item(s) to set dynamic to each of them (in arrange view)
  v2.11: add keep midi editor focused
  v2.2: add replace velocity function

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



function copyToClipboard(text)
    if reaper.CF_SetClipboard then
        reaper.CF_SetClipboard(text)
    else
        reaper.ShowMessageBox("SWS extension is not installed. Clipboard functionality is not available.", ":(", 0)
    end
end

function getPasteFromClipboard()
    if reaper.CF_GetClipboard then
        local clipboard_content = reaper.CF_GetClipboard("")
        return clipboard_content
    else
        reaper.ShowMessageBox("SWS extension is not installed. Clipboard functionality is not available.", ":(", 0)
        return ""
    end
end

function selectAllNotesInTake(take)
    local retval, notecnt, _, _ = reaper.MIDI_CountEvts(take)
    for i = 0, notecnt - 1 do
        local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
        if not selected then
            reaper.MIDI_SetNote(take, i, true, muted, startppqpos, endppqpos, chan, pitch, vel, false) 
        end
    end
    reaper.MIDI_Sort(take) 
end

function deselectAllNotesInTake(take)
    local retval, notecnt, _, _ = reaper.MIDI_CountEvts(take)
    for i = 0, notecnt - 1 do
        local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
        if selected then
            reaper.MIDI_SetNote(take, i, false, muted, startppqpos, endppqpos, chan, pitch, vel, false) 
        end
    end
    reaper.MIDI_Sort(take) 
end

function main_dynamic_script(take)

    math.randomseed(os.time())

    --local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive()) 

    if not take then 
        return reaper.MB("No active MIDI editor found", ":(", 0)
    end

    local function switchToVelocity()
        reaper.MIDIEditor_LastFocused_OnCommand(40237, false)
    end

    switchToVelocity()

    local function changeVelocity(take, substitutions, range)
        if not take or not substitutions then return end
    
        local range = range or 5  -- change this value to get more approximately range of velocity you need to replace (now is +-5)
        reaper.MIDI_DisableSort(take)
        local _, num_items = reaper.MIDI_CountEvts(take)
        local hasSelectedNotes = false
        local anyChangesMade = false
    
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
                for baseVel, newVel in pairs(substitutions) do
                    if vel >= baseVel - range and vel <= baseVel + range then
                        reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chan, pitch, newVel, true)
                    end
                end
            end
        end
    
        reaper.MIDI_Sort(take)
        return anyChangesMade
    end
    

    --[[local function getUserInput()
        local retval, user_input = reaper.GetUserInputs("Academic Dynamic 2.0", 1, "Enter value (ppp (to) fff, 123):", "")
        if retval then copyToClipboard(user_input) --return user_input
        elseif not retval then return nil end
        return user_input
    end ]]--

    local function getUserInput(default_value)
        local retval, user_input = reaper.GetUserInputs("Academic Dynamic 2.2", 1, "Enter value (ppp (to) fff, 123):", default_value)
        if retval then
            copyToClipboard(user_input)
            return user_input
        end
        return nil
    end

    local function isValidInput(user_input)
        local velocityMap = {
            ppp = true,
            pp = true,
            p = true,
            mp = true,
            mf = true,
            f = true,
            ff = true,
            fff = true,
            cresc = true,
            dim = true
        }
        

        local exactValue = tonumber(user_input)
        if exactValue and exactValue >= 1 and exactValue <= 127 then
            return true
        end

        local startVel, endVel = user_input:match("^(%d+)%s+to%s+(%d+)$")
        if startVel and endVel then
            startVel, endVel = tonumber(startVel), tonumber(endVel)
            if startVel >= 1 and startVel <= 127 and endVel >= 1 and endVel <= 127 then
                return true
            end
        end

        if velocityMap[user_input] then
            return true
        end

        local fromDynamic, toDynamic = user_input:match("(%w+)%sto%s(%w+)")
        if fromDynamic and toDynamic and velocityMap[fromDynamic] and velocityMap[toDynamic] then
            return true
        end

        if user_input:match("^to%s+(%w+)$") then
            return true
        end

        if user_input:match("^%d+%s+=%s+%d+$") then 
            return true
        end

        local minVel, maxVel = user_input:match("^(%d+)%s+r%s+(%d+)$")
        if minVel and maxVel then
            minVel, maxVel = tonumber(minVel), tonumber(maxVel)
            if minVel and maxVel and minVel >= 1 and maxVel <= 127 and minVel <= maxVel then
                return true
            end
        end

        return false
    end

    local clipboard_text = getPasteFromClipboard()

    local user_input
    repeat
        user_input = getUserInput(clipboard_text)
        if user_input == nil then return end

        if user_input == "instruction" or user_input == "i" then
            reaper.ShowMessageBox("Thank you to download this script! \n \n \nYou can type here: \n \nppp, pp, p, mp, mf, f, ff, fff \nto mf \nmf to mp \n \n123 (from 1 to 127) \nto 123 \n123 to 123 \n \n123 r 123 (to random in range) \n \n 123 = 123 (to replace approximately)\n \ncresc, dim \n \n \nYou can support me via PayPal: \n@suncroll \n \nBest, Amely Suncroll", "Instruction", 0)
        
        
        elseif not isValidInput(user_input) then
            reaper.MB("Invalid input! \n \nType i to get instruction.", ":(", 0)
        end

    until isValidInput(user_input)

    local velocityMap = {
        ppp = 16,
        pp = 32,
        p = 48,
        mp = 64,
        mf = 80,
        f = 96,
        ff = 112,
        fff = 127
    }

    local note_count = reaper.MIDI_CountEvts(take)
    local firstSelectedIdx, lastSelectedIdx

    for i = 0, note_count - 1 do
        local retval, selected = reaper.MIDI_GetNote(take, i)
        if selected then
            if not firstSelectedIdx then
                firstSelectedIdx = i
            end
            lastSelectedIdx = i
        end
    end

    if not (firstSelectedIdx and lastSelectedIdx) then
        return reaper.MB("No notes selected!", ":(", 0)
    end

    local noteBefore, noteAfter

    if firstSelectedIdx > 0 then
        local retval, _, _, _, _, _, _, vel = reaper.MIDI_GetNote(take, firstSelectedIdx - 1)
        noteBefore = vel
    end

    if lastSelectedIdx < note_count - 1 then
        local retval, _, _, _, _, _, _, vel = reaper.MIDI_GetNote(take, lastSelectedIdx + 1)
        noteAfter = vel
    end

    local dynamics = {}
    for dynamic in user_input:gmatch("(%w+)") do
        if velocityMap[dynamic] then
            table.insert(dynamics, velocityMap[dynamic])
        end
    end

    local command_id = 40153

    local totalSections = #dynamics - 1
    local notesPerSection = (lastSelectedIdx - firstSelectedIdx) / totalSections

    local exactValue = tonumber(user_input)

    if #dynamics >= 2 then
        for i = firstSelectedIdx, lastSelectedIdx do
            local section = math.min(math.floor((i - firstSelectedIdx) / notesPerSection) + 1, totalSections)
            local alpha = ((i - firstSelectedIdx) - (notesPerSection * (section - 1))) / notesPerSection
            local interpolated_vel = dynamics[section] + alpha * (dynamics[section + 1] - dynamics[section])
            interpolated_vel = math.floor(interpolated_vel + 0.5)

            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch, vel = reaper.MIDI_GetNote(take, i)
            if selected then
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, interpolated_vel, false)
            end
        end
    elseif velocityMap[user_input] then
        for i = firstSelectedIdx, lastSelectedIdx do
            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch, vel = reaper.MIDI_GetNote(take, i)
            if selected then
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, velocityMap[user_input], false)
            end
        end
    elseif exactValue and exactValue >= 1 and exactValue <= 127 then
        for i = firstSelectedIdx, lastSelectedIdx do
            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch, vel = reaper.MIDI_GetNote(take, i)
            if selected then
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, exactValue, false)
            end
        end
    elseif user_input:match("^%d+%s+to%s+%d+$") then
        local startVel, endVel = user_input:match("^(%d+)%s+to%s+(%d+)$")
        startVel, endVel = tonumber(startVel), tonumber(endVel)
        local totalNotes = lastSelectedIdx - firstSelectedIdx
        for i = firstSelectedIdx, lastSelectedIdx do
            local alpha = (i - firstSelectedIdx) / totalNotes
            local interpolated_vel = startVel + alpha * (endVel - startVel)
            interpolated_vel = math.floor(interpolated_vel + 0.5)
            interpolated_vel = math.max(1, math.min(interpolated_vel, 127)) 

            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch = reaper.MIDI_GetNote(take, i)
            if selected then
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, interpolated_vel, false)
            end
        end
        reaper.MIDI_Sort(take)
    elseif user_input:match("^to%s+(%w+)$") then
        local targetDynamic = user_input:match("^to%s+(%w+)$")
        local targetVelocity = velocityMap[targetDynamic] or tonumber(targetDynamic)
        if not targetVelocity or targetVelocity < 1 or targetVelocity > 127 then
            return reaper.MB("Invalid target dynamic!", ":(", 0)
        end

        local _, _, _, _, _, _, _, firstNoteVel = reaper.MIDI_GetNote(take, firstSelectedIdx)
        local velocityDifference = firstNoteVel - targetVelocity

        for i = firstSelectedIdx, lastSelectedIdx do
            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch, vel = reaper.MIDI_GetNote(take, i)
            if selected then
                local newVel = math.max(1, math.min(127, vel - velocityDifference))
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, newVel, false)
            end
        end
    elseif user_input:match("^%d+%s+r%s+%d+$") then
        local minVel, maxVel = user_input:match("^(%d+)%s+r%s+(%d+)$")
        minVel, maxVel = tonumber(minVel), tonumber(maxVel)
        if not minVel or not maxVel or minVel > maxVel then
            return reaper.MB("Invalid range!", ":(", 0)
        end

        for i = firstSelectedIdx, lastSelectedIdx do
            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch, vel = reaper.MIDI_GetNote(take, i)
            if selected then
                local randomVel = math.random(minVel, maxVel)
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, randomVel, false)
            end
        end
    elseif user_input == "cresc" and noteBefore and noteAfter then
        local totalNotes = lastSelectedIdx - firstSelectedIdx + 1
        for i = firstSelectedIdx, lastSelectedIdx do
            local alpha = (i - firstSelectedIdx) / totalNotes
            local interpolated_vel = noteBefore + alpha * (noteAfter - noteBefore)
            interpolated_vel = math.floor(interpolated_vel + 0.5)
            
            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch, vel = reaper.MIDI_GetNote(take, i)
            if selected then
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, interpolated_vel, false)
            end
        end
    elseif user_input == "dim" and noteBefore and noteAfter then
        local totalNotes = lastSelectedIdx - firstSelectedIdx + 1
        for i = firstSelectedIdx, lastSelectedIdx do
            local alpha = 1 - ((i - firstSelectedIdx) / totalNotes)
            local interpolated_vel = noteAfter + alpha * (noteBefore - noteAfter)
            interpolated_vel = math.floor(interpolated_vel + 0.5)
            
            local retval, selected, muted, startppqpos, endppqpos, chanmsg, pitch, vel = reaper.MIDI_GetNote(take, i)
            if selected then
                reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chanmsg, pitch, interpolated_vel, false)
            end
        end
    elseif user_input:match("^%d+%s+=%s+%d+$") then
        local substitutions = {}
        for baseVel, newVel in user_input:gmatch("(%d+)%s*=%s*(%d+)") do
            baseVel, newVel = tonumber(baseVel), tonumber(newVel)
            if baseVel and newVel then
                substitutions[baseVel] = newVel
            end
        end
        if next(substitutions) then
            changeVelocity(take, substitutions)  
            reaper.MIDI_Sort(take)
            return true  
        end
    else
        reaper.MB("Invalid input!", ":(", 0)
        return false
        
    end


    reaper.MIDI_Sort(take)

end

local midiEditor = reaper.MIDIEditor_GetActive()

if midiEditor then
    local take = reaper.MIDIEditor_GetTake(midiEditor)
    if take then
        main_dynamic_script(take)
    end
else
    local itemCount = reaper.CountSelectedMediaItems(0)
    if itemCount == 0 then
        reaper.MB("No MIDI items selected and no active MIDI editor found.", ":(", 0)
        return
    end

    for i = 0, itemCount - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local take = reaper.GetActiveTake(item)
        if reaper.TakeIsMIDI(take) then
            selectAllNotesInTake(take)
            main_dynamic_script(take)
            deselectAllNotesInTake(take)
        end
    end
end


local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
reaper.Main_OnCommand(focus_midi_editor, 0)
