-- @description Show FX window inside midi editor and focus to midi editor after close fx
-- @author Amely Suncroll
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
-- @about 

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- amelysuncroll@gmail.com

local command_id = ({reaper.get_action_context()})[4]
local is_running = true
local track = reaper.GetSelectedTrack(0, 0)

local function open_fx()
    reaper.Main_OnCommand(40291, 0)
end

local function close_fx()
    local commandID = reaper.NamedCommandLookup("_S&M_WNCLS4")
    if commandID ~= 0 then
        reaper.Main_OnCommand(commandID, 1)
    end
end

function focus_midi_editor()
  local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
  reaper.Main_OnCommand(focus_midi_editor, 0)
end

local function main()
    if not is_running then return end

    local is_fx_open = reaper.TrackFX_GetOpen(track, 0)
    
    if not is_fx_open then
        focus_midi_editor()
        is_running = false
    else
        reaper.defer(main)
    end
end

local function start_script()
    open_fx()
    main()
end

function stop_script()
    close_fx()
    is_running = false
    focus_midi_editor()
end

start_script()
reaper.atexit(stop_script)
