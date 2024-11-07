-- @description Create new folder with selected tracks or move them to existing folder or track
-- @author Amely Suncroll
-- @version 1.1
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + v.1.1 add track folder height lock
-- @about Select tracks and call the script. If you type "DRUMS" but you have this track or folder already - all selected tracks will move there
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll
-- https://www.youtube.com/@yxo_composer

local script_title = "Create new folder with selected tracks or move them to existing folder or track"
reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local min_height = 24  -- minimal height folder, depends by your theme


local retval, folder_name = reaper.GetUserInputs("Create Folder from Selected Tracks ...", 1, "... or move to already existing:", "")
if not retval then
    reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock(script_title, -1)
    return
end

local track_count = reaper.CountTracks(0)
local existing_folder_track = nil

for i = 0, track_count - 1 do
    local track = reaper.GetTrack(0, i)
    local _, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    if track_name == folder_name and string.match(track_name, "%S") then
        existing_folder_track = track
        break
    end
end

if existing_folder_track then
    reaper.SetMediaTrackInfo_Value(existing_folder_track, "I_HEIGHTOVERRIDE", min_height)
    reaper.SetMediaTrackInfo_Value(existing_folder_track, "B_HEIGHTLOCK", 1)         -- to unlock track height set 0
    local start_index = reaper.GetMediaTrackInfo_Value(existing_folder_track, "IP_TRACKNUMBER")
    reaper.ReorderSelectedTracks(start_index, 1)
    reaper.SetOnlyTrackSelected(existing_folder_track)
else
    local first_sel_track = reaper.GetSelectedTrack(0, 0)
    if not first_sel_track then
        reaper.PreventUIRefresh(-1)
        reaper.Undo_EndBlock(script_title, -1)
        return
    end

    local idx = reaper.GetMediaTrackInfo_Value(first_sel_track, "IP_TRACKNUMBER") - 1
    reaper.InsertTrackAtIndex(idx, true)

    local new_folder_track = reaper.GetTrack(0, idx)
    reaper.GetSetMediaTrackInfo_String(new_folder_track, "P_NAME", folder_name, true)
    reaper.SetMediaTrackInfo_Value(new_folder_track, "I_HEIGHTOVERRIDE", min_height)
    reaper.SetMediaTrackInfo_Value(new_folder_track, "B_HEIGHTLOCK", 1)              -- to unlock track height set 0

    reaper.ReorderSelectedTracks(idx + 1, 1)

    local last_track_idx = idx + reaper.CountSelectedTracks(0)
    local last_track = reaper.GetTrack(0, last_track_idx)
    --reaper.SetMediaTrackInfo_Value(new_folder_track, "I_FOLDERDEPTH", 1) -- Set as start of folder
    reaper.SetMediaTrackInfo_Value(last_track, "I_FOLDERDEPTH", -1) -- Set as end of folder
    reaper.SetOnlyTrackSelected(new_folder_track)
end

reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock(script_title, -1)
