-- @description Convert item notes to regions
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about My own script I created when don't knew about others
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll
-- https://www.youtube.com/@yxo_composer

local item_count = reaper.CountSelectedMediaItems(0)

if item_count > 0 then
    reaper.Undo_BeginBlock()

    for i = 0, item_count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local item_end = item_start + item_length
        local _, item_note = reaper.GetSetMediaItemInfo_String(item, "P_NOTES", "", false)

        if item_note ~= "" then
            reaper.AddProjectMarker2(0, true, item_start, item_end, item_note, -1, 0)
        end
    end

    reaper.Undo_EndBlock("Convert Item Notes to Regions", -1)
else
    reaper.ShowMessageBox("No items selected.", "Error", 0)
end
