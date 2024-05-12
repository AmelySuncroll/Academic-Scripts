--[[

  ReaScript Name: Convert item notes to regions
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: my own script I created when don't knew about others.


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

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
