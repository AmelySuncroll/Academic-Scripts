--[[

  ReaScript Name: Auto Aim Midi (toggle)
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 2.0

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
