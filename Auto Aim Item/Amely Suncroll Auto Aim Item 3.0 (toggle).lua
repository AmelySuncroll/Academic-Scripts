-- @description Auto Aim Item (toggle)
-- @author Amely Suncroll
-- @version 3.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + 2.0 add toggle script
--    + 3.0 add link edit cursor to start, mouse position or end of the item
-- @about Glue edit cursor to start, mouse position or end of selected item. It has the main script and the switch scriipt. Best solution for working with foleys. \n \nAn exact copy of the Auto Aim Midi 2.0 script, but applied to items. The kit consists of two components - the "main" and the so-called "switch", or "toggle". When you run the "main", it starts running in the background, while the "toggle" at this time changes the edit cursor binding of the selected item to its beginning, mouse cursor position or end. Once you're done with your work, simply turn off the main part of the script from the background. I recommend use "toggle" script as a mouse modifier to easy to use: Options - Preferences - Mouse Modifiers - Media item bottom half - Double Click - Default Action - Action list.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

if not reaper.BR_GetMouseCursorContext then
  reaper.ShowMessageBox("SWS Extension is not installed", ":(", 0)
  return
end

local main_script_identifier = "_AmelySuncrollAutoAimItem30Toggle"
local mode_identifier = main_script_identifier .. "_Mode"

function ToggleCursorBindingMode()
    reaper.BR_GetMouseCursorContext()

    local item = reaper.GetSelectedMediaItem(0, 0)
    local currentMode = reaper.GetExtState(main_script_identifier, mode_identifier)

    if item then
        local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local mouse_pos = reaper.BR_GetMouseCursorContext_Position()

        if mouse_pos >= item_pos and mouse_pos <= (item_pos + item_length) then
            if currentMode == "Mouse" then
                reaper.SetExtState(main_script_identifier, mode_identifier, "End", false)
            elseif currentMode == "End" then
                reaper.SetExtState(main_script_identifier, mode_identifier, "Start", false)
            else
                local relative_pos = (mouse_pos - item_pos) / item_length
                reaper.SetExtState(main_script_identifier, "RelativePos", tostring(relative_pos), false)
                reaper.SetExtState(main_script_identifier, mode_identifier, "Mouse", false)
                reaper.SetEditCurPos(mouse_pos, true, false)
                return
            end
        end
    end

    if currentMode == "Start" then
        reaper.SetExtState(main_script_identifier, mode_identifier, "Mouse", false)
    elseif currentMode == "Mouse" then
        reaper.SetExtState(main_script_identifier, mode_identifier, "End", false)
    else
        reaper.SetExtState(main_script_identifier, mode_identifier, "Start", false)
    end
end

ToggleCursorBindingMode()
