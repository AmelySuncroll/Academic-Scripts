--[[

  ReaScript Name: Delete track name contains [ABC]
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: use this script after use "Amely Suncroll Create a link by cross name".


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

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
  
