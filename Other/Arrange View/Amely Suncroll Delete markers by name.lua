-- @description Delete markers by name
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about Delete markers by name
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll
-- https://www.youtube.com/@yxo_composer



while true do
  local retval, input_name = reaper.GetUserInputs("Delete Markers By Name", 1, "Enter marker name (or ''all''):", "")
  if not retval or input_name == "" then return end 

  if input_name:upper() == "ALL" then
      reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWSMARKERLIST9"), 0) 
      break
  end

  local marker_found = false
  local num_markers = reaper.CountProjectMarkers(0)
  local idx = 0
  while idx < num_markers do
      local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(idx)
      if not isrgn and name == input_name then
          reaper.DeleteProjectMarker(0, markrgnindexnumber, false)
          num_markers = num_markers - 1
          marker_found = true
      else
          idx = idx + 1
      end
  end

  if not marker_found then
      reaper.ShowMessageBox("No markers found with the name '" .. input_name .. "'!", ":(", 0)
  else
      break
  end
end

reaper.UpdateArrange()
