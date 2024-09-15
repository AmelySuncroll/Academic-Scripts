-- @description Move 'PLAY' marker to previous marker
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @

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

function find_prev_marker(current_position)
    local _, num_markers = reaper.CountProjectMarkers(0)
    local previous_marker_position = nil
    for i = 0, num_markers - 1 do
        local retval, is_region, position, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
        if not is_region and position < current_position then
            if not previous_marker_position or position > previous_marker_position then
                previous_marker_position = position
            end
        end
    end
    return previous_marker_position
end

local marker_index, marker_position = find_marker(marker_name, marker_color)

if marker_index then
    local previous_marker_position = find_prev_marker(marker_position)
    if previous_marker_position then
        move_marker(marker_index, previous_marker_position)
    end
end

reaper.UpdateArrange()
