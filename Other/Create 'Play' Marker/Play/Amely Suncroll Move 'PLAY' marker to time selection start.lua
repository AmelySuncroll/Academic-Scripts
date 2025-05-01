-- @description Move 'PLAY' marker to time selection start
-- @author Amely Suncroll
-- @version 1.01
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @noIndex

-- @about 

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Personal support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

local marker_color = reaper.ColorToNative(215, 215, 215) | 0x1000000
local marker_name = "▶|| PLAY"

function find_marker(name, color)
    local _, num_markers = reaper.CountProjectMarkers(0)
    for i = 0, num_markers - 1 do
        local retval, is_region, position, rgnend, current_marker_name, markrgnindexnumber, current_color = reaper.EnumProjectMarkers3(0, i)
        if not is_region and current_marker_name == name and current_color == color then
            return markrgnindexnumber, position
        end
    end
    return nil, nil
end

function move_marker(marker_index, new_position)
    if marker_index then
        reaper.SetProjectMarker(marker_index, false, new_position, 0, marker_name, marker_color)
    end
end

function get_time_selection_start()
    local time_sel_start, time_sel_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
    return time_sel_start
end

local marker_index, marker_position = find_marker(marker_name, marker_color)

if marker_index then
    local time_selection_start = get_time_selection_start()
    move_marker(marker_index, time_selection_start)
end

reaper.UpdateArrange()