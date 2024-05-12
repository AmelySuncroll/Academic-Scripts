-- @description Create send to ROOM
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Create send to folder named 'ROOM' (you can change name inside the code)

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll
-- https://www.youtube.com/@yxo_composer

function dBToSlider(dB)
    return 10 ^ (dB / 20)
end

local targetTrackName = "Room"  -- change it to "Delay", "Room", "Stage" or other track names you want

local retval, sendVolume_dB_str = reaper.GetUserInputs("Set Send Volume", 1, "Send Volume in dB:", "0.00")
if not retval then return end

local sendVolume_dB = tonumber(sendVolume_dB_str)
if sendVolume_dB == nil then
    reaper.ShowMessageBox("Invalid volume level. Please enter a numeric value.", ":(", 0)
    return
end

function findTrackByNameIgnoreCase(trackName)
    local trackCount = reaper.CountTracks(0)
    for i = 0, trackCount - 1 do
        local track = reaper.GetTrack(0, i)
        local _, currentTrackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        if currentTrackName:lower() == trackName:lower() then
            return track
        end
    end
    return nil
end

function sendExists(selectedTrack, targetTrack)
    local numSends = reaper.GetTrackNumSends(selectedTrack, 0)
    for sendIndex = 0, numSends - 1 do
        local destinationTrack = reaper.BR_GetMediaTrackSendInfo_Track(selectedTrack, 0, sendIndex, 1)
        if destinationTrack == targetTrack then
            return true
        end
    end
    return false
end

local targetTrack = findTrackByNameIgnoreCase(targetTrackName)

if targetTrack then
    local selectedTrackCount = reaper.CountSelectedTracks(0)
    if selectedTrackCount > 0 then
        for i = 0, selectedTrackCount - 1 do
            local selectedTrack = reaper.GetSelectedTrack(0, i)
            local _, selectedTrackName = reaper.GetSetMediaTrackInfo_String(selectedTrack, "P_NAME", "", false)

            if selectedTrack ~= targetTrack then
                if sendExists(selectedTrack, targetTrack) then
                    reaper.ShowMessageBox("A send from " .. selectedTrackName .. " to " .. targetTrackName .. " already exists.", ":(", 0)
                else
                    local sendIndex = reaper.CreateTrackSend(selectedTrack, targetTrack)
                    local sendVolume = dBToSlider(sendVolume_dB)
                    reaper.SetTrackSendInfo_Value(selectedTrack, 0, sendIndex, "D_VOL", sendVolume)
                end
            else
                reaper.ShowMessageBox(selectedTrackName .. " cannot be sent to itself.", ":(", 0)
            end
        end
    else
        reaper.ShowMessageBox("Please select one or more tracks.", ":(", 0)
    end
else
    reaper.ShowMessageBox("Track named '" .. targetTrackName .. "' not found.", ":(", 0)
end
