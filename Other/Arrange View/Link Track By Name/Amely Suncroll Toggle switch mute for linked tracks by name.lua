--[[

  ReaScript Name: Toggle switch mute for linked track by name
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: use "Create a link by cross name" to make a link between two tracks by their name. 
  Then call this scripts and then try to set mute on one of two that tracks. And again.


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

local is_running = false

-- Определение функции Exit
local function Exit()
  is_running = false
  reaper.ShowMessageBox("Script stopped.", "Switch MUTE for linked tracks", 0)
end

local function get_track_name(track)
    local _, name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    return name
end

local function find_linked_tracks_by_name()
    local track_count = reaper.CountTracks(0)
    local linked_tracks = {}
    local processed_tracks = {}  

    for i = 0, track_count - 1 do
        local track1 = reaper.GetTrack(0, i)
        if not processed_tracks[track1] then
            local name1 = get_track_name(track1)
            local main_name1, link_name1 = name1:match("^(.-)               %[(.-)%]$")

            if main_name1 and link_name1 then
                for j = 0, track_count - 1 do
                    local track2 = reaper.GetTrack(0, j)
                    if track1 ~= track2 and not processed_tracks[track2] then
                        local name2 = get_track_name(track2)
                        local main_name2, link_name2 = name2:match("^(.-)               %[(.-)%]$")

                        if main_name2 and link_name2 and main_name1 == link_name2 and main_name2 == link_name1 then
                            linked_tracks[#linked_tracks + 1] = {track1, track2}
                            processed_tracks[track1] = true
                            processed_tracks[track2] = true
                            break
                        end
                    end
                end
            end
        end
    end

    return linked_tracks
end

local previous_mute_state = {}

local function monitor_and_sync_mute_states()
    if not is_running then return end

    local linked_tracks = find_linked_tracks_by_name()

    for _, pair in ipairs(linked_tracks) do
        local track1, track2 = pair[1], pair[2]
        local is_muted1 = reaper.GetMediaTrackInfo_Value(track1, "B_MUTE") > 0
        local is_muted2 = reaper.GetMediaTrackInfo_Value(track2, "B_MUTE") > 0
        local pair_id = tostring(track1) .. "-" .. tostring(track2)  

        if previous_mute_state[pair_id] == nil then
            previous_mute_state[pair_id] = {is_muted1, is_muted2}
        end

        if is_muted1 ~= previous_mute_state[pair_id][1] or is_muted2 ~= previous_mute_state[pair_id][2] then
            if is_muted1 ~= previous_mute_state[pair_id][1] then
                reaper.SetMediaTrackInfo_Value(track2, "B_MUTE", is_muted1 and 0 or 1)
            else
                reaper.SetMediaTrackInfo_Value(track1, "B_MUTE", is_muted2 and 0 or 1)
            end

            previous_mute_state[pair_id] = {reaper.GetMediaTrackInfo_Value(track1, "B_MUTE") > 0, reaper.GetMediaTrackInfo_Value(track2, "B_MUTE") > 0}
        end
    end

    if is_running then
        reaper.defer(monitor_and_sync_mute_states) 
    end
end




local function main()
    local selected_track_count = reaper.CountSelectedTracks(0)

    if not is_running then
        is_running = true
        monitor_and_sync_mute_states()
        reaper.ShowMessageBox("Script working", "Switch MUTE for linked tracks", 0)
    else
        Exit()
    end
end

reaper.atexit(Exit)

main()
