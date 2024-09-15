-- @description Create 'PLAY' marker (like in ProTools) (toggle)
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @

-- @about Play your project from 'PLAY' marker, not edit cursor. Set 'Amely Suncroll Play or Stop project from 'PLAY' marker or edit cursor' script on 'Space' button before using this script.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Personal support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

local reaper = reaper

local marker_color = reaper.ColorToNative(215, 215, 215) | 0x1000000
local marker_name = "▶|| PLAY"
local current_edit_pos = reaper.GetCursorPosition()
local command_id = ({reaper.get_action_context()})[4]
local is_running = true

function add_marker()
  reaper.AddProjectMarker2(0, false, current_edit_pos, 0, marker_name, 0, marker_color)
end

function delete_marker(targetColor)
  local _, num_markers, _ = reaper.CountProjectMarkers(0)
  
  for i = num_markers - 1, 0, -1 do
    local _, isrgn, _, _, name, _, color = reaper.EnumProjectMarkers3(0, i)
    
    if not isrgn and color == targetColor and name == marker_name then
      reaper.DeleteProjectMarkerByIndex(0, i)
      return true
    end
  end
  return false
end

function main()
  if not is_running then return end
  reaper.defer(main)
end

function start_script()
  reaper.Undo_BeginBlock()
  
  if not delete_marker(marker_color) then
    add_marker()
  end

  reaper.Undo_EndBlock("Toggle 'PLAY ▶' marker", -1)
  
  reaper.SetToggleCommandState(0, command_id, 1)
  reaper.RefreshToolbar2(0, command_id)

  main()
end

function stop_script()
  delete_marker(marker_color)
  reaper.SetToggleCommandState(0, command_id, 0)
  reaper.RefreshToolbar2(0, command_id)
end

start_script()
reaper.atexit(stop_script)
