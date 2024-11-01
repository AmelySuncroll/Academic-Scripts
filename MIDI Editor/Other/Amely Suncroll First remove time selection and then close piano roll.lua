-- @description First remove time selection and then close piano roll
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about First remove time selection and then close piano roll

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com


local midiEditor = reaper.MIDIEditor_GetActive()
if midiEditor ~= nil then
    local startTime, endTime = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

    if startTime < endTime then
        reaper.MIDIEditor_OnCommand(midiEditor, 40745)
    else
        reaper.MIDIEditor_OnCommand(midiEditor, 2)
    end
end
