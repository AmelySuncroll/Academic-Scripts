-- @description Smart duplicate tracks
-- @author Amely Suncroll
-- @version 1.01
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + if you have Track 01 and Track 03 this script will add Track 02, exactly next to Track 01 
-- @about Smart duplicate track with name by formula X+1. Example: original track named "FX" after use this script will change name to "FX 1" and duplicated track will change name to "FX 2". Etc.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

function get_next_track(baseName)
    local usedNums = {}
    
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        local name, num = string.match(trackName, "^(.*) (%d+)$")
        if name == baseName and num then
            usedNums[tonumber(num)] = true
        end
    end

    local nextNum = 1
    while usedNums[nextNum] do
        nextNum = nextNum + 1
    end
    
    return nextNum
end


function rename_track(track, newName)
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", newName, true)
end

function find_index(baseName, targetNum)
    local insertIndex = -1

    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        local name, trackNum = string.match(trackName, "^(.*) (%d+)$")
        trackNum = tonumber(trackNum)
        
        if name == baseName and trackNum and trackNum <= targetNum then
            insertIndex = i
        end
    end

    return insertIndex
end


function dupl_track(track, insertIndex)
    reaper.InsertTrackAtIndex(insertIndex + 1, true)
    local newTrack = reaper.GetTrack(0, insertIndex + 1)
    local _, trackState = reaper.GetTrackStateChunk(track, "", false)

    reaper.SetTrackStateChunk(newTrack, trackState, true)

    local itemCount = reaper.CountTrackMediaItems(track)

    for i = 0, itemCount - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local itemState = reaper.GetItemStateChunk(item, "", false)
        if type(itemState) == "string" then
            local newItem = reaper.AddMediaItemToTrack(newTrack)
            reaper.SetItemStateChunk(newItem, itemState, true)
        end
    end

    return newTrack
end

function main()
    reaper.Undo_BeginBlock()

    local selectedTrack = reaper.GetSelectedTrack(0, 0)
    if not selectedTrack then return end

    local _, trackName = reaper.GetSetMediaTrackInfo_String(selectedTrack, "P_NAME", "", false)
    local baseName, num = string.match(trackName, "^(.*) (%d+)$")

    if not baseName then
        baseName = trackName
        num = 0
    else
        num = tonumber(num)
    end

    local baseTrackExists = false

    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, tName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        if tName == baseName then
            baseTrackExists = true
            break
        end
    end

    if baseTrackExists and num == 0 then
        local newName1 = baseName .. " 1"
        rename_track(selectedTrack, newName1)
        trackName = newName1
        baseName, num = string.match(trackName, "^(.*) (%d+)$")
        num = tonumber(num)
    end

    local nextNum = get_next_track(baseName)
    local insertIndex = find_index(baseName, nextNum - 1)
    local newTrack = dupl_track(selectedTrack, insertIndex)

    rename_track(newTrack, baseName .. " " .. nextNum)
    reaper.Main_OnCommand(40297, 0)
    reaper.SetTrackSelected(newTrack, true)
    reaper.Main_OnCommand(40421, 0)
    reaper.Main_OnCommand(41613, 0)
    reaper.Main_OnCommand(40289, 0)

    reaper.Undo_EndBlock("Smart duplicate track", -1)
end

main()
