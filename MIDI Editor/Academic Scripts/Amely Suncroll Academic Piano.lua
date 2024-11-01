-- @description Academic Piano 
-- @author Amely Suncroll
-- @version 1.01
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + v1.01 add focus on midi editor after script message box (if it is open)
-- @about play on your pc keyboard anytime. Anywhere. With one button. Even other windows are focused. (You need to add this script to Arrange View (Main) and Piano Roll Actions separately)

-- IF YOU HAVE NO SOUND:
-- 1. Click right mouse on Virtual MIDI Keyboard (VKB) and check "Send all keyboard input to VKB (even when other windows active)";
-- 2. Be sure your MIDI-channel on VKB is set to 01 (check right virtual keyboard corner);
-- 3. Be sure your MIDI-channel in your VST is set to 01 or "omni".
-- 4.1 Check your preferences - Project - Track/Send Defaults - Record config: "MIDI: Virtual MIDI keyboard: All channels"
-- or
-- 4.2 Click on input part of track - Input: MIDI - Virtual MIDI keyboard - All channels (this option is local to selected track)

-- @donation https://www.paypal.com/ncp/payment/S8C8GEXK68TNC

-- @website https://forum.cockos.com/showthread.php?t=291067

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

local extStateSection = "MyCustomScript"
local extStateKey = "isCommandsActive"
local cmdSNMInputAllCh = reaper.NamedCommandLookup("_S&M_MIDI_INPUT_ALL_CH")
local cmdSNMMapInputCh1 = reaper.NamedCommandLookup("_S&M_MAP_MIDI_INPUT_CH1")

function get_midi_editor_state()
  local midi_editor = reaper.MIDIEditor_GetActive()
  local is_me_open, is_me_closed, is_me_docked = false, false, false
  
  if not midi_editor then
      is_me_closed = true
  else
      is_me_open = true
      local is_docked_value = reaper.DockIsChildOfDock(midi_editor)
      if is_docked_value > 0 then
          is_me_docked = true
      end
  end
  
  local current_state = ""

  if is_me_open and is_me_docked then
      current_state = "docked"
      -- reaper.ShowConsoleMsg("d")
  elseif is_me_open then
      current_state = "open"
      -- reaper.ShowConsoleMsg("o")
  elseif is_me_closed and not is_me_docked and not is_me_open then
      current_state = "closed"
      -- reaper.ShowConsoleMsg("c")
  end

  if current_state ~= previous_state then
      previous_state = current_state
  end
  
  return is_me_open, is_me_closed, is_me_docked
end

function RunCommands()

  local state
  
  state = reaper.GetToggleCommandState(40740)
  if state ~= 1 then reaper.Main_OnCommand(40740, 0) end
  
  state = reaper.GetToggleCommandState(40637)
  if state ~= 1 then reaper.Main_OnCommand(40637, 0) end
  
  state = reaper.GetToggleCommandState(40377)
  if state ~= 1 then reaper.Main_OnCommand(40377, 0) end
  
  
  reaper.Main_OnCommand(cmdSNMInputAllCh, 0)
  reaper.Main_OnCommand(cmdSNMMapInputCh1, 0)
end


function ToggleCommands()
  
  reaper.Main_OnCommand(40740, 0)
  reaper.Main_OnCommand(40637, 0)
  reaper.Main_OnCommand(40377, 0)
  reaper.Main_OnCommand(cmdSNMInputAllCh, 0)
  reaper.Main_OnCommand(cmdSNMMapInputCh1, 0)
end


function SetScriptState(state)
  reaper.SetExtState(extStateSection, extStateKey, tostring(state), false)
end


function GetScriptState()
  return reaper.GetExtState(extStateSection, extStateKey) == "true"
end

function focusMidiEditor()
  local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
  reaper.Main_OnCommand(focus_midi_editor, 0)
end

function main()
  local is_me_open, is_me_closed, is_me_docked = get_midi_editor_state()

  if not GetScriptState() then
    RunCommands()
    SetScriptState(true)
    reaper.MB("Piano mode is on", "Academic Piano", 0)

    if is_me_open then
      focusMidiEditor()
    end

  else
    RunCommands()
    ToggleCommands()
    SetScriptState(false)
    reaper.MB("Piano mode is off", "Academic Piano", 0)

    if is_me_open then
      focusMidiEditor()
    end
  end


  reaper.UpdateArrange()
end

main()
