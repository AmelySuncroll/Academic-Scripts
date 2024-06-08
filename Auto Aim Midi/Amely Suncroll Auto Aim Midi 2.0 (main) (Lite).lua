--[[

  ReaScript Name: Auto Aim Midi (main)
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 2.0 (lite)

  About: An exact copy of the Auto Aim Item 2.0 script, but applied to items. 
  The kit consists of two components - the "main" and the so-called "switch", or "toggle". 
  When you run the "main", it starts running in the background, while the "toggle" at this time 
  changes the edit cursor binding of the selected note to its beginning or end. 
  Once you're done with your work, simply turn off the main part of the script from the background. 
         
  I recommend use "toggle" script as a mouse modifier to easy to use:
  Options - Preferences - Mouse Modifiers - MIDI Note - Double Click - Default Action - Action list
    

  Donations: 
  https://www.paypal.com/paypalme/suncroll
  if you are from russia - text me by links below

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]

local useEndOfNote = false

local script_identifier = "_MyScriptToggle"
local mode_identifier = script_identifier .. "_Mode"

function ToggleCursorBindingMode()
    useEndOfNote = not useEndOfNote
end

function GetCursorBindingMode()
    return reaper.GetExtState(script_identifier, mode_identifier) == "End"
end

function MoveEditCursorToSelectedMIDIEvents()
    local useEndOfNote = GetCursorBindingMode()
    local commandId = useEndOfNote and 40873 or 40872
    reaper.MIDIEditor_LastFocused_OnCommand(commandId, false)
end

local script_identifier = "_MyScriptToggle"

local function IsScriptToggledOn()
    return reaper.GetExtState(script_identifier, "Running") == "1"
end

local function SetScriptToggle(state)
    if state then
        reaper.SetExtState(script_identifier, "Running", "1", false)
    else
        reaper.DeleteExtState(script_identifier, "Running", false)
    end
end

local last_time = reaper.time_precise()

function Main()
    local current_time = reaper.time_precise()
    if current_time - last_time >= 0.5 then 
        MoveEditCursorToSelectedMIDIEvents()
        last_time = current_time
    end
    
    reaper.defer(Main)
end

function Exit()
    reaper.MB("Script terminated", "Auto Aim Midi 2.0", 0)
    SetScriptToggle(false)
end

if not IsScriptToggledOn() then
    reaper.MB("Script working", "Auto Aim Midi 2.0", 0)
    SetScriptToggle(true)
    reaper.defer(Main)
else
    Exit()
end

reaper.atexit(Exit)
