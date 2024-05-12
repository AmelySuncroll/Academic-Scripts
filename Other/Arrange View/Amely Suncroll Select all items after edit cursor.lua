--[[

  ReaScript Name: Select all items after edit cursor
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: Select all items after edit cursor.


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

local track_count = reaper.CountTracks(0)

for i = 0, track_count - 1 do
    local track = reaper.GetTrack(0, i)
    local item_count = reaper.CountTrackMediaItems(track)
    for j = 0, item_count - 1 do
        local item = reaper.GetTrackMediaItem(track, j)
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local edit_cursor_pos = reaper.GetCursorPosition()

        if item_start >= edit_cursor_pos then
            reaper.SetMediaItemSelected(item, true)
        end
    end
end

reaper.UpdateArrange()
