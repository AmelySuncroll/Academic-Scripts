-- @description Mute tracks (like Cubase)
-- @author Amely Suncroll
-- @version 1.0
-- @changelog
--    + init @

    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com



function track_recur(trackIndex, newMute)
    local trackCount = reaper.CountTracks(0)
    local track = reaper.GetTrack(0, trackIndex)
    reaper.SetMediaTrackInfo_Value(track, "B_MUTE", newMute)
    local folderDepth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")

    if folderDepth == 1 then
        local depthCounter = 1
        local i = trackIndex + 1
        
        while i < trackCount and depthCounter > 0 do
            local childTrack = reaper.GetTrack(0, i)
            reaper.SetMediaTrackInfo_Value(childTrack, "B_MUTE", newMute)

            local childDepth = reaper.GetMediaTrackInfo_Value(childTrack, "I_FOLDERDEPTH")
            depthCounter = depthCounter + childDepth
            
            i = i + 1
        end
    end
end

function main()
    local num_selected = reaper.CountSelectedTracks(0)
    if num_selected == 0 then return end

    local selected_tracks = {}

    for i = 0, num_selected - 1 do
        local tr = reaper.GetSelectedTrack(0, i)
        table.insert(selected_tracks, tr)
    end

    for _, track in ipairs(selected_tracks) do
        local trackIndex = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER") - 1
        local is_muted = reaper.GetMediaTrackInfo_Value(track, "B_MUTE")
        local newMuteState = (is_muted == 0) and 1 or 0
        
        track_recur(trackIndex, newMuteState)
    end

    local track_count = reaper.CountTracks(0)
    local any_muted = false

    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)

        if reaper.GetMediaTrackInfo_Value(track, "B_MUTE") ~= 0 then
            any_muted = true break
        end
    end

    if any_muted then
        reaper.PreventUIRefresh(1)

        for i = 0, track_count - 1 do
            local track = reaper.GetTrack(0, i)

            if reaper.GetMediaTrackInfo_Value(track, "B_MUTE") == 0 then
                reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 1)
            else
                reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 0)
            end
        end

        reaper.PreventUIRefresh(-1)
    else
        reaper.PreventUIRefresh(1)

        for i = 0, track_count - 1 do
            local track = reaper.GetTrack(0, i)
            reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 0)
        end

        reaper.PreventUIRefresh(-1)
    end
end

main()
