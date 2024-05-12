--[[

  ReaScript Name: Academic Piano
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  @Version: 1.0

  About: Play on your pc keyboard anywhere (you need to add this script to Arrange View (Main) and Piano Roll Actions separately)

  IF YOU HAVE NO SOUND:
  1. Click right mouse on Virtual MIDI Keyboard (VKB) and check 
  "Send all keyboard input to VKB (even when other windows active)";

  2. Be sure your MIDI-channel on VKB is set to 01 (check right virtual keyboard corner);

  3 Be sure your MIDI-channel in your VST is set to 01 or "omni".

  4.1 Check your preferences - Project - Track/Send Defaults - Record config: "MIDI: Virtual MIDI keyboard: All channels"
  or
  4.2 Click on input part of track - Input: MIDI - Virtual MIDI keyboard - All channels (this option is local to selected track)



  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

local extStateSection = "MyCustomScript"
local extStateKey = "isCommandsActive"
local cmdSNMInputAllCh = reaper.NamedCommandLookup("_S&M_MIDI_INPUT_ALL_CH")
local cmdSNMMapInputCh1 = reaper.NamedCommandLookup("_S&M_MAP_MIDI_INPUT_CH1")

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

if not GetScriptState() then
  RunCommands()
  SetScriptState(true)
  reaper.MB("Piano mode is on", "Academic Piano", 0)
else
  RunCommands()
  ToggleCommands()
  SetScriptState(false)
  reaper.MB("Piano mode is off", "Academic Piano", 0)
end

reaper.UpdateArrange()
