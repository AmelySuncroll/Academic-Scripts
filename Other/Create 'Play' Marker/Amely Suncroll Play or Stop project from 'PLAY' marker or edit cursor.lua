-- @description Play or Stop project from 'PLAY' marker or edit cursor 
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @

-- @about Set this script on 'Space' button before using 'Amely Suncroll Create 'PLAY' marker (like in ProTools) (toggle)' script.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Personal support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

local marker_color = reaper.ColorToNative(215, 215, 215) | 0x1000000
local marker_name = "▶|| PLAY"

function play_from_marker_or_cursor()
    if reaper.GetPlayState() ~= 0 then
        reaper.OnStopButton()
        return
    end

    local num_markers, num_regions = reaper.CountProjectMarkers(0)
    local marker_found = false
    local marker_position = 0
    local edit_cursor_pos = reaper.GetCursorPosition()

    for i = 0, num_markers - 1 do
        local retval, isrgn, position, rgnend, name, markrgn_index, color = reaper.EnumProjectMarkers3(0, i)
        
        if not isrgn and name == marker_name and color == marker_color then
            marker_found = true
            marker_position = position
            break
        end
    end

    if marker_found then
        reaper.SetEditCurPos(marker_position, false, false)
        reaper.OnPlayButton()
        reaper.SetEditCurPos(edit_cursor_pos, false, false)
    else
        reaper.OnPlayButton()
    end
end

reaper.Undo_BeginBlock()
play_from_marker_or_cursor()
reaper.Undo_EndBlock("Play from marker or cursor", -1)
