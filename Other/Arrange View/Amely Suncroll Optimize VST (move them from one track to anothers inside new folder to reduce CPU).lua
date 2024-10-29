-- @description Optimize VST (move them from one track to anothers inside new folder to reduce CPU)
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @

-- @about Select track and type how many VST's do you want to place to each new track. If you have 10 VST's and you choose '5', this script will create two new tracks recursively with 5 vst's on each track inside one general folder. Your original track will be included to the end of this folder. This action should help you to reduce some CPU load.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Personal support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local num_sel_tracks = reaper.CountSelectedTracks(0)
if num_sel_tracks == 0 then
    reaper.ShowMessageBox("Please select at least one track.", ":(", 0)
    reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock("Optimize VST into folders", -1)
    return
end

local retval, user_input = reaper.GetUserInputs("Optimize VST", 1, "Number of VST per track:", "")
if not retval then
    reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock("Optimize VST into folders", -1)
    return
end

local fx_per_folder = tonumber(user_input)
if not fx_per_folder or fx_per_folder <= 0 then
    reaper.ShowMessageBox("Please enter a valid number greater than 0.", ":(", 0)
    reaper.PreventUIRefresh(-1)
    reaper.Undo_EndBlock("Optimize VST into folders", -1)
    return
end

local selected_tracks = {}
for i = 0, num_sel_tracks - 1 do
    local sel_track = reaper.GetSelectedTrack(0, i)
    table.insert(selected_tracks, sel_track)
end

for t = 1, #selected_tracks do
    local sel_track = selected_tracks[t]
    if not sel_track then
        reaper.ShowMessageBox("Failed to get selected track(s).", ":(", 0)
        goto continue
    end
    local retval, track_name = reaper.GetSetMediaTrackInfo_String(sel_track, "P_NAME", "", false)
    local num_fx = reaper.TrackFX_GetCount(sel_track)
    if num_fx == 0 then
        reaper.ShowConsoleMsg("Track '" .. track_name .. "' has no FX to optimize.\n")
        goto continue
    end
    local num_folders = math.ceil(num_fx / fx_per_folder)
    
    local track_idx = reaper.GetMediaTrackInfo_Value(sel_track, "IP_TRACKNUMBER") - 1
    reaper.InsertTrackAtIndex(track_idx, true)
    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateArrange()
    local parent_folder = reaper.GetTrack(0, track_idx)
    reaper.GetSetMediaTrackInfo_String(parent_folder, "P_NAME", track_name .. " Optimize", true)
    reaper.SetMediaTrackInfo_Value(parent_folder, "I_FOLDERDEPTH", 1)  
    
    reaper.SetMediaTrackInfo_Value(parent_folder, "I_HEIGHTOVERRIDE", 17)       -- main folder height value
    reaper.SetMediaTrackInfo_Value(parent_folder, "B_HEIGHTLOCK", 1)            -- main folder height lock
    
    local last_folder = parent_folder
    local total_folder_depth = 1
    
    for i = 1, num_folders do
        local last_folder_idx = reaper.GetMediaTrackInfo_Value(last_folder, "IP_TRACKNUMBER")
        reaper.InsertTrackAtIndex(last_folder_idx, true)
        reaper.TrackList_AdjustWindows(false)
        reaper.UpdateArrange()
        local new_track = reaper.GetTrack(0, last_folder_idx)
        if not new_track then
            reaper.ShowMessageBox("Failed to get new track.", ":(", 0)
            reaper.PreventUIRefresh(-1)
            reaper.Undo_EndBlock("Optimize VST into folders", -1)
            return
        end
        reaper.GetSetMediaTrackInfo_String(new_track, "P_NAME", tostring(i), true)
        
        for j = 1, fx_per_folder do
            local fx_idx = (i - 1) * fx_per_folder + (j - 1)
            if fx_idx < num_fx then
                reaper.TrackFX_CopyToTrack(sel_track, fx_idx, new_track, -1, false)
            end
        end

        reaper.SetMediaTrackInfo_Value(new_track, "I_FOLDERDEPTH", 1)
        reaper.SetMediaTrackInfo_Value(last_folder, "I_FOLDERDEPTH", 1)

        reaper.SetMediaTrackInfo_Value(new_track, "I_HEIGHTOVERRIDE", 17)       -- each folder height value
        reaper.SetMediaTrackInfo_Value(new_track, "B_HEIGHTLOCK", 1)            -- each folder height lock
        
        last_folder = new_track
        total_folder_depth = total_folder_depth + 1
    end
    
    local sel_track_idx = reaper.GetMediaTrackInfo_Value(sel_track, "IP_TRACKNUMBER") - 1
    local last_folder_idx = reaper.GetMediaTrackInfo_Value(last_folder, "IP_TRACKNUMBER")
  
    reaper.Main_OnCommand(40297, 0)
    reaper.SetTrackSelected(sel_track, true)
    reaper.ReorderSelectedTracks(last_folder_idx, 0)
    
    reaper.SetMediaTrackInfo_Value(sel_track, "I_FOLDERDEPTH", -total_folder_depth)
    
    for i = num_fx - 1, 0, -1 do
        reaper.TrackFX_Delete(sel_track, i)
    end
  
    reaper.SetMediaTrackInfo_Value(sel_track, "I_HEIGHTOVERRIDE", 100)          -- last folder height value
    reaper.SetMediaTrackInfo_Value(sel_track, "B_HEIGHTLOCK", 0)                -- last folder height lock

    ::continue::
end

reaper.TrackList_AdjustWindows(false)
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock("Optimize VST into folders", -1)
