-- @description Select all notes after edit cursor
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Select all notes after edit cursor
-- inspired by DaVinci Resolve

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- amelysuncroll@gmail.com

local cursor_pos = reaper.GetCursorPosition()

local item_count = reaper.CountSelectedMediaItems(0)
for i = 0, item_count - 1 do
    local item = reaper.GetSelectedMediaItem(0, i)
    local take = reaper.GetActiveTake(item)
    if reaper.TakeIsMIDI(take) then
        local note_count = reaper.MIDI_CountEvts(take)
        for j = 0, note_count - 1 do
            local retval, selected, muted, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take, j)
            local note_start_time = reaper.MIDI_GetProjTimeFromPPQPos(take, startppq)
            if note_start_time >= cursor_pos then
                reaper.MIDI_SetNote(take, j, true, muted, startppq, endppq, chan, pitch, vel, false)
            end
        end
    end
end


reaper.UpdateArrange()
