--[[

  ReaScript Name: Time / Frames / BPM
  Instructions: Just open it with Actions -  New action - Load ReaScript
  Author: Amely Suncroll
  REAPER: 6+ (maybe less)
  Extensions: none
  Version: 1.0

  About: just tableau of current project time, frames and bpm.


  Donations: 
  https://www.paypal.com/paypalme/suncroll

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com

  Other links:
  https://github.com/AmelySuncroll
  https://www.youtube.com/@yxo_composer

]]--


function load_window_params()
    local x = tonumber(reaper.GetExtState("TimeFrameBPM", "WindowPosX")) or 200
    local y = tonumber(reaper.GetExtState("TimeFrameBPM", "WindowPosY")) or 200
    local startWidth = tonumber(reaper.GetExtState("TimeFrameBPM", "WindowWidth")) or 500
    local startHeight = tonumber(reaper.GetExtState("TimeFrameBPM", "WindowHeight")) or 100
    local dock_state = tonumber(reaper.GetExtState("TimeFrameBPM", "DockState")) or 0
    return x, y, startWidth, startHeight, dock_state
  end
  
  function save_window_params()
    local dock_state, x, y, width, height = gfx.dock(-1, 0, 0, 0, 0)
    reaper.SetExtState("TimeFrameBPM", "DockState", tostring(dock_state), true)
    reaper.SetExtState("TimeFrameBPM", "WindowPosX", tostring(x), true)
    reaper.SetExtState("TimeFrameBPM", "WindowPosY", tostring(y), true)
    reaper.SetExtState("TimeFrameBPM", "WindowWidth", tostring(width), true)
    reaper.SetExtState("TimeFrameBPM", "WindowHeight", tostring(height), true)
  end
  

  function get_scale_factor(startWidth, startHeight)
    return math.min(gfx.w / startWidth, gfx.h / startHeight)
  end

  local last_cursor_position = -1
  
  function format_time(time_in_seconds)
      local hours = math.floor(time_in_seconds / 3600)
      local minutes = math.floor(time_in_seconds % 3600 / 60)
      local seconds = time_in_seconds % 60
      return string.format("%02d:%02d:%05.2f", hours, minutes, seconds)
  end
  
  function get_frame_count(project_time)
    local fps = reaper.TimeMap_curFrameRate(0)
    return math.floor(project_time * fps)
  end
  
  function get_current_position()
    if reaper.GetPlayState() == 1 then
        return reaper.GetPlayPosition()
    else
        return reaper.GetCursorPosition()
    end
  end
  
  function main()
    local startWidth, startHeight = 500, 400
    local scale = get_scale_factor(startWidth, startHeight)
    local font_size = 300 * scale
  
    gfx.setfont(1, "Consolas", font_size) ------------------------ FONT
    gfx.clear = reaper.ColorToNative(100, 100, 100) -- WHITE BACKGROUND
  
    local project_time = get_current_position()
    local time_str = format_time(project_time)
    local bpm = reaper.Master_GetTempo()
    local frame_count = get_frame_count(project_time)
    
    gfx.set(0, 0, 0) --------------------------------------- FONT COLOR
    gfx.x = 10
    gfx.y = 5
    gfx.drawstr(string.format("%s / %d / %.2f bpm", time_str, frame_count, bpm))
    
  
    gfx.update()
  
    if gfx.getchar() >= 0 then
        save_window_params()
        reaper.defer(main)
    else
        save_window_params()
    end
  end
  
  local x, y, startWidth, startHeight, dock_state = load_window_params()
  gfx.init("Time / Frame / BPM", startWidth, startHeight, dock_state, x, y)
  main()
  
