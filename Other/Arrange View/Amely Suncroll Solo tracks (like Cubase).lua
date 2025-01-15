-- @description Solo tracks (like Cubase)
-- @author Amely Suncroll
-- @version 1.0
-- @changelog
--    + init @

    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com


function main()
    local num_selected = reaper.CountSelectedTracks(0)
    if num_selected == 0 then return end

    local selected_tracks = {}
    for i = 0, num_selected - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        table.insert(selected_tracks, track)
    end

    local function tog_solo_parent(track)
        local is_solo = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
        local new_val = (is_solo == 0) and 1 or 0
        reaper.SetMediaTrackInfo_Value(track, "I_SOLO", new_val)

        if new_val == 1 then
            local parent = reaper.GetParentTrack(track)
            while parent ~= nil do
                reaper.SetMediaTrackInfo_Value(parent, "I_SOLO", 1)
                parent = reaper.GetParentTrack(parent)
            end
        else
            local parent = reaper.GetParentTrack(track)
            
            while parent ~= nil do
                reaper.SetMediaTrackInfo_Value(parent, "I_SOLO", 0)
                parent = reaper.GetParentTrack(parent)
            end
        end
    end

    for _, track in ipairs(selected_tracks) do
        tog_solo_parent(track)
    end

    local track_count = reaper.CountTracks(0)
    local any_soloed = false

    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)

        if reaper.GetMediaTrackInfo_Value(track, "I_SOLO") ~= 0 then
            any_soloed = true
            break
        end
    end

    reaper.PreventUIRefresh(1)

    if any_soloed then
        for i = 0, track_count -1 do
            local track = reaper.GetTrack(0, i)
            if reaper.GetMediaTrackInfo_Value(track, "I_SOLO") == 0 then
                reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 1)
            else
                reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 0)
            end
        end
    else
        for i = 0, track_count -1 do
            local track = reaper.GetTrack(0, i)
            reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 0)
        end
    end

    reaper.PreventUIRefresh(-1)
end

main()
