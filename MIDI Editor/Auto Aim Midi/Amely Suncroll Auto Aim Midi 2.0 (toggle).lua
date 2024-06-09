-- @description Auto Aim Midi (toggle)
-- @author Amely Suncroll
-- @version 2.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + 2.0 add toggle script

-- @about Glue edit cursor to start or end of selected note or notes. It has the main script and the switch scriipt. Best solution for working with foleys. \n \nAn exact copy of the Auto Aim Item 2.0 script, but applied to notes. The kit consists of two components - the "main" and the so-called "switch", or "toggle". When you run the "main", it starts running in the background, while the "toggle" at this time changes the edit cursor binding of the selected note to its beginning or end. Once you're done with your work, simply turn off the main part of the script from the background. I recommend use "toggle" script as a mouse modifier to easy to use: Options - Preferences - Mouse Modifiers - MIDI Note - Double Click - Default Action - Action list.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com  

local main_script_identifier = "_MyScriptToggle"
local mode_identifier = main_script_identifier .. "_Mode"

function ToggleCursorBindingMode()
    local currentMode = reaper.GetExtState(main_script_identifier, mode_identifier)
    if currentMode == "End" then
        reaper.SetExtState(main_script_identifier, mode_identifier, "Start", false)
        
    else
        reaper.SetExtState(main_script_identifier, mode_identifier, "End", false)
        
    end
end

ToggleCursorBindingMode()
