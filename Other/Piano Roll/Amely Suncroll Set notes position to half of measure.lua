--[[

  ReaScript Name: Set notes position to half of each measure
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: set notes position to half of each measure.


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

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
                local measureEnd = reaper.MIDI_GetPPQPos_EndOfMeasure(take, startppqpos)
                local halfMeasure = measureStart + ((measureEnd - measureStart) / 2)
                local newPos = startppqpos < halfMeasure and measureStart or halfMeasure
                reaper.MIDI_SetNote(take, i, selected, false, newPos, newPos + (endppqpos - startppqpos), chan, pitch, vel, true)
            end
        end

        reaper.MIDI_Sort(take)
        reaper.UpdateItemInProject(selectedItem)
    end
end

reaper.UpdateArrange()
