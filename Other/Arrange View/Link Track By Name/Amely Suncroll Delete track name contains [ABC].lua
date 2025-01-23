-- @description Delete track name contains [ABC]
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Use this script after use "Amely Suncroll Create a link by cross name".

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

local function removeSquareBracketsAndContents(str)
    return string.gsub(str, "%s*%[.+%]", "")
  end
  
  local numTracks = reaper.CountTracks(0)
  for i = 0, numTracks - 1 do
    local track = reaper.GetTrack(0, i) 
    local _, trackName = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false) 
  
    if string.match(trackName, "%[.+%]") then
        local newName = removeSquareBracketsAndContents(trackName)
        reaper.GetSetMediaTrackInfo_String(track, "P_NAME", newName, true)
    end
  end
  
