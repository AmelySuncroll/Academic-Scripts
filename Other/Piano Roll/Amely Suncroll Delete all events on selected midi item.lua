--[[

  ReaScript Name: Delete all events on selected midi item
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: get piano roll and call the script to delete all events such as velocity (will be 100), pitch etc


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--



local midiEditor = reaper.MIDIEditor_GetActive()

if not midiEditor then
  reaper.ShowMessageBox("No active MIDI editor found.", "Error", 0)
  return
end

local take = reaper.MIDIEditor_GetTake(midiEditor)

if not take or reaper.TakeIsMIDI(take) == false then
  reaper.ShowMessageBox("No active MIDI take found.", "Error", 0)
  return
end

reaper.Undo_BeginBlock()

local retval, notecnt, ccevtcnt, textsyxevtcnt = reaper.MIDI_CountEvts(take)
for i = 0, notecnt - 1 do
    local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(take, i)
    -- Set velocity to 100
    reaper.MIDI_SetNote(take, i, selected, muted, startppqpos, endppqpos, chan, pitch, 100, false)
end

for i = textsyxevtcnt - 1, 0, -1 do
  reaper.MIDI_DeleteTextSysexEvt(take, i)
end

for i = ccevtcnt - 1, 0, -1 do
  reaper.MIDI_DeleteCC(take, i)
end

reaper.Undo_EndBlock("Set velocity to 100 and delete non-note MIDI events", -1)

reaper.MIDIEditor_OnCommand(midiEditor, 40435) 
