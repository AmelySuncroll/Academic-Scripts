--[[

  ReaScript Name: Insert and edit marker at current edit cursor position in piano roll
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: insert and edit marker at current edit cursor position in piano roll.
  To edit marker set edit cursor near the marker and call the script again.


  Donations: 
  https://www.paypal.com/paypalme/suncroll
  if you are from russia - text me by links below

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]


local midiEditor = reaper.MIDIEditor_GetActive()
if midiEditor ~= nil then
    local currentPosition = reaper.GetCursorPosition()
    reaper.Main_OnCommand(40171, 0)
end