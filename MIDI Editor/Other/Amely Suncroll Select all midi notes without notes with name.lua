-- @description Select all midi notes without notes with name
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Select all midi notes without notes with name

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- amelysuncroll@gmail.com

function getActiveMIDITake()
    local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
    if not take or not reaper.TakeIsMIDI(take) then
        reaper.ShowMessageBox("No active MIDI", ":(", 0)
        return nil
    end
    return take
  end
  
function getAvailableNoteNames(take)
  local item = reaper.GetMediaItemTake_Item(take)
  local track = reaper.GetMediaItem_Track(item)
  local proj = reaper.EnumProjects(-1, "")
  local chan = 0  -- Assuming channel 0 for simplicity
  local noteNames = {}
  for pitch = 0, 127 do
      if track then
          local noteName = reaper.GetTrackMIDINoteNameEx(proj, track, pitch, chan)
          if noteName ~= "" then
              table.insert(noteNames, noteName)
          end
      end
  end
  return noteNames
end
  

  
function getAllNoteNamesAndPositions(take)
  local noteData = {}
  local _, notecnt = reaper.MIDI_CountEvts(take)
  local item = reaper.GetMediaItemTake_Item(take)  
  local track = reaper.GetMediaItem_Track(item)    
  local proj = reaper.EnumProjects(-1, "")
  local chan = 0 -- Assuming channel 0 for simplicity
  for i = 0, notecnt - 1 do
      local _, _, _, startppq, _, _, pitch, _ = reaper.MIDI_GetNote(take, i)
      local noteName = reaper.GetTrackMIDINoteNameEx(proj, track, pitch, chan)
      if noteName ~= "" then
          table.insert(noteData, {name = noteName, ppq = startppq})
      end
  end
  return noteData
end
  
  
  
function main()
    local take = getActiveMIDITake()
    if not take then return end

    local noteNames = getAvailableNoteNames(take)
    local customNoteNames = {}
    for _, name in ipairs(noteNames) do
        customNoteNames[name] = true
    end

    local _, notecnt = reaper.MIDI_CountEvts(take)
    reaper.MIDI_DisableSort(take)
    for i = 0, notecnt - 1 do
        local _, selected, _, startppq, endppq, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
        local item = reaper.GetMediaItemTake_Item(take)
        if item then
            local track = reaper.GetMediaItem_Track(item)
            if track then
                local noteName = reaper.GetTrackMIDINoteNameEx(nil, track, pitch, chan)
                if not customNoteNames[noteName] then
                    reaper.MIDI_SetNote(take, i, true, nil, startppq, endppq, chan, pitch, vel, false)
                end
            end
        end
    end
    reaper.MIDI_Sort(take)
end
  
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Smart selection without note with names", -1)
