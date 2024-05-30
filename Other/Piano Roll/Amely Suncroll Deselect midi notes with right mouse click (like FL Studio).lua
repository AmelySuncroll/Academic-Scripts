-- @description Deselect midi notes with right mouse click (like FL Studio)
-- @version 1.01
-- @author Amely Suncroll
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + Added toolbar icon highlighting
-- @about Click right mouse click just one time to deselect all midi notes. Hold right mouse click to delete midi notes (if you set up delete notes by right drag) and keep others selected.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

function deselect_all_notes(midi_editor)
    local take = reaper.MIDIEditor_GetTake(midi_editor)
    if take then
      reaper.MIDI_DisableSort(take)
      local _, note_count = reaper.MIDI_CountEvts(take)
      for i = 0, note_count - 1 do
        reaper.MIDI_SetNote(take, i, false, false, nil, nil, nil, nil, nil, true)
      end
      reaper.MIDI_Sort(take)
    end
  end
  
local was_right_button_pressed = false
local right_button_click_time = 0
local right_button_held_threshold = 0.2
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
          deselect_all_notes(midi_editor)
        end
      end
    end
    
    was_right_button_pressed = is_right_button_pressed
end

function focusMidiEditor()
    local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
    reaper.Main_OnCommand(focus_midi_editor, 0)
end

function main()
    if not is_running then return end
    check_right_click()
    reaper.defer(main)
end

function start_script()
    reaper.ShowMessageBox("Script working", "Deselect notes with right click", 0)
    focusMidiEditor()
    reaper.SetToggleCommandState(0, command_id, 1) -- Highlight toolbar button
    reaper.RefreshToolbar2(0, command_id)
    main()
end

function stop_script()
    is_running = false
    reaper.ShowMessageBox("Script stopped", "Deselect notes with right click", 0)
    reaper.SetToggleCommandState(0, command_id, 0) -- Remove highlight from toolbar button
    reaper.RefreshToolbar2(0, command_id)
    focusMidiEditor()
end

start_script()
reaper.atexit(stop_script)
