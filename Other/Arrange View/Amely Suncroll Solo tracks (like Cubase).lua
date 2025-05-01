-- @description Solo tracks (like Cubase)
-- @author Amely Suncroll
-- @version 1.1
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

    local function is_any_child_soloed(folder_track)
        local total_tracks = reaper.CountTracks(0)
        local start_idx = reaper.GetMediaTrackInfo_Value(folder_track, "IP_TRACKNUMBER")
        local depth = 1
        
        for i = start_idx, total_tracks - 1 do
            local track = reaper.GetTrack(0, i)
            local folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")

            if reaper.GetMediaTrackInfo_Value(track, "I_SOLO") ~= 0 then
                return true
            end

            depth = depth + folder_depth
            if depth <= 0 then break end
        end
        
        return false
    end

    local function tog_solo_related(track)
        local is_solo = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
        local new_val = (is_solo == 0) and 1 or 0
        reaper.SetMediaTrackInfo_Value(track, "I_SOLO", new_val)

        local parent = reaper.GetParentTrack(track)

        while parent do
            if new_val == 1 then
                reaper.SetMediaTrackInfo_Value(parent, "I_SOLO", 1)
            else
                if not is_any_child_soloed(parent) then
                    reaper.SetMediaTrackInfo_Value(parent, "I_SOLO", 0)
                end
            end
            parent = reaper.GetParentTrack(parent)
        end

        local num_sends = reaper.GetTrackNumSends(track, 0)

        for i = 0, num_sends - 1 do
            local dest_track = reaper.BR_GetMediaTrackSendInfo_Track(track, 0, i, 1)
            if dest_track then
                reaper.SetMediaTrackInfo_Value(dest_track, "I_SOLO", new_val)
            end
        end

        local folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")

        if folder_depth == 1 then
            local total_tracks = reaper.CountTracks(0)
            local start_idx = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")
            local depth = 1

            for i = start_idx, total_tracks - 1 do
                local sub_track = reaper.GetTrack(0, i)
                local sub_depth = reaper.GetMediaTrackInfo_Value(sub_track, "I_FOLDERDEPTH")

                reaper.SetMediaTrackInfo_Value(sub_track, "I_SOLO", new_val)

                local num_sends = reaper.GetTrackNumSends(sub_track, 0)

                for j = 0, num_sends - 1 do
                    local dest_track = reaper.BR_GetMediaTrackSendInfo_Track(sub_track, 0, j, 1)
                    if dest_track then
                        reaper.SetMediaTrackInfo_Value(dest_track, "I_SOLO", new_val)
                    end
                end

                depth = depth + sub_depth
                if depth <= 0 then break end
            end
        end
    end

    for _, track in ipairs(selected_tracks) do
        tog_solo_related(track)
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
        for i = 0, track_count - 1 do
            local track = reaper.GetTrack(0, i)
            if reaper.GetMediaTrackInfo_Value(track, "I_SOLO") == 0 then
                reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 1)
            else
                reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 0)
            end
        end
    else
        for i = 0, track_count - 1 do
            local track = reaper.GetTrack(0, i)
            reaper.SetMediaTrackInfo_Value(track, "B_MUTE", 0)
        end
    end

    reaper.PreventUIRefresh(-1)
end

main()

