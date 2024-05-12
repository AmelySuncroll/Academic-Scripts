--[[

-- @description Conductor Mode
-- @author Amely Suncroll
-- @version beta 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @screenshot none
-- @about EXPERIMENTAL FUNCTION. 
-- Slows down the selected part of the project by 30% and then by 50%, and then returns the original tempo. 
-- The script will be useful for those who want to hear their mush at a slower tempo without making unnecessary movements. 
-- Why beta? Because the created markers are not deleted yet.
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com


]]--

local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
if start_time ~= end_time then
    local tempoMarkerCount = reaper.CountTempoTimeSigMarkers(0)
    local hasTempoMarkerAtStart = false
    local hasTempoMarkerAtEnd = false
    for i=0, tempoMarkerCount-1 do
        local _, pos, _, _, _, _, _, _, _ = reaper.GetTempoTimeSigMarker(0, i)
        if pos == start_time then
            hasTempoMarkerAtStart = true
        end
        if pos == end_time then
            hasTempoMarkerAtEnd = true
        end
    end

    if not hasTempoMarkerAtStart then
        local currentBPM = reaper.Master_GetTempo()
        reaper.AddTempoTimeSigMarker(0, start_time, currentBPM, -1, -1, false)
    end

    if not hasTempoMarkerAtEnd then
        local currentBPM = reaper.Master_GetTempo()
        reaper.AddTempoTimeSigMarker(0, end_time, currentBPM, -1, -1, false)
    end
end




if start_time == end_time then
    reaper.ShowMessageBox("Please set time selection", "Error", 0)
    return
end

local num_markers = reaper.CountTempoTimeSigMarkers(0)
local markers_modified = 0

-- Получаем количество запусков этого скрипта
local script_run_count = tonumber(reaper.GetExtState("myTempoScript", "run_count")) or 0

local adjustment_factor = 0.7

if script_run_count == 0 then
    for i = 0, num_markers - 1 do
        local retval, _, _, _, bpm, _, _, _ = reaper.GetTempoTimeSigMarker(0, i)
        reaper.SetExtState("myTempoScript", "original_bpm_" .. i, tostring(bpm), false)
    end
elseif script_run_count == 1 then
    adjustment_factor = 0.8
elseif script_run_count == 2 then
    for i = 0, num_markers - 1 do
        local retval, time, _, _, _, _, _, _ = reaper.GetTempoTimeSigMarker(0, i)
        local original_bpm = tonumber(reaper.GetExtState("myTempoScript", "original_bpm_" .. i))
        if original_bpm then
            reaper.SetTempoTimeSigMarker(0, i, time, -1, -1, original_bpm, -1, -1, false)
            markers_modified = markers_modified + 1
        end
    end
    reaper.UpdateTimeline()
    script_run_count = (script_run_count + 1) % 3
    reaper.SetExtState("myTempoScript", "run_count", tostring(script_run_count), false)
    return
end

local last_bpm_in_selection = nil
local last_marker_index_in_selection = nil

for i = 0, num_markers - 1 do
    local retval, time, _, _, bpm, _, _, _ = reaper.GetTempoTimeSigMarker(0, i)
    if time >= start_time and time <= end_time then
        local new_bpm = bpm * adjustment_factor
        reaper.SetTempoTimeSigMarker(0, i, time, -1, -1, new_bpm, -1, -1, false)
        markers_modified = markers_modified + 1
        last_bpm_in_selection = new_bpm
        last_marker_index_in_selection = i
    end
end

local modified_outside_selection = false

if last_bpm_in_selection then
    for i = 0, num_markers - 1 do
        local retval, time, _, _, _, _, _, _ = reaper.GetTempoTimeSigMarker(0, i)
        if time > end_time then
            reaper.SetTempoTimeSigMarker(0, i, time, -1, -1, last_bpm_in_selection, -1, -1, false)
            modified_outside_selection = true
            break
        end
    end
end

if not modified_outside_selection and last_marker_index_in_selection then
    local _, time, _, _, original_bpm, _, _, _ = reaper.GetTempoTimeSigMarker(0, last_marker_index_in_selection)
    reaper.SetTempoTimeSigMarker(0, last_marker_index_in_selection, time, -1, -1, original_bpm * adjustment_factor, -1, -1, false)
end

reaper.UpdateTimeline()

script_run_count = (script_run_count + 1) % 3
reaper.SetExtState("myTempoScript", "run_count", tostring(script_run_count), false)

