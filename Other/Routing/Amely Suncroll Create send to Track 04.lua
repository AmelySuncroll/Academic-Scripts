-- @description Create send to Track 04
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + add track number to header
-- @about Create send to the FOURTH track (include folders)

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

local retval, sendVolume_dB_str = reaper.GetUserInputs("Set Send Volume to Track 04", 1, "Send Volume in dB:", "0.00")
if not retval then return end

local sendVolume_dB = tonumber(sendVolume_dB_str)
if sendVolume_dB == nil then
    reaper.ShowMessageBox("Invalid volume level. Please enter a numeric value.", ":(", 0)
    return
end

local firstTrack = reaper.GetTrack(0, 3) 

if firstTrack then
    local _, firstTrackName = reaper.GetSetMediaTrackInfo_String(firstTrack, "P_NAME", "", false)
    local selectedTrackCount = reaper.CountSelectedTracks(0)

    if selectedTrackCount > 0 then
        for i = 0, selectedTrackCount - 1 do
            local selectedTrack = reaper.GetSelectedTrack(0, i)
            local _, selectedTrackName = reaper.GetSetMediaTrackInfo_String(selectedTrack, "P_NAME", "", false)

            if selectedTrack ~= firstTrack then
                local sendExists = false
                local numSends = reaper.GetTrackNumSends(selectedTrack, 0)
                for sendIndex = 0, numSends - 1 do
                    local destinationTrack = reaper.BR_GetMediaTrackSendInfo_Track(selectedTrack, 0, sendIndex, 1)
                    if destinationTrack == firstTrack then
                        sendExists = true
                        break
                    end
                end

                if sendExists then
                    reaper.ShowMessageBox("A send from " .. selectedTrackName .. " to " .. firstTrackName .. " already exists.", ":(", 0)
                else
                    local sendIndex = reaper.CreateTrackSend(selectedTrack, firstTrack)
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
    reaper.ShowMessageBox("First track not found.", ":(", 0)
end
