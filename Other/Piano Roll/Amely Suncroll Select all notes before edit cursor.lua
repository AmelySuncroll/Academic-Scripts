--[[

  ReaScript Name: Select all notes before edit cursor
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: select all notes before edit cursor.


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

local cursor_pos = reaper.GetCursorPosition()

local item_count = reaper.CountSelectedMediaItems(0)
for i = 0, item_count - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    local take = reaper.GetActiveTake(item)
    if reaper.TakeIsMIDI(take) then
        local note_count = reaper.MIDI_CountEvts(take)
        for j = 0, note_count - 1 do
            local retval, selected, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take, j)
            local note_end_time = reaper.MIDI_GetProjTimeFromPPQPos(take, endppq)
            if note_end_time <= cursor_pos then
                reaper.MIDI_SetNote(take, j, true, muted, startppq, endppq, chan, pitch, vel, false)
            end
        end
    end
end

reaper.UpdateArrange()
