--[[

-- @description Academic Articulations
-- @author Amely Suncroll
-- @version 1.04
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + v1.02 add text events (type: marker)
--    + v1.03 add pop-up menu
--    + v1.04 add auto-refresh text events (type: marker)
-- @screenshot none
-- @about Set acticulations by note names you've set before
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

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
      local noteName = reaper.GetTrackMIDINoteNameEx(proj, track, pitch, chan)
      if noteName ~= "" then
          table.insert(noteNames, noteName)
      end
  end
  return noteNames
end

function getSelectedNoteRange(take)
  local minStart, maxEnd = nil, nil
  local retval, notecnt = reaper.MIDI_CountEvts(take)
  for i = 0, notecnt - 1 do
      local retval, selected, muted, startppq, endppq = reaper.MIDI_GetNote(take, i)
      if selected then
          if minStart == nil or startppq < minStart then minStart = startppq end
          if maxEnd == nil or endppq > maxEnd then maxEnd = endppq end
      end
  end
  if not minStart or not maxEnd then
      reaper.ShowMessageBox("No notes are selected!", ":(", 0)
      return nil, nil
  end
  return minStart, maxEnd
end

function insertArticulationAndMarker(take, minStart, userNoteName)
  local ppqLength = 5 -- leight of articulate note (here is PPQ leight)
  local proj = reaper.EnumProjects(-1, "")
  local track = reaper.GetMediaItem_Track(reaper.GetMediaItemTake_Item(take))
  local chan = 0
  local noteInserted = false
  userNoteName = string.lower(userNoteName) 
  
  for pitch = 0, 127 do
      local noteName = reaper.GetTrackMIDINoteNameEx(proj, track, pitch, chan)
      if noteName then
        noteName = string.lower(noteName)  
        if string.find(noteName, userNoteName, 1, true) then

          reaper.MIDI_InsertNote(
                                        take,
                                        false, -- select inserting note
                                        false,
                                        minStart - 1, -- start articulation one pixel before note selection
                                        minStart - 1 + ppqLength,    -- leight = minStart + PPQ you set before
                                        --maxEnd - 2,                -- leight of articulate note (here is until selected notes)
                                        chan,
                                        pitch,
                                        1,
                                        true
                    )

      --[[reaper.MIDI_InsertTextSysexEvt(                            -- contain this function to turn off it --[[ function(bla, bla, bla) 
                                        take,
                                        false, -- select event
                                        false,
                                        minStart - 1, -- start articulation one pixel before note selection
                                        6,       -- type (Marker)
                                        noteName -- text (articulation name)
                ) ]]--
                
          noteInserted = true
          break
        end
      end
  end
  if not noteInserted then
      reaper.ShowMessageBox("No note name containing '" .. userNoteName .. "' found. Please try again.", ":(", 0)
  end
  return noteInserted
end

function showArticulationMenu(noteNames)
  local menuStr = ""
  for i, name in ipairs(noteNames) do
      menuStr = menuStr .. name .. "|"
  end

  local x, y = reaper.GetMousePosition()
  gfx.init("", 0, 0, 0, x, y)

  local userChoice = gfx.showmenu(menuStr)
  gfx.quit()  

  -- Проверяем выбор пользователя
  if userChoice > 0 then
      return noteNames[userChoice]
  else
      return nil
  end
end

function getActiveMIDITake()
  local midiEditor = reaper.MIDIEditor_GetActive()
  if not midiEditor then
      reaper.ShowMessageBox("No active MIDI editor found.", ":(", 0)
      return nil
  end

  local take = reaper.MIDIEditor_GetTake(midiEditor)
  if not take or not reaper.TakeIsMIDI(take) then
      reaper.ShowMessageBox("No active MIDI take found.", ":(", 0)
      return nil
  end
  return take
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

function createTextMarkersForNotes(take, noteData)
  for _, noteInfo in ipairs(noteData) do
      if noteInfo.name then  -- Make sure we have a valid name before attempting to insert it
          reaper.MIDI_InsertTextSysexEvt(
              take,
              false, -- do not select
              false, -- not muted
              noteInfo.ppq, -- PPQ position of the note
              6, -- type 6 for marker
              noteInfo.name -- marker text
          )
      end
  end
end

function deleteTextEvents(take)
  local _, _, _, textsyxevtcnt = reaper.MIDI_CountEvts(take)
  for i = textsyxevtcnt - 1, 0, -1 do
      reaper.MIDI_DeleteTextSysexEvt(take, i)
  end
end

function mainForRefreshTextEvents()
  local take = getActiveMIDITake()
  if not take then return end

  --deleteTextEvents(take)

  local noteData = getAllNoteNamesAndPositions(take)
  if #noteData == 0 then
      reaper.ShowMessageBox("No named notes found in the active take.", "Info", 0)
      return
  end

  createTextMarkersForNotes(take, noteData)
  reaper.MIDI_Sort(take)
end



function main()
  local take = getActiveMIDITake()
  if not take then return end

  local noteNames = getAvailableNoteNames(take)
  if #noteNames == 0 then
      reaper.ShowMessageBox("No named notes available for articulation.", ":(", 0)
      return
  end

  local userNoteName = showArticulationMenu(noteNames)
  if not userNoteName then return end

  local minStart, maxEnd = getSelectedNoteRange(take)
  if not minStart or not maxEnd then return end

  local success = insertArticulationAndMarker(take, minStart, userNoteName)
  if not success then
      reaper.ShowMessageBox("Failed to insert articulation. Please try again.", ":(", 0)
      return
  end

  reaper.Undo_BeginBlock()
  deleteTextEvents(take)
  reaper.Undo_EndBlock("Delete All Midi Text Events", -1)

  reaper.MIDIEditor_LastFocused_OnCommand(40370, false) -- switch cc lane to text events

  reaper.Undo_BeginBlock()
  mainForRefreshTextEvents()
  reaper.Undo_EndBlock("Create New Midi Text Events", -1)
end

function focusMidiEditor()
  local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
  reaper.Main_OnCommand(focus_midi_editor, 0)
end

reaper.Undo_BeginBlock()
main()
focusMidiEditor()
reaper.Undo_EndBlock("Insert Articulation", -1)
