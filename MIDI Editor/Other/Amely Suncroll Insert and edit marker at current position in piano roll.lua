-- @description Insert and edit marker at current position in piano roll
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Insert and edit marker at current position in piano roll

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll
-- https://www.youtube.com/@yxo_composer


local midiEditor = reaper.MIDIEditor_GetActive()
if midiEditor ~= nil then
    local currentPosition = reaper.GetCursorPosition()
    reaper.Main_OnCommand(40171, 0)
end
