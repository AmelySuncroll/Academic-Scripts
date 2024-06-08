-- @description Auto Aim Item (main)
-- @author Amely Suncroll
-- @version 3.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + 2.0 add toggle script
--    + 3.0 add link edit cursor to start, middle or end of the item
-- @about Glue edit cursor to start , mouse position or end of selected item. It has the main script and the switch scriipt. Best solution for working with foleys.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

local script_identifier = "_AmelySuncrollAutoAimItem30Toggle"
local mode_identifier = script_identifier .. "_Mode"

function GetCursorBindingMode()
    return reaper.GetExtState(script_identifier, mode_identifier)
end

function MoveEditCursorToSelectedItems()
    local mode = GetCursorBindingMode()
    local item = reaper.GetSelectedMediaItem(0, 0)
    if not item then
        return
    end

    local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    local cursor_pos

    if mode == "Start" then
        cursor_pos = item_pos
    elseif mode == "End" then
        cursor_pos = item_pos + item_length
    elseif mode == "Mouse" then
        local relative_pos = tonumber(reaper.GetExtState(script_identifier, "RelativePos"))
        if relative_pos then
            cursor_pos = item_pos + relative_pos * item_length
        else
            cursor_pos = item_pos
        end
    else
        cursor_pos = item_pos
    end

    reaper.SetEditCurPos(cursor_pos, true, false)
end

local script_identifier_toggle = "_MyScriptToggle"

local function IsScriptToggledOn()
    return reaper.GetExtState(script_identifier_toggle, "Running") == "1"
end

local function SetScriptToggle(state)
    if state then
        reaper.SetExtState(script_identifier_toggle, "Running", "1", false)
    else
        reaper.DeleteExtState(script_identifier_toggle, "Running", false)
    end
end

local last_time = reaper.time_precise()

function Main()
    local current_time = reaper.time_precise()
    if current_time - last_time >= 0.01 then  -- change it to 0.1 to slow, to 0.5 to very slow or to 0.001 to ultra fast
        MoveEditCursorToSelectedItems()
        last_time = current_time
    end

    reaper.defer(Main)
end

function Exit()
    reaper.MB("Script terminated", "Auto Aim Item 3.0", 0)
    SetScriptToggle(false)
end

if not IsScriptToggledOn() then
    reaper.MB("Script working", "Auto Aim Item 3.0", 0)
    SetScriptToggle(true)
    reaper.defer(Main)
else
    Exit()
end

reaper.atexit(Exit)