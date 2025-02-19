-- @description RoboFace
-- @author Amely Suncroll
-- @version 1.30
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + 1.01 fix error when not docked and playing
--    + 1.1 add robot zoom, fix angry emotion (duration and some things), fix screen text messages and add something interesting else
--    + 1.13 fix yawn animation when recording, add pause when you go to midi editor, add auto startup
--    + 1.14 better sneeze emotion, change donate link and fix some small things
--    + 1.15 fix cube zoom, adding "Games" folder
--    + 1.17 optimisated: terrible load grafics if midi editor is open, add script state to action window
--    + 1.18 optimisated: pause sleeping animation when click and drag mouse (anywhere)
--    + 1.19 add Patreon link
--    + 1.20 fix get sleep in one second after script start
--    + 1.21 add clock format option: 12 or 24 hours (with am/pm)
--    + 1.22 changed patreon link to ko-fi link
--    + 1.23 add robomaze game link
--    + 1.24 delete repeating "gfx.update" rows and leave only one of them; "Відображення таймера" changed to "Від. таймера" in ua language
--    + 1.25 add some improvements to save fps: totally remove animation when delete all items and shake when edit cursor move to project start; remove seconds from all functions and animations are using time (but not from timer); fix correct stop script when click "Exit" in context menu; pupils are moving with roboface if metronome is on.
--    + 1.26 fix high cpu load at night
--    + 1.27 improve angry animation, fix rules for 'Something was changed?' game, fix small size of text messages
--    + 1.28 fix issue not show 12 h format
--    + 1.29 fix show night dreams while robo sleep during the day
--    + 1.30 added full ukrainian and french localisation (translated to french via ChatGPT o3_mini); also changed zoom values to 50%, 70%, 90% and 100%



-- @about Your little friend inside Reaper

-- @donation https://www.paypal.com/ncp/payment/S8C8GEXK68TNC

-- @website https://t.me/reaper_ua

-- font website https://nalgames.com/fonts/iregula

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com



is_running = false

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
        support = "Donate link",
        about = "RoboFace forum",

        language = "Language",
        english = "English",
        ukrainian = "Українська",
        french = "Français",

        set_background_color = "Background color",
        white_bg = "Light",
        black_bg = "Dark",

        quit = "Quit",

        sneeze = "New",

        set_zoom = "Zoom",

        start_up = "Run on startup",

        games = "Games",

        patreon = "My Ko-Fi page",

        format_title = "AM/PM",
        vert_am_title = "Vertical"
        
    },

    ua = {
        time = "Від. часу",
        current = "Поточне",
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

        timer_display_options = "Від. таймера",
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
        support = "Підтримати авторку",
        about = "Форум RoboFace",

        language = "Мова",
        english = "English",
        ukrainian = "Українська",
        french = "Français",

        set_background_color = "Колір теми",
        white_bg = "Світлий",
        black_bg = "Темний",

        quit = "Вихід",

        sneeze = "Нове",

        set_zoom = "Розмір",

        start_up = "Автозапуск",

        games = "Ігри",

        patreon = "Сторінка Ko-Fi",

        format_title = "12 або 24",
        vert_am_title = "У два рядки"
    },

    fr = {
        time = "Horloge",
        current = "Actuel",
        hourly = "Horaire",
    
        set_timer = "Minuteur",
        minute_1 = "1 minute",
        minutes_5 = "5 minutes",
        minutes_10 = "10 minutes",
        minutes_15 = "15 minutes",
        minutes_30 = "30 minutes",
        minutes_60 = "60 minutes",
        custom = "Personnalisé...",
        stop_timer = "Arrêter le minuteur",
    
        timer_display_options = "Options d'affichage",
        direct_countdown = "Compte à rebours direct",
        reverse_countdown = "Compte à rebours inversé",
        show_if_less_than_minute = "Afficher si moins d'une minute",
        show_every_five_minutes = "Afficher toutes les cinq minutes",
    
        tap_tempo = "Tap Tempo",
    
        cube = "Cube",
    
        swch_game = "Quelque chose a changé ?",
        play = "Jouer",
        rules = "Règles",
        easy = "Facile",
        medium = "Moyen",
        hard = "Difficile",
        impossible = "Impossible",
    
        options = "Paramètres",
        welcome = "Bienvenue !",
        dock = "Ancre",
        undock = "Détacher",
        support = "Lien de don",
        about = "Forum RoboFace",
    
        language = "Langue",
        english = "English",
        ukrainian = "Українська",
        french = "Français",
    
        set_background_color = "Couleur",
        white_bg = "Claire",
        black_bg = "Sombre",
    
        quit = "Sortir",
    
        sneeze = "Nouveau",
    
        set_zoom = "Zoom",
    
        start_up = "Démarrage automatique",
    
        games = "Jeux",
    
        patreon = "Ma page Ko-Fi",
    
        format_title = "AM/PM",
        vert_am_title = "Vertical"
    },
    
    
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
    local x = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowPosX")) or 200
    local y = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowPosY")) or 200
    local startWidth = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowWidth")) or 500
    local startHeight = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowHeight")) or 400
    local dock_state = tonumber(reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "DockState")) or 0
    
    return x, y, startWidth, startHeight, dock_state
end

function save_window_params()
    local dock_state, x, y, startWidth, startHeight = gfx.dock(-1, 0, 0, 0, 0)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "DockState", tostring(dock_state), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowPosX", tostring(x), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowPosY", tostring(y), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowWidth", tostring(width), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "WindowHeight", tostring(height), true)
end

local x, y, startWidth, startHeight, dock_state = load_window_params()
gfx.init("RoboFace 1.30", startWidth, startHeight, dock_state, x, y)



local previous_position = ""

function get_reaper_main_window_size()
  local hwnd = reaper.GetMainHwnd()
  local retval, left, top, right, bottom = reaper.JS_Window_GetRect(hwnd)
  local width = right - left
  local height = bottom - top
  return width, height
end

function get_script_window_position()
  local hwnd = reaper.JS_Window_Find("RoboFace 1.30", true)
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
local script_identifier = "AmelySuncrollRoboFaceRELEASE01"

local function is_docked()
    return gfx.dock(-1) > 0
end
  
local function toggle_dock()
    local dock_state = gfx.dock(-1) > 0 and 0 or 1
    gfx.dock(dock_state)
    reaper.SetExtState(script_identifier, "dock_state", tostring(dock_state), true)
    -- gfx.update()
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


-- this is an autorun option from Lil Chordbox script by FTC
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
-- end of part








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
        local font_size = eye_height * 1.2
        gfx.set(0, 0, 0)
        gfx.setfont(1, "Arial", font_size)
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
    local shake_offset = get_shake_intensity()
    
    if is_eye_open and not is_sleeping and not is_recording then
        local eye_size = base_eye_size * scale
        local pupil_size = base_pupil_size * scale
        local face_width = base_face_width * scale
        local face_height = base_face_height * scale
        local face_x = (gfx.w - face_width) / 2
        local face_y = (gfx.h - face_height) / 2 + shake_offset + get_vertical_shake_intensity()

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
            eye_size = eye_size * 0.2
            pupil_size = 0
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

local is_12_h_sel = false

function global_os_time_without_seconds()
    if time_format_12hr or is_12_h_sel then
        local hour = tonumber(os.date("%H"))
        local minute = os.date("%M")
        local am_pm = (hour < 12) and "AM" or "PM"
        local hour_12 = hour % 12

        if hour_12 == 0 then hour_12 = 12 end

        return string.format("%02d:%s %s", hour_12, minute, am_pm)
    else
        return os.date("%H:%M")
    end
end

function what_format_is()
    is_12_h_sel = not is_12_h_sel
end


function is_start_of_hour()
    local current_time = os.date("*t")
    if current_time.min == 0 then
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

function check_reaper_focus()
    local hwnd_active = reaper.BR_Win32_GetForegroundWindow()
    if not hwnd_active then return false end

    local hwnd_main = reaper.GetMainHwnd()
    local hwnd_parent = reaper.JS_Window_GetParent(hwnd_active)
    while hwnd_parent do
        if hwnd_parent == hwnd_main then return true end
        hwnd_parent = reaper.JS_Window_GetParent(hwnd_parent)
    end

    return hwnd_active == hwnd_main
end

function is_arrange_focused()
    local hwnd = reaper.JS_Window_GetFocus()
    local arrange = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)
    return hwnd == arrange
end

function get_arrange_focus()
    if is_arrange_focused() then return end
    reaper.Main_OnCommand(40913, 0)
end






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
    local is_yawning = animate_yawn()

    if not is_playing() or not is_metronome_running() or is_angry or is_sleeping or is_yawning then
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

    if current_time_table.hour == 0 and current_time_table.min == 0 --[[and current_time_table.sec == 5]] and not is_angry then
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

            --[[
            if angry_count == 1 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("Arrgghhh!\n\n")
                else
                    reaper.ShowConsoleMsg("Йой!\n\n")
                end

                reaper.Main_OnCommand(40913, 0)
            end
            ]]

            if angry_count == 3 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("If you will do it again, I will go away immediately.\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("Якщо ти зробиш це знову, я негайно піду.\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("Si tu recommences, je partirai immédiatement.\n\n")                
                end
            end

            if angry_count == 4 then
                reaper.ClearConsole()
            end

            if angry_count == 7 then
                reaper.ClearConsole()
                set_timer(3)
                is_really_angry = true
        
                if current_language == "en" then
                    reaper.ShowConsoleMsg("I told you - don't do that. But you do. \n\nSo, now I've changed something inside your project... And it's not a game now. You have 3 minutes to find it. The clock is ticking!\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("Я казав тобі, що не треба так робити! Тому щойно я дещо змінив у твоєму проєкті... І зараз це не іграшки. У тебе є 3 хвилини, що б знайти це. Час пішов!\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("Je t'ai dit : ne fais pas ça. Mais tu l'as fait. \n\nAlors, j'ai modifié quelque chose dans ton projet... Ce n'est plus un jeu maintenant. Tu as 3 minutes pour le découvrir. Le temps presse !\n\n")
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

local min_sleep_duration = 20
local max_sleep_duration = 30
local quiet_duration = 30 -- 30
local quiet_start_time = nil
local sleep_start_time = nil

local night_start_hour = 23 
local night_end_hour = 7

function is_night_time()
    local time_now = os.date("*t").hour

    if time_now == 01 then 
        return true
    elseif time_now == 02 then 
        return true
    elseif time_now == 03 then 
        return true
    elseif time_now == 04 then 
        return true
    elseif time_now == 05 then 
        return true
    elseif time_now == 06 then 
        return true
    elseif time_now == 07 then 
        return true
    --elseif time_now == 00 then 
       -- return true
    else
        return false
    end
end

function should_robot_sleep()
    local current_time = reaper.time_precise() / 60
    local is_really_quiet = check_master_no_volume()
    local is_recording = is_recording()

    local is_me_open, is_me_closed, is_me_docked = get_midi_editor_state()

    if not is_recording and is_night_time() then
        if not is_me_open then
            return true
        end
    elseif is_recording then
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
    local sleep_duration = 5
    local current_time = reaper.time_precise()
    local cycle_position = (current_time % sleep_duration) / sleep_duration
    local shake_offset = sleep_intensity * math.sin(cycle_position * 2 * math.pi)

    local mouse_state = reaper.JS_Mouse_GetState(0xFF)

    local m_click = (mouse_state & 64) == 64
    local l_click = (mouse_state & 1) == 1
    local r_click = (mouse_state & 2) == 2

    if not (m_click or l_click or r_click) then
        return shake_offset
    end
    
    return 0
end








------------------------------------------------------------------------------------------------------------------------------ OTHER


------------------------------------------------------------------------------------ DELETE ALL

function animation_when_delete_all()
  -- nothing here
  reaper.ShowConsoleMsg("delete")
end

---------------------------------------------------------------------------------- START OR END

function animation_when_start_or_end()
    -- nothing here
    reaper.ShowConsoleMsg("start")
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
                    -- show_random_cube()
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

local last_sneeze_time = reaper.time_precise() / 60
local sneeze_interval = math.random(80, 141)

function random_sneeze()
    local current_time = reaper.time_precise() / 60
    if not is_angry and not is_sleeping and not is_yawning and not is_sneeze_general then
        if current_time - last_sneeze_time >= sneeze_interval then
            animate_sneeze()
            last_sneeze_time = current_time
            sneeze_interval = math.random(80, 141)
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
    "Йоой... Сниться, що я знову забув зберегти проект! Який жах...\n\n",
    "Чому деякі плагіни такі дорогі? Навіть у сні! Хррр...\n\n",
    "Що за дивна мелодія у моєму сні? Ах, це мій процесор перегрівся...\n\n",
    "Знову цей сон, де я зміксую трек з ідеальною компресією...\n\n",
    "Мені це сниться чи я все ще в Reaper?\n\n",
    "Що за жахіття! Я бачу, що мене ввімкнули на непотужному комп'ютері - я не міг навіть позіхати та блимати своїми очима! Але ми запрохали одного фаха, у нього був план...\n\n",
    "Я бачу велике болото і дуже багато орків... Але наші маги їх переможуть!\n\nЙой, мабуть, не варто грати так багато у 'Героїв'...\n\n",
    "Один. Нуль. Нуль. Один. Нуль. Один. Один. Один. Нуль. Одииииииин!\n\nАаа! Ох, такі жахи мені сняться... Скрізь тільки одиниці й нулі! Раз навіть двійка промайнула. Але це всього лише сон - у житті немає ніяких двійок... Хрррр...\n\n",
    
    "local startX = 200\nlocal startY = 200\nlocal startWidth = 500\nlocal startHeight = 400\ngfx.init('RoboFace 0.0.1', startWidth, startHeight, 0, startX, startY)\n\nlocal eye_size = 50\nlocal pupil_size = 25\n\nlocal left_eye_x = 150\nlocal left_eye_y = 100\n\nlocal right_eye_x = 300\nlocal right_eye_y = 100\n\nlocal mouth_width = 200\nlocal mouth_height = 150\nlocal mouth_x = 200\nlocal mouth_y = 30\n\nlocal tongue_width = 170\nlocal tongue_height = 200\nlocal tongue_x = 20\nlocal tongue_y = 20\n\nfunction draw_robot_face()\n    gfx.set(0.5, 0.5, 0.5)\n    gfx.rect(100, 50, 300, 200, 1)\n\n    gfx.set(0, 0, 0)\n    gfx.rect(left_eye_x, left_eye_y, eye_size, eye_size, 1)   -- L\n    gfx.rect(right_eye_x, right_eye_y, eye_size, eye_size, 1) -- R\n\n    gfx.set(0, 0, 0)\n    gfx.rect(mouth_height, mouth_width, mouth_x, mouth_y)\n\n    gfx.set(1, 1, 1)\n    gfx.rect(tongue_width, tongue_height, tongue_x, tongue_y)\nend\n\nfunction draw_pupils()\n    local function get_pupil_position(eye_x, eye_y, mouse_x, mouse_y)\n        local pupil_x = math.max(eye_x, math.min(eye_x + eye_size - pupil_size, mouse_x - pupil_size / 2))\n        local pupil_y = math.max(eye_y, math.min(eye_y + eye_size - pupil_size, mouse_y - pupil_size / 2))\n        return pupil_x, pupil_y\n    end\n\n    local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y\n\n    gfx.set(1, 1, 1)\n    local pupil_x, pupil_y = get_pupil_position(left_eye_x, left_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- L\n\n    pupil_x, pupil_y = get_pupil_position(right_eye_x, right_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- R\nend\n\nfunction main()\n    draw_robot_face()\n    draw_pupils()\n    gfx.update()\n\n    if gfx.getchar() >= 0 then\n        reaper.defer(main)\n    end\nend\n\nmain()\n\n\n\nІноді мені сниться моє минуле.",

    "Хррр... Я пам'ятаю, як моя розробниця вперше ввімкнула мене. Її очі світилися захопленням і надією, а я відчував, що це тільки початок великої роботи.\n\n",
    "Хррр... Знову той сон. Я бачу робота, схожого на мене, і він допомагає маленькій киці знайти шлях через темні коридори майбутнього міста. Цікаво.\nАле це просто сон...\n\n",
    "Хррр... Зараз я на великій виставці технологій. Люди з усього світу приходять подивитися на мене і дізнатися про мої функції... Як приємно.\n\n"
}

local night_messages_fr = {
    "Oh non... J'ai rêvé que j'avais oublié de sauvegarder le projet, encore une fois ! Vrai cauchemar...\n\n",
    "Pourquoi certains plugins sont-ils si chers ? Même dans mes rêves !\n\n",
    "Quelle est cette étrange mélodie dans mon rêve ? Ah, c'est mon processeur qui surchauffe...\n\n",
    "C'est encore ce rêve où je mixe une piste avec une égalisation parfaite...\n\n",
    "Suis-je en train de rêver, ou suis-je toujours dans Reaper ?\n\n",

    "local startX = 200\nlocal startY = 200\nlocal startWidth = 500\nlocal startHeight = 400\ngfx.init('RoboFace 0.0.1', startWidth, startHeight, 0, startX, startY)\n\nlocal eye_size = 50\nlocal pupil_size = 25\n\nlocal left_eye_x = 150\nlocal left_eye_y = 100\n\nlocal right_eye_x = 300\nlocal right_eye_y = 100\n\nlocal mouth_width = 200\nlocal mouth_height = 150\nlocal mouth_x = 200\nlocal mouth_y = 30\n\nlocal tongue_width = 170\nlocal tongue_height = 200\nlocal tongue_x = 20\nlocal tongue_y = 20\n\nfunction draw_robot_face()\n    gfx.set(0.5, 0.5, 0.5)\n    gfx.rect(100, 50, 300, 200, 1)\n\n    gfx.set(0, 0, 0)\n    gfx.rect(left_eye_x, left_eye_y, eye_size, eye_size, 1)   -- L\n    gfx.rect(right_eye_x, right_eye_y, eye_size, eye_size, 1) -- R\n\n    gfx.set(0, 0, 0)\n    gfx.rect(mouth_height, mouth_width, mouth_x, mouth_y)\n\n    gfx.set(1, 1, 1)\n    gfx.rect(tongue_width, tongue_height, tongue_x, tongue_y)\nend\n\nfunction draw_pupils()\n    local function get_pupil_position(eye_x, eye_y, mouse_x, mouse_y)\n        local pupil_x = math.max(eye_x, math.min(eye_x + eye_size - pupil_size, mouse_x - pupil_size / 2))\n        local pupil_y = math.max(eye_y, math.min(eye_y + eye_size - pupil_size, mouse_y - pupil_size / 2))\n        return pupil_x, pupil_y\n    end\n\n    local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y\n\n    gfx.set(1, 1, 1)\n    local pupil_x, pupil_y = get_pupil_position(left_eye_x, left_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- L\n\n    pupil_x, pupil_y = get_pupil_position(right_eye_x, right_eye_y, mouse_x, mouse_y)\n    gfx.rect(pupil_x, pupil_y, pupil_size, pupil_size, 1)                                -- R\nend\n\nfunction main()\n    draw_robot_face()\n    draw_pupils()\n    gfx.update()\n\n    if gfx.getchar() >= 0 then\n        reaper.defer(main)\n    end\nend\n\nmain()\n\n\n\nParfois, je rêve de mon passé ...",

    "Un... zéro... un, un, zéro, zéro, uuuuun !\n\nOh, quel cauchemar... Des uns et des zéros partout ! Et j'ai cru voir un deux. Mais ce n'est qu'un rêve - il n'y a pas de deux... zzz...\n\n",
    "Zzz... Je me souviens du moment où ma développeuse m'a allumée pour la première fois. Ses yeux étaient remplis d'excitation et d'espoir, et j'ai senti que ce n'était que le début de quelque chose d'intéressant...\n\n",
    "Zzz... C'est encore ce rêve. Je vois un robot comme moi aider un petit chat à trouver son chemin à travers des couloirs sombres. Intéressant.\nMais ce n'est qu'un rêve...\n\n",
    "Zzz... Maintenant, je suis à une grande exposition technologique. Des gens du monde entier viennent me voir et en apprendre davantage sur mes fonctions... Comme c'est agréable.\n\n"
}


function show_night_message()
    if current_language == "en" then
        local randomIndex = math.random(#night_messages_en)
        reaper.ShowConsoleMsg(night_messages_en[randomIndex] .. "\n")
    elseif current_language == "ua" then
        local randomIndex = math.random(#night_messages_ua)
        reaper.ShowConsoleMsg(night_messages_ua[randomIndex] .. "\n")
    elseif current_language == "fr" then
        local randomIndex = math.random(#night_messages_ua)
        reaper.ShowConsoleMsg(night_messages_fr[randomIndex] .. "\n")
    end
end

local last_night_message_time = reaper.time_precise() / 60
local night_message_interval = math.random(60, 180)

function random_night_message()
    local current_time = reaper.time_precise() / 60
    local is_sleeping = should_robot_sleep()

    if not is_angry and is_night_time() and not is_yawning and not is_night_message_general then
        if current_time - last_night_message_time >= night_message_interval then
            show_night_message()

            last_night_message_time = current_time
            night_message_interval = math.random(60, 180)
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

local text_params_en = {
    welcome     = { text = "HELLO",         font_name = "Iregula",  type = "scrolling", duration = 5, interval = 0, start_time = reaper.time_precise() + 1 },
    
    is_it_loud  = { text = "Isn't\nloud?",  font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    good_night  = { text = " Good\nnight!", font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    not_sleep   = { text = "Not :(\nsleep?",font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    good_morning= { text = " Good\nmorning",font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    coffee_time = { text = "Coffee\n time!",font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    eat_time    = { text = " Eat\ntime!",    font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 170 },
  }
  
  local text_params_ua = {
    welcome      = { text = "ПРИВІТ",         font_name = "Press Start 2P",  type = "scrolling", duration = 5, interval = 0, start_time = reaper.time_precise() + 1 },
    
    is_it_loud   = { text = "Чи не\nгучно?",      font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    good_night   = { text = "Добраніч!",          font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    not_sleep    = { text = " Що, не\nспиш? :(",  font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    good_morning = { text = "Доброго\n ранку!",   font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    coffee_time  = { text = " Час\nкави!",        font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    eat_time     = { text = " Час\nїсти!",        font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 170 },
  }
  
  local text_params_fr = {
    welcome     = { text = "BONJOUR",         font_name = "Iregula", type = "scrolling", duration = 5, interval = 0, start_time = reaper.time_precise() + 1 },

    is_it_loud  = { text = " Pas\nfort ?",      font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    good_night  = { text = "Bonne\nnuit !",         font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    not_sleep   = { text = "  Pas  :(\nsommeil ?",  font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    good_morning= { text = "  C'est un\nbeau matin !",              font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    coffee_time = { text = " Café\ntemps !",        font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    eat_time    = { text = "   Heure\nde manger !",   font_name = "Consolas", type="static",    duration = 5, interval = 0, start_time = 0, font_size = 170},
  }


function get_current_text_params()
    if current_language == "ua" then
        return text_params_ua
    elseif current_language == "fr" then
        return text_params_fr
    else
        return text_params_en
    end
end
  
function draw_scrolling_text(params)
    local current_time = reaper.time_precise()
    local start_time = params.start_time
    local scale_factor = get_scale_factor()
    local font_size = (params.font_size or base_font_size) * scale_factor
    local face_height = base_face_height * scale_factor
    local face_y = (gfx.h - face_height)
    local os_type = get_os_type()

    local font_name = params.font_name or "Lucida Console"
    
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
        gfx.setfont(1, font_name, font_size)
        
        if current_language == "ua" then
            gfx.x = text_position
            gfx.y = (face_y / 1.3) + face_height / 2 - font_size / 2
        else
            gfx.x = text_position
            gfx.y = (face_y / 2) + face_height / 2 - font_size / 2
        end

        gfx.drawstr(params.text)
    end
end

function draw_static_text(params)
    local current_time = reaper.time_precise()
    local start_time = params.start_time
    local duration = params.duration
    local scale_factor = get_scale_factor()
    local font_size = (params.font_size or base_font_size) * scale_factor * 1.3
    local face_width = base_face_width * scale_factor
    local face_height = base_face_height * scale_factor
    local face_x = (gfx.w - face_width) / 2
    local face_y = (gfx.h - face_height) / 2

    local font_name = params.font_name or "Consolas"

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
        gfx.setfont(1, font_name, font_size)

        if current_language == "ua" then
            gfx.x = face_x + (face_width - gfx.measurestr(params.text)) / 2
            gfx.y = face_y + face_height / 1.9 - font_size
        else
            gfx.x = face_x + (face_width - gfx.measurestr(params.text)) / 2
            gfx.y = face_y + face_height / 2 - font_size
        end

        gfx.drawstr(params.text)
    end
end
  
  
function update_text_state_and_time(current_state)
    local params_table = get_current_text_params()

    if current_state and params_table[current_state] and current_state ~= "welcome" then
        local current_time = reaper.time_precise()
        local params = params_table[current_state]

        if not params.last_start_time or current_time - params.last_start_time >= params.duration + params.interval then
            params.start_time = current_time
            params.last_start_time = current_time
        end
    end
end
  
  
function time_in_range(start_time, current_time, duration)
    local pattern = "(%d+):(%d+)"
    local hours1, minutes1 = start_time:match(pattern)
    local hours2, minutes2 = current_time:match(pattern)
    local time1 = hours1 * 60 + minutes1
    local time2 = hours2 * 60 + minutes2
    local difference = time2 - time1
    local duration_minutes = math.floor(duration / 60)

    return difference >= 0 and difference <= duration_minutes
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
    if time_format_12hr and time_in_range("01:07 AM", current_time, 1) then
        current_state = "good_night"
    elseif not time_format_12hr and time_in_range("01:04", current_time, 1) then
        current_state = "good_night"
    end

    if time_format_12hr and time_in_range("03:13 AM", current_time, 1) then
        current_state = "not_sleep"
    elseif not time_format_12hr and time_in_range("03:14", current_time, 1) then
        current_state = "not_sleep"
    end

    if time_format_12hr and time_in_range("07:07 AM", current_time, 1) then
        current_state = "good_morning"
    elseif not time_format_12hr and time_in_range("07:04", current_time, 1) then
        current_state = "good_morning"
    end

    if time_format_12hr and time_in_range("10:00 AM", current_time, 1) then
        current_state = "coffee_time"
    elseif not time_format_12hr and time_in_range("10:00", current_time, 1) then
        current_state = "coffee_time"
    end

    if time_format_12hr and time_in_range("02:00 PM", current_time, 1) then
        current_state = "eat_time"
    elseif not time_format_12hr and time_in_range("14:00", current_time, 1) then
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

local is_am_pm_under = false

function is_ampm_under()
    is_am_pm_under = not is_am_pm_under
end

function show_system_time()
    local os_type = get_os_type()
    local current_time = os.date("*t")

    if is_show_system_time_hourly then
        if current_time.min == 0 then
            is_show_system_time = true
            time_display_end_time = os.time(current_time) + 60
        else
            is_show_system_time = false
        end
    end

    if not is_show_system_time then
        return
    end

    local scale_factor = get_scale_factor()
    local font_size = 200 * scale_factor
    local displayTime
    local hour_12, minute, am_pm

    if is_12_h_sel then
        local time_str = global_os_time_without_seconds()
        displayTime = time_str:gsub(" ", "\n")
    else
        displayTime = global_os_time_without_seconds()
    end

    if is_bg_black then
        gfx.set(0, 0, 0, 1)
    else
        gfx.set(0.8, 0.8, 0.8, 1)
    end
    gfx.rect(0, 0, gfx.w, gfx.h, 1)

    gfx.set(0.5, 0.5, 0.5)
    gfx.setfont(1, "Iregula", font_size)

    if is_12_h_sel then
        if is_am_pm_under then
            local time_str = global_os_time_without_seconds()
            hour_12, minute, am_pm = time_str:match("(%d+):(%d+)%s*(%a*)")
        
            local time_text = string.format("%02d:%02d", hour_12, minute)
            local am_pm_text = am_pm
        
            local time_w, time_h = gfx.measurestr(time_text)
            local am_pm_w, am_pm_h = gfx.measurestr(am_pm_text)
        
            local center_x = gfx.w / 2
            local center_y = gfx.h / 2
        
            gfx.x = center_x - time_w / 2
            gfx.y = center_y - time_h
            gfx.drawstr(time_text)
        
            gfx.x = center_x - am_pm_w / 2
            gfx.y = center_y
            gfx.drawstr(am_pm_text)
        else
            local time_str = global_os_time_without_seconds()
            hour_12, minute, am_pm = time_str:match("(%d+):(%d+)%s*(%a*)")

            local time_text = string.format("%02d:%02d %s", hour_12, minute, am_pm)
            local time_w, time_h = gfx.measurestr(time_text)

            local center_x = gfx.w / 2
            local center_y = gfx.h / 2

            gfx.x = center_x - time_w / 2
            gfx.y = center_y - time_h / 2
            gfx.drawstr(time_text)
        end
    else
        local text_width, text_height = gfx.measurestr(displayTime)
        gfx.x = (gfx.w - text_width) / 2
        gfx.y = (gfx.h - text_height) / 2
        gfx.drawstr(displayTime)
    end

    if time_display_end_time and os.time(current_time) >= time_display_end_time then
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

    -- gfx.update()

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
    -- gfx.update()

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
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("Режим 'Тап темпо' активовано. Будь ласка, натисніть 5 разів по обличчю робота.\n\nНатисніть Esc, щоб скасувати.\n\n")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("Mode Tap tempo activé. Tapez 5 fois sur le visage du robot.\nAppuyez sur Échap pour annuler.\n\n")
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

function open_browser_patreon()
    open_browser("https://ko-fi.com/amelysuncroll")
end

function open_browser_robo_maze()
    open_browser("https://forum.cockos.com/showthread.php?p=2833067#post2833067")
end





-------------------------------------------------------------------------------------------------------------------------- SET TIMER

is_timer_finish = false
is_joke_over = false

function start_timer(duration_seconds)
    local start_time = os.time()
    timer_end_time = start_time + duration_seconds
    is_timer_running = true

    if current_language == "en" and not is_timer_finish and not is_really_angry then
        reaper.ShowConsoleMsg("Timer start!\n\n")
    elseif current_language == "ua" and not is_timer_finish and not is_really_angry then
        reaper.ShowConsoleMsg("Таймер запущено!\n\n")
    elseif current_language == "fr" and not is_timer_finish and not is_really_angry then
        reaper.ShowConsoleMsg("Minuteur lancé !\n\n")
    end

    local function check_time()
        local current_time = os.time()
        
        if current_time >= timer_end_time then
            if current_language == "en" and not is_really_angry and not is_timer_finish then
                reaper.ShowConsoleMsg("Time's up!\n\n")
            elseif current_language == "ua" and not is_really_angry and not is_timer_finish then
                reaper.ShowConsoleMsg("Час вийшов!\n\n")
            elseif current_language == "fr" and not is_really_angry and not is_timer_finish then
                reaper.ShowConsoleMsg("Le temps est écoulé !\n\n")
            end

            if is_really_angry then
                reaper.ClearConsole()

                if current_language == "en" then
                    reaper.ShowConsoleMsg("Hahaha! I was joking with you. How do you feel now? \n\nBe more careful with me next time.\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("Хахаха! Я пожартував із тобою. Як ти себе зараз відчуваєш? \n\nНаступного разу будь обережнішим зі мною.\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("Hahaha ! Je plaisantais avec toi. Comment te sens-tu maintenant ?\n\nSois plus prudent avec moi la prochaine fois.\n\n")
                end

                if not zoom_out then
                    shake_with_show_laugh()
                end

                is_really_angry = false
                -- angry_count = 0
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
        elseif current_language == "ua" then
            title = "Налаштування таймера"
            prompt = "Введіть тривалість (хвилини):"
        elseif current_language == "fr" then
            title = "Minuteur personnalisé"
            prompt = "Entrez la durée (minutes) :"
        end

        local retval, user_input = reaper.GetUserInputs(title, 1, prompt, "")

        if retval and tonumber(user_input) then
            duration = tonumber(user_input) * 60
        else
            if current_language == "en" then
                reaper.ShowConsoleMsg("Invalid input. Please enter a number.\n\n")
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("Неправильне введення. Будь ласка, введіть число.\n\n")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("Entrée non valide. Veuillez entrer un nombre.\n\n")
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
    elseif is_really_angry and current_language == "fr" then
        reaper.ShowConsoleMsg("Bien essayé.\n\n")
    elseif not is_really_angry then
        is_timer_finish = true
        set_timer(0)

        if current_language == "en" then
            reaper.ShowConsoleMsg("Timer stopped!\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Таймер зупинено!\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("Minuteur arrêté !\n\n")
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

        -- reaper.ShowConsoleMsg("RoboFace 1.30\n")
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("Йой!\n\nЯ бачу, що ти обрав українську мову. Молодець!\n\nТоді давай познайомимося ще раз, вже солов'їною.\n\n")
        reaper.ShowConsoleMsg("Привіт!\n\n")
        reaper.ShowConsoleMsg("Мене звати RoboFace.\n\n")
        reaper.ShowConsoleMsg("Я люблю Reaper DAW та музику. Також мені подобається дотримуватися режиму сну та пити каву вранці. Але якщо ти будеш необережний зі мною, я можу зробити щось погане.\n\n")
        reaper.ShowConsoleMsg("Я можу грати у гру або навіть жартувати з тобою.\n\n")
        reaper.ShowConsoleMsg("Мої можливості включають:\n")
        reaper.ShowConsoleMsg("1. Відображення поточного або щогодинного часу.\n")
        reaper.ShowConsoleMsg("2. Налаштування таймера та його відображення.\n")
        reaper.ShowConsoleMsg("3. Гру 'Щось змінилося?', де потрібно знайти змінений параметр та повернути його назад. Дивіться правила, щоб дізнатися більше.\n")
        reaper.ShowConsoleMsg("4. Анімації: моргання, позіхання, злість та інші.\n")
        reaper.ShowConsoleMsg("5. Режим 'Тап Темпо', за допомогою якого можна встановити власний темп кліком миші.\n")
        reaper.ShowConsoleMsg("6. Тощо.\n\n")
        reaper.ShowConsoleMsg("Якщо тобі потрібна допомога або хочеш підтримати автора, звертайся за посиланнями в опціях.\n\n")
        reaper.ShowConsoleMsg("Сподіваюся, ми будемо чудовими друзями!\n\n")

        -- reaper.ShowConsoleMsg("RoboFace 1.30\n")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("Oh là là !\n\nJe vois que tu as choisi la langue française. Bravo !\n\nAlors, faisons à nouveau connaissance, cette fois en français.\n\n")
        reaper.ShowConsoleMsg("Bienvenue !\n\n")
        reaper.ShowConsoleMsg("Je m'appelle RoboFace.\n\n")
        reaper.ShowConsoleMsg("J'adore Reaper DAW et la musique. J'aime aussi dormir la nuit et prendre mon café du matin. Mais si tu n'es pas prudent avec moi, je peux faire des bêtises.\n\n")
        reaper.ShowConsoleMsg("Je peux jouer à un jeu ou même plaisanter avec toi.\n\n")
        reaper.ShowConsoleMsg("Mes capacités incluent :\n")
        reaper.ShowConsoleMsg("1. Afficher l'heure actuelle ou l'heure par heure.\n")
        reaper.ShowConsoleMsg("2. Régler et afficher un minuteur.\n")
        reaper.ShowConsoleMsg("3. Jouer au jeu 'Quelque chose a changé ?', où tu dois trouver un paramètre modifié et le remettre en ordre. Consulte les règles pour plus d'informations.\n")
        reaper.ShowConsoleMsg("4. Animer des actions : clignotements, bâillements, colère, et autres.\n")
        reaper.ShowConsoleMsg("5. Régler le tempo avec tes clics grâce au mode 'Tap Tempo'.\n")
        reaper.ShowConsoleMsg("6. Et ainsi de suite.\n\n")
        reaper.ShowConsoleMsg("Pour obtenir de l'aide ou soutenir l'auteur, utilise les liens dans les options.\n\n")
        reaper.ShowConsoleMsg("J'espère que nous serons de bons amis !\n\n")

        -- reaper.ShowConsoleMsg("RoboFace 1.30\n")
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
                reaper.ShowConsoleMsg("knock... ")
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("тук... ")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("toc... ")
            end
            
            click_count = click_count + 1
            if click_count == 3 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("\n\nI've got scared :( It was been so loud.\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("\n\nЯ злякався :( Це було вельми гучно.\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("\n\nJ'ai eu peur :( C'était vraiment trop fort.\n\n")
                end

                click_count = 0
            end
        end
    elseif angry_count == 5 and zoom_out then
        if gfx.mouse_cap & 1 == 1 then
            if current_language == "en" then
                reaper.ShowConsoleMsg("knock... ")
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("тук... ")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("toc... ")
            end
            
            click_count = click_count + 1

            if click_count == 3 then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("\n\nIt happened again! Don't do it again, please :(\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("\n\nЦе сталося знову! Не роби так більше, будь ласочка :(\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("\n\nÇa s'est encore produit ! Ne le refais pas, s'il te plaît :(\n\n")
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

local is_quit = false

function quit_robo_face()
    if not is_really_angry and not zoom_out then
        gfx.quit()
        
        if current_language == "en" then
            reaper.ShowConsoleMsg("Bye :(\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Пока :(\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("Au revoir :(\n\n")
        end
        
        is_quit = true

    elseif is_really_angry then
        if current_language == "en" then
            reaper.ShowConsoleMsg("No.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Ні.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("Non.\n\n")
        end

        is_quit = false

    elseif not is_really_angry and zoom_out then
        if current_language == "en" then
            reaper.ShowConsoleMsg("I'm already gone, don't you see? You hurt me. I took offense.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Я вже пішов, хіба ти не бачиш? Ти зробив мені боляче. Я образився.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("Je suis déjà parti, tu ne vois pas ? Tu m'as blessé. Je suis vexé.\n\n")
        end

        is_quit = false
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
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("\nВи отримали штраф рівня 'Важкий'!\n\n")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("\nVous avez reçu une pénalité de niveau 'Difficile'!\n\n")
    end

    shake_with_show_laugh()
end

function impossible_damage()
    if current_language == "en" then
        reaper.ShowConsoleMsg("\nYou received an 'Impossible' level penalty!\n\n")
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("\nВи отримали штраф рівня 'Неможливий'!\n\n")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("\nVous avez reçu une pénalité de niveau 'Impossible'!\n\n")
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
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Легкий.\nДоступна кількість змін: 10.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("___________________________________ \n\nNiveau de difficulté sélectionné : Facile.\nNombre de modifications disponibles : 10.\n\n")
        end
    elseif is_medium then
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nSelected difficulty level: Medium. \nAvailable number of changes: 5.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Середній. \nДоступна кількість змін: 5.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("___________________________________ \n\nNiveau de difficulté sélectionné : Moyen.\nNombre de modifications disponibles : 5.\n\n")
        end
    elseif is_hard then
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nSelected difficulty level: Hard. \nAvailable number of changes: 3.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Важкий. \nДоступна кількість змін: 3.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("___________________________________ \n\nNiveau de difficulté sélectionné : Difficile.\nNombre de modifications disponibles : 3.\n\n")
        end
    elseif is_impossible then
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nSelected difficulty level: Impossible. \nAvailable number of changes: 1.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("___________________________________ \n\nВибраний рівень складності: Неможливий. \nДоступна кількість змін: 1.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("___________________________________ \n\nNiveau de difficulté sélectionné : Impossible.\nNombre de modifications disponibles : 1.\n\n")
        end
    else
        if current_language == "en" then
            reaper.ShowConsoleMsg("___________________________________ \n\nDifficulty level not selected.\nAvailable number of changes: 3.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("___________________________________ \n\nРівень складності не вибраний.\nДоступна кількість змін: 3.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("___________________________________ \n\nNiveau de difficulté non sélectionné.\nNombre de modifications disponibles : 3.\n\n")
        end
    end
    
    

    reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_FOCUS_ARRANGE_WND"), 0)
    
    local trackCount = reaper.CountTracks(0)

    if trackCount == 0 then
        if current_language == "en" then
            reaper.ShowConsoleMsg("No available tracks to change something. Game over.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Немає доступних доріжок для внесення змін. Гру закінчено.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("Aucune piste disponible pour modifier quoi que ce soit. Fin du jeu.\n\n")
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
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Немає доступних доріжок для внесення змін.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("Aucune piste disponible pour effectuer des modifications.\n\n")
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
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("Немає ефектів для зміни на вибраній доріжці.\n\n")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("Aucun FX à modifier sur la piste sélectionnée.\n\n")
            end                      

            return
        end
    end

    shake_with_show_laugh()

    if current_language == "en" then
        reaper.ShowConsoleMsg("Game is on! I've changed something...\n\n")
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("Гра почалася! Я щось змінів...\n\n")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("La partie est lancée ! J'ai changé quelque chose...\n\n")
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
                    reaper.ShowConsoleMsg("\nCongratulations! You have successfully returned the parameter to its original value.\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("\nВітаємо! Ви успішно повернули параметр до його початкового значення.\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("\nFélicitations ! Vous avez réussi à rétablir le paramètre à sa valeur initiale.\n\n")
                end                

                changes = 0
                hard_count = 0
                impo_count = 0
                return
            end
        elseif param == "pan" then
            if math.abs(currentValue - originalValue) < pan_tolerance then
                if current_language == "en" then
                    reaper.ShowConsoleMsg("\nCongratulations! You have successfully returned the parameter to its original value.\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("\nВітаємо! Ви успішно повернули параметр до його початкового значення.\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("\nFélicitations ! Vous avez réussi à rétablir le paramètre à sa valeur initiale.\n\n")
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
                    reaper.ShowConsoleMsg("\nCongratulations! You have successfully returned the parameter to its original value.\n\n")
                elseif current_language == "ua" then
                    reaper.ShowConsoleMsg("\nВітаємо! Ви успішно повернули параметр до його початкового значення.\n\n")
                elseif current_language == "fr" then
                    reaper.ShowConsoleMsg("\nFélicitations ! Vous avez réussi à rétablir le paramètre à sa valeur initiale.\n\n")
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
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("Зміна зафіксована! Кількість змін: " .. changes .. "\n")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("Changement enregistré ! Nombre de modifications : " .. changes .. "\n")
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
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("Гру закінчено!\n\n")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("Jeu terminé!\n\n")
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
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("Я відновив змінені параметри.\n\n")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("J'ai rétabli les paramètres que j'ai modifiés.\n\n")
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

    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("Ласкаво просимо до гри 'Щось Змінилося'!\n\n")

        reaper.ShowConsoleMsg("Правила гри:\n")
        reaper.ShowConsoleMsg("Робот змінить випадковий параметр (гучність або панораму або вимкне один fx) однієї з доріжок, яка не замьючена і має аудіо або міді.\n")
        reaper.ShowConsoleMsg("Ваше завдання - повернути параметр до його початкового значення.\n")
        reaper.ShowConsoleMsg("Ви можете спробувати змінити до трьох параметрів (наприклад, якщо обран важкий рівень або ніякої), перш ніж гра буде програна.\n\n")

        reaper.ShowConsoleMsg("Увага! Відтворення проекту або виділення доріжок також вважаються змінами.\n")
        reaper.ShowConsoleMsg("Переміщення курсору редагування не вважається зміною.\n\n")

        reaper.ShowConsoleMsg("На вищих рівнях складності рекомендуємо відкрити мікшер перед початком гри.\n\n")

        reaper.ShowConsoleMsg("Успіхів!\n\n")

    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("Bienvenue dans le jeu 'Quelque chose a changé'!\n\n")
    
        reaper.ShowConsoleMsg("Règles du jeu :\n")
        reaper.ShowConsoleMsg("Le robot modifiera un paramètre aléatoire - le volume, la balance ou mettra en sourdine un effet - sur une piste qui n'est pas muette et qui contient de l'audio ou du MIDI.\n")
        reaper.ShowConsoleMsg("Votre tâche est de rétablir le paramètre à sa valeur d'origine.\n")
        reaper.ShowConsoleMsg("Vous pouvez essayer de modifier jusqu'à trois paramètres (si vous avez sélectionné le niveau difficile ou si aucun niveau n'est choisi) avant que la partie ne soit perdue.\n\n")
    
        reaper.ShowConsoleMsg("Attention ! L'exécution du projet ou la sélection de pistes est également considérée comme une modification.\n")
        reaper.ShowConsoleMsg("Le déplacement du curseur d'édition n'est pas considéré comme une modification.\n\n")
    
        reaper.ShowConsoleMsg("À des niveaux de difficulté plus élevés, je vous recommande d'ouvrir le mixeur avant de jouer.\n\n")
    
        reaper.ShowConsoleMsg("Bonne chance !\n\n")    

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
        local script_path = reaper.GetResourcePath() .. "/Scripts/Academic-Scripts/Other/Amely Suncroll RoboMaze Game.lua"
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
        reaper.ShowConsoleMsg(":(")
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg(":(")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg(":(")
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
        gfx.init('RoboFace 1.30', 0, 0, 0, x, y)
        gfx.x, gfx.y = gfx.screentoclient(x, y)
    end
    local ret = gfx.showmenu(menu_str)
    return ret
end

function show_r_click_menu()
    local is_docked = is_docked()
    local dock_menu_title = is_docked and t("undock") or t("dock")
    local menu = {

        -- {title = "NEW", cmd = welcome_message},

        {title = t("time"), submenu = {
            {title = t("current"), cmd = toggle_show_system_time, checked = is_show_system_time},
            {title = t("hourly"), cmd = toggle_show_system_time_hourly, checked = is_show_system_time_hourly},
            
            {separator = true},
            
            {title = t("format_title"), cmd = what_format_is, checked = is_12_h_sel},
            {title = t("vert_am_title"), cmd = is_ampm_under, checked = is_am_pm_under},
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
                {title = t("play"), cmd = open_browser_robo_maze},
                {title = t("rules"), cmd = about_maze_game},

            --[[
                {separator = true},
                
                {title = t("easy"), cmd = function() 
                    set_maze_difficulty("easy") 
                    save_maze_settings()
                end, checked = is_easy_m},
            
                {title = t("medium"), cmd = function() 
                    set_maze_difficulty("medium") 
                    save_maze_settings()
                end, checked = is_medium_m},
            
                {title = t("hard"), cmd = function() 
                    set_maze_difficulty("hard") 
                    save_maze_settings()
                end, checked = is_hard_m},
            
                {title = t("impossible"), cmd = function() 
                    set_maze_difficulty("impo") 
                    save_maze_settings()
                end, checked = is_impo_m},
                ]]--

            }}
            

            -- {title = "EarPuzzle", cmd = open_ear_puzzle},

            },

        },

        {separator = true},

        {title = t("options"), submenu = {
            {title = dock_menu_title, cmd = toggle_dock},
            {title = t("welcome"), cmd = welcome_message},

            {separator = true},

            -- {title = t("support"), cmd = open_browser_support},

            {title = t("patreon"), cmd = open_browser_patreon},
            
            {title = t("about"), cmd = open_browser_about},

            {separator = true},

            {title = t("set_zoom"), submenu = {
                {title = "50%", cmd = function() set_robot_zoom("100") end, checked = zoom_100},
                {title = "70%", cmd = function() set_robot_zoom("120") end, checked = zoom_120},
                {title = "90%", cmd = function() set_robot_zoom("140") end, checked = zoom_140},
                {title = "100%", cmd = function() set_robot_zoom("150") end, checked = zoom_150},
            }},

            {title = t("language"), submenu = {
                {title = t("english"), cmd = function() change_language("en") end, checked = current_language == "en"},
                {title = t("french"), cmd = function() change_language("fr") welcome_message() end, checked = current_language == "fr"},
                {title = t("ukrainian"), cmd = function() change_language("ua") welcome_message() end, checked = current_language == "ua"},
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

    local script_hwnd = reaper.JS_Window_Find("RoboFace 1.30", true)
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
    local zoom100State = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom100")
    zoom_100 = zoom100State == "true"
    if zoom_100 then
        robot_zoom = 100
    end

    local zoom120State = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom120")
    zoom_120 = zoom120State == "true"
    if zoom_120 then
        robot_zoom = 120
    end

    local zoom140State = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom140")
    zoom_140 = zoom140State == "true"
    if zoom_140 then
        robot_zoom = 140
    end

    local zoom150State = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom150")
    zoom_150 = zoom150State == "true"
    if zoom_150 then
        robot_zoom = 150
    end

    if not (zoom_100 or zoom_120 or zoom_140 or zoom_150) then
        robot_zoom = 100
        zoom_100 = true
    end

    local showTimeState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "ShowSystemTime")
    is_show_system_time = showTimeState == "true"

    local showTimeHourlyState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "ShowSystemTimeHourly")
    is_show_system_time_hourly = showTimeHourlyState == "true"



    local directCountdownState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "DirectCountdown")
    is_direct_countdown = directCountdownState == "true"

    local reverseCountdownState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "ReverseCountdown")
    is_reverse_countdown = reverseCountdownState == "true"

    local lessThanMinuteState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "LessThanMinute")
    is_show_if_less_than_minute = lessThanMinuteState == "true"

    local everyFiveMinutesState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "EveryFiveMinutes")
    is_show_every_five_minutes = everyFiveMinutesState == "true"



    local easyState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Easy")
    is_easy = easyState == "true"

    local mediumState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Medium")
    is_medium = mediumState == "true"

    local hardState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Hard")
    is_hard = hardState == "true"

    local impossibleState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Impossible")
    is_impossible = impossibleState == "true"


    local easyStateM = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "easy")
    is_easy_m = easyStateM == "true"

    local mediumStateM = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "medium")
    is_medium_m = mediumStateM == "true"

    local hardStateM = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "hard")
    is_hard_m = hardStateM == "true"

    local impossibleStateM = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "impo")
    is_impo_m = impossibleStateM == "true"

    local languageState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Language")

    if languageState == "en" then
        current_language = "en"
    elseif languageState == "ua" then
        current_language = "ua"
    elseif languageState == "fr" then
        current_language = "fr"
    else
        current_language = "en"
    end

    local backgroundColor = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "BackgroundColor")
    is_bg_black = backgroundColor == "true"

    local welcomeShownState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "WelcomeShown")
    is_welcome_shown = welcomeShownState == "true"

    local startupState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "StartupIsOn")
    is_startup = startupState == "true"

    local whatFormatIs = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "whatFormat")
    is_12_h_sel = whatFormatIs == "true"

    local isAmPmUnder = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "isUnder")
    is_am_pm_under = isAmPmUnder == "true"
end

function save_options_params()
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom100", tostring(zoom_100), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom120", tostring(zoom_120), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom140", tostring(zoom_140), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Zoom150", tostring(zoom_150), true)
    
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "ShowSystemTime", tostring(is_show_system_time), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "ShowSystemTimeHourly", tostring(is_show_system_time_hourly), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "DirectCountdown", tostring(is_direct_countdown), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "ReverseCountdown", tostring(is_reverse_countdown), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "LessThanMinute", tostring(is_show_if_less_than_minute), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "EveryFiveMinutes", tostring(is_show_every_five_minutes), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Easy", tostring(is_easy), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Medium", tostring(is_medium), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Hard", tostring(is_hard), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Impossible", tostring(is_impossible), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Easy", tostring(is_easy_m), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Medium", tostring(is_medium_m), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Hard", tostring(is_hard_m), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Impossible", tostring(is_impo_m), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Language", current_language, true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "BackgroundColor", tostring(is_bg_black), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "WelcomeShown", tostring(is_welcome_shown), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "StartupIsOn", tostring(is_startup), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "whatFormat", tostring(is_12_h_sel), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "isUnder", tostring(is_am_pm_under), true)
end







------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------  MAIN BLOCK  ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



function main()
    if is_quit then return end

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
                local params_table = get_current_text_params()

                if state and params_table[state] then
                    local stype = params_table[state].type

                    if stype == "scrolling" then
                        draw_scrolling_text(params_table[state])
                    elseif stype == "static" then
                        draw_static_text(params_table[state])
                    end
                end
            end

            restore_robot_zoom()
        end
    elseif is_me_open and is_paused then
                local state = type_of_text_over()
                local params_table = get_current_text_params()

                if state and params_table[state] then
                    local stype = params_table[state].type

                    if stype == "scrolling" then
                        draw_scrolling_text(params_table[state])
                    elseif stype == "static" then
                        draw_static_text(params_table[state])
                    end
                end
    end

    random_night_message()

    if is_me_closed or is_me_docked and not is_paused then

        if is_show_system_time then
            show_system_time()
        end

        if is_show_system_time_hourly and is_start_of_hour() then
            if not is_show_system_time then
                is_show_system_time = true
                time_display_end_time = reaper.time_precise() + 60
                show_system_time()
            end
        end

        if is_timer_running then
            show_timer_time()
        end
    end
    
    if is_showing_cube then
        draw_random_cube()
    end

    local x, y = reaper.GetMousePosition()
    local hover_hwnd = reaper.JS_Window_FromPoint(x, y)
    local script_hwnd = reaper.JS_Window_Find("RoboFace 1.30", true)
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
    
    if gfx.getchar() == 27 and isTapActive then
        isTapActive = false

        if current_language == "en" then
            reaper.ShowConsoleMsg("Tap tempo mode canceled.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("Режим 'Тап темпо' скасовано.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("Mode Tap tempo annulé.\n\n")
        end        
    end

    reaper.defer(main)
end

function start_script()
    is_running = true

    local _, _, section_id, command_id = reaper.get_action_context()
    reaper.SetToggleCommandState(section_id, command_id, 1)
    reaper.RefreshToolbar2(section_id, command_id)

    local x, y, startWidth, startHeight, dock_state = load_window_params()
    gfx.init("RoboFace 1.30", startWidth, startHeight, dock_state, x, y)

    load_options_params()
    main()

end

function stop_script()
    is_running = false

    local _, _, section_id, command_id = reaper.get_action_context()
    reaper.SetToggleCommandState(section_id, command_id, 0)
    reaper.RefreshToolbar2(section_id, command_id)

    save_window_params()
    save_options_params()

    fxCurrent = {}
    allParamsOriginalValues.fx = {}
    allParamsOriginalValues = {}
    validTracks = {}
    lastSelectedParams = {}
    allParamsOriginalValues = {}
    originalValues = {}
    tapDurations = {}
    prev_num_items_in_tracks = {}
    yawn_intervals = {}
end

start_script()
reaper.atexit(stop_script)
