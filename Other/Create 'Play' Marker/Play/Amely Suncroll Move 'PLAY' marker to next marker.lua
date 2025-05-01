-- @description Move 'PLAY' marker to next marker
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

function find_next_marker(current_position)
    local _, num_markers = reaper.CountProjectMarkers(0)
    local next_marker_position = nil
    for i = 0, num_markers - 1 do
        local retval, is_region, position, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3(0, i)
        if not is_region and position > current_position then
            if not next_marker_position or position < next_marker_position then
                next_marker_position = position
            end
        end
    end
    return next_marker_position
end

local marker_index, marker_position = find_marker(marker_name, marker_color)

if marker_index then
    local next_marker_position = find_next_marker(marker_position)
    if next_marker_position then
        move_marker(marker_index, next_marker_position)
    end
end

reaper.UpdateArrange()