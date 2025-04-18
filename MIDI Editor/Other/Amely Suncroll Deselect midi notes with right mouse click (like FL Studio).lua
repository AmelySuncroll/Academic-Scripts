-- @description Deselect midi notes with right mouse click (like FL Studio)
-- @version 1.05
-- @author Amely Suncroll
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + Improved toolbar icon handling
--    + Remove "working" and "stopped" messages
--    + Fix unmute notes if was muted
--    + Changed treshold to 0.1 and add reaper's native deselecting function
-- @about Click right mouse click just one time to deselect all midi notes. Hold right mouse click to delete midi notes (if you set up delete notes by right drag) and keep others selected.

-- @donation https://www.paypal.com/paypalme/suncroll
-- @website https://t.me/reaper_ua
-- Support: https://t.me/amely_suncroll_support amelysuncroll@gmail.com

if not reaper.APIExists('JS_ReaScriptAPI_Version') then
    reaper.ShowMessageBox("Requies js_ReaScriptAPI.", ":(", 0)
end

function deselect_all_notes(midi_editor)
    local take = reaper.MIDIEditor_GetTake(midi_editor)
    if take then
        reaper.MIDI_DisableSort(take)
        local _, note_count = reaper.MIDI_CountEvts(take)
        for i = 0, note_count - 1 do
            local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
            reaper.MIDI_SetNote(take, i, false, muted, startppqpos, endppqpos, chan, pitch, vel, true)
        end
        reaper.MIDI_Sort(take)
    end
end

local was_right_button_pressed = false
local right_button_click_time = 0
local right_button_held_threshold = 0.1
local command_id = ({reaper.get_action_context()})[4]
local is_running = true

function check_right_click()
    local is_right_button_pressed = reaper.JS_Mouse_GetState(2) == 2
    
    if is_right_button_pressed and not was_right_button_pressed then
        right_button_click_time = reaper.time_precise()
    end
    
    if not is_right_button_pressed and was_right_button_pressed then
        local click_duration = reaper.time_precise() - right_button_click_time
        if click_duration < right_button_held_threshold then
            local midi_editor = reaper.MIDIEditor_GetActive()
            if midi_editor then
                -- deselect_all_notes(midi_editor)
                reaper.MIDIEditor_LastFocused_OnCommand(40214, false)
            end
        end
    end
    
    was_right_button_pressed = is_right_button_pressed
end

function main()
    if not is_running then
        stop_script()
        return
    end
    check_right_click()
    reaper.defer(main)
end

function start_script()
    is_running = true
    reaper.SetToggleCommandState(0, command_id, 1)
    reaper.RefreshToolbar2(0, command_id)
    main()
end

function stop_script()
    reaper.SetToggleCommandState(0, command_id, 0)
    reaper.RefreshToolbar2(0, command_id)
    is_running = false
end

start_script()
reaper.atexit(stop_script)
