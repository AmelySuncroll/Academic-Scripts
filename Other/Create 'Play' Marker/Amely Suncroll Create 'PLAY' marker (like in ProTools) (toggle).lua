-- @description Create 'PLAY' marker (like in ProTools) (toggle)
-- @author Amely Suncroll
-- @version 1.01
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + 1.01
-- @provides [main]Play/*.lua

local marker_color = reaper.ColorToNative(1, 127, 63) | 0x1000000
local marker_name = "PLAY ▶"
local current_edit_pos = reaper.GetCursorPosition()

function add_marker()
  reaper.AddProjectMarker2(0, false, current_edit_pos, 0, marker_name, 1000, marker_color)
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

reaper.Undo_BeginBlock()

if not delete_marker(marker_color) then
  add_marker()
end

reaper.Undo_EndBlock("Toggle маркера 'PLAY ▶'", -1)

reaper.UpdateArrange()