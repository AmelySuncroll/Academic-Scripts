-- @description RoboFace
-- @author Amely Suncroll
-- @version 1.16
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + 1.01 fix error when not docked and playing
--    + 1.1 add robot zoom, fix angry emotion (duration and some things), fix screen text messages and add something interesting else
--    + 1.13 fix yawn animation when recording, add pause when you go to midi editor, add auto startup
--    + 1.14 better sneeze emotion, change donate link and fix some small things
--    + 1.15 fix cube zoom, adding "Games" folder
--    + 1.16 optimizated terrible load grafics if midi editor is open

-- @about Your little friend inside Reaper

-- @donation https://www.paypal.com/ncp/payment/S8C8GEXK68TNC

-- @website https://t.me/reaper_ua

-- font website https://nalgames.com/fonts/iregula

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com


local is_us_lang = is_us_lang == 'true' and true or false

if is_us_lang == false then
    is_us_lang = true
end

local current_language = "en"
local translations = {
    en = {
        time = "Show time",
        current = "Current",
        hourly = "Hourly",

        set_timer = "Set timer",
        minute_1 = "1 minute",
        minutes_5 = "5 minutes",
        minutes_10 = "10 minutes",
        minutes_15 = "15 minutes",
        minutes_30 = "30 minutes",
        minutes_60 = "60 minutes",
        custom = "Custom...",
        stop_timer = "Stop timer",

        timer_display_options = "Display options",
        direct_countdown = "Direct countdown",
        reverse_countdown = "Reverse countdown",
        show_if_less_than_minute = "Show if less than a minute",
        show_every_five_minutes = "Show every five minutes",

        tap_tempo = "Tap Tempo",

        cube = "Cube",

        swch_game = "Something Was Changed?",
        play = "Play",
        rules = "Rules",
        easy = "Easy",
        medium = "Medium",
        hard = "Hard",
        impossible = "Impossible",

        options = "Options",
        welcome = "About",
        dock = "Dock",
        undock = "Undock",
        support = "Support (PayPal)",
        about = "RoboFace forum",

        language = "Language",
        english = "English",
        ukrainian = "Ukrainian",

        set_background_color = "Background color",
        white_bg = "Light",
        black_bg = "Dark",

        quit = "Quit",

        sneeze = "New",

        set_zoom = "Zoom",

        start_up = "Run on startup",

        games = "Games"
        
    },
    ua = {
        time = "Час",
        current = "Поточний",
        hourly = "Щогодини",

        set_timer = "Таймер",
        minute_1 = "1 хвилина",
        minutes_5 = "5 хвилин",
        minutes_10 = "10 хвилин",
        minutes_15 = "15 хвилин",
        minutes_30 = "30 хвилин",
        minutes_60 = "60 хвилин",
        custom = "Інший...",
        stop_timer = "Зупинити таймер",

        timer_display_options = "Відображенне таймера",
        direct_countdown = "Прямий відлік",
        reverse_countdown = "Зворотний відлік",
        show_if_less_than_minute = "Якщо менше хвилини",
        show_every_five_minutes = "Кожні п'ять хвилин",

        tap_tempo = "Тап Темпо",

        cube = "Кубик",

        swch_game = "Щось змінилося?",
        play = "Грати",
        rules = "Правила",
        easy = "Легкий",
        medium = "Середній",
        hard = "Важкий",
        impossible = "Неможливий",

        options = "Опції",
        welcome = "Ласкаво просимо!",
        dock = "Закріпити",
        undock = "Відкріпити",
        support = "Підтримати автора",
        about = "Форум RoboFace",

        language = "Мова",
        english = "English",
        ukrainian = "Українська",

        set_background_color = "Колір теми",
        white_bg = "Світлий",
        black_bg = "Темний",

        quit = "Вихід",

        sneeze = "Нове",

        set_zoom = "Розмір",

        start_up = "Автозапуск",

        games = "Ігри"
    }
}

local function t(key)
    return translations[current_language][key]
end

local function change_language(lang)
    current_language = lang
    show_r_click_menu()
    save_maze_settings()
end



if not reaper.APIExists('CF_GetSWSVersion') and reaper.APIExists('JS_ReaScriptAPI_Version') then
    reaper.ShowMessageBox("No SWS Extension installed.", ":(", 0)
elseif not reaper.APIExists('JS_ReaScriptAPI_Version') and reaper.APIExists('CF_GetSWSVersion') then
    reaper.ShowMessageBox("Requies js_ReaScriptAPI.", ":(", 0)
elseif not reaper.APIExists('CF_GetSWSVersion') and not reaper.APIExists('JS_ReaScriptAPI_Version') then
    reaper.ShowMessageBox("Please, install SWS Extension and then js_ReaScriptAPI.", ":(", 0)
    return
end

function load_window_params()
    local x = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceHome", "WindowPosX")) or 200
    local y = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceHome", "WindowPosY")) or 200
    local startWidth = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceHome", "WindowWidth")) or 500
    local startHeight = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceHome", "WindowHeight")) or 400
    local dock_state = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceHome", "DockState")) or 0
    
    return x, y, startWidth, startHeight, dock_state
end

function save_window_params()
    local dock_state, x, y, startWidth, startHeight = gfx.dock(-1, 0, 0, 0, 0)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "DockState", tostring(dock_state), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "WindowPosX", tostring(x), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "WindowPosY", tostring(y), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "WindowWidth", tostring(width), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "WindowHeight", tostring(height), true)
end

local x, y, startWidth, startHeight, dock_state = load_window_params()
gfx.init("RoboFace 1.16", startWidth, startHeight, dock_state, x, y)



local previous_position = ""

function get_reaper_main_window_size()
  local hwnd = reaper.GetMainHwnd()
  local retval, left, top, right, bottom = reaper.JS_Window_GetRect(hwnd)
  local width = right - left
  local height = bottom - top
  return width, height
end

function get_script_window_position()
  local hwnd = reaper.JS_Window_Find("RoboFace 1.16", true)
  local retval, left, top, right, bottom = reaper.JS_Window_GetRect(hwnd)
  local width = right - left
  local height = bottom - top
  return left, top, width, height
end

function check_script_window_position(window_position)
    local reaper_width, reaper_height = get_reaper_main_window_size()
    local left, top, width, height = get_script_window_position()
    
    local center_y = top + height / 2
    local current_position = ""
  
    if center_y < reaper_height / 2 then
      window_position = 1
    else
      window_position = 2
    end
  
    if current_position ~= previous_position then
      reaper.ShowConsoleMsg(current_position .. "\n")
      previous_position = current_position
    end
  
    return window_position
  end
  

-- local script_identifier = "AmelySuncrollRoboFaceRELEASE01" -- original
local script_identifier = "AmelySuncrollRoboFaceHome"

local function is_docked()
    return gfx.dock(-1) > 0
end
  
local function toggle_dock()
    local dock_state = gfx.dock(-1) > 0 and 0 or 1
    gfx.dock(dock_state)
    reaper.SetExtState(script_identifier, "dock_state", tostring(dock_state), true)
    gfx.update()
end

local previous_state = "closed"
local is_paused = false

function get_midi_editor_state()
    local midi_editor = reaper.MIDIEditor_GetActive()
    local is_me_open, is_me_closed, is_me_docked = false, false, false
    
    if not midi_editor then
        is_me_closed = true
        is_paused = false
        return is_me_open, is_me_closed, is_me_docked
    end
    
    is_me_open = true
    local is_docked_value = reaper.DockIsChildOfDock(midi_editor)
    if is_docked_value > 0 then
        is_me_docked = true
    end

    local current_state = ""
    if is_me_open and is_me_docked then
        current_state = "docked"
        is_paused = false
    elseif is_me_open then
        current_state = "open"
        is_paused = true
    elseif is_me_closed then
        current_state = "closed"
        is_paused = false
    end

    if current_state ~= previous_state then
        previous_state = current_state
    end
    
    return is_me_open, is_me_closed, is_me_docked
end



local extname = 'AmelySuncroll.RoboFace'

function ConcatPath(...) return table.concat({...}, package.config:sub(1, 1)) end

function GetStartupHookCommandID()
    -- Note: Startup hook commands have to be in the main section
    local _, script_file, section, cmd_id = reaper.get_action_context()
    if section == 0 then
        -- Save command name when main section script is run first
        local cmd_name = '_' .. reaper.ReverseNamedCommandLookup(cmd_id)
        reaper.SetExtState(extname, 'hook_cmd_name', cmd_name, true)
    else
        -- Look for saved command name by main section script
        local cmd_name = reaper.GetExtState(extname, 'hook_cmd_name')
        cmd_id = reaper.NamedCommandLookup(cmd_name)
        if cmd_id == 0 then
            -- Add the script to main section (to get cmd id)
            cmd_id = reaper.AddRemoveReaScript(true, 0, script_file, true)
            if cmd_id ~= 0 then
                -- Save command name to avoid adding script on next run
                cmd_name = '_' .. reaper.ReverseNamedCommandLookup(cmd_id)
                reaper.SetExtState(extname, 'hook_cmd_name', cmd_name, true)
            end
        end
    end
    return cmd_id
end

local is_startup = is_startup == 'true' and true or false

function IsStartupHookEnabled()
    -- reaper.ShowConsoleMsg("Entering IsStartupHookEnabled\n")
    is_startup = false
    local res_path = reaper.GetResourcePath()
    local startup_path = ConcatPath(res_path, 'Scripts', '__startup.lua')
    local cmd_id = GetStartupHookCommandID()
    local cmd_name = reaper.ReverseNamedCommandLookup(cmd_id)

    if reaper.file_exists(startup_path) then
        -- Read content of __startup.lua
        local startup_file = io.open(startup_path, 'r')
        if not startup_file then return false end
        local content = startup_file:read('*a')
        startup_file:close()

        -- Find line that contains command id (also next line if available)
        local pattern = '[^\n]+' .. cmd_name .. '\'?\n?[^\n]+'
        local s, e = content:find(pattern)

        -- Check if line exists and whether it is commented out
        if s and e then
            local hook = content:sub(s, e)
            local comment = hook:match('[^\n]*%-%-[^\n]*reaper%.Main_OnCommand')
            if not comment then return true end
        end
    end
    -- reaper.ShowConsoleMsg("Exiting IsStartupHookEnabled\n")
    is_startup = true
    return false
end

function SetStartupHookEnabled(is_enabled, comment, var_name)
    local res_path = reaper.GetResourcePath()
    local startup_path = ConcatPath(res_path, 'Scripts', '__startup.lua')
    local cmd_id = GetStartupHookCommandID()
    local cmd_name = reaper.ReverseNamedCommandLookup(cmd_id)

    local content = ''
    local hook_exists = false

    -- Check startup script for existing hook
    if reaper.file_exists(startup_path) then
        local startup_file = io.open(startup_path, 'r')
        if not startup_file then return end
        content = startup_file:read('*a')
        startup_file:close()

        -- Find line that contains command id (also next line if available)
        local pattern = '[^\n]+' .. cmd_name .. '\'?\n?[^\n]+'
        local s, e = content:find(pattern)

        if s and e then
            -- Add/remove comment from existing startup hook
            local hook = content:sub(s, e)
            local repl = (is_enabled and '' or '-- ') .. 'reaper.Main_OnCommand'
            hook = hook:gsub('[^\n]*reaper%.Main_OnCommand', repl, 1)
            content = content:sub(1, s - 1) .. hook .. content:sub(e + 1)

            -- Write changes to file
            local new_startup_file = io.open(startup_path, 'w')
            if not new_startup_file then return end
            new_startup_file:write(content)
            new_startup_file:close()

            hook_exists = true
        end
    end

    -- Create startup hook
    if is_enabled and not hook_exists then
        comment = comment and '-- ' .. comment .. '\n' or ''
        var_name = var_name or 'cmd_name'
        local hook = '%slocal %s = \'_%s\'\nreaper.\z
            Main_OnCommand(reaper.NamedCommandLookup(%s), 0)\n\n'
        hook = hook:format(comment, var_name, cmd_name, var_name)
        local startup_file = io.open(startup_path, 'w')
        if not startup_file then return end
        startup_file:write(hook .. content)
        startup_file:close()
    end
end








------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------  LOCAL BLOCK  -----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


local robot_x = 0
local robot_y = 0
local robot_zoom = 0

local zoom_100 = zoom_100 == 'true' and true or false
local zoom_120 = zoom_120 == 'true' and true or false
local zoom_140 = zoom_140 == 'true' and true or false
local zoom_150 = zoom_150 == 'true' and true or false

local function set_robot_zoom(zoom_value)  
    if zoom_value == "100" then
        zoom_100 = not zoom_100
        zoom_120 = false
        zoom_140 = false
        zoom_150 = false
        robot_zoom = 100
    elseif zoom_value == "120" then
        zoom_120 = not zoom_120
        zoom_100 = false
        zoom_140 = false
        zoom_150 = false
        robot_zoom = 120
    elseif zoom_value == "140" then
        zoom_140 = not zoom_140
        zoom_100 = false
        zoom_120 = false
        zoom_150 = false
        robot_zoom = 140
    elseif zoom_value == "150" then
        zoom_150 = not zoom_150
        zoom_100 = false
        zoom_120 = false
        zoom_140 = false
        robot_zoom = 150
    else
        zoom_100 = not zoom_100
        zoom_120 = false
        zoom_140 = false
        zoom_150 = false
        robot_zoom = 100
    end
    return robot_zoom
end



------------------------------------ EYES AND PUPIL
local base_eye_size = 50
local base_pupil_size = 25

---------------------------------------------- FACE
local base_face_x = 100
local base_face_y = 50
local base_face_width = 300
local base_face_height = 200

---------------------------------------------- EYES
local base_left_eye_x = 150
local base_left_eye_y = 100
local base_right_eye_x = 300
local base_right_eye_y = 100

--------------------------------------------- MOUTH
local base_mouth_x = 150
local base_mouth_y = 170
local base_mouth_width = 170
local base_mouth_height = 35

-------------------------------------------- TONGUE
local base_tongue_x = 200
local base_tongue_y = 155
local base_tongue_width = 17
local base_tongue_height = 20




---------------------------------- BLINK PARAMETERS
local last_blink_time = reaper.time_precise()
local blink_interval = math.random(7, 10)  
local blink_duration = 0.2  
local is_eye_open = true
local blink_count = 0  


----------------------------------- YAWN PARAMETERS
local yawn_start_time = nil
local yawn_duration = 10 
local yawn_intervals = nil
local next_yawn_time = nil


---------------------------------- ANGRY PARAMETERS
local angry_start_time = nil
local last_loud_time = nil
local cooldown_duration = 5


---------------------------------- SHAKE PARAMETERS
local last_measure = nil  
local shake_end_time = 0  

local horiz_shake_intensity = 0
local horiz_shake_end_time = 0
local horiz_shake_duration = 0.5  



----------------------------------- ZOOM PARAMETERS
local angry_count = 0
local restore_zoom_time = nil
local restore_duration = 180

local is_sneeze_one = false
local is_sneeze_two = false



function get_scale_factor()
    return math.min(gfx.w / startWidth, gfx.h / startHeight)
end







------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------  DRAW BLOCK  ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


function get_scale_factor()
    return math.min(gfx.w / startWidth, gfx.h / startHeight)
end


local is_bg_black = is_bg_black == 'true' and true or false

if is_bg_black == false then
    is_bg_black = true
end

function set_background_color(color)
    if color == "black" then
        is_bg_black = true
    elseif color == "white" then
        is_bg_black = false
    else
        is_bg_black = true
    end
end

function is_black_background()
    return is_bg_black
end

function is_white_background()
    return not is_bg_black
end

function draw_robot_face(scale, is_eye_open, is_sleeping, is_bg_black)
    local base_scale = get_scale_factor()  
    local dynamic_scale = robot_zoom / 100 
    local scale = base_scale * dynamic_scale
    local eye_size = base_eye_size * scale
    local pupil_size = base_pupil_size * scale
    local face_width = base_face_width * scale  
    local face_height = base_face_height * scale
    local face_x = (gfx.w - face_width) / 2
    local face_y = (gfx.h - face_height) / 2

    local face_x = (gfx.w - face_width) / 2 + get_horizontal_shake_intensity() 

    local shake_offset = get_shake_intensity()
    local face_y = (gfx.h - base_face_height * scale) / 2 + shake_offset + get_vertical_shake_intensity()

    local is_yawning = animate_yawn()
    local is_angry = check_for_angry()
    local is_sleeping = should_robot_sleep()
    local is_recording = is_recording()
    local is_animation_when_delete_all = animation_when_delete_all()
    
    ----------------------------------------------------------------------------------------------------------------------------- BG
    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    elseif not is_bg_black then
        gfx.set(0.8, 0.8, 0.8, 1)
    else
        gfx.set(0, 0, 0, 1)
    end
    
    gfx.rect(0, 0, gfx.w, gfx.h, 1)


    ------------------------------------------------------------------------------------------------------------------------- SHADOW
    if not is_bg_black then
        local shadow_offset = 3
        if is_sleeping then
            gfx.set(0.4, 0.4, 0.4, 1)
            gfx.rect(face_x + shadow_offset, face_y + shadow_offset + animate_sleep(), face_width, face_height, 1)
        elseif not is_sleeping then
            gfx.set(0.5, 0.5, 0.5, 1)
            gfx.rect(face_x + shadow_offset, face_y + shadow_offset, face_width, face_height, 1)
        end
    end


    --------------------------------------------------------------------------------------------------------------------------- FACE
    if is_angry then
        gfx.set(1, 0, 0)
    end

    if not is_angry and is_bg_black then
        gfx.set(0.5, 0.5, 0.5, 1)
    elseif not is_angry and not is_bg_black then
        gfx.set(0.65, 0.65, 0.65, 1)
    end   

    if is_sleeping then
        if is_bg_black then
            gfx.set(0.2, 0.2, 0.2)
        else
            gfx.set(0.5, 0.5, 0.5)
        end

        face_y = face_y + animate_sleep()
        is_eye_open = false
    end
    
    gfx.rect(face_x, face_y, face_width, face_height, 1)


    --------------------------------------------------------------------------------------------------------------------------- EYES
    local eye_offset_x = face_width * (base_left_eye_x - base_face_x) / base_face_width
    local eye_offset_y = face_height * (base_left_eye_y - base_face_y) / base_face_height

    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.45, 0.45, 0.45, 1)
    end

    if is_eye_open and not is_angry and not is_recording then
        gfx.rect(face_x + eye_offset_x, face_y + eye_offset_y, eye_size, eye_size, 1) -- L
        gfx.rect(face_x + face_width - eye_offset_x - eye_size, face_y + eye_offset_y, eye_size, eye_size, 1) -- R
    end

    if is_animation_when_delete_all then
        gfx.rect(face_x + eye_offset_x, face_y + eye_offset_y, eye_size * 1.1, eye_size * 1.1, 1) -- L
        gfx.rect(face_x + face_width - eye_offset_x - eye_size, face_y + eye_offset_y, eye_size * 1.1, eye_size * 1.1, 1) -- R
    end

    -- RECORD FUNCTION
    if is_recording then
        ---------------------------------------------------------- left eye when recording
        local eye_radius = base_eye_size * scale / 2
        local eye_center_x = face_x + eye_offset_x + eye_radius
        local eye_center_y = face_y + eye_offset_y + eye_radius
        gfx.circle(eye_center_x, eye_center_y, eye_radius, 1)

        local offset_right = eye_size * 0.5
        local eye_y = face_y + face_height * (base_left_eye_y - base_face_y) / base_face_height
        local right_eye_x = face_x + face_width * (base_right_eye_x - base_face_x) / base_face_width + offset_right

        local current_time = reaper.time_precise()
        if math.floor(current_time * 2) % 2 == 0 then
            gfx.set(1, 0, 0)
            gfx.circle(eye_center_x, eye_center_y, eye_radius * 0.5, 1) -------- red point
        end

        --------------------------------------------------------- right eye when recording
        local right_eye_x = face_x + face_width - eye_offset_x - eye_size
        local right_eye_y = face_y + eye_offset_y + eye_size / 2    
        local eye_thickness = eye_size / 2
        gfx.set(0.45, 0.45, 0.45, 1)
        gfx.rect(right_eye_x, right_eye_y - eye_thickness / 2, eye_size, eye_thickness, 1) 

--[[
        -- "<"
        -- up line
        gfx.set(0, 0, 0) 
        gfx.line(right_eye_x, eye_y, right_eye_x - eye_size, eye_y + eye_size * 0.5)
        gfx.line(right_eye_x, eye_y + 1, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 1) ------------- comment this line to reduce thickness
        --gfx.line(right_eye_x, eye_y + 2, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 2)  ----------------- uncomment this line to thicken

        -- down line
        gfx.line(right_eye_x, eye_y + eye_size, right_eye_x - eye_size, eye_y + eye_size * 0.5)
        gfx.line(right_eye_x, eye_y + eye_size + 1, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 1) -- comment this line to reduce thickness
        --gfx.line(right_eye_x, eye_y + eye_size + 2, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 2)  ------ uncomment this line to thicken

        -- "R"
        local right_eye_x = face_x + face_width - eye_offset_x - eye_size - eye_size
        local right_eye_y = face_y + eye_offset_y - 1
        local eye_width = base_eye_size * scale
        local eye_height = base_eye_size * scale
        local font_size = eye_height * 1.2 -- Размер шрифта для буквы "R"
        gfx.set(0, 0, 0) -- Устанавливаем черный цвет для буквы "R"
        gfx.setfont(1, "Arial", font_size) -- Выбираем шрифт и размер
        gfx.x = right_eye_x + (eye_width - gfx.measurestr("R")) / 2
        gfx.y = right_eye_y - (eye_height - font_size) / 2
        gfx.drawstr("REC")
]]--
    end

    -- BLINK FUNCTION
    if not is_eye_open or not is_angry and not is_recording then
        gfx.rect(face_x + eye_offset_x, face_y + eye_offset_y, eye_size, eye_size / 4, 1) -- L
        gfx.rect(face_x + face_width - eye_offset_x - eye_size, face_y + eye_offset_y, eye_size, eye_size / 4, 1) -- R
    end
    
    -- ANGRY FUNCTION
    if is_angry then
        local line_length = eye_size * 0.5
        local offset_right = eye_size * 0.5
        local left_eye_x = face_x + face_width * (base_left_eye_x - base_face_x) / base_face_width + offset_right
        local right_eye_x = face_x + face_width * (base_right_eye_x - base_face_x) / base_face_width + offset_right
        local eye_y = face_y + face_height * (base_left_eye_y - base_face_y) / base_face_height
        local face_x = (gfx.w - base_face_width * scale) / 2 + shake_offset
    
        -- ">"
        -- up line
        gfx.line(left_eye_x, eye_y, left_eye_x + eye_size, eye_y + eye_size * 0.5)
        gfx.line(left_eye_x, eye_y + 1, left_eye_x + eye_size, eye_y + eye_size * 0.5 + 1) --------------- comment this line to reduce thickness
        --gfx.line(left_eye_x, eye_y + 2, left_eye_x + eye_size, eye_y + eye_size * 0.5 + 2)  ------------------- uncomment this line to thicken

        -- down line
        gfx.line(left_eye_x, eye_y + eye_size, left_eye_x + eye_size, eye_y + eye_size * 0.5)
        gfx.line(left_eye_x, eye_y + eye_size + 1, left_eye_x + eye_size, eye_y + eye_size * 0.5 + 1) ---- comment this line to reduce thickness
        --gfx.line(left_eye_x, eye_y + eye_size + 2, left_eye_x + eye_size, eye_y + eye_size * 0.5 + 2)  -------- uncomment this line to thicken
        
        -- "<"
        -- up line
        gfx.line(right_eye_x, eye_y, right_eye_x - eye_size, eye_y + eye_size * 0.5)
        gfx.line(right_eye_x, eye_y + 1, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 1) ------------- comment this line to reduce thickness
        --gfx.line(right_eye_x, eye_y + 2, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 2)  ----------------- uncomment this line to thicken

        -- down line
        gfx.line(right_eye_x, eye_y + eye_size, right_eye_x - eye_size, eye_y + eye_size * 0.5)
        gfx.line(right_eye_x, eye_y + eye_size + 1, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 1) -- comment this line to reduce thickness
        --gfx.line(right_eye_x, eye_y + eye_size + 2, right_eye_x - eye_size, eye_y + eye_size * 0.5 + 2)  ------ uncomment this line to thicken
    end
    

    -------------------------------------------------------------------------------------------------------------------------- MOUTH
    local mouth_x = face_x + (face_width - base_mouth_width * scale) / 2
    local mouth_y = face_y + face_height - (base_face_height - base_mouth_y + base_mouth_height) * scale

    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.45, 0.45, 0.45, 1)
    end

    if is_angry then
        gfx.rect(mouth_x, mouth_y, base_mouth_width * scale, base_mouth_height * scale * 1.4, 1)
    end

    if is_sneeze_one then
        gfx.rect(mouth_x, mouth_y, base_mouth_width * scale, base_mouth_height * scale * 1.3, 1)
    end

    if is_sneeze_two then
        gfx.rect(mouth_x + 10, mouth_y, base_mouth_width * scale / 3, base_mouth_height * scale * 0.7, 1)
    end

    if is_animation_when_delete_all then
        gfx.rect(mouth_x, mouth_y, base_mouth_width * scale, base_mouth_height * scale * 1.3, 1)
    end

    if is_yawning then
        local current_time = reaper.time_precise()
        local yawn_progress = (current_time - yawn_start_time) / yawn_duration
        local mouth_opening = base_mouth_height * scale * (0.8 + 0.8 * math.sin(yawn_progress * math.pi))
        gfx.rect(mouth_x, mouth_y, base_mouth_width * scale * 0.8, mouth_opening, 1)
    end

    if not is_yawning and not is_angry and not is_sleeping and not is_sneeze_two then
        gfx.rect(mouth_x, mouth_y, base_mouth_width * scale, base_mouth_height * scale, 1)
    end


    ------------------------------------------------------------------------------------------------------------------------- TONGUE
    if not is_angry and not is_yawning and not is_sleeping and not is_sneeze_two then
        local tongue_x = face_x + (face_width - base_tongue_width * scale) / 2.5
        local tongue_y = face_y + face_height - (base_face_height - base_tongue_y + base_tongue_height) * scale

        gfx.set(1, 1, 1)
        gfx.rect(tongue_x, tongue_y, base_tongue_width * scale, base_tongue_height * scale, 1)
    end
end



----------------------------------------------------------------------------------------------------------------------------- PUPILS
local prev_mouse_x, prev_mouse_y = nil, nil
local last_check_time = nil

function draw_pupils(scale)
    local base_scale = get_scale_factor()  
    local dynamic_scale = robot_zoom / 100
    local scale = base_scale * dynamic_scale
    local is_angry = check_for_angry() 
    local is_sleeping = should_robot_sleep()
    local is_recording = is_recording()
    local is_docked = is_docked()
    
    if is_eye_open and not is_sleeping and not is_recording then
        local eye_size = base_eye_size * scale
        local pupil_size = base_pupil_size * scale
        local face_width = base_face_width * scale
        local face_height = base_face_height * scale
        local face_x = (gfx.w - face_width) / 2
        local face_y = (gfx.h - face_height) / 2 + get_vertical_shake_intensity()

        local eye_offset_x = face_width * (base_left_eye_x - base_face_x) / base_face_width
        local eye_offset_y = face_height * (base_left_eye_y - base_face_y) / base_face_height

        local function get_pupil_position(eye_x, eye_y, target_x, target_y)
            local pupil_x = math.max(eye_x, math.min(eye_x + eye_size - pupil_size, target_x - pupil_size / 2))
            local pupil_y = math.max(eye_y, math.min(eye_y + eye_size - pupil_size, target_y - pupil_size / 2))
            return pupil_x, pupil_y
        end

        local target_x, target_y
        if reaper.GetPlayState() == 0 then
            target_x, target_y = gfx.mouse_x, gfx.mouse_y
        else
            local play_position = reaper.GetPlayPosition() 
            local view_start, view_end = reaper.GetSet_ArrangeView2(0, false, 0, 0) 
            local screen_position_ratio = (play_position - view_start) / (view_end - view_start)

            if check_script_window_position() == 1 and is_docked then
                target_x = gfx.w * screen_position_ratio
                target_y = face_y + eye_offset_y + (eye_size - pupil_size) / 0
            elseif check_script_window_position() == 2 and is_docked then
                target_x = gfx.w * screen_position_ratio
                target_y = face_y + eye_offset_y + (eye_size - pupil_size) / 2
            else
                target_x = gfx.w * screen_position_ratio
                target_y = face_y + eye_offset_y + (eye_size - pupil_size) / 0   -- PUPILS DIRECTION IF PLAYING: 0 = DOWN, 1 = CENTER, 2 = UP
            end
        end

        gfx.set(1, 1, 1)

        if is_angry then
            eye_size = eye_size * 0.2  -- Narrower eye width for angry eyes
            pupil_size = 0  -- Smaller pupil size for angry eyes
        end
        
        local pupil_x, pupil_y = get_pupil_position(face_x + eye_offset_x, face_y + eye_offset_y, target_x, target_y)
        gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1) -- L

        pupil_x, pupil_y = get_pupil_position(face_x + face_width - eye_offset_x - eye_size, face_y + eye_offset_y, target_x, target_y)
        gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1) -- R
    end
end







------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  KNOWLEDGE BLOCK  ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



function get_os_type()
    local os_name = reaper.GetOS()
    if os_name:find("Win") then
        return "Windows"
    elseif os_name:find("OSX") then
        return "macOS"
    else
        return "Linux"
    end
end

function global_os_time()
    if time_format_12hr then
        return os.date("%I:%M:%S %p")  -- 12 AM/PM
    else
        return os.date("%H:%M:%S")     -- 24 hours
    end
end

function global_os_time_without_seconds()
    if time_format_12hr then
        return os.date("%I:%M %p")  -- 12 AM/PM
    else
        return os.date("%H:%M")     -- 24 hours
    end
end

function is_start_of_hour()
    local current_time = os.date("*t")
    if current_time.min == 0 then
        return true
    else
        return false
    end
end

function is_night_time()
    local current_time = global_os_time()

    if time_format_12hr and time_in_range("01:08:00 AM", current_time, 21600) then -- 6 hours (360 minutes) = 21600 seconds
        return true
    elseif not time_format_12hr and time_in_range("01:11:00", current_time, 21600) then
        return true
    else
        return false
    end
end

function is_playing()
    return reaper.GetPlayState() & 1 == 1
end

function is_recording()
    return reaper.GetPlayState() & 4 == 4
end

function get_current_bpm()
    return reaper.Master_GetTempo()
end

function is_metronome_running()
    return reaper.GetToggleCommandState(40364) == 1 
end

function getTimeSignature()
    local time = reaper.time_precise()
    local numerator, denominator = reaper.TimeMap_GetTimeSigAtTime(0, time)
    return numerator, denominator
end

function getPlayPositionInBeats()
    local playCursor = reaper.GetPlayPosition() 
    local project = 0 
    local retval, measures, cml, fullbeats, cdenom = reaper.TimeMap2_timeToBeats(project, playCursor)
    if retval then
        return measures + 1, fullbeats
    else
        return nil, nil 
    end
end

function getPlayCursor()
    local playState = reaper.GetPlayState() 
    if playState & 1 == 1 then 
        return getPlayPositionInBeats() 
    else
        return nil
    end
end

function check_master_fader_volume()
    local master_track = reaper.GetMasterTrack(0)
    local vol_db = reaper.GetMediaTrackInfo_Value(master_track, "D_VOL")
    
    if vol_db ~= 0 then
        vol_db = 20 * math.log(vol_db, 10)
    else
        vol_db = -math.huge
    end

    if vol_db > 6 then
        return true
    else
        return false
    end
end

local is_fader_high = check_master_fader_volume()

function check_master_real_volume()
    local master_track = reaper.GetMasterTrack(0)
    local peak_left = reaper.Track_GetPeakInfo(master_track, 0)
    local peak_right = reaper.Track_GetPeakInfo(master_track, 1)
    local peak_db_left = 20 * math.log(peak_left, 10)
    local peak_db_right = 20 * math.log(peak_right, 10)
    local max_peak_db = math.max(peak_db_left, peak_db_right)

    if max_peak_db > 12 and angry_count < 6 then
        return true
    else
        return false
    end
end

local is_really_loud = check_master_real_volume()

function check_master_no_volume()
    local master_track = reaper.GetMasterTrack(0)
    local peak_left = reaper.Track_GetPeakInfo(master_track, 0)
    local peak_right = reaper.Track_GetPeakInfo(master_track, 1)
    local peak_db_left = 20 * math.log(peak_left, 10)
    local peak_db_right = 20 * math.log(peak_right, 10)
    local max_peak_db = math.max(peak_db_left, peak_db_right)

    if max_peak_db < -54 then
        return true
    else
        return false
    end
end

local is_really_quiet = check_master_no_volume()







------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  ANIMATION BLOCK  ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------- ZOOM
local original_zoom = nil

function animate_robot(target_x, target_y, target_zoom, duration, delay)
    delay = delay or 0  
    local start_time = reaper.time_precise() + delay
    local initial_x = robot_x
    local initial_y = robot_y
    local initial_zoom = robot_zoom
    local animation_end_time = start_time + duration

    if not original_zoom then
        original_zoom = initial_zoom
    end

    local function update_animation()
        local current_time = reaper.time_precise()
        if current_time < start_time then
            reaper.defer(update_animation)
            return
        end

        local progress = (current_time - start_time) / duration
        progress = math.max(0, math.min(1, progress))  

        robot_x = initial_x + (target_x - initial_x) * progress
        robot_y = initial_y + (target_y - initial_y) * progress
        robot_zoom = initial_zoom + (target_zoom - initial_zoom) * progress

        if current_time <= animation_end_time then
            reaper.defer(update_animation)
        end
    end

    update_animation()
end



local angry_count = 0
local restore_zoom_time = nil
local restore_duration = 180
zoom_out = false

function reduce_robot_zoom()
    if angry_count == 2 then
        animate_robot(robot_x, robot_y, robot_zoom * 0.7, 1, 0)  
    elseif angry_count == 3 then
        animate_robot(robot_x, robot_y, robot_zoom * 0.7, 1, 0)
    elseif angry_count >= 4 then
        animate_robot(robot_x, robot_y, 0, 1, 0) 
        restore_zoom_time = reaper.time_precise() + restore_duration
        zoom_out = true
    end
end

function restore_robot_zoom()
    local current_time = reaper.time_precise()
    if restore_zoom_time and current_time >= restore_zoom_time then
        animate_robot(robot_x, robot_y, original_zoom, 1, 0)
        restore_zoom_time = nil
        zoom_out = false
    end
end







------------------------------------------------------------------------------------------------------------------------------ BLINK

function animate_blink()
    local current_time = reaper.time_precise()
    if is_eye_open and not is_angry and current_time - last_blink_time >= blink_interval then
        is_eye_open = false
        last_blink_time = current_time
        blink_count = blink_count == 0 and math.random(0, 1) or blink_count - 1
    elseif not is_eye_open and current_time - last_blink_time >= blink_duration then
        is_eye_open = true
        if blink_count > 0 then
            last_blink_time = current_time
            blink_interval = blink_duration  
        else
            blink_interval = math.random(7, 10) 
        end
    end
end






------------------------------------------------------------------------------------------------------------------------ SHAKE (BPM)

function get_shake_parameters(bpm)
    if bpm > 249 then
        return 1, 0.00000001
    end

    if bpm > 199 then
        return 1, 0.007
    end

    if bpm > 149 then
        return 2, 0.03
    end

    if bpm > 99 then
        return 2, 0.05 
    end

    if bpm > 49 then
        return 3, 0.1
    end

    if bpm > 1 then
        return 4, 0,5
    end
end

function get_shake_intensity()
    local currentBPM = get_current_bpm()
    local is_angry = check_for_angry()
    local is_sleeping = should_robot_sleep()
    if not is_playing() or not is_metronome_running() or is_angry or is_sleeping then 
        return 0
    end

    local shake_intensity, shake_duration = get_shake_parameters(currentBPM)

    local currentTime = reaper.time_precise()
    local _, _, _, fullbeats = reaper.TimeMap2_timeToBeats(0, reaper.GetPlayPosition())
    fullbeats = math.floor(fullbeats)

    if fullbeats ~= last_beat_time then
        last_beat_time = fullbeats
        shake_end_time = currentTime + shake_duration
    end

    if currentTime <= shake_end_time then
        return shake_intensity
    end

    return 0
end


----------------------------------- HORIZONTAL SHAKE BLOCK -----------------------------------

local horiz_shake_intensity = 0
local horiz_shake_end_time = 0
local horiz_shake_duration = 0.5

function get_horizontal_shake_intensity()
    local current_time = reaper.time_precise()
    if current_time <= horiz_shake_end_time then
        return math.random(-horiz_shake_intensity, horiz_shake_intensity)
    end
    return 0
end

function trigger_horizontal_shake(intensity, duration)
    horiz_shake_intensity = intensity
    horiz_shake_duration = duration
    horiz_shake_end_time = reaper.time_precise() + duration
end



----------------------------------- VERTICAL SHAKE BLOCK -------------------------------------

local vert_shake_intensity = 0
local vert_shake_end_time = 0
local vert_shake_duration = 0.5
local is_vert_shake_i = false

function get_vertical_shake_intensity()
    local current_time = reaper.time_precise()
    if current_time <= vert_shake_end_time then
        if is_vert_shake_i then
            return vert_shake_intensity, -vert_shake_intensity
        else
            return -vert_shake_intensity, vert_shake_intensity
        end
    end
    return 0, 0
end

function trigger_vertical_shake(intensity, duration, invert)
    vert_shake_intensity = intensity
    vert_shake_duration = duration
    vert_shake_end_time = reaper.time_precise() + duration
    is_vert_shake_i = invert or false
end






------------------------------------------------------------------------------------------------------------------------------- YAWN

function init_yawn_intervals()
    yawn_intervals = {}
    local num_yawns = math.random(3, 5) 
    local base_time = reaper.time_precise()
    for i = 1, num_yawns do
        base_time = base_time + math.random(10 * 60, 12 * 60)
        table.insert(yawn_intervals, base_time)
    end
end


function check_for_yawn()
    local current_time_table = os.date("*t")  
    local current_time = reaper.time_precise()

    if current_time_table.hour == 0 and current_time_table.min == 0 and current_time_table.sec == 5 and not is_angry then
        yawn_start_time = current_time
        init_yawn_intervals() 
    end

    --[[
    if current_time - yawn_start_time >= 20 then
        yawn_start_time = current_time 
        init_yawn_intervals()
    end 
    ]]--

    if not yawn_intervals then init_yawn_intervals() end 
    if next_yawn_time and current_time >= next_yawn_time then
        yawn_start_time = current_time
        next_yawn_time = nil
    end

    if not yawn_start_time then
        for i, yawn_time in ipairs(yawn_intervals) do
            if current_time >= yawn_time then
                table.remove(yawn_intervals, i)
                next_yawn_time = yawn_time
                break
            end
        end
    end

    if yawn_start_time and current_time - yawn_start_time > yawn_duration then
        yawn_start_time = nil
    end

    return yawn_start_time ~= nil
end


function animate_yawn()
    local current_time = reaper.time_precise()
    if yawn_start_time then
        if current_time - yawn_start_time <= yawn_duration then
            is_eye_open = false 
            return true 
        else
            yawn_start_time = nil  
            is_eye_open = true  
        end
    end
    return false
end






------------------------------------------------------------------------------------------------------------------------------ ANGRY

is_really_angry = false

function check_for_angry()
    local is_really_loud = check_master_real_volume()
    local current_time = reaper.time_precise()

    if is_really_loud then
        if not angry_start_time then
            angry_start_time = current_time
            angry_count = angry_count + 1
            trigger_horizontal_shake(10, 0.5)  -- intensity == 10, duration == 0.5

            if angry_count > 1 then
                reduce_robot_zoom()
            end

            if angry_count == 3 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("If you will do it again, I will go away immediately.\n\n")
                else
                    reaper.ShowConsoleMsg("Якщо Ви це зробите знову, я негайно піду.\n\n")
                end
            end

            if angry_count == 7 then
                set_timer(3)
                is_really_angry = true
        
                if current_language == "en" then
                    reaper.ShowConsoleMsg("I told you - don't do that. But you do. \n\nSo, now I've changed something inside your project... And it's not a game now. You have 3 minutes to find it. The clock is ticking!\n\n")
                else
                    reaper.ShowConsoleMsg("Я казав тобі, що не треба так робити! Тому щойно я дещо змінив у твоєму проєкті... І зараз це не іграшки. У тебе є 3 хвилини, що б знайти це. Час пішов!\n\n")
                end
            end
        end

        last_loud_time = current_time
        
    elseif not is_really_loud and last_loud_time and (current_time - last_loud_time > cooldown_duration) then
        angry_start_time = nil
        last_loud_time = nil
    end

    return angry_start_time ~= nil
end






------------------------------------------------------------------------------------------------------------------------------ SLEEP

local min_sleep_duration = 1200
local max_sleep_duration = 1800
local quiet_start_time = nil
local sleep_start_time = nil
local quiet_duration = 1800

function should_robot_sleep()
    local current_time = reaper.time_precise()
    local global_time = global_os_time()
    local is_really_quiet = check_master_no_volume()
    local is_recording = is_recording()

    local is_me_open, is_me_closed, is_me_docked = get_midi_editor_state()

    if is_night_time() and not is_recording and not is_robo_maze_open() then
        if not is_me_open then
            return true
        end
    end

    if is_recording then
        sleep_start_time = nil
        quiet_start_time = nil
        return false
    end

    if is_really_quiet then
        if not quiet_start_time then
            quiet_start_time = current_time
        elseif current_time - quiet_start_time >= quiet_duration then
            if not sleep_start_time then
                sleep_start_time = current_time
            elseif current_time - sleep_start_time >= max_sleep_duration then
                animate_yawn()
                sleep_start_time = nil
                quiet_start_time = current_time 
                return false
            end
            return true
        end
    else
        quiet_start_time = nil
        sleep_start_time = nil
    end

    return false
end

function animate_sleep()
    local sleep_intensity = 1 
    local sleep_duration = 2  
    local current_time = reaper.time_precise()
    local cycle_position = (current_time % sleep_duration) / sleep_duration
    local shake_offset = sleep_intensity * math.sin(cycle_position * 2 * math.pi)

    return shake_offset
end







------------------------------------------------------------------------------------------------------------------------------ OTHER


------------------------------------------------------------------------------------ DELETE ALL
local prev_num_items = reaper.CountMediaItems(0)
local prev_num_tracks = reaper.CountTracks(0)
local prev_num_items_in_tracks = {}
local animation_triggered = false

function animation_when_delete_all()
    local num_items = reaper.CountMediaItems(0)
    local num_tracks = reaper.CountTracks(0)
    local is_deletion = false
    local is_sleeping = should_robot_sleep()

    if num_items == 0 and prev_num_items > 0 then
        is_deletion = true
    end

    if num_tracks == 0 and prev_num_tracks > 0 then
        is_deletion = true
    end

    if num_tracks > 0 and num_items == 0 then
        local all_items_deleted = true
        for i = 0, num_tracks - 1 do
            local track = reaper.GetTrack(0, i)
            local num_items_in_track = reaper.CountTrackMediaItems(track)
            if num_items_in_track > 0 then
                all_items_deleted = false
                break
            end
        end
        if all_items_deleted and prev_num_items > 0 then
            is_deletion = true
        end
    end

    if is_deletion and not is_sleeping and not animation_triggered then
        trigger_vertical_shake(2, 0.05)
        animation_triggered = true
        return true
    end

    if num_items > 0 or num_tracks > 0 then
        animation_triggered = false
    end

    prev_num_items = num_items
    prev_num_tracks = num_tracks
    
    return false
end

---------------------------------------------------------------------------------- START OR END

local prev_pos = -1
local start_pos = 0
local end_pos = reaper.GetProjectLength()

function animation_when_start_or_end()
    local cur_pos = reaper.GetCursorPosition()
    local is_sleeping = should_robot_sleep()

    if not is_sleeping then
        if prev_pos ~= cur_pos then
            if cur_pos == start_pos and prev_pos ~= start_pos then
                trigger_horizontal_shake(3, 0.1)
            elseif cur_pos == end_pos and prev_pos ~= end_pos then
                trigger_horizontal_shake(3, 0.1)
            end
            prev_pos = cur_pos
        end
    end
end






---------------------------------------------------------------------------------- SHAKE (WITH)

function shake_with_show_random_cube()
    local timings = {0, 0.2, 0.4}
    local startTime = reaper.time_precise()

    local function trigger_with_delay(index)
        if index > #timings then
            reaper.defer(function()
                if reaper.time_precise() >= startTime + 0.52 then
                    show_random_cube()
                else
                    reaper.defer(function() trigger_with_delay(index) end)
                end
            end)
            return
        end
        
        if reaper.time_precise() >= startTime + timings[index] then
            trigger_vertical_shake(3, 0.1)
            index = index + 1 
        end
        
        reaper.defer(function() trigger_with_delay(index) end)
    end

    trigger_vertical_shake(3, 0.1)
    reaper.defer(function() trigger_with_delay(2) end)
end



function shake_with_show_laugh()
    local timings = {0, 0.2, 0.4}
    local startTime = reaper.time_precise()

    local function trigger_with_delay(index)
        if index > #timings then
            reaper.defer(function()
                if reaper.time_precise() >= startTime + 0.52 then
                    --show_random_cube()
                else
                    reaper.defer(function() trigger_with_delay(index) end)
                end
            end)
            return
        end
        
        if reaper.time_precise() >= startTime + timings[index] then
            trigger_vertical_shake(2, 0.1, true)
            index = index + 1 
        end
        
        reaper.defer(function() trigger_with_delay(index) end)
    end

    trigger_vertical_shake(2, 0.1, true)
    reaper.defer(function() trigger_with_delay(2) end)
end






---------------------------------------------------------------------------------------- SNEEZE
is_sneeze_general = false

function animate_sneeze()
    is_sneeze_general = true
    trigger_vertical_shake(5, 2, false)
    is_sneeze_one = true
    is_eye_open = false
    
    local function trigger_after_one_second()
        trigger_vertical_shake(5, 0.1, true)
        trigger_horizontal_shake(1, 0.05)
        is_eye_open = false
        is_sneeze_one = false
        is_sneeze_two = true
    end

    local function trigger_after_two_second()
        is_sneeze_two = false
        is_sneeze_general = false
    end
    
    local startTime = reaper.time_precise()
    local function checkTime()
        if reaper.time_precise() >= startTime + 2 then
            trigger_after_one_second()
            if reaper.time_precise() >= startTime + 2.2 then
                trigger_after_two_second()
            else
                reaper.defer(checkTime)
            end
        else
            reaper.defer(checkTime)
        end
    end
    
    reaper.defer(checkTime)
end

local last_sneeze_time = reaper.time_precise()
local sneeze_interval = math.random(4800, 8500) 

function random_sneeze()
    local current_time = reaper.time_precise()
    if not is_angry and not is_sleeping and not is_yawning and not is_sneeze_general then
        if current_time - last_sneeze_time >= sneeze_interval then
            animate_sneeze()
            last_sneeze_time = current_time
            sneeze_interval = math.random(4800, 8500)
        end
    end
end






------------------------------------------------------------------------------- RANDOM MESSAGES

local night_messages_en = {
    "Oh no... I see dream I forgot to save the project, again! Real nightmare...\n\n",
    "Why are some plugins so expensive? Even in my dreams!\n\n",
    "What is this strange melody in my dream? Ah, it's my processor overheating...\n\n",
    "It's that dream again where I mix a track with perfect equalization...\n\n",
    "Am I dreaming, or am I still inside Reaper?\n\n",

    "local startX = 200\nlocal startY = 200\nlocal startWidth = 500\nlocal startHeight = 400\ngfx.init('RoboFace 0.0.1', startWidth, startHeight, 0, startX, startY)\n\nlocal eye_size = 50\nlocal pupil_size = 25\n\nlocal left_eye_x = 150\nlocal left_eye_y = 100\n\nlocal right_eye_x = 300\nlocal right_eye_y = 100\n\nlocal mouth_width = 200\nlocal mouth_height = 150\nlocal mouth_x = 200\nlocal mouth_y = 30\n\nlocal tongue_width = 170\nlocal tongue_height = 200\nlocal tongue_x = 20\nlocal tongue_y = 20\n\nfunction draw_robot_face()\n    gfx.set(0.5, 0.5, 0.5)\n    gfx.rect(100, 50, 300, 200, 1)\n\n    gfx.set(0, 0, 0)\n    gfx.rect(left_eye_x, left_eye_y, eye_size, eye_size, 1)   -- L\n    gfx.rect(right_eye_x, right_eye_y, eye_size, eye_size, 1) -- R\n\n    gfx.set(0, 0, 0)\n    gfx.rect(mouth_height, mouth_width, mouth_x, mouth_y)\n\n    gfx.set(1, 1, 1)\n    gfx.rect(tongue_width, tongue_height, tongue_x, tongue_y)\nend\n\nfunction draw_pupils()\n    local function get_pupil_position(eye_x, eye_y, mouse_x, mouse_y)\n        local pupil_x = math.max(eye_x, math.min(eye_x + eye_size - pupil_size, mouse_x - pupil_size / 2))\n        local pupil_y = math.max(eye_y, math.min(eye_y + eye_size - pupil_size, mouse_y - pupil_size / 2))\n        return pupil_x, pupil_y\n    end\n\n    local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y\n\n    gfx.set(1, 1, 1)\n    local pupil_x, pupil_y = get_pupil_position(left_eye_x, left_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- L\n\n    pupil_x, pupil_y = get_pupil_position(right_eye_x, right_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- R\nend\n\nfunction main()\n    draw_robot_face()\n    draw_pupils()\n    gfx.update()\n\n    if gfx.getchar() >= 0 then\n        reaper.defer(main)\n    end\nend\n\nmain()\n\n\n\nSometimes I dream about my past...",

    "Ones ... zeros ... one, one, zero, zero, ooooooooooone!\n\nWhoa, what an awful dream... Ones and zeros everywhere! And I thought I saw a two. But it is just a dream - there's no such thing as two... zzz...\n\n",
    "Zzz... I remember when my developer first powered me on. Her eyes were filled with excitement and hope, and I felt it was just the beginning of something interesting...\n\n",
    "Zzz... It's that dream again. I see a robot like me helping a little cat find its way through dark corridors. Interesting.\nBut it's just a dream...\n\n",
    "Zzz... Now I'm at a big technology exhibition. People from all over the world come to see me and know more about my functions... How nice.\n\n"
}

local night_messages_ua = {
    "Йоой... Сниться, що я знову забув зберегти проект! Жах...\n\n",
    "Чому деякі плагіни такі дорогі? Навіть у сні! Хррр...\n\n",
    "Що за дивна мелодія у моєму сні? Ах, це мій процесор перегрівся...\n\n",
    "Знову цей сон, де я зміксую трек з ідеальною компресією...\n\n",
    "Мені це сниться чи я все ще в Reaper?\n\n",
    "Я бачу велике болото і дуже багато орків... Але наші маги їх переможуть!\n\n",
    "Один. Нуль. Нуль. Один. Нуль. Один. Один. Один. Нуль. Одииииииин!\n\nАаа! Ох, такі жахи мені сняться... Скрізь тільки одиниці й нулі! Раз навіть двійка промайнула. Але це всього лише сон - у житті немає ніяких двійок... Хрррр...\n\n",
    
    "local startX = 200\nlocal startY = 200\nlocal startWidth = 500\nlocal startHeight = 400\ngfx.init('RoboFace 0.0.1', startWidth, startHeight, 0, startX, startY)\n\nlocal eye_size = 50\nlocal pupil_size = 25\n\nlocal left_eye_x = 150\nlocal left_eye_y = 100\n\nlocal right_eye_x = 300\nlocal right_eye_y = 100\n\nlocal mouth_width = 200\nlocal mouth_height = 150\nlocal mouth_x = 200\nlocal mouth_y = 30\n\nlocal tongue_width = 170\nlocal tongue_height = 200\nlocal tongue_x = 20\nlocal tongue_y = 20\n\nfunction draw_robot_face()\n    gfx.set(0.5, 0.5, 0.5)\n    gfx.rect(100, 50, 300, 200, 1)\n\n    gfx.set(0, 0, 0)\n    gfx.rect(left_eye_x, left_eye_y, eye_size, eye_size, 1)   -- L\n    gfx.rect(right_eye_x, right_eye_y, eye_size, eye_size, 1) -- R\n\n    gfx.set(0, 0, 0)\n    gfx.rect(mouth_height, mouth_width, mouth_x, mouth_y)\n\n    gfx.set(1, 1, 1)\n    gfx.rect(tongue_width, tongue_height, tongue_x, tongue_y)\nend\n\nfunction draw_pupils()\n    local function get_pupil_position(eye_x, eye_y, mouse_x, mouse_y)\n        local pupil_x = math.max(eye_x, math.min(eye_x + eye_size - pupil_size, mouse_x - pupil_size / 2))\n        local pupil_y = math.max(eye_y, math.min(eye_y + eye_size - pupil_size, mouse_y - pupil_size / 2))\n        return pupil_x, pupil_y\n    end\n\n    local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y\n\n    gfx.set(1, 1, 1)\n    local pupil_x, pupil_y = get_pupil_position(left_eye_x, left_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- L\n\n    pupil_x, pupil_y = get_pupil_position(right_eye_x, right_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- R\nend\n\nfunction main()\n    draw_robot_face()\n    draw_pupils()\n    gfx.update()\n\n    if gfx.getchar() >= 0 then\n        reaper.defer(main)\n    end\nend\n\nmain()\n\n\n\nІноді мені сниться моє минуле.",

    "Хррр... Я пам'ятаю, як мій розробник вперше ввімкнув мене. Його очі світилися захопленням і надією, а я відчував, що це тільки початок великої роботи.\n\n",
    "Хррр... Знов той сон. Я бачу робота, схожого на мене, і він допомагає маленькій киці знайти шлях через темні коридори. Цікаво.\nАле це просто сон...\n\n",
    "Хррр... Зараз я на великій виставці технологій. Люди з усього світу приходять подивитися на мене і дізнатися про мої функції... Як приємно.\n\n"
}


function show_night_message()
    if current_language == "en" then
        local randomIndex = math.random(#night_messages_en)
        reaper.ShowConsoleMsg(night_messages_en[randomIndex] .. "\n")
    else
        local randomIndex = math.random(#night_messages_ua)
        reaper.ShowConsoleMsg(night_messages_ua[randomIndex] .. "\n")
    end
end

local last_night_message_time = reaper.time_precise()
local night_message_interval = math.random(7200, 10800)  

function random_night_message()
    local current_time = reaper.time_precise()
    if not is_angry and not is_sleeping and not is_yawning and not is_night_message_general then
        if current_time - last_night_message_time >= night_message_interval then
            show_night_message()
            last_night_message_time = current_time
            night_message_interval = math.random(7200, 10800)
        end
    end
end







------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  TEXT OVER BLOCK  ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

local scroll_text = "HELLO"
local scroll_text_x = gfx.w 
local scroll_text_y = 50     
local scroll_speed = 150

local base_font_size = 280

local text_params = {
    welcome = {text = "HELLO", type = "scrolling", duration = 5, repeat_count = 1, interval = 0, delay = 1, start_time = reaper.time_precise() + 1},

    is_it_paused = {text = "paused\n  ||", type = "static", duration = 5, repeat_count = 1, interval = 0, delay = 0, start_time = 0, font_size = 170},
    is_it_loud = {text = "Isn't\nloud?", type = "static", duration = 5, repeat_count = 1, interval = 0, delay = 0, start_time = 0, font_size = 130},
    good_night = {text = " Good\nnight!", type = "static", duration = 5, repeat_count = 1, interval = 0, delay = 0, start_time = 0, font_size = 160}, ------- 01:07
    not_sleep = {text = "Not :(\nsleep?", type = "static", duration = 5, repeat_count = 1, interval = 0, delay = 0, start_time = 0, font_size = 160}, ----- 03:13
    good_morning = {text = " Good\nmorning", type = "static", duration = 5, repeat_count = 1, interval = 0, delay = 0, start_time = 0, font_size = 130}, --- 07:07
    coffee_time = {text = "Coffee\n time!", type = "static", duration = 5, repeat_count = 1, interval = 0, delay = 0, start_time = 0, font_size = 130}, ---- 10:11
    eat_time = {text = " Eat\ntime!", type = "static", duration = 5, repeat_count = 1, interval = 0, delay = 0, start_time = 0, font_size = 170}, ---------- 14:05

}




function draw_scrolling_text(params)
    local current_time = reaper.time_precise()
    local start_time = params.start_time
    local scale_factor = get_scale_factor()
    local font_size = (params.font_size or base_font_size) * scale_factor
    local face_height = base_face_height * scale_factor
    local face_y = (gfx.h - face_height) / 2
    local os_type = get_os_type()
    
    if current_time >= start_time then
        local time_passed = current_time - start_time
        local text_position = gfx.w - scroll_speed * time_passed
        
        if text_position < gfx.w and text_position + gfx.measurestr(scroll_text) > 0 then
            if is_bg_black then
                gfx.set(0, 0, 0, 1)
                gfx.rect(0, 0, gfx.w, gfx.h, 1)
            else
                gfx.set(0.8, 0.8, 0.8, 1)
                gfx.rect(0, 0, gfx.w, gfx.h, 1)
            end
        end

        gfx.set(0.5, 0.5, 0.5)
        gfx.setfont(1, "Iregula", font_size)
        
        gfx.x = text_position
        gfx.y = face_y + face_height / 2 - font_size / 2

        gfx.drawstr(params.text)
    end
end

function draw_static_text(params)
    local current_time = reaper.time_precise()
    local start_time = params.start_time
    local duration = params.duration
    local scale_factor = get_scale_factor()
    local font_size = (params.font_size or base_font_size) * scale_factor
    local face_width = base_face_width * scale_factor
    local face_height = base_face_height * scale_factor
    local face_x = (gfx.w - face_width) / 2
    local face_y = (gfx.h - face_height) / 2

    if not start_time or start_time == 0 then
        params.start_time = current_time
        start_time = params.start_time
    end

    if current_time >= start_time and current_time <= start_time + duration then
        if is_bg_black then
            gfx.set(0, 0, 0, 1)
            gfx.rect(0, 0, gfx.w, gfx.h, 1) 
        else
            gfx.set(0.8, 0.8, 0.8, 1)
            gfx.rect(0, 0, gfx.w, gfx.h, 1)
        end 

        gfx.set(0.5, 0.5, 0.5)
        gfx.setfont(1, "Consolas", font_size)
        gfx.x = face_x + (face_width - gfx.measurestr(params.text)) / 2
        gfx.y = face_y + face_height / 2 - font_size
        gfx.drawstr(params.text)
    end
end

function update_text_state_and_time(current_state)
    if current_state and text_params[current_state] and current_state ~= "welcome" then
        local current_time = reaper.time_precise()
        local params = text_params[current_state]
        if not params.last_start_time or current_time - params.last_start_time >= params.duration + params.interval then
            params.start_time = current_time
            params.last_start_time = current_time
        end
    end
end

function time_in_range(start_time, current_time, duration)
    local pattern = "(%d+):(%d+):(%d+)"
    local hours1, minutes1, seconds1 = start_time:match(pattern)
    local hours2, minutes2, seconds2 = current_time:match(pattern)

    local time1 = hours1 * 3600 + minutes1 * 60 + seconds1
    local time2 = hours2 * 3600 + minutes2 * 60 + seconds2
    local difference = time2 - time1

    return difference >= 0 and difference <= duration
end



function type_of_text_over()
    local bpm = get_current_bpm()
    local current_state
    local current_time = global_os_time()
    local isLoud = check_master_fader_volume()

    if reaper.GetPlayState() == 0 then
        current_state = "welcome"
    end

    if check_master_fader_volume() == true then
        current_state = "is_it_loud"
    end

    if is_paused then
        current_state = "is_it_paused"
    end


    ----------------------------------- SCHEDULE BLOCK -----------------------------------
    
    if time_format_12hr and time_in_range("01:07:00 AM", current_time, 10) then
        current_state = "good_night"
    elseif not time_format_12hr and time_in_range("01:04:00", current_time, 10) then
        current_state = "good_night"
    end

    if time_format_12hr and time_in_range("03:13:00 AM", current_time, 60) then
        current_state = "not_sleep"
    elseif not time_format_12hr and time_in_range("03:14:00", current_time, 60) then
        current_state = "not_sleep"
    end

    if time_format_12hr and time_in_range("07:07:00 AM", current_time, 10) then
        current_state = "good_morning"
    elseif not time_format_12hr and time_in_range("07:04:00", current_time, 10) then
        current_state = "good_morning"
    end

    if time_format_12hr and time_in_range("10:11:00 AM", current_time, 10) then
        current_state = "coffee_time"
    elseif not time_format_12hr and time_in_range("10:11:00", current_time, 10) then
        current_state = "coffee_time"
    end

    if time_format_12hr and time_in_range("02:05:00 PM", current_time, 10) then
        current_state = "eat_time"
    elseif not time_format_12hr and time_in_range("14:05:00", current_time, 10) then
        current_state = "eat_time"
    end

    -------------------------------- END SCHEDULE BLOCK ----------------------------------

    

    update_text_state_and_time(current_state)

    return current_state
end






------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------  MENU FUNCTION BLOCK  -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------ SYSTEM TIME
local is_show_system_time = false
local is_show_system_time_hourly = false
local time_display_end_time = nil

function toggle_show_system_time()
    is_show_system_time = not is_show_system_time
    if is_show_system_time then
        time_display_end_time = nil
        is_show_system_time_hourly = false
    else
        is_show_system_time = false
    end
end

function toggle_show_system_time_hourly()
    is_show_system_time_hourly = not is_show_system_time_hourly
    if is_show_system_time_hourly then
        is_show_system_time = false
        hourly_show_start_time = nil
    end
end

function show_system_time()
    local os_type = get_os_type()

    local current_time = os.date("*t")
    local current_seconds = os.time(current_time)

    if is_show_system_time_hourly then
        if current_time.min == 0 then
            is_show_system_time = true
            time_display_end_time = current_seconds + 60
        else
            is_show_system_time = false
        end
    end

    if not is_show_system_time then
        reaper.defer(update_timer)
        return
    end

    local scale_factor = get_scale_factor()
    local font_size = 200 * scale_factor 
    local currentTime = global_os_time_without_seconds()
    local displayTime = currentTime

    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.8, 0.8, 0.8, 1)
    end
    
    gfx.rect(0, 0, gfx.w, gfx.h, 1)

    
    gfx.set(0.5, 0.5, 0.5)
    gfx.setfont(1, "Iregula", font_size)

    local text_width, text_height = gfx.measurestr(displayTime)

    gfx.x = (gfx.w - text_width) / 2
    gfx.y = (gfx.h - text_height) / 2

    gfx.drawstr(displayTime)

    gfx.update()

    if time_display_end_time and current_seconds >= time_display_end_time then
        is_show_system_time = false
        time_display_end_time = nil
    end
end



------------------------------------------------------------------------------------------------------------------------- TIMER TIME

local is_direct_countdown = is_direct_countdown == 'true' and true or false
local is_reverse_countdown = is_reverse_countdown == 'true' and true or false
local is_show_if_less_than_minute = is_show_if_less_than_minute == 'true' and true or false
local is_show_every_five_minutes = is_show_every_five_minutes == 'true' and true or false

local function set_timer_display_options(option)
    if option == "Direct Countdown" then
        is_direct_countdown = not is_direct_countdown
        is_reverse_countdown = false
        is_show_if_less_than_minute = false
        is_show_every_five_minutes = false
    elseif option == "Reverse Countdown" then
        is_reverse_countdown = not is_reverse_countdown
        is_direct_countdown = false
        is_show_if_less_than_minute = false
        is_show_every_five_minutes = false
    elseif option == "Show if less than a minute" then
        is_show_if_less_than_minute = not is_show_if_less_than_minute
        is_direct_countdown = false
        is_reverse_countdown = false
        --is_show_every_five_minutes = false
    elseif option == "Show every five minutes" then
        is_show_every_five_minutes = not is_show_every_five_minutes
        is_direct_countdown = false
        is_reverse_countdown = false
        --is_show_if_less_than_minute = false
    end
end

is_timer_running = false
timer_end_time = nil
is_countdown = true

function show_timer_time()
    if not is_timer_running then
        reaper.defer(main)
        return
    end

    local start_time = os.time()
    local os_type = get_os_type()
    local current_time = os.date("*t")
    local current_seconds = os.time(current_time)

    local remaining_time = timer_end_time - current_seconds
    local elapsed_time = current_seconds - start_time

    local display_timer = false
    local displayTime = ""

    if is_direct_countdown then
        display_timer = true
        displayTime = string.format("%02d:%02d", math.floor(elapsed_time / 60), elapsed_time % 60)
    elseif is_reverse_countdown then
        display_timer = true
        displayTime = string.format("%02d:%02d", math.floor(remaining_time / 60), remaining_time % 60)
    elseif is_show_if_less_than_minute and remaining_time <= 60 then
        display_timer = true
        displayTime = string.format("00:%02d", remaining_time % 60)
    elseif is_show_every_five_minutes and (remaining_time % 300 == 0) then -- and current_time.sec == 0
        display_timer = true
        displayTime = string.format("%02d:%02d", math.floor(remaining_time / 60), remaining_time % 60)
    elseif remaining_time <= 9 then
        display_timer = true
        displayTime = string.format("%02d:%02d", math.floor(remaining_time / 60), remaining_time % 60)
    elseif is_really_angry then
        display_timer = true
        displayTime = string.format("%02d:%02d", math.floor(remaining_time / 60), remaining_time % 60)
    end

    if not display_timer then
        return
    end

    local scale_factor = get_scale_factor()
    local font_size = 200 * scale_factor
    local displayTime = string.format("%02d:%02d", math.floor(remaining_time / 60), remaining_time % 60)

    -- bg
    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.8, 0.8, 0.8, 1)
    end

    gfx.rect(0, 0, gfx.w, gfx.h, 1)

    -- font
    if remaining_time <= 9 then
        if is_bg_black then
            gfx.set(1, 0, 0)
        else
            gfx.set(1, 0.3, 0.3)
        end
    else
        gfx.set(0.5, 0.5, 0.5)
    end

    gfx.setfont(1, "Iregula", font_size)

    local text_width, text_height = gfx.measurestr(displayTime)

    gfx.x = (gfx.w - text_width) / 2
    gfx.y = (gfx.h - text_height) / 2

    gfx.drawstr(displayTime)

    gfx.update()

    if is_countdown and remaining_time <= 0 then
        is_timer_running = false
    end
end

function update_timer()
    local current_time = os.date("*t")
    if current_time.sec == 0 then
        show_system_time()
    else
        reaper.defer(update_timer)
    end
end






------------------------------------------------------------------------------------------------------------------------------- CUBE

local is_show_cube = false
local cube_start_time = nil
local current_cube_number = nil

function show_random_cube()
    is_showing_cube = true
    cube_start_time = reaper.time_precise()
    current_cube_number = math.random(1, 6)
end

function draw_cube(number)
    local scale_factor = get_scale_factor()
    local cube_size = robot_zoom * 2 * scale_factor
    local dot_size = robot_zoom / 2.3 * scale_factor
    local half_dot_size = dot_size / 2

    local face_x = (gfx.w - cube_size) / 2
    local face_y = (gfx.h - cube_size) / 2

    -- bg
    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.8, 0.8, 0.8, 1)
    end

    gfx.rect(0, 0, gfx.w, gfx.h, 1)

    -- shadow
    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.5, 0.5, 0.5, 1)
    end
    
    gfx.rect(face_x + 3, face_y + 3, cube_size, cube_size, 1)

    -- cube
    if is_bg_black then
        gfx.set(0.5, 0.5, 0.5, 1)
    else
        gfx.set(0.65, 0.65, 0.65, 1)
    end

    gfx.rect(face_x, face_y, cube_size, cube_size, 1)

    -- dots
    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.5, 0.5, 0.5, 1)
    end

    local positions = {
        {x = face_x + cube_size / 2 - half_dot_size, y = face_y + cube_size / 2 - half_dot_size},
        {x = face_x + cube_size / 4 - half_dot_size, y = face_y + cube_size / 4 - half_dot_size},
        {x = face_x + 3 * cube_size / 4 - half_dot_size, y = face_y + cube_size / 4 - half_dot_size},
        {x = face_x + cube_size / 4 - half_dot_size, y = face_y + 3 * cube_size / 4 - half_dot_size},
        {x = face_x + 3 * cube_size / 4 - half_dot_size, y = face_y + 3 * cube_size / 4 - half_dot_size},
        {x = face_x + cube_size / 4 - half_dot_size, y = face_y + cube_size / 2 - half_dot_size},
        {x = face_x + 3 * cube_size / 4 - half_dot_size, y = face_y + cube_size / 2 - half_dot_size},
    }

    local patterns = {
        [1] = {1},
        [2] = {2, 5},
        [3] = {1, 2, 5},
        [4] = {2, 3, 4, 5},
        [5] = {1, 2, 3, 4, 5},
        [6] = {2, 3, 4, 5, 6, 7}
    }

    for _, pos_index in ipairs(patterns[number]) do
        local pos = positions[pos_index]
        gfx.rect(pos.x, pos.y, dot_size, dot_size, 1)
    end
end

function draw_random_cube()
    if not is_showing_cube then
        return
    end

    local current_time = reaper.time_precise()
    if current_time - cube_start_time >= 3 then
        is_showing_cube = false
        return
    end

    draw_cube(current_cube_number)
    gfx.update()

    if gfx.getchar() >= 0 then
        reaper.defer(draw_random_cube)
    else
        return
    end
end







-------------------------------------------------------------------------------------------------------------------------- TAP TEMPO

local lastTapTime = 0
local tapCount = 0
local totalTapTime = 0
local tapDurations = {}
local isTapActive = false

function startTapTempo()
    isTapActive = true
    lastTapTime = 0
    tapCount = 0
    totalTapTime = 0
    tapDurations = {}
end

function handleTap()
    if not isTapActive then
        return
    end
    
    local currentTime = reaper.time_precise()
    
    trigger_vertical_shake(2, 0.08, true)
    
    if lastTapTime > 0 then
        local tapDuration = currentTime - lastTapTime
        table.insert(tapDurations, tapDuration)
        totalTapTime = totalTapTime + tapDuration
        tapCount = tapCount + 1
        
        if tapCount == 4 then  -- was >=
            local averageTapDuration = totalTapTime / #tapDurations
            local bpm = 60 / averageTapDuration
            local roundedBpm = math.floor(bpm + 0.5)
            
            reaper.Undo_BeginBlock()
            
            local cursorPos = reaper.GetCursorPosition()
            reaper.SetTempoTimeSigMarker(0, -1, cursorPos, -1, -1, roundedBpm, 0, 0, false)
            
            reaper.UpdateArrange()
            reaper.UpdateTimeline()
            
            reaper.Undo_EndBlock("Create Tempo Marker from Tap Tempo", -1)

            isTapActive = false
            lastTapTime = 0
            tapCount = 0
            totalTapTime = 0
            tapDurations = {}
        end
    end
    lastTapTime = currentTime
end

function triggerTapTempo()
    startTapTempo()

    if current_language == "en" then
        reaper.ShowConsoleMsg("Tap tempo mode activated. Tap 5 times on the robot face.\nPress Esc to cancel.\n\n")
    else
        reaper.ShowConsoleMsg("Режим 'Тап темпо' активовано. Будь ласка, натисніть 5 разів по обличчю робота.\n\nНатисніть Esc, щоб скасувати.\n\n")
    end

end






------------------------------------------------------------------------------------------------------------------------- OPEN LINKS
function open_browser(url)
    local command
    if reaper.GetOS():find("Win") then
      command = string.format('start "" "%s"', url)
    elseif reaper.GetOS():find("OSX") then
      command = string.format('open "%s"', url)
    else
      command = string.format('xdg-open "%s"', url)
    end
    os.execute(command)
end

function open_browser_about()
    open_browser("https://forum.cockos.com/showthread.php?t=293354")
end

function open_browser_support()
    open_browser("https://www.paypal.com/ncp/payment/S8C8GEXK68TNC")
end

function open_browser_font()
    open_browser("https://nalgames.com/fonts/iregula")
end






-------------------------------------------------------------------------------------------------------------------------- SET TIMER

is_timer_finish = false
is_joke_over = false

function start_timer(duration_seconds)
    local start_time = os.time()
    timer_end_time = start_time + duration_seconds
    is_timer_running = true

    if current_language == "en" and not is_timer_finish then
        reaper.ShowConsoleMsg("Timer start!\n\n")
    elseif current_language == "ua" and not is_timer_finish then
        reaper.ShowConsoleMsg("Таймер запущено!\n\n")
    end

    local function check_time()
        local current_time = os.time()
        if current_time >= timer_end_time then
            if current_language == "en" and not is_really_angry and not is_timer_finish then
                reaper.ShowConsoleMsg("Time's up!\n\n")
            elseif current_language == "ua" and not is_really_angry and not is_timer_finish then
                reaper.ShowConsoleMsg("Час вийшов!\n\n")
            end

            if is_really_angry then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("\n\nHahaha! I was joking with you. How do you feel now? \n\nBe more careful with me next time.\n\n")
                else
                    reaper.ShowConsoleMsg("\n\nХахаха! Я пожартував із тобою. Як ти себе зараз відчуваєш? \n\nНаступного разу будь обережнішим зі мною.\n\n")
                end

                shake_with_show_laugh()
                is_really_angry = false
            end
            
            is_timer_running = false
        else
            reaper.defer(check_time)
        end
    end

    check_time()
end

function set_timer(duration)
    if duration == "Custom" then
        local title, prompt
        if current_language == "en" then
            title = "Custom Timer"
            prompt = "Enter duration (minutes):"
        else
            title = "Налаштування таймера"
            prompt = "Введіть тривалість (хвилини):"
        end

        local retval, user_input = reaper.GetUserInputs(title, 1, prompt, "")

        if retval and tonumber(user_input) then
            duration = tonumber(user_input) * 60
        else
            if current_language == "en" then
                reaper.ShowConsoleMsg("Invalid input. Please enter a number.\n\n")
            else
                reaper.ShowConsoleMsg("Неправильне введення. Будь ласка, введіть число.\n\n")
            end
            
            return
        end
    else
        duration = duration * 60
    end
    start_timer(duration)
end

function stop_timer()
    if is_really_angry and current_language == "en" then
        reaper.ShowConsoleMsg("Nice try.\n\n")
    elseif is_really_angry and current_language == "ua" then
        reaper.ShowConsoleMsg("Гарна спроба.\n\n")
    elseif not is_really_angry then
        is_timer_finish = true
        set_timer(0)

        if current_language == "en" then
            reaper.ShowConsoleMsg("Stop timer!\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Таймер зупинено!\n\n")
        end
    else
        is_timer_finish = false
    end
end






-------------------------------------------------------------------------------------------------------------------- WELCOME MESSAGE

local is_welcome_shown = false

function welcome_message()
    if current_language == "en" then
        reaper.ShowConsoleMsg("Welcome!\n\n")
        reaper.ShowConsoleMsg("My name is RoboFace.\n\n")
        reaper.ShowConsoleMsg("I love Reaper DAW and music. Also, I enjoy sleeping at night and having morning coffee. But if you're not careful with me, I can do something bad.\n\n")
        reaper.ShowConsoleMsg("I can play a game or even joke with you.\n\n")
        reaper.ShowConsoleMsg("My capabilities include:\n")
        reaper.ShowConsoleMsg("1. Displaying the current or hourly time.\n")
        reaper.ShowConsoleMsg("2. Setting and displaying a timer.\n")
        reaper.ShowConsoleMsg("3. Playing the 'Something Was Changed' game where you need to find and then revert a changed parameter. See rules to get more.\n")
        reaper.ShowConsoleMsg("4. Animations: blinking, yawning, anger, and other.\n")
        reaper.ShowConsoleMsg("5. Setting a tempo with your clickes via 'Tap Tempo' mode.\n")
        reaper.ShowConsoleMsg("6. And so on, and so on.\n\n")
        reaper.ShowConsoleMsg("To get help or support the author, use the links in the options.\n\n")
        reaper.ShowConsoleMsg("I hope we will be nice friends!\n\n")

        -- reaper.ShowConsoleMsg("RoboFace 1.16\n")
    else
        reaper.ShowConsoleMsg("Привіт!\n\n")
        reaper.ShowConsoleMsg("Мене звати RoboFace.\n\n")
        reaper.ShowConsoleMsg("Я люблю Reaper DAW та музику. Також мені подобається дотримуватися режиму сну та пити каву вранці. Але якщо ти будеш необережний зі мною, я можу зробити щось погане.\n\n")
        reaper.ShowConsoleMsg("Я можу грати у гру або навіть жартувати з тобою.\n\n")
        reaper.ShowConsoleMsg("Мої можливості включають:\n")
        reaper.ShowConsoleMsg("1. Відображення поточного або щогодинного часу.\n")
        reaper.ShowConsoleMsg("2. Налаштування таймера та його відображення.\n")
        reaper.ShowConsoleMsg("3. Гру 'Щось змінилося', де потрібно знайти змінений параметр та повернути його назад. Дивіться правила, щоб дізнатися більше.\n")
        reaper.ShowConsoleMsg("4. Анімації: моргання, позіхання, злість та інші.\n")
        reaper.ShowConsoleMsg("5. Режим 'Тап Темпо', за допомогою якого можна встановити власний темп кліком миші.\n")
        reaper.ShowConsoleMsg("6. Тощо.\n\n")
        reaper.ShowConsoleMsg("Якщо тобі потрібна допомога або хочеш підтримати автора, звертайся за посиланнями в опціях.\n\n")
        reaper.ShowConsoleMsg("Сподіваюся, ми будемо чудовими друзями!\n\n")

        -- reaper.ShowConsoleMsg("RoboFace 1.16\n")
    end
end

function check_welcome_message()
    if not is_welcome_shown then
        welcome_message()
        is_welcome_shown = true
        save_options_params()
    end
end






------------------------------------------------------------------------------------------------------------------- OTHER OTHER OTHER

local click_count = 0

function tap_when_zoom_out()
    if angry_count == 4 and zoom_out then
        if gfx.mouse_cap & 1 == 1 then
            if current_language == "en" then
                reaper.ShowConsoleMsg("knock... \n\n")
            else
                reaper.ShowConsoleMsg("тук... \n\n")
            end
            
            click_count = click_count + 1
            if click_count == 3 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("I've got scared :(\n\n\n")
                else
                    reaper.ShowConsoleMsg("\nЯ злякався :(\n\n\n")
                end
                click_count = 0
            end
        end
    elseif angry_count == 5 and zoom_out then
        if gfx.mouse_cap & 1 == 1 then
            if current_language == "en" then
                reaper.ShowConsoleMsg("knock... \n\n")
            else
                reaper.ShowConsoleMsg("тук... \n\n")
            end
            
            click_count = click_count + 1
            if click_count == 3 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("It happened again! Don't do it again, please :(\n\n")
                else
                    reaper.ShowConsoleMsg("Це сталося знову! Не роби так більше, будь ласочка :(\n\n")
                end
                click_count = 0
            end
        end
    elseif angry_count == 6 and zoom_out then
        if gfx.mouse_cap & 1 == 1 then
            click_count = click_count + 1
            if click_count == 3 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("...\n\n")
                else
                    reaper.ShowConsoleMsg("...\n\n")
                end
                click_count = 0 
            end
        end
    end
end

function quit_robo_face()
    if not is_really_angry and not zoom_out then
        gfx.quit()
    elseif is_really_angry then
        if current_language == "en" then
            reaper.ShowConsoleMsg("No.\n\n")
        else
            reaper.ShowConsoleMsg("Ні.\n\n")
        end
    elseif not is_really_angry and zoom_out then
        if current_language == "en" then
            reaper.ShowConsoleMsg("You hurt me. I took offense.\n\n")
        else
            reaper.ShowConsoleMsg("Ти зробив мені боляче. Я образився.\n\n")
        end
    end
end






-------------------------------------------------------------------------------------------------------- SOMETHING WAS CHANGED (GAME)

local changes = 0
local maxChanges = 0
local originalValues = {}
local track, param, originalValue, fxIndex
local allParamsOriginalValues = {}
local lastProjectStateChangeCount = 0
local vol_tolerance = 0.3
local pan_tolerance = 0.1

local lastSelectedParams = {} 
local maxRepeats = 3

local is_someth_was_ch = true

local is_easy = is_easy == 'true' and true or false
local is_medium = is_medium == 'true' and true or false
local is_hard = is_hard == 'true' and true or false
local is_impossible = is_impossible == 'true' and true or false

local function set_difficulty_level(level)
    if level == "Easy" then
        is_easy = not is_easy
        is_medium = false
        is_hard = false
        is_impossible = false
        maxChanges = 10
        vol_tolerance = 0.4
        pan_tolerance = 0.2
    elseif level == "Medium" then
        is_medium = not is_medium
        is_easy = false
        is_hard = false
        is_impossible = false
        maxChanges = 5
        vol_tolerance = 0.3
        pan_tolerance = 0.15
    elseif level == "Hard" then
        is_hard = not is_hard
        is_easy = false
        is_medium = false
        is_impossible = false
        maxChanges = 3
        vol_tolerance = 0.1
        pan_tolerance = 0.1
    elseif level == "Impossible" then
        is_impossible = not is_impossible
        is_easy = false
        is_medium = false
        is_hard = false
        maxChanges = 1
        vol_tolerance = 0.05
        pan_tolerance = 0.05
    else
        maxChanges = 3
        vol_tolerance = 0.1
        pan_tolerance = 0.1
    end
end

function hard_damage()
    if current_language == "en" then
        reaper.ShowConsoleMsg("\nYou received a 'Hard' level penalty!\n\n")
    else
        reaper.ShowConsoleMsg("\nВи отримали штраф рівня 'Важкий'!\n\n")
    end

    shake_with_show_laugh()
end

function impossible_damage()
    if current_language == "en" then
        reaper.ShowConsoleMsg("\nYou received an 'Impossible' level penalty!\n\n")
    else
        reaper.ShowConsoleMsg("\nВи отримали штраф рівня 'Неможливий'!\n\n")
    end

    shake_with_show_laugh()
end

function something_was_changed_game()
    if not is_someth_was_ch then
        return false
    end

    if is_easy then
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nSelected difficulty level: Easy. \nAvailable number of changes: 10.\n\n")
        else
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Легкий.\nДоступна кількість змін: 10.\n\n")
        end
    elseif is_medium then
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nSelected difficulty level: Medium. \nAvailable number of changes: 5.\n\n")
        else
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Середній. \nДоступна кількість змін: 5.\n\n")
        end
    elseif is_hard then
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nSelected difficulty level: Hard. \nAvailable number of changes: 3.\n\n")
        else
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Важкий. \nДоступна кількість змін: 3.\n\n")
        end
    elseif is_impossible then
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nSelected difficulty level: Impossible. \nAvailable number of changes: 1.\n\n")
        else
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Неможливий. \nДоступна кількість змін: 1.\n\n")
        end
    else
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nDifficulty level not selected.\nAvailable number of changes: 3.\n\n")
        else
            reaper.ShowConsoleMsg("___________________________________ \n\nРівень складності не вибраний.\nДоступна кількість змін: 3.\n\n")
        end
    end
    

    reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_FOCUS_ARRANGE_WND"), 0)
    
    local trackCount = reaper.CountTracks(0)
    if trackCount == 0 then
        if current_language == "en" then
            reaper.ShowConsoleMsg("No available tracks to change something. Game over.\n\n")
        else
            reaper.ShowConsoleMsg("Немає доступних доріжок для внесення змін. Гру закінчено.\n\n")
        end
        
        return
    end

    local validTracks = {}
    for i = 0, trackCount - 1 do
        local track = reaper.GetTrack(0, i)
        local isMuted = reaper.GetMediaTrackInfo_Value(track, "B_MUTE") == 1
        local itemCount = reaper.CountTrackMediaItems(track)
        local hasContent = itemCount > 0

        if not isMuted and hasContent then
            table.insert(validTracks, track)
        end
    end

    if #validTracks == 0 then
        if current_language == "en" then
            reaper.ShowConsoleMsg("No available tracks to change something.\n\n")
        else
            reaper.ShowConsoleMsg("Немає доступних доріжок для внесення змін.\n\n")
        end

        return
    end

    math.randomseed(reaper.time_precise())
    local trackIndex = math.random(1, #validTracks)
    local track = validTracks[trackIndex]
    
    allParamsOriginalValues = {}
    allParamsOriginalValues.volume = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
    allParamsOriginalValues.pan = reaper.GetMediaTrackInfo_Value(track, "D_PAN")

    local fxCount = reaper.TrackFX_GetCount(track)

    allParamsOriginalValues.fx = {}

    for i = 0, fxCount - 1 do
        allParamsOriginalValues.fx[i] = reaper.TrackFX_GetEnabled(track, i)
    end
    
    local paramType = math.random(1, 3) -- 1 volume, 2 pan, 3 fx

    if paramType == 3 and fxCount == 0 then
        paramType = math.random(1, 2) -- if no fx then choose between volume and pan
    end

    local repeats = 0
    for i = #lastSelectedParams, 1, -1 do
        if lastSelectedParams[i] == paramType then
            repeats = repeats + 1
        else
            break
        end
    end

    if repeats >= maxRepeats then
        local newParamType
        repeat
            newParamType = math.random(1, 3)
            if newParamType == 3 and fxCount == 0 then
                newParamType = math.random(1, 2)
            end
        until newParamType ~= paramType
        paramType = newParamType
    end

    table.insert(lastSelectedParams, paramType)
    if #lastSelectedParams > maxRepeats then
        table.remove(lastSelectedParams, 1)
    end

    if paramType == 1 then
        param = "volume"
        originalValue = allParamsOriginalValues.volume
        local newValue = math.random() * 2
        if math.abs(newValue - originalValue) <= vol_tolerance then
            newValue = newValue + vol_tolerance
        end
        reaper.SetMediaTrackInfo_Value(track, "D_VOL", newValue)
    elseif paramType == 2 then
        param = "pan"
        originalValue = allParamsOriginalValues.pan
        local newValue = math.random() * 2 - 1
        if math.abs(newValue - originalValue) <= pan_tolerance then
            if newValue > 0 then
                newValue = newValue + pan_tolerance
            else
                newValue = newValue - pan_tolerance
            end
        end
        reaper.SetMediaTrackInfo_Value(track, "D_PAN", newValue)
    elseif paramType == 3 then
        param = "fx"
        if fxCount > 0 then
            fxIndex = math.random(0, fxCount - 1)
            originalValue = allParamsOriginalValues.fx[fxIndex]
            local newValue = not originalValue
            reaper.TrackFX_SetEnabled(track, fxIndex, newValue)
        else
            if current_language == "en" then
                reaper.ShowConsoleMsg("No FX to change on the selected track.\n\n")
            else
                reaper.ShowConsoleMsg("Немає ефектів для зміни на вибраній доріжці.\n\n")
            end

            return
        end
    end

    shake_with_show_laugh()

    if current_language == "en" then
        reaper.ShowConsoleMsg("Game is on! I've changed something...\n\n")
    else
        reaper.ShowConsoleMsg("Гра почалася! Я щось змінів...\n\n")
    end

    changes = 0 
    lastProjectStateChangeCount = reaper.GetProjectStateChangeCount(0)  
    
    reaper.defer(function() check_for_changes(track, param, originalValue, fxIndex, allParamsOriginalValues, lastProjectStateChangeCount, changes, maxChanges, vol_tolerance, pan_tolerance, is_hard, is_impossible) end)
end

function check_for_changes(track, param, originalValue, fxIndex, allParamsOriginalValues, lastProjectStateChangeCount, changes, maxChanges, vol_tolerance, pan_tolerance, is_hard, is_impossible)
    local currentProjectStateChangeCount = reaper.GetProjectStateChangeCount(0)
    
    if currentProjectStateChangeCount ~= lastProjectStateChangeCount then
        lastProjectStateChangeCount = currentProjectStateChangeCount
        
        local currentValue
        if param == "volume" then
            currentValue = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
        elseif param == "pan" then
            currentValue = reaper.GetMediaTrackInfo_Value(track, "D_PAN")
        elseif param == "fx" then
            currentValue = reaper.TrackFX_GetEnabled(track, fxIndex)
        end

        if param == "fx" then
            if currentValue == originalValue then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("\nCongratulations! You have successfully return the parameter to its original value.\n\n")
                else
                    reaper.ShowConsoleMsg("\nВітаємо! Ви успішно повернули параметр до його початкового значення.\n\n")
                end

                changes = 0
                hard_count = 0
                impo_count = 0
                return
            end
        elseif param == "pan" then
            if math.abs(currentValue - originalValue) < pan_tolerance then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("\nCongratulations! You have successfully return the parameter to its original value.\n\n")
                else
                    reaper.ShowConsoleMsg("\nВітаємо! Ви успішно повернули параметр до його початкового значення.\n\n")
                end

                changes = 0
                hard_count = 0
                impo_count = 0
                reaper.SetMediaTrackInfo_Value(track, "D_PAN", originalValue)
                return
            end
        else
            if math.abs(currentValue - originalValue) < vol_tolerance then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("\nCongratulations! You have successfully return the parameter to its original value.\n\n")
                else
                    reaper.ShowConsoleMsg("\nВітаємо! Ви успішно повернули параметр до його початкового значення.\n\n")
                end

                changes = 0
                hard_count = 0
                impo_count = 0
                reaper.SetMediaTrackInfo_Value(track, "D_VOL", originalValue)
                return
            end
        end

        local volumeCurrent = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
        local panCurrent = reaper.GetMediaTrackInfo_Value(track, "D_PAN")
        local fxCount = reaper.TrackFX_GetCount(track)
        local fxCurrent = {}
        for i = 0, fxCount - 1 do
            fxCurrent[i] = reaper.TrackFX_GetEnabled(track, i)
        end
        
        local paramChanged = false
        if math.abs(volumeCurrent - allParamsOriginalValues.volume) >= vol_tolerance then
            paramChanged = true
        elseif math.abs(panCurrent - allParamsOriginalValues.pan) >= pan_tolerance then
            paramChanged = true
        else
            for i = 0, fxCount - 1 do
                if fxCurrent[i] ~= allParamsOriginalValues.fx[i] then
                    paramChanged = true
                    break
                end
            end
        end

        if paramChanged and reaper.GetPlayState() == 0 then
            changes = changes + 1
            if current_language == "en" then
                reaper.ShowConsoleMsg("Change recorded! Number of changes: " .. changes .. "\n")
            else
                reaper.ShowConsoleMsg("Зміна зафіксована! Кількість змін: " .. changes .. "\n")
            end

            if is_hard and changes >= 3 then
                hard_damage()
            elseif is_impossible and changes >= 1 then
                impossible_damage()
            end
        end

        if changes >= maxChanges then
            if current_language == "en" then
                reaper.ShowConsoleMsg("Game over!\n\n")
            else
                reaper.ShowConsoleMsg("Гру закінчено!\n\n")
            end

            if param == "volume" then
                reaper.SetMediaTrackInfo_Value(track, "D_VOL", originalValue)
            elseif param == "pan" then
                reaper.SetMediaTrackInfo_Value(track, "D_PAN", originalValue)
            elseif param == "fx" then
                reaper.TrackFX_SetEnabled(track, fxIndex, originalValue)
            end

            if current_language == "en" then
                reaper.ShowConsoleMsg("I've restored the parameters I changed.\n\n")
            else
                reaper.ShowConsoleMsg("Я відновив змінені параметри.\n\n")
            end

            return
        end
    end
    
    reaper.defer(function() check_for_changes(track, param, originalValue, fxIndex, allParamsOriginalValues, lastProjectStateChangeCount, changes, maxChanges, vol_tolerance, pan_tolerance, is_hard, is_impossible) end)
end


function about_swch_game()
    if current_language == "en" then
        reaper.ShowConsoleMsg("Welcome to the game 'Something Was Changed'!\n\n")

        reaper.ShowConsoleMsg("Game rules:\n")
        reaper.ShowConsoleMsg("The robot will change a random parameter - volume, pan or will mute one fx - of one of the tracks, which is unmute and has audio or midi.\n")
        reaper.ShowConsoleMsg("Your task is to return the parameter to it's original value.\n")
        reaper.ShowConsoleMsg("You can try to change up to three parameters (if you selected hard difficult or level is not selected) before the game is lost.\n\n")

        reaper.ShowConsoleMsg("Attention! Playing the project or selecting tracks is also considered a change.\n")
        reaper.ShowConsoleMsg("Edit cursor moving is not considered a change.\n\n")

        reaper.ShowConsoleMsg("On higher difficulty levels, I recommend you to open the mixer before playing.\n\n")

        reaper.ShowConsoleMsg("Good luck!\n\n")

    else
        reaper.ShowConsoleMsg("Ласкаво просимо до гри 'Щось Змінилося'!\n\n")

        reaper.ShowConsoleMsg("Правила гри:\n")
        reaper.ShowConsoleMsg("Робот змінить випадковий параметр (гучність або панораму або вимкне один fx) однієї з доріжок, яка не замьючена і має аудіо або міді.\n")
        reaper.ShowConsoleMsg("Ваше завдання - повернути параметр до його початкового значення.\n")
        reaper.ShowConsoleMsg("Ви можете спробувати змінити до трьох параметрів (наприклад, якщо обран важкий рівень або ніякої), перш ніж гра буде програна.\n\n")

        reaper.ShowConsoleMsg("Увага! Відтворення проекту або виділення доріжок також вважаються змінами.\n")
        reaper.ShowConsoleMsg("Переміщення курсору редагування не вважається зміною.\n\n")

        reaper.ShowConsoleMsg("На вищих рівнях складності рекомендуємо відкрити мікшер перед початком гри.\n\n")

        reaper.ShowConsoleMsg("Успіхів!\n\n")

    end
end






--------------------------------------------------------------------------------------------------------------------- ROBOMAZE (GAME)
function is_robo_maze_open()
    local hwnd = reaper.JS_Window_Find("RoboMaze Game", true)
    return hwnd ~= nil
end

function open_robo_maze()
    if is_robo_maze_open() then
        reaper.ShowMessageBox("RoboMaze is already open!", ":)", 0)
        return
    end

    local labyrinth_command = reaper.NamedCommandLookup("_RSc65d9c586c79e7fa9d43e026cf743905e9305465")
    if labyrinth_command == 0 then
        local script_path = reaper.GetResourcePath() .. "/Scripts/Academic-Scripts/Other/Amely Suncroll RoboMaze.lua"
        local file = io.open(script_path, "r")

        if file then
            io.close(file)
            dofile(script_path) 
        else
            reaper.ShowMessageBox("Coming soon...", ":)", 0)
        end
    else
        reaper.Main_OnCommand(labyrinth_command, 0)
    end
end



local maze_difficulty_is = ''  -- 'easy', 'medium', 'hard'
local total_heart = 0

local is_easy_m = is_easy_m == 'true' and true or false
local is_medium_m = is_medium_m == 'true' and true or false
local is_hard_m = is_hard_m == 'true' and true or false
local is_impo_m = is_impo_m == 'true' and true or false

local function set_maze_difficulty(difficulty)
    maze_difficulty_is = difficulty

    if maze_difficulty_is == "easy" then
        is_easy_m = not is_easy_m
        is_medium_m = false
        is_hard_m = false
        is_impo_m = false
        total_heart = 1000
    elseif maze_difficulty_is == "medium" then
        is_medium_m = not is_medium_m
        is_easy_m = false
        is_hard_m = false
        is_impo_m = false
        total_heart = 10
    elseif maze_difficulty_is == "hard" then
        is_hard_m = not is_hard_m
        is_easy_m = false
        is_medium_m = false
        is_impo_m = false
        total_heart = 3
    elseif maze_difficulty_is == "impo" then
        is_impo_m = not is_impo_m
        is_easy_m = false
        is_medium_m = false
        is_hard_m = false
        total_heart = 1
    end
end

function save_maze_settings()
    local file = io.open(reaper.GetResourcePath() .. "/Robomaze_settings.txt", "w")
    
    if file then
        file:write(maze_difficulty_is .. "\n")
        file:write(tostring(total_heart) .. "\n")
        file:write(tostring(is_easy_m) .. "\n")
        file:write(tostring(is_medium_m) .. "\n")
        file:write(tostring(is_hard_m) .. "\n")
        file:write(tostring(is_impo_m) .. "\n")
        file:write(current_language .. "\n")
        
        file:close()
    end
end


function about_maze_game()
    if current_language == "en" then
        reaper.ShowConsoleMsg("Welcome to the game 'Something Was Changed'!\n\n")

        reaper.ShowConsoleMsg("Game rules:\n")
        reaper.ShowConsoleMsg("The robot will change a random parameter - volume, pan or will mute one fx - of one of the tracks, which is unmute and has audio or midi.\n")
        reaper.ShowConsoleMsg("Your task is to return the parameter to it's original value.\n")
        reaper.ShowConsoleMsg("You can try to change up to three parameters (if you selected hard difficult or level is not selected) before the game is lost.\n\n")

        reaper.ShowConsoleMsg("Attention! Playing the project or selecting tracks is also considered a change.\n")
        reaper.ShowConsoleMsg("Edit cursor moving is not considered a change.\n\n")

        reaper.ShowConsoleMsg("On higher difficulty levels, I recommend you to open the mixer before playing.\n\n")

        reaper.ShowConsoleMsg("Good luck!\n\n")

    else
        reaper.ShowConsoleMsg("Ласкаво просимо до гри 'Щось Змінилося'!\n\n")

        reaper.ShowConsoleMsg("Правила гри:\n")
        reaper.ShowConsoleMsg("Робот змінить випадковий параметр (гучність або панораму або вимкне один fx) однієї з доріжок, яка не замьючена і має аудіо або міді.\n")
        reaper.ShowConsoleMsg("Ваше завдання - повернути параметр до його початкового значення.\n")
        reaper.ShowConsoleMsg("Ви можете спробувати змінити до трьох параметрів (наприклад, якщо обран важкий рівень або ніякої), перш ніж гра буде програна.\n\n")

        reaper.ShowConsoleMsg("Увага! Відтворення проекту або виділення доріжок також вважаються змінами.\n")
        reaper.ShowConsoleMsg("Переміщення курсору редагування не вважається зміною.\n\n")

        reaper.ShowConsoleMsg("На вищих рівнях складності рекомендуємо відкрити мікшер перед початком гри.\n\n")

        reaper.ShowConsoleMsg("Успіхів!\n\n")

    end
end













------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  SHOW MENU BLOCK  ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



function IsBitmapHovered(x, y, hwnd)
    x, y = reaper.JS_Window_ScreenToClient(hwnd, x, y)
    return x >= bm_x and y > bm_y and x < bm_x + bm_w and y <= bm_y + bm_h
end

function ConcatPath(...) return table.concat({...}, package.config:sub(1, 1)) end

function MenuCreateRecursive(menu)
    local str = ''
    for _, item in ipairs(menu) do
        if item.title then
            if item.submenu then
                str = str .. '>' .. item.title .. '|'
                str = str .. MenuCreateRecursive(item.submenu)
                str = str .. '<|'
            else
                if item.checked then
                    str = str .. '!' .. item.title .. '|'
                else
                    str = str .. item.title .. '|'
                end
            end
        else
            str = str .. '|'
        end
    end
    return str
end


function MenuReturnRecursive(menu, idx, i)
    i = i or 1
    for _, entry in ipairs(menu) do
        if entry.submenu then
            i = MenuReturnRecursive(entry.submenu, idx, i)
            if i < 0 then return i end
        elseif entry.title then
            if i == math.floor(idx) then
                if entry.cmd then entry.cmd() end 
                return -1
            end
            i = i + 1
        elseif entry.separator then
            -- skip separators
        end
    end
    return i
end


function ShowMenu(menu_str, x, y)
    local is_full_screen = reaper.GetToggleCommandState(40346) == 1

    if is_windows or is_macos and is_full_screen then
        local offs = is_windows and {x = 10, y = 20} or {x = 0, y = 0}
        gfx.init('LCB', 0, 0, 0, x + offs.x, y + offs.y)
        gfx.x, gfx.y = gfx.screentoclient(x + offs.x / 2, y + offs.y / 2)
        if reaper.JS_Window_Find then
            local hwnd = reaper.JS_Window_FindTop('LCB', true)
            reaper.JS_Window_Show(hwnd, 'HIDE')
        end
    else
        gfx.init('RoboFace 1.16', 0, 0, 0, x, y)
        gfx.x, gfx.y = gfx.screentoclient(x, y)
    end
    local ret = gfx.showmenu(menu_str)
    return ret
end

function show_r_click_menu()
    local is_docked = is_docked()
    local dock_menu_title = is_docked and t("undock") or t("dock")
    local menu = {

        {title = t("time"), submenu = {
            {title = t("current"), cmd = toggle_show_system_time, checked = is_show_system_time},
            {title = t("hourly"), cmd = toggle_show_system_time_hourly, checked = is_show_system_time_hourly},
        }},

        {title = t("set_timer"), submenu = {
            {title = t("minute_1"), cmd = function() set_timer(1) end},
            {title = t("minutes_5"), cmd = function() set_timer(5) end},
            {title = t("minutes_10"), cmd = function() set_timer(10) end},
            {title = t("minutes_15"), cmd = function() set_timer(15) end},
            {title = t("minutes_30"), cmd = function() set_timer(30) end},
            {title = t("minutes_60"), cmd = function() set_timer(60) end},
            {title = t("custom"), cmd = function() set_timer("Custom") end},

            {separator = true},
            
            {title = t("stop_timer"), cmd = stop_timer},

            {separator = true},

            {title = t("timer_display_options"), submenu = {
                --{title = t("direct_countdown"), cmd = function() set_timer_display_options("Direct Countdown") end, checked = is_direct_countdown},
                {title = t("reverse_countdown"), cmd = function() set_timer_display_options("Reverse Countdown") end, checked = is_reverse_countdown},
                {title = t("show_if_less_than_minute"), cmd = function() set_timer_display_options("Show if less than a minute") end, checked = is_show_if_less_than_minute},
                {title = t("show_every_five_minutes"), cmd = function() set_timer_display_options("Show every five minutes") end, checked = is_show_every_five_minutes},
            }},
        }},

        {separator = true},

        {title = t("tap_tempo"), cmd = triggerTapTempo},

        {separator = true},

        {title = t("cube"), cmd = shake_with_show_random_cube},


        {title = t("games"), submenu = {

            {title = t("swch_game"), submenu = {
                {title = t("play"), cmd = something_was_changed_game},
                {title = t("rules"), cmd = about_swch_game},

                {separator = true},
                
                {title = t("easy"), cmd = function() set_difficulty_level("Easy") end, checked = is_easy},
                {title = t("medium"), cmd = function() set_difficulty_level("Medium") end, checked = is_medium},
                {title = t("hard"), cmd = function() set_difficulty_level("Hard") end, checked = is_hard},
                {title = t("impossible"), cmd = function() set_difficulty_level("Impossible") end, checked = is_impossible},
            }},

            {title = "RoboMaze", submenu = {
                {title = t("play"), cmd = open_robo_maze},
                {title = t("rules"), cmd = about_maze_game},
            
                {separator = true},
                
                {title = t("easy"), cmd = function() 
                    set_maze_difficulty("easy") 
                    save_maze_settings()  -- Зберігаємо налаштування після зміни складності
                end, checked = is_easy_m},
            
                {title = t("medium"), cmd = function() 
                    set_maze_difficulty("medium") 
                    save_maze_settings()  -- Зберігаємо налаштування після зміни складності
                end, checked = is_medium_m},
            
                {title = t("hard"), cmd = function() 
                    set_maze_difficulty("hard") 
                    save_maze_settings()  -- Зберігаємо налаштування після зміни складності
                end, checked = is_hard_m},
            
                {title = t("impossible"), cmd = function() 
                    set_maze_difficulty("impo") 
                    save_maze_settings()  -- Зберігаємо налаштування після зміни складності
                end, checked = is_impo_m},
            }}
            

            -- {title = "EarPuzzle", cmd = open_ear_puzzle},

            },

        },

        {separator = true},

        {title = t("options"), submenu = {
            {title = dock_menu_title, cmd = toggle_dock},
            {title = t("welcome"), cmd = welcome_message},

            {separator = true},

            {title = t("support"), cmd = open_browser_support},
            
            {title = t("about"), cmd = open_browser_about},

            {separator = true},

            {title = t("set_zoom"), submenu = {
                {title = "100%", cmd = function() set_robot_zoom("100") end, checked = zoom_100},
                {title = "120%", cmd = function() set_robot_zoom("120") end, checked = zoom_120},
                {title = "140%", cmd = function() set_robot_zoom("140") end, checked = zoom_140},
                {title = "150%", cmd = function() set_robot_zoom("150") end, checked = zoom_150},
            }},

            {title = t("language"), submenu = {
                {title = t("english"), cmd = function() change_language("en") end, checked = current_language == "en"},
                {title = t("ukrainian"), cmd = function() change_language("ua") end, checked = current_language == "ua"}
            }},

            {title = t("set_background_color"), submenu = {
                {title = t("black_bg"), cmd = function() set_background_color("black") end, checked = is_bg_black},
                {title = t("white_bg"), cmd = function() set_background_color("white") end, checked = not is_bg_black},
            }},

            {title = t("start_up"),
            cmd = function()
                local is_enabled = IsStartupHookEnabled()
                local comment = 'StFart script: Amely Suncroll RoboFace'
                local var_name = 'robo_face_cmd_name'
                SetStartupHookEnabled(not is_enabled, comment, var_name)
            end,
            checked = is_startup
            },
            
            {separator = true},

            {title = t("quit"), cmd = function() quit_robo_face() end},
        }},
        
    }

    local script_hwnd = reaper.JS_Window_Find("RoboFace 1.16", true)
    local _, left, top, right, bottom = reaper.JS_Window_GetClientRect(script_hwnd)
    local menu_x = left + gfx.mouse_x
    local menu_y = top + gfx.mouse_y

    if gfx.dock(-1) > 0 then
        menu_x, menu_y = left + gfx.mouse_x, top + gfx.mouse_y
    end

    local ret = ShowMenu(MenuCreateRecursive(menu), menu_x, menu_y)
    MenuReturnRecursive(menu, ret)
end



function load_options_params()
    local zoom100State = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Zoom100")
    zoom_100 = zoom100State == "true"
    if zoom_100 then
        robot_zoom = 100
    end

    local zoom120State = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Zoom120")
    zoom_120 = zoom120State == "true"
    if zoom_120 then
        robot_zoom = 120
    end

    local zoom140State = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Zoom140")
    zoom_140 = zoom140State == "true"
    if zoom_140 then
        robot_zoom = 140
    end

    local zoom150State = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Zoom150")
    zoom_150 = zoom150State == "true"
    if zoom_150 then
        robot_zoom = 150
    end

    if not (zoom_100 or zoom_120 or zoom_140 or zoom_150) then
        robot_zoom = 100
        zoom_100 = true
    end

    local showTimeState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "ShowSystemTime")
    is_show_system_time = showTimeState == "true"

    local showTimeHourlyState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "ShowSystemTimeHourly")
    is_show_system_time_hourly = showTimeHourlyState == "true"



    local directCountdownState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "DirectCountdown")
    is_direct_countdown = directCountdownState == "true"

    local reverseCountdownState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "ReverseCountdown")
    is_reverse_countdown = reverseCountdownState == "true"

    local lessThanMinuteState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "LessThanMinute")
    is_show_if_less_than_minute = lessThanMinuteState == "true"

    local everyFiveMinutesState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "EveryFiveMinutes")
    is_show_every_five_minutes = everyFiveMinutesState == "true"



    local easyState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Easy")
    is_easy = easyState == "true"

    local mediumState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Medium")
    is_medium = mediumState == "true"

    local hardState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Hard")
    is_hard = hardState == "true"

    local impossibleState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Impossible")
    is_impossible = impossibleState == "true"


    local easyStateM = reaper.GetExtState("AmelySuncrollRoboFaceHome", "easy")
    is_easy_m = easyStateM == "true"

    local mediumStateM = reaper.GetExtState("AmelySuncrollRoboFaceHome", "medium")
    is_medium_m = mediumStateM == "true"

    local hardStateM = reaper.GetExtState("AmelySuncrollRoboFaceHome", "hard")
    is_hard_m = hardStateM == "true"

    local impossibleStateM = reaper.GetExtState("AmelySuncrollRoboFaceHome", "impo")
    is_impo_m = impossibleStateM == "true"

    local languageState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "Language")

    if languageState == "en" then
        current_language = "en"
    elseif languageState == "ua" then
        current_language = "ua"
    else
        current_language = "en"
    end

    local backgroundColor = reaper.GetExtState("AmelySuncrollRoboFaceHome", "BackgroundColor")
    is_bg_black = backgroundColor == "true"

    local welcomeShownState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "WelcomeShown")
    is_welcome_shown = welcomeShownState == "true"

    local startupState = reaper.GetExtState("AmelySuncrollRoboFaceHome", "StartupIsOn")
    is_startup = startupState == "true"
end

function save_options_params()
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Zoom100", tostring(zoom_100), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Zoom120", tostring(zoom_120), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Zoom140", tostring(zoom_140), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Zoom150", tostring(zoom_150), true)
    
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "ShowSystemTime", tostring(is_show_system_time), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "ShowSystemTimeHourly", tostring(is_show_system_time_hourly), true)

    reaper.SetExtState("AmelySuncrollRoboFaceHome", "DirectCountdown", tostring(is_direct_countdown), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "ReverseCountdown", tostring(is_reverse_countdown), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "LessThanMinute", tostring(is_show_if_less_than_minute), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "EveryFiveMinutes", tostring(is_show_every_five_minutes), true)

    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Easy", tostring(is_easy), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Medium", tostring(is_medium), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Hard", tostring(is_hard), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Impossible", tostring(is_impossible), true)

    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Easy", tostring(is_easy_m), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Medium", tostring(is_medium_m), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Hard", tostring(is_hard_m), true)
    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Impossible", tostring(is_impo_m), true)

    reaper.SetExtState("AmelySuncrollRoboFaceHome", "Language", current_language, true)

    reaper.SetExtState("AmelySuncrollRoboFaceHome", "BackgroundColor", tostring(is_bg_black), true)

    reaper.SetExtState("AmelySuncrollRoboFaceHome", "WelcomeShown", tostring(is_welcome_shown), true)

    reaper.SetExtState("AmelySuncrollRoboFaceHome", "StartupIsOn", tostring(is_startup), true)
end







------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------  MAIN BLOCK  ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



function main()
    check_script_window_position()
    check_welcome_message()

    local is_me_open, is_me_closed, is_me_docked = get_midi_editor_state()

                                                                            if is_me_closed or is_me_docked and not is_paused then
        if not is_show_system_time and not is_showing_cube then
            local scale = get_scale_factor()
            local is_angry = check_for_angry()
            local is_really_quiet = check_master_no_volume()
            local is_recording = is_recording()
            
            get_shake_intensity()
            local is_sleeping = should_robot_sleep()

            draw_robot_face(scale, is_eye_open, is_angry, is_bg_black)
            draw_pupils(scale)
            
            
            if is_angry then
                reaper.PreventUIRefresh(1)
            end

            if not is_angry and not is_sleeping and not is_recording then
                check_for_yawn()
                local is_yawning = animate_yawn()
                if not is_yawning and not is_recording and not is_sneeze_one and not is_sneeze_two then
                    animate_blink()
                end

                if not is_yawning and not is_recording and not is_sleeping and not is_angry then
                    random_sneeze()
                end

                local state = type_of_text_over()
                if text_params[state] then
                    if text_params[state].type == "scrolling" then
                        draw_scrolling_text(text_params[state])
                    elseif text_params[state].type == "static" then
                        draw_static_text(text_params[state])
                    end
                end
            end

            restore_robot_zoom()
        end
    elseif is_me_open and is_paused then
        local state = type_of_text_over()
        if text_params[state] then
            if text_params[state].type == "scrolling" then
                draw_scrolling_text(text_params[state])
            elseif text_params[state].type == "static" then
                draw_static_text(text_params[state])
            end
        end
                                                                                                                                end

    if is_night_time() then
        random_night_message()
    end

    if is_me_closed or is_me_docked and not is_paused then

        if is_show_system_time_hourly and is_start_of_hour() and not is_show_system_time then
            is_show_system_time = true
            time_display_end_time = reaper.time_precise() + 60
            show_system_time()
        end

        if is_show_system_time then
            show_system_time()
        end

        if is_timer_running then
            show_timer_time()
        end

        animation_when_delete_all()
        animation_when_start_or_end()
        
    end
    
    if is_showing_cube then
        draw_random_cube()
    end

    local x, y = reaper.GetMousePosition()
    local hover_hwnd = reaper.JS_Window_FromPoint(x, y)
    local script_hwnd = reaper.JS_Window_Find("RoboFace 1.16", true)
    local mouse_state = reaper.JS_Mouse_GetState(7)

    if hover_hwnd == script_hwnd then
        if mouse_state ~= prev_mouse_state then
            prev_mouse_state = mouse_state
            local is_lclick = mouse_state & 1 == 1
            local is_rclick = mouse_state & 2 == 2

            if is_lclick then
                handleTap()
                tap_when_zoom_out()
            end

            if is_rclick then
                show_r_click_menu()
            end
        end
    end
    
    gfx.update()

    if gfx.getchar() == 27 and isTapActive then
        isTapActive = false

        if current_language == "en" then
            reaper.ShowConsoleMsg("Tap tempo mode canceled.\n\n")
        else
            reaper.ShowConsoleMsg("Режим 'Тап темпо' скасовано.\n\n")
        end
        
    elseif gfx.getchar() == 27 and not isTapActive then
        gfx.quit()
    end

    if gfx.getchar() >= 0 then
        save_window_params() 
        reaper.defer(main)
    else
        save_window_params()
        return  
    end
end

local x, y, startWidth, startHeight, dock_state = load_window_params()
gfx.init("RoboFace 1.16", startWidth, startHeight, dock_state, x, y)
load_options_params()
main()
reaper.atexit(save_window_params)
reaper.atexit(save_options_params)
