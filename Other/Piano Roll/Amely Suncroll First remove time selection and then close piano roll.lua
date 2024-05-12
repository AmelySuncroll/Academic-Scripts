--[[

  ReaScript Name: First remove time selection and then close piano roll
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: first remove time selection and then close piano roll. If no time selection then just close piano roll. 
  Set this script to ESC or other button.


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
if midiEditor ~= nil then
    local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    if startTime < endTime then
        reaper.MIDIEditor_OnCommand(midiEditor, 40745)
    else
        reaper.MIDIEditor_OnCommand(midiEditor, 2)
    end
end
