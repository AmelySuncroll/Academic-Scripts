--[[

  ReaScript Name: Create a link by cross name (for script "Toggle switch mute for linked tracks by name")
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: select two tracks WITH NAMES to make a cross name between them (to link)
  Then call script "Amely Suncroll Toggle switch mute (or solo) for linked tracks by name"


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--

local function get_track_name(track)
    local _, name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    return name
  end
  
  local function make_cross_name(tracks)
    for _, pair in ipairs(tracks) do
        local track1, track2 = table.unpack(pair)
        local is_muted1 = reaper.GetMediaTrackInfo_Value(track1, "B_MUTE") > 0
        local is_muted2 = reaper.GetMediaTrackInfo_Value(track2, "B_MUTE") > 0
  
        if track1 and track2 then
          local _, name1 = reaper.GetSetMediaTrackInfo_String(track1, "P_NAME", "", false)
          local _, name2 = reaper.GetSetMediaTrackInfo_String(track2, "P_NAME", "", false)
          local is_muted1 = reaper.GetMediaTrackInfo_Value(track1, "B_MUTE") > 0
          local is_muted2 = reaper.GetMediaTrackInfo_Value(track2, "B_MUTE") > 0
  
          if not name1:find("%[.-%]") and not name2:find("%[.-%]") then
            reaper.GetSetMediaTrackInfo_String(track1, "P_NAME", name1 .. "               [" .. name2 .. "]", true)
            reaper.GetSetMediaTrackInfo_String(track2, "P_NAME", name2 .. "               [" .. name1 .. "]", true)
          end
        end
    end
  end
  
  
  local function main()
    local selected_track_count = reaper.CountSelectedTracks(0)
    if selected_track_count == 2 then
        local track1 = reaper.GetSelectedTrack(0, 0)
        local track2 = reaper.GetSelectedTrack(0, 1)
  
        if track1 and track2 then
            make_cross_name({{track1, track2}})
            return 
        end
    end
  end
  
  main()
