-- @description Set notes position to start of each measure
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Set notes position to start of each measure

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- amelysuncroll@gmail.com


local project = reaper.EnumProjects(-1, "")
local selectedItem = reaper.GetSelectedMediaItem(project, 0)

if selectedItem then
    local take = reaper.GetActiveTake(selectedItem)
    
    if reaper.TakeIsMIDI(take) then
        reaper.MIDI_DisableSort(take)

        local _, notecnt = reaper.MIDI_CountEvts(take)
        
        for i = 0, notecnt-1 do
            local _, selected, _, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
            
            if selected then
                local measureStart = reaper.MIDI_GetPPQPos_StartOfMeasure(take, startppqpos)
        
                reaper.MIDI_SetNote(take, i, selected, false, measureStart, measureStart + (endppqpos - startppqpos), chan, pitch, vel, true)
            end
        end
        
        reaper.MIDI_Sort(take)
        reaper.UpdateItemInProject(selectedItem)
    end
end

reaper.UpdateArrange()
