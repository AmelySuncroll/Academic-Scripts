-- @description Auto Aim Item (two in one)
-- @author Amely Suncroll
-- @version 3.01
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + 2.0 add toggle script
--    + 3.0 add link edit cursor to start, middle or end of the item
--    + 3.01 fix not glue cursor while stretch item
-- @about Glue edit cursor to start, mouse position or end of selected item. It has the main script and the switch scriipt. Best solution for working with foleys.

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
local call_count_identifier = main_script_identifier .. "_CallCount"
local last_call_time_identifier = main_script_identifier .. "_LastCallTime"
local zone_start_percentage = 0.05 -- first X% (5% = 0.05) of item
local zone_end_percentage = 0.05 -- last X% (5% = 0.05) of item

function MoveEditCursorToPoint()
    reaper.BR_GetMouseCursorContext()

    local item = reaper.GetSelectedMediaItem(0, 0)
    if not item then
        return
    end

    local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    local mouse_pos = reaper.BR_GetMouseCursorContext_Position()
    local relative_pos = (mouse_pos - item_pos) / item_length

    if relative_pos <= zone_start_percentage then
        reaper.SetEditCurPos(item_pos, true, false)
        tracking_mouse_pos = 0 -- glue edit cursor to start of item
        tracking_item = item
        is_tracking = true
    elseif relative_pos >= (1 - zone_end_percentage) then
        reaper.SetEditCurPos(item_pos + item_length, true, false)
        tracking_mouse_pos = 1 -- glue edit cursor to end of item
        tracking_item = item
        is_tracking = true
    else
        reaper.SetEditCurPos(mouse_pos, true, false)
        tracking_mouse_pos = relative_pos
        tracking_item = item
        is_tracking = true
    end

    local function keepCursorInSync()
        if not reaper.IsMediaItemSelected(item) then
            is_tracking = false
            return
        end

        local new_item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local new_item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local new_cursor_pos = new_item_pos + tracking_mouse_pos * new_item_length
        reaper.SetEditCurPos(new_cursor_pos, true, false)

        reaper.defer(keepCursorInSync)
    end

    reaper.defer(keepCursorInSync)
end

MoveEditCursorToPoint()
