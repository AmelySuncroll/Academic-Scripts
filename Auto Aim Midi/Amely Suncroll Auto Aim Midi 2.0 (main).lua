-- @description Auto Aim Midi (main)
-- @author Amely Suncroll
-- @version 2.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + 2.0 add toggle script

-- @about Glue edit cursor to start or end of selected note or notes. It has the main script and the switch scriipt. Best solution for working with foleys.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

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
    if current_time - last_time >= 0.01 then 
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
