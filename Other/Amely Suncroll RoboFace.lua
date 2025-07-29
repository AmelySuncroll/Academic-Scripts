-- @description RoboFace
-- @author Amely Suncroll
-- @version 1.41
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
--    + 1.31 little productivity improvements
--    + 1.32 fix making Reaper slow after a few hours work (I hope), add calendar messages, add welcome back messages, add EarPuzzle game, add workout animation, improve show animations within day time
--    + 1.33 fix error with welcome back messages
--    + 1.34 minor update French localisation, change 'Tap Tempo' function to just show bpm, made cube dots white with white background, add auto night mode (beta), change random time to show animations (was 2-3 hours, now 1-1,5 hours)
--    + 1.35 important fix no show some type of emotions - everything is now tested and working!
--    + 1.36 fix show night dream in ukrainian but current language is french (excusez-moi)
--    + 1.37 fix keep close eyes after sneezing
--    + 1.38 little improvements for animations
--    + 1.39 fix not blink eyes after little improvements for animations, hahaha
--    + 1.40 full French localisation (many thanks to my french friend Arnaud, who checked it), full calendar, add promt to get user's name and happy birthday, rearrange and rename right-click menu
--    + 1.41 improved ukrainian localization, fix not show welcome back messages after the time



-- @about Your little friend inside Reaper

-- @donation https://www.paypal.com/ncp/payment/S8C8GEXK68TNC

-- ua website https://t.me/reaper_ua

-- font website (en, fr) https://nalgames.com/fonts/iregula
-- font website (ua)     https://www.behance.net/gallery/77343531/Pomidorko-Cyrillic-free-font

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

        cube = "Dice",

        swch_game = "Something Was Changed?",
        play = "Play",
        rules = "Rules",
        easy = "Easy",
        medium = "Medium",
        hard = "Hard",
        impossible = "Impossible",

        options = "Options",
        welcome = "About RoboFace",
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

        patreon = "My another scripts",

        format_title = "AM/PM",
        vert_am_title = "Vertical",

        reset = "Hard reset",

        stop_ear_puzzle = "Reset game",
        my_own = "Own",

        t_auto_night = "Auto",
        birth = "Your birthday"
        
    },
    
    ua = {
        time = "Від. час",
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
        
        timer_display_options = "Від. таймера",
        direct_countdown = "Прямий відлік",
        reverse_countdown = "Зворотний відлік",
        show_if_less_than_minute = "Якщо менше хвилини",
        show_every_five_minutes = "Кожні п'ять хвилин",

        tap_tempo = "Тап Темпо",
        
        cube = "Кості",
        
        swch_game = "Що змінилося?",
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
        
        patreon = "Інші скрипти",

        format_title = "12 або 24",
        vert_am_title = "У два рядки",
        
        reset = "Перепрошивка",
        
        stop_ear_puzzle = "Зупинити гру",
        my_own = "Власний",
        
        t_auto_night = "День/Ніч",
        birth = "Твій ДН"
    },
    
    fr = {
        time = "Horloge",
        current = "Actuel",
        hourly = "Chaque heure",
        
        set_timer = "Minuteur",
        minute_1 = "1 minute",
        minutes_5 = "5 minutes",
        minutes_10 = "10 minutes",
        minutes_15 = "15 minutes",
        minutes_30 = "30 minutes",
        minutes_60 = "60 minutes",
        custom = "Personnaliser...",
        stop_timer = "Arrêter le minuteur",
        
        timer_display_options = "Options d'affichage",
        direct_countdown = "Compte à rebours direct",
        reverse_countdown = "Compte à rebours inversé",
        show_if_less_than_minute = "Afficher si moins d'une minute",
        show_every_five_minutes = "Afficher toutes les cinq minutes",
        
        tap_tempo = "Tap Tempo",
        
        cube = "Dé",
        
        swch_game = "Quelque chose a changé ?",
        play = "Jouer",
        rules = "Règles",
        easy = "Facile",
        medium = "Moyen",
        hard = "Difficile",
        impossible = "Impossible",
        
        options = "Paramètres",
        welcome = "Bienvenue !",
        dock = "Attacher",
        undock = "Détacher",
        support = "Lien pour me soutenir",
        about = "Forum RoboFace",
        
        language = "Langues",
        english = "English",
        ukrainian = "Українська",
        french = "Français",
        
        set_background_color = "Couleur de fond",
        white_bg = "Claire",
        black_bg = "Sombre",
        
        quit = "Sortir",
        
        sneeze = "Nouveau",
        
        set_zoom = "Zoom",
        
        start_up = "Lancer à l`ouverture ",
        
        games = "Jeux",
        
        patreon = "Autres scripts",
        
        format_title = "AM/PM",
        vert_am_title = "Vertical",
        
        reset = "Reset",
        
        stop_ear_puzzle = "Arrêter le jeu",
        my_own = "La mienne",
        
        t_auto_night = "Jour / Nuit",
        birth = "Votre anniversaire"
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
gfx.init("RoboFace 1.41", startWidth, startHeight, dock_state, x, y)



local previous_position = ""

function get_reaper_main_window_size()
  local hwnd = reaper.GetMainHwnd()
  local retval, left, top, right, bottom = reaper.JS_Window_GetRect(hwnd)
  local width = right - left
  local height = bottom - top
  return width, height
end

function get_script_window_position()
    local hwnd = reaper.JS_Window_Find("RoboFace 1.41", true)
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
        -- reaper.ShowConsoleMsg("1")
        window_position = 1
    else
        -- reaper.ShowConsoleMsg("2")
        window_position = 2
    end
  
    if current_position ~= previous_position then
        -- reaper.ShowConsoleMsg(current_position .. "\n")
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

-- math.randomseed(math.floor(reaper.time_precise() / 60))

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
local is_angry = false


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



------------------------------------ FPS PARAMETERS
local t_fps = 0
local g_fps = 1


---------------------------------- OTHER PARAMETERS
local is_reading = false
local is_reading_a = false

local show_book_one = false
local show_book_two = false
local show_book_three = false
local show_book_four = false
local show_book_five = false
local show_book_six = false

local is_workout = false
local is_antennas = false
local is_auto_night = false
local t_f_f = false
local t_f_fr = false

local is_sleeping = false
local is_recording = false
local is_yawning = false
local is_sneeze_general = false
local is_coffee = false







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

    local shake_offset = get_shake_bpm_intensity()
    
    local face_x = (gfx.w - face_width) / 2 + get_horizontal_shake_intensity() 
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


    ----------------------------------------------------------------------------------------------------------------------------- 24
    local f_h = gfx.h / 2
    local b_y = 0
    local y_y = gfx.h / 2

    if t_f_f then
        gfx.set(0, 0.55, 1, 1) -- b
        gfx.rect(0, b_y, gfx.w, f_h, 1)

        gfx.set(1, 0.84, 0, 1) -- y
        gfx.rect(0, y_y, gfx.w, f_h, 1)
    end


    ----------------------------------------------------------------------------------------------------------------------------- 14
    local f_w = gfx.w / 3

    if t_f_fr then
        gfx.set(0, 0, 0.7, 1) -- b
        gfx.rect(0, 0, f_w, gfx.h, 1)

        gfx.set(1, 1, 1, 1) -- w
        gfx.rect(f_w, 0, f_w, gfx.h, 1)

        gfx.set(0.9, 0, 0, 1) -- r
        gfx.rect(f_w * 2, 0, f_w, gfx.h, 1)
    end


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
        
    elseif is_bg_black and (t_f_f or t_f_fr) then
        local shadow_offset = 3
        
        if is_sleeping then
            gfx.set(0.1, 0.1, 0.1, 1)
            gfx.rect(face_x + shadow_offset, face_y + shadow_offset + animate_sleep(), face_width, face_height, 1)
        elseif not is_sleeping then
            gfx.set(0.3, 0.3, 0.3, 1)
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


    --------------------------------------------------------------------------------------------------------------------------- BOOK
    local book_width = face_width * 0.9
    local book_height = face_height * 1
    local book_x = face_x - (book_width - face_width) / 2
    local book_y = face_y + face_height * 0.55

    if is_reading and not is_workout and not is_coffee and not is_yawning and not is_recording and not is_sleeping and not is_angry then
        if not is_bg_black then
            gfx.set(0.5, 0.5, 0.5, 1)
            gfx.rect(book_x + 3, book_y + 3, book_width, book_height, 1)

            gfx.set(0.65, 0.65, 0.65, 1)
            gfx.rect(book_x, book_y, book_width, book_height, 1)

            gfx.set(0.5, 0.5, 0.5, 1)
        else
            gfx.set(0.5, 0.5, 0.5, 1)
            gfx.rect(book_x, book_y, book_width, book_height, 1)

            gfx.set(0.1, 0.1, 0.1, 1)
        end

        local line_thickness = 2

        for i = 0, line_thickness - 1 do
            gfx.line(book_x, book_y + i, book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- R
            gfx.line(book_x + book_width, book_y + i, book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- L
            
            if show_book_one then
                gfx.line(book_x + book_width / 1.2, book_y + i,       book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- 1
            elseif show_book_two then
                gfx.line(book_x + book_width / 1.5, book_y + i,       book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- 2
            elseif show_book_three then
                gfx.line(book_x + book_width / 1.8, book_y + i,       book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- 3
            elseif show_book_four then
                gfx.line(book_x + book_width / 2.2, book_y + i,       book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- 4
            elseif show_book_five then
                gfx.line(book_x + book_width / 3,   book_y + i,       book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- 5
            elseif show_book_six then
                gfx.line(book_x + book_width / 6,   book_y + i,       book_x + book_width / 2, book_y - book_height * (- 0.15) + i) -- 6
            end
            
            gfx.line(book_x + i, book_y, book_x + i, book_y + book_height)
            gfx.line(book_x + book_width - i, book_y, book_x + book_width - i, book_y + book_height)

            gfx.line(book_x + book_width / 2 + i / 2, book_y + book_height * 0.2, book_x + book_width / 2, book_y + book_height)
        end

    end



    ------------------------------------------------------------------------------------------------------------------------- COFFEE
    local book_width = face_width * 0.6
    local book_height = face_height * 1
    local book_x = face_x - (book_width - face_width) / 0.8
    local book_y = face_y + face_height * 0.9
    
    if is_coffee and not is_workout and not is_reading and not is_yawning and not is_recording and not is_sleeping and not is_angry then
        if not is_bg_black then
            gfx.set(0.5, 0.5, 0.5, 1)
            gfx.rect(book_x + 3, book_y + 3, book_width, book_height, 1)
            
            gfx.set(0.65, 0.65, 0.65, 1)
            gfx.rect(book_x, book_y, book_width, book_height, 1)
            
            gfx.set(0.5, 0.5, 0.5, 1)
        else
            gfx.set(0.5, 0.5, 0.5, 1)
            gfx.rect(book_x, book_y, book_width, book_height, 1)
            
            gfx.set(0.1, 0.1, 0.1, 1)
        end
        
        local line_thickness = 2
        
        for i = 0, line_thickness - 1 do
            gfx.line(book_x, book_y, book_x + book_width + i, book_y)
            
            gfx.line(book_x + i, book_y, book_x + i, book_y + book_height)
            gfx.line(book_x + book_width - i, book_y, book_x + book_width - i, book_y + book_height)
        end
    end

    draw_pupils(scale)

    ------------------------------------------------------------------------------------------------------------------------ WORKOUT
    local brbl_light_offcet = 2.3

    if not is_bg_black then
        brbl_light_offcet = 2.3
    else
        brbl_light_offcet = 2
    end

    local brbl_width = face_width * 1.6
    local brbl_height = face_height * 0.15
    local brbl_x = face_x + (face_width - brbl_width) / brbl_light_offcet
    local brbl_y = face_y + (face_height - brbl_height) / 2
    
    if is_workout and not is_reading and not is_coffee and not is_yawning and not is_recording and not is_sleeping and not is_angry then
        local current_time = reaper.time_precise()
        local lift_progress = math.min((current_time - workout_start_time) / workout_duration, 1)
        local lift_offset = face_height * 0.4 * math.sin(lift_progress * math.pi)

        local brbl_y_animated = brbl_y - lift_offset

        -- barbell
        gfx.set(0.5, 0.5, 0.5, 1)
        gfx.rect(brbl_x, brbl_y_animated, brbl_width, brbl_height, 1)

        -- plates
        local plate_heights = {brbl_height * 2, brbl_height * 3.3, brbl_height * 4}
        local plate_width = brbl_height * 1.2
        
        local left_x = brbl_x - plate_width
        local right_x = brbl_x + brbl_width
        
        gfx.set(0.5, 0.5, 0.5, 1)

        for i, h in ipairs(plate_heights) do
            local y_offset = (h - brbl_height) / 2

            gfx.rect(left_x + (i - 1) * plate_width, brbl_y_animated - y_offset, plate_width, h, 1) -- L
            gfx.rect(right_x - (i - 1) * plate_width, brbl_y_animated - y_offset, plate_width, h, 1) -- R
        end
    end

    

    ----------------------------------------------------------------------------------------------------------------------- ANTENNAS
    local antenna_length = face_height * 0.2
    local antenna_width = 2 * scale
    local antenna_offset_x = face_width * 0.2
    local antenna_offset_y = face_height * (- 0.001)
    
    -- L A
    local left_antenna_x1 = face_x + antenna_offset_x
    local left_antenna_y1 = face_y + antenna_offset_y
    local left_antenna_x2 = left_antenna_x1 - antenna_length * 0.4
    local left_antenna_y2 = left_antenna_y1 - antenna_length * 1.1
    
    -- R A
    local right_antenna_x1 = face_x + face_width - antenna_offset_x
    local right_antenna_y1 = face_y + antenna_offset_y
    local right_antenna_x2 = right_antenna_x1 + antenna_length * 0.4
    local right_antenna_y2 = right_antenna_y1 - antenna_length * 1.1

    -- TV
    local tv_width = face_width * 0.8
    local tv_height = face_height * 0.8
    local tv_x = face_x + (face_width - tv_width) / 2
    local tv_y = face_y + (face_height - tv_height) / 2
    
    if is_antennas then
        if not is_bg_black then
            
            -- ANTENNAS
            local line_thickness = 5
            
            for i = 0, line_thickness - 1 do            
                gfx.set(0.65, 0.65, 0.65, 1)
                gfx.line(left_antenna_x1, left_antenna_y1 + i, left_antenna_x2, left_antenna_y2)
                gfx.line(right_antenna_x1, right_antenna_y1 + i, right_antenna_x2, right_antenna_y2)
            end
            
            -- POINTS
            local antenna_dot_radius = 10 * scale
            gfx.set(0.5, 0.5, 0.5, 1)
            gfx.circle(left_antenna_x2, left_antenna_y2, antenna_dot_radius, 1)    
            gfx.circle(right_antenna_x2, right_antenna_y2, antenna_dot_radius, 1)

            -- TV
            -- gfx.set(0.5, 0.5, 0.5, 1)
            -- gfx.rect(tv_x, tv_y, tv_width, tv_height, 1)
        
        else
            
            -- ANTENNAS
            local line_thickness = 30
            gfx.set(0.65, 0.65, 0.65, 1)
                
            for i = 0, line_thickness - 1 do
                gfx.line(left_antenna_x1, left_antenna_y1 + i, left_antenna_x2, left_antenna_y2)
                gfx.line(right_antenna_x1, right_antenna_y1 + i, right_antenna_x2, right_antenna_y2)
            end
            
            -- POINTS
            local antenna_dot_radius = 5 * scale
            gfx.set(0.6, 0.6, 0.6, 1)
        end
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
    local shake_offset = get_shake_bpm_intensity()
    local shake_offset_h = get_horizontal_shake_intensity()
    
    if is_eye_open and not is_sleeping and not is_recording then
        local eye_size = base_eye_size * scale
        local pupil_size = base_pupil_size * scale
        local face_width = base_face_width * scale
        local face_height = base_face_height * scale
        local face_x = (gfx.w - face_width) / 2
        local face_y = (gfx.h - face_height) / 2 + shake_offset + get_vertical_shake_intensity()

        local eye_offset_x = face_width * (base_left_eye_x - base_face_x) / base_face_width -- + shake_offset_h
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

function is_night_time() -- see p.s.
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
    else
        return false
    end
end

function is_early_morning_time() -- see p.s.
    local time_now = os.date("*t").hour

    if time_now == 08 then 
        return true
    elseif time_now == 09 then 
        return true
    else
        return false
    end
end

function is_morning_time() -- see p.s.
    local time_now = os.date("*t").hour

    if time_now == 10 then 
        return true
    elseif time_now == 11 then 
        return true
    else
        return false
    end
end

function is_day_time() -- see p.s.
    local time_now = os.date("*t").hour

    if time_now == 12 then 
        return true
    elseif time_now == 13 then 
        return true
    elseif time_now == 14 then 
        return true
    elseif time_now == 15 then 
        return true
    elseif time_now == 16 then 
        return true
    elseif time_now == 17 then 
        return true
    else
        return false
    end
end

function is_evening_time() -- see p.s.
    local time_now = os.date("*t").hour

    if time_now == 18 then 
        return true
    elseif time_now == 19 then 
        return true
    elseif time_now == 20 then 
        return true
    elseif time_now == 21 then 
        return true
    else
        return false
    end
end

function is_late_evening_time() -- see p.s.
    local time_now = os.date("*t").hour

    if time_now == 22 then 
        return true
    elseif time_now == 23 then
        return true
    else
        return false
    end
end

function is_midnight_time() -- see p.s.
    local time_now = os.date("*t").hour

    if time_now == 00 then 
        return true
    else
        return false
    end
end

-- p.s.
-- functions: is_night_time, is_early_morning_time, is_early_morning_time, is_day_time, is_evening_time, is_late_evening_time, is_midnight_time is NOT loads CPU with this structure (almost, of course). 
-- another variations of this functions is LOADS CPU for 15-18% more. I have tried so many variations before this.
-- I do not know why it is.



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

function queue(actions)
    local start_time = reaper.time_precise()
    local i = 1
  
    local function step()
        local now = reaper.time_precise()

        while i <= #actions and now - start_time >= actions[i][1] do
            actions[i][2]()
            i = i + 1
        end
  
        if i <= #actions then
            reaper.defer(step)
        else
            return
        end
    end
  
    step()
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

function get_shake_bpm_intensity()
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
    local num_yawns = math.random(2, 3)
    local base_time = reaper.time_precise()

    for i = 1, num_yawns do
        base_time = base_time + math.random(10 * 60, 12 * 60)
        table.insert(yawn_intervals, base_time)
    end
end


function check_for_yawn()
    local current_time_table = os.date("*t")  
    local current_time = reaper.time_precise()
    
    if not yawn_intervals then init_yawn_intervals() end

    if current_time_table.hour == 0 and current_time_table.min == 0 then
        yawn_start_time = current_time
        init_yawn_intervals()
    end

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
                    reaper.ShowConsoleMsg("Si tu recommences, je m`en vais.\n\n")                
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
                    reaper.ShowConsoleMsg("Je t'ai déjà dit de ne pas faire ça. Mais tu l'as fait. \n\nAlors, j'ai modifié quelque chose dans ton projet... Ce n'est plus un jeu maintenant. Tu as 3 minutes pour le découvrir. Le temps presse !\n\n")
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
                -- animate_yawn()
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



--------------------------------------------------------------------------------------- WORKOUT

function animation_workout()
    is_workout = true

    workout_start_time = reaper.time_precise()
    workout_duration = 5
end

function shake_with_show_workout() -- this function structure was written completely with chatgpt but I'm lazy to make it better. it is works... anyway. may be, later. :/
    local timings = {0, 6, 12}
    local startTime = reaper.time_precise()

    local function trigger_with_delay(index)
        if index > #timings then
            reaper.defer(function()
                
                if reaper.time_precise() >= startTime + 18 then
                    is_workout = false -- here is end of cycle
                else
                    reaper.defer(function() trigger_with_delay(index) end)
                end
            end)
            
            return
        end
        
        if reaper.time_precise() >= startTime + timings[index] then
            animation_workout()
            
            if not is_reading or not is_sneeze_general or not is_coffee then
                trigger_horizontal_shake(1, 5)
            end

            index = index + 1 
        end
        
        reaper.defer(function() trigger_with_delay(index) end)
    end

    -- animation_workout()
    reaper.defer(function() trigger_with_delay(1) end)
end

local last_workout_time = reaper.time_precise() / 60
local workout_interval = math.random(60, 100)

function random_show_workout()
    local current_time = reaper.time_precise() / 60

    if not (
        is_angry or
        is_sleeping or
        is_yawning or
        is_sneeze_general or
        is_reading or
        is_coffee
    ) and (is_morning_time() or is_day_time()) then
        if current_time - last_workout_time >= workout_interval then
            shake_with_show_workout()

            last_workout_time = current_time
            workout_interval = math.random(60, 100)
            -- reaper.ShowConsoleMsg("workout " .. workout_interval .. "\n")
        end
    end
end



------------------------------------------------------------------------------------------ BOOK

function animation_book()
    queue{
      {0, function() show_book_one = true end},
      {0.15, function() show_book_one = false; show_book_two = true end},
      {0.30, function() show_book_two = false; show_book_three = true end},
      {0.45, function() show_book_three = false; show_book_four = true end},
      {0.6, function() show_book_four = false; show_book_five = true end},
      {0.75, function() show_book_five = false; show_book_six = true end},
      {0.9, function() show_book_six = false end},
    }
end

function animation_book_nx()
    queue{
        {1, function() animation_book() end},
        {4, function() animation_book() end},
        {7, function() animation_book() end},
        {10, function() animation_book() end},

        {16, function() animation_book() end},
        {19, function() animation_book() end},
        {22, function() animation_book() end},
        {25, function() animation_book() end},

        {30, function() is_reading = false end},
    }
end

function animation_book_start()
    is_reading = true
    animation_book_nx()
end

local last_book_a_time = reaper.time_precise() / 60
local book_a_interval = math.random(50, 100)

function random_show_book_a()
    local current_time = reaper.time_precise() / 60

    if not (
        is_angry or
        is_sleeping or
        is_yawning or
        is_sneeze_general or
        is_workout or
        is_coffee
    ) and (is_day_time() or is_evening_time()) then
        if current_time - last_book_a_time >= book_a_interval then
            animation_book_start()

            last_book_a_time = current_time
            book_a_interval = math.random(50, 100)
            -- reaper.ShowConsoleMsg("book " .. book_a_interval .. "\n")
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
        is_sneeze_one = false
        is_sneeze_two = false
        is_sneeze_general = false
        is_eye_open = true
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
local sneeze_interval = math.random(80, 100)

function random_show_sneeze()
    local current_time = reaper.time_precise() / 60

    if not (
        is_angry or
        is_sleeping or
        is_yawning or
        is_sneeze_general or
        is_workout or
        is_reading or
        is_coffee
    ) then
        if current_time - last_sneeze_time >= sneeze_interval then
            animate_sneeze()

            last_sneeze_time = current_time
            sneeze_interval = math.random(80, 100)
            -- reaper.ShowConsoleMsg("sn " .. sneeze_interval .. "\n")
        end
    end
end







-------------------------------------------------------------------------------------------------------------------- RANDOM MESSAGES

---------------------------------------------------------------------------------- DAY MESSAGES

--[[
local day_messages_en = {
    "123",
}

local day_messages_ua = {
    "123",
}

local day_messages_fr = {
    "123",
}


function show_day_message()
    if current_language == "en" then
        local randomIndex = math.random(#day_messages_en)
        reaper.ShowConsoleMsg(day_messages_en[randomIndex] .. "\n")
    elseif current_language == "ua" then
        local randomIndex = math.random(#day_messages_ua)
        reaper.ShowConsoleMsg(day_messages_ua[randomIndex] .. "\n")
    elseif current_language == "fr" then
        local randomIndex = math.random(#day_messages_fr)
        reaper.ShowConsoleMsg(day_messages_fr[randomIndex] .. "\n")
    end
end

local last_day_message_time = reaper.time_precise() / 60
local day_message_interval = math.random(120, 180)

function random_day_message()
    local current_time = reaper.time_precise() / 60
    local is_sleeping = should_robot_sleep()

    if not is_angry and is_night_time() and not is_yawning and not is_day_message_general then
        if current_time - last_day_message_time >= day_message_interval then
            show_day_message()

            last_day_message_time = current_time
            day_message_interval = math.random(120, 180)
        end
    end
end

]]--

-------------------------------------------------------------------------------- NIGHT MESSAGES

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
    "Хто там у тебе за твоєю спиною?\n\n",
    "Хрррр... хрррр... хррр. \n\n",
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
    "Zzz... Je me souviens du moment où ma développeuse m'a allumé pour la première fois. Ses yeux étaient remplis d'excitation et d'espoir, et j'ai senti que ce n'était que le début de quelque chose d'intéressant...\n\n",
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
        local randomIndex = math.random(#night_messages_fr)
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
    welcome      = { text = "ПРИВІТ",         font_name = "Pomidorko",  type = "scrolling", duration = 5, interval = 0, start_time = reaper.time_precise() + 1, font_size = 300 },
    
    is_it_loud   = { text = "Чи не\nгучно?",      font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    good_night   = { text = "Добраніч!",          font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    not_sleep    = { text = " Що, не\nспиш? :(",  font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    good_morning = { text = "Доброго\n ранку!",   font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    coffee_time  = { text = " Час\nкави!",        font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    eat_time     = { text = " Час\nїсти!",        font_name = "Consolas",  type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 170 },
  }
  
  local text_params_fr = {
    welcome     = { text = "BONJOUR",         font_name = "Iregula", type = "scrolling", duration = 5, interval = 0, start_time = reaper.time_precise() + 1 },

    is_it_loud  = { text = " Pas trop\nfort ?",      font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    good_night  = { text = "Bonne\nnuit !",         font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    not_sleep   = { text = "  Pas  :(\nsommeil ?",  font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 160 },
    good_morning= { text = "  C'est un\nbeau matin !",              font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    coffee_time = { text = " Pause\ncafé !",        font_name = "Consolas", type = "static",    duration = 5, interval = 0,  start_time = 0, font_size = 130 },
    eat_time    = { text = "   À table !",   font_name = "Consolas", type="static",    duration = 5, interval = 0, start_time = 0, font_size = 170},
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

local l_stop_one = false

function f_stop_one()
    local st = reaper.time_precise()

    local function check_t()
        local ct = reaper.time_precise()
        if ct - st >= 15 then
            l_stop_one = true
            return
        elseif not l_stop_one then
            reaper.defer(check_t)
        end
    end

    check_t()
end

function draw_scrolling_text(params)
    local current_time = reaper.time_precise()
    local start_time = params.start_time
    local scale_factor = get_scale_factor()
    local font_size = (params.font_size or base_font_size) * scale_factor
    local face_height = base_face_height * scale_factor
    local face_y = (gfx.h - face_height)

    local font_name = params.font_name or "Lucida Console"
    
    if current_time >= start_time then
        local time_pas = current_time - start_time
        local text_pos = gfx.w - scroll_speed * time_pas
        
        if text_pos < gfx.w and text_pos + gfx.measurestr(scroll_text) > 0 then
            if is_bg_black then
                gfx.set(0, 0, 0, 1)
                gfx.rect(0, 0, gfx.w, gfx.h, 1)

                gfx.set(0.7, 0.7, 0.7)
                gfx.setfont(1, font_name, font_size)
        
            else
                gfx.set(0.8, 0.8, 0.8, 1)
                gfx.rect(0, 0, gfx.w, gfx.h, 1)

                gfx.set(0.5, 0.5, 0.5)
                gfx.setfont(1, font_name, font_size)
        
            end
        end

        if current_language == "ua" then
            gfx.x = text_pos
            gfx.y = (face_y / 1.7) + face_height / 2 - font_size / 2
        else
            gfx.x = text_pos
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
    if time_format_12hr and time_in_range("00:59 AM", current_time, 1) then
        current_state = "good_night"
    elseif not time_format_12hr and time_in_range("00:59", current_time, 1) then
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
        gfx.set(0.9, 0.9, 0.9, 1)
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

local last_tap = 0
local tap_count = 0
local tap_dur = {}
local total_tap = 0
local is_tap_active = false

local l_stop_tap_tempo = false

function f_stop_tap_tempo()
    local st = reaper.time_precise()

    local function check_t()
        local ct = reaper.time_precise()

        if ct - st >= 15 then
            l_stop_tap_tempo = true
            is_tap_active = false

            if current_language == "en" then
                reaper.ShowConsoleMsg("\nTap tempo mode canceled automatically.\n\n")
            elseif current_language == "ua" then
                reaper.ShowConsoleMsg("\nРежим 'Тап темпо' завершено.\n\n")
            elseif current_language == "fr" then
                reaper.ShowConsoleMsg("\nLe mode Tap Tempo est maintenant terminé.\n\n")
            end

            return

        elseif not l_stop_tap_tempo then
            reaper.defer(check_t)
        end
    end

    check_t()
end

function f_tap_tempo()
    if not is_tap_active then return end
    
    local cur_time = reaper.time_precise()
    local tap_dur_2 = cur_time - last_tap
    
    trigger_vertical_shake(2, 0.08, true)
    
    if last_tap > 0 then
        table.insert(tap_dur, tap_dur_2)
        total_tap = total_tap + tap_dur_2
        tap_count = tap_count + 1
        
        if tap_count >= 4 then
            local tap_dur_av = total_tap / #tap_dur
            local bpm = 60 / tap_dur_av
            local what_bpm = math.floor(bpm + 0.5)
            
            reaper.ShowConsoleMsg(what_bpm .. "\n")
        end
    end
    
    last_tap = cur_time
end

function trigger_tap_tempo()
    is_tap_active = true
    last_tap = 0
    tap_count = 0
    total_tap = 0
    tap_dur = {}

    -- f_stop_tap_tempo()

    if current_language == "en" then
        reaper.ShowConsoleMsg("Tap tempo mode activated. Tap at least 5 times on the robot face.\nPress Esc to stop function.\n\n")
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("Режим 'Тап темпо' активовано. Будь ласка, натисніть мінімум 5 разів по обличчю робота.\n\nНатисніть Esc, щоб завершити.\n\n")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("Le mode 'Tap tempo' est activé. Tapez au moins cinq fois sur le visage du robot.\nAppuyez sur Esc pour terminer.\n\n")
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
    open_browser("https://amelysuncroll.sitepulse.com.ua/?fbclid=IwY2xjawJwkAdleHRuA2FlbQIxMAABHnp7iIKM89x_2ocOLFN3NmdLhs3OkQDMl9dhqbfJ3M1f5lM5GIDxmmoX99Af_aem_U4s2GWsZM5jhJERnrVHhhQ")
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
        reaper.ShowConsoleMsg("Bien tenté.\n\n")
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
    local name = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_name")

    if name == nil or name:match("^%s*$") then
        if current_language == "en" then
            name = "friend"
        elseif current_language == "ua" then
            name = "добродію"
        elseif current_language == "fr" then
            name = "mon ami"
        end
    end

    if current_language == "en" then
        reaper.ShowConsoleMsg("Welcome, " .. name .. "!\n\n")
        reaper.ShowConsoleMsg("My name is RoboFace.\n\n")
        reaper.ShowConsoleMsg("I love Reaper DAW and music. Also, I enjoy sleeping at night and having morning coffee. But if you're not careful with me, I can do something bad.\n\n")
        reaper.ShowConsoleMsg("I can play a game or even joke with you.\n\n")
        reaper.ShowConsoleMsg("My capabilities include:\n")
        reaper.ShowConsoleMsg("1. Displaying the current or hourly time.\n")
        reaper.ShowConsoleMsg("2. Setting and displaying a timer.\n")
        reaper.ShowConsoleMsg("3. Playing the 'Something Was Changed' game where you need to find and then revert a changed parameter. See rules to get more.\n")
        reaper.ShowConsoleMsg("4. Animations: blinking, yawning, anger, and other.\n")
        reaper.ShowConsoleMsg("5. Getting a tempo with your clickes via 'Tap Tempo' mode.\n")
        reaper.ShowConsoleMsg("6. And so on, and so on.\n\n")
        reaper.ShowConsoleMsg("To get help or support the author, use the links in the options.\n\n")
        reaper.ShowConsoleMsg("I hope we will be nice friends!\n\n")

        -- reaper.ShowConsoleMsg("RoboFace 1.41\n")
    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("Йой!\n\nЯ бачу, що ти обрав українську мову. Молодець!\n\nТоді нумо познайомимося ще раз, уже солов'їною.\n\n")
        reaper.ShowConsoleMsg("Привіт, " .. name .. "!\n\n")
        reaper.ShowConsoleMsg("Мене звати RoboFace.\n\n")
        reaper.ShowConsoleMsg("Я люблю Reaper DAW та музику. Також мені подобається дотримуватися режиму сну та пити каву вранці. Але якщо ти будеш необережний зі мною, я можу зробити дещо погане.\n\n")
        reaper.ShowConsoleMsg("Я можу грати в ігри або навіть жартувати з тобою.\n\n")
        reaper.ShowConsoleMsg("Мої можливості включають:\n")
        reaper.ShowConsoleMsg("1. Відображення поточного часу або щогодини.\n")
        reaper.ShowConsoleMsg("2. Налаштування таймера.\n")
        reaper.ShowConsoleMsg("3. Гру 'Що змінилося?', де потрібно знайти змінений параметр та відновити його значення. Дивіться правила, щоб дізнатися більше.\n")
        reaper.ShowConsoleMsg("4. Анімації: блимання очима, позіхання, злість, чхання та інші.\n")
        reaper.ShowConsoleMsg("5. Режим 'Тап Темпо', за допомогою якого можна перевірити власний темп клацом миші.\n")
        reaper.ShowConsoleMsg("6. Тощо.\n\n")
        reaper.ShowConsoleMsg("Якщо тобі потрібна допомога або хочеш підтримати авторку, звертайся за посиланнями в опціях.\n\n")
        reaper.ShowConsoleMsg("Сподіваюся, ми будемо чудовими друзями!\n\n")

        -- reaper.ShowConsoleMsg("RoboFace 1.41\n")
    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("Oh là là !\n\nJe vois que tu as choisi la langue française. Bravo !\n\nAlors, faisons à nouveau connaissance, cette fois en français.\n\n")
        reaper.ShowConsoleMsg("Bienvenue, " .. name .. " !\n\n")
        reaper.ShowConsoleMsg("Je m'appelle RoboFace.\n\n")
        reaper.ShowConsoleMsg("J'adore Reaper DAW et la musique. J'aime aussi dormir la nuit et prendre mon café le matin. Mais si tu n'es pas prudent avec moi, je peux faire des bêtises.\n\n")
        reaper.ShowConsoleMsg("Je peux jouer à un jeu ou même plaisanter avec toi.\n\n")
        reaper.ShowConsoleMsg("Mes capacités incluent :\n")
        reaper.ShowConsoleMsg("1. Afficher l'heure actuelle ou l'heure par heure.\n")
        reaper.ShowConsoleMsg("2. Régler et afficher un minuteur.\n")
        reaper.ShowConsoleMsg("3. Jouer au jeu 'Quelque chose a changé ?', où tu dois trouver un paramètre modifié et le remettre en ordre. Consulte les règles pour plus d'informations.\n")
        reaper.ShowConsoleMsg("4. Animer des actions : clignotements, bâillements, colère, et autres.\n")
        reaper.ShowConsoleMsg("5. Régler le tempo avec tes clics grâce au mode 'Tap Tempo'.\n")
        reaper.ShowConsoleMsg("6. Et ainsi de suite.\n\n")
        reaper.ShowConsoleMsg("Pour obtenir de l'aide ou soutenir la créatrice, utilise les liens dans les options.\n\n")
        reaper.ShowConsoleMsg("J'espère que nous serons de bons amis !\n\n")

        -- reaper.ShowConsoleMsg("RoboFace 1.41\n")
    end
end

function check_welcome_message()
    if is_welcome_shown then return end

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
                    reaper.ShowConsoleMsg("\n\nJ'ai eu peur :( C'était vraiment très fort.\n\n")
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
        stop_script()

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



local is_user_night = false

function auto_night()
    if is_auto_night and not is_user_night then
        if is_late_evening_time() or is_midnight_time() or is_night_time() or is_early_morning_time() then
            is_bg_black = true
        else
            is_bg_black = false
        end
    end
end

function auto_night_user()
    local time_now = os.date("*t").hour
    local start_night
    local finish_night
    
    if time_now == start_night then
        is_user_night = true
    elseif time_now == finish_night then
        is_user_night = false
    else
        is_user_night =  false
    end
end

function set_auto_night()
    is_auto_night = not is_auto_night
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
        reaper.ShowConsoleMsg("\nT`as perdu !\n\n")
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
        reaper.ShowConsoleMsg("Ласкаво просимо до гри 'Що змінилося?'!\n\n")

        reaper.ShowConsoleMsg("Правила гри:\n")
        reaper.ShowConsoleMsg("Робот змінить випадковий параметр (гучність або панораму або вимкне один fx) однієї з доріжок, яка не замьючена і має аудіо або міді.\n")
        reaper.ShowConsoleMsg("Ваше завдання - повернути параметр до його початкового значення.\n")
        reaper.ShowConsoleMsg("Ви можете спробувати змінити до трьох параметрів (наприклад, якщо обран важкий рівень або ніякої), перш ніж гра буде програна.\n\n")

        reaper.ShowConsoleMsg("Увага! Відтворення проекту або виділення доріжок також вважаються змінами.\n")
        reaper.ShowConsoleMsg("Переміщення курсору редагування не вважається зміною.\n\n")

        reaper.ShowConsoleMsg("На вищих рівнях складності рекомендуємо відкрити мікшер перед початком гри.\n\n")

        reaper.ShowConsoleMsg("Успіхів!\n\n")

    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("Bienvenue dans le jeu 'Quelque chose a changé' !\n\n")
    
        reaper.ShowConsoleMsg("Règles du jeu :\n")
        reaper.ShowConsoleMsg("Le robot modifiera un paramètre aléatoire - le volume, la balance ou mettra en sourdine un effet - sur une piste qui n'est pas muette et qui contient de l'audio ou du MIDI.\n")
        reaper.ShowConsoleMsg("Votre tâche est de rétablir le paramètre à sa valeur d'origine.\n")
        reaper.ShowConsoleMsg("Vous pouvez essayer de modifier jusqu'à trois paramètres (si vous avez sélectionné le niveau difficile ou si aucun niveau n'est choisi) avant que la partie ne soit perdue.\n\n")
    
        reaper.ShowConsoleMsg("Attention ! L'exécution du projet ou la sélection de pistes sont également considérés comme des modifications.\n")
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




-------------------------------------------------------------------------------------------------------------------- EARPUZZLE (GAME)

local is_ep_easy = is_ep_easy == 'true' and true or false
local is_ep_medium = is_ep_medium == 'true' and true or false
local is_ep_hard = is_ep_hard == 'true' and true or false
local is_ep_my_own = is_ep_my_own == 'true' and true or false

local parts_to_cut_it = 0

local function set_ep_difficulty_level(ep_level)
    if ep_level == "Easy" then
        is_ep_easy = not is_ep_easy
        is_ep_medium = false
        is_ep_hard = false
        is_ep_my_own = false
        parts_to_cut_it = 3
    elseif ep_level == "Medium" then
        is_ep_medium = not is_ep_medium
        is_ep_easy = false
        is_ep_hard = false
        is_ep_my_own = false
        parts_to_cut_it = 5
    elseif ep_level == "Hard" then
        is_ep_hard = not is_ep_hard
        is_ep_easy = false
        is_ep_medium = false
        is_ep_my_own = false
        parts_to_cut_it = 7
    elseif ep_level == "MyOwn" then
        is_ep_my_own = not is_ep_my_own
        is_ep_easy = false
        is_ep_medium = false
        is_ep_hard = false

        if current_language == "en" then
            hm_ep_parts = "ENG"
            ep_parts = "ENG"
            ep_wrong1 = "ENG"
        elseif current_language == "ua" then
            hm_ep_parts = "Введіть кількість частин"
            ep_parts = "Кількість частин:"
            ep_wrong1 = "Введено некоректну кількість частин!"
        elseif current_language == "fr" then
            hm_ep_parts = "FR"
            ep_parts = "FR"
            ep_wrong1 = "FR"
        end

        local ret, user_input = reaper.GetUserInputs(hm_ep_parts, 1, ep_parts, "")

        if ret then
            local num_parts = tonumber(user_input)
            if num_parts and num_parts >= 2 then
                parts_to_cut_it = num_parts
            else
                reaper.ShowMessageBox(ep_wrong1, ":(", 0)
            end
        end
    end
end

function split_selected_item(parts_to_cut_it)
    local item_count = reaper.CountSelectedMediaItems(0)

    if current_language == "en" then
        sel_parts = "Select exactly one item, please!"
    elseif current_language == "ua" then
        sel_parts = "Будь ласка, оберіть рівно один айтем!"
    elseif current_language == "fr" then
        sel_parts = "Veuillez sélectionner un seul item !"
    end
    
    if item_count ~= 1 then
        reaper.ShowMessageBox(sel_parts, ":(", 0)
        return
    end

    local item = reaper.GetSelectedMediaItem(0, 0)
    local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

    local min_part_length = item_length * 0.05 -- 5%
    math.randomseed(os.time())  

    local proportions = {}
    local total = 0

    repeat
        proportions = {}
        total = 0

        for i = 1, parts_to_cut_it do
            proportions[i] = math.random()
            total = total + proportions[i]
        end

        local is_valid = true

        for i = 1, parts_to_cut_it do
            if (proportions[i] / total) * item_length < min_part_length then
                is_valid = false
                break
            end
        end
    until is_valid

    local cut_pos = {}
    local accum_length = 0

    for i = 1, parts_to_cut_it - 1 do
        accum_length = accum_length + (proportions[i] / total) * item_length
        table.insert(cut_pos, item_start + accum_length)
    end

    for _, cut_pos in ipairs(cut_pos) do
        reaper.SetEditCurPos(cut_pos, false, false)
        reaper.Main_OnCommand(40759, 0) -- split at edit cursor
    end

    reaper.SelectAllMediaItems(0, false)

    local new_item_count = reaper.CountMediaItems(0)

    for i = 0, new_item_count - 1 do
        local new_item = reaper.GetMediaItem(0, i)
        local new_item_pos = reaper.GetMediaItemInfo_Value(new_item, "D_POSITION")

        if new_item_pos >= item_start and new_item_pos < (item_start + item_length) then
            reaper.SetMediaItemSelected(new_item, true)
        end
    end
end


function shuffle_items()
    local item_count = reaper.CountSelectedMediaItems(0)
    local items = {}
    local lengths = {}
    local total_length = 0

    for i = 0, item_count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        table.insert(items, item)
        table.insert(lengths, length)
        total_length = total_length + length
    end

    local first_item = items[1]
    local start_pos = reaper.GetMediaItemInfo_Value(first_item, "D_POSITION")
    local end_pos = start_pos + total_length

    math.randomseed(os.time())

    for i = #items, 2, -1 do
        local j = math.random(1, i)
        items[i], items[j] = items[j], items[i]
        lengths[i], lengths[j] = lengths[j], lengths[i]
    end

    local current_pos = start_pos

    for i = 1, item_count do
        reaper.SetMediaItemInfo_Value(items[i], "D_POSITION", current_pos)
        current_pos = current_pos + lengths[i]
    end
end

original_order = {}

function get_items_order()
    local item_count = reaper.CountSelectedMediaItems(0)
    local order = {}

    for i = 0, item_count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        table.insert(order, {item = item, pos = pos})
    end

    table.sort(order, function(a, b) return a.pos < b.pos end)

    local ordered_items = {}

    for i = 1, #order do
        table.insert(ordered_items, order[i].item)
    end

    return ordered_items
end

function check_order()
    local item_count = reaper.CountSelectedMediaItems(0)

    if item_count ~= #original_order then
        reaper.defer(check_order)
        return
    end

    local current_order = get_items_order()
    local is_correct = true

    for i = 1, item_count do
        if current_order[i] ~= original_order[i] then
            is_correct = false
            break
        end
    end

    if not is_correct then
        reaper.defer(check_order)
    end
end

original_item = nil
original_track = nil
original_position = nil

function puzzle_game(parts_to_cut_it)
    local item_count = reaper.CountSelectedMediaItems(0)

    if current_language == "en" then
        sel_parts = "Select exactly one item, please!"
    elseif current_language == "ua" then
        sel_parts = "Будь ласка, оберіть рівно один айтем!"
    elseif current_language == "fr" then
        sel_parts = "Veuillez sélectionner un seul iteme !"
    end

    if item_count ~= 1 then
        reaper.ShowMessageBox(sel_parts, ":(", 0)
        return
    end

    original_item = reaper.GetSelectedMediaItem(0, 0)
    original_track = reaper.GetMediaItemTrack(original_item)
    original_position = reaper.GetMediaItemInfo_Value(original_item, "D_POSITION")

    reaper.Main_OnCommand(40698, 0) -- copy items

    split_selected_item(parts_to_cut_it)
    original_order = get_items_order()
    shuffle_items()
    reaper.defer(check_order)
end

function check_order()
    local item_count = reaper.CountSelectedMediaItems(0)
    
    if item_count ~= #original_order then
        reaper.defer(check_order)
        return
    end

    local current_order = get_items_order()
    local is_correct = true
    
    for i = 1, item_count do
        if current_order[i] ~= original_order[i] then
            is_correct = false
            break
        end
    end

    if current_language == "en" then
        win_ep = "Congratulations! You have returned the item parts to their original order!"
    elseif current_language == "ua" then
        win_ep = "Вітаю! Ви повернули частини у початковий порядок!"
    elseif current_language == "fr" then
        win_ep = "Nous vous félicitons ! Vous avez remis les pièces dans leur ordre d'origine !"
    end

    if is_correct then
        reaper.ShowConsoleMsg(win_ep, ":)", 0)
        restore_original_item()
    else
        reaper.defer(check_order)
    end
end

function restore_original_item()
    reaper.Undo_BeginBlock()

    reaper.Main_OnCommand(40006, 0) -- remove items

    reaper.SetEditCurPos(original_position, false, false)
    reaper.SetOnlyTrackSelected(original_track)
    reaper.Main_OnCommand(40058, 0) -- paste items

    reaper.Undo_EndBlock("Restore original item after ear puzzle game", -1)
end

function about_ear_puzzle_game()
    if current_language == "en" then
        reaper.ShowConsoleMsg("Welcome to the game 'Ear Puzzle'!\n\n")

        reaper.ShowConsoleMsg("Game rules:\n\n")

        reaper.ShowConsoleMsg("Choose one item you want to play with.\n")
        reaper.ShowConsoleMsg("After the game is launched, this item will be divided into several parts (depending on the difficulty), which will be shuffled.\n")
        reaper.ShowConsoleMsg("Your task is to restore the original order of this parts. The number of listening attempts and game time are unlimited.\n")
        reaper.ShowConsoleMsg("When you're done, just select all the parts of the asset. If you've restored the order correctly, you'll see a message.\n\n")

        reaper.ShowConsoleMsg("Don't worry - either in case of victory or in case of stopping the game through the context menu - RoboFace will return the original item to the same place where it was.\n\n")

        reaper.ShowConsoleMsg("Good luck!\n\n")

    elseif current_language == "ua" then
        reaper.ShowConsoleMsg("Ласкаво просимо до гри 'Вушний пазл'!\n\n")

        reaper.ShowConsoleMsg("Правила гри:\n\n")

        reaper.ShowConsoleMsg("Виберіть один айтем, з яким Ви хочете погратися.\n")
        reaper.ShowConsoleMsg("Після запуску гри цей айтем поділиться на декілька частин (залежно від складності), які будуть перемішані.\n")
        reaper.ShowConsoleMsg("Ваше завдання - відновити початковий порядок. Кількість спроб прослуховування та час необмежені.\n")
        reaper.ShowConsoleMsg("Коли закінчите, виділить усі частини айтему. Якщо Ви правильно відновили порядок, Ви побачите повідомлення.\n\n")

        reaper.ShowConsoleMsg("Не хвилюйтеся - що у випадку перемоги, що у випадку зупинення гри через контекстне меню - РобоФейс поверне оригінал айтему на те саме місце, де він був.\n\n")

        reaper.ShowConsoleMsg("Успіхів!\n\n")

    elseif current_language == "fr" then
        reaper.ShowConsoleMsg("Bienvenue dans le jeu 'Ear Puzzle' !\n\n")
    
        reaper.ShowConsoleMsg("Règles du jeu :\n\n")
        reaper.ShowConsoleMsg("Choisissez un jeu avec lequel vous voulez jouer.\n")
        reaper.ShowConsoleMsg("Après le lancement du jeu, cet objet sera divisé en plusieurs parties (en fonction de la difficulté), qui seront mélangées.\n")
        reaper.ShowConsoleMsg("Votre tâche consiste à rétablir l'ordre d'origine. Le nombre de tentatives d'écoute et le temps sont illimités.\n")
        reaper.ShowConsoleMsg("Lorsque vous avez terminé, sélectionnez toutes les parties du bien. Si vous avez correctement rétabli l'ordre, un message s'affiche.\n\n")

        reaper.ShowConsoleMsg("Ne vous inquiétez pas - que ce soit en cas de victoire ou d'arrêt du jeu via le menu contextuel - RoboFace remettra l'objet d'origine à l'endroit où il se trouvait.\n\n")

        reaper.ShowConsoleMsg("Bonne chance !\n\n")

        reaper.ShowConsoleMsg("P.S. Cette partie du RoboFace a été traduite en utilisant DeepL car mon abonnement à ChatGPT a expiré. Si vous souhaitez participer à la traduction, veuillez envoyer un courriel à amelysuncroll@gmail.com. Merci beaucoup !\n\n")    

    end
end






---------------------------------------------------------------------------------------------------------------------------- CALENDAR

function save_first_launch_date()
    local key = "first_launch_date"
    local section = "AmelySuncrollRoboFaceRELEASE01"

    local existing = reaper.GetExtState(section, key)

    if existing == "" then
        local today = os.date("%Y-%m-%d")
        reaper.SetExtState(section, key, today, true)
    end
end

function get_first_launch_date()
    local key = "first_launch_date"
    local section = "AmelySuncrollRoboFaceRELEASE01"
    local date = reaper.GetExtState(section, key)
    return (date ~= "" and date) or nil
end

function get_user_name_or_default()
    local name = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_name")
    
    if name == nil or name:match("^%s*$") then
        if current_language == "en" then
            name = "friend"
        elseif current_language == "ua" then
            name = "добродію"
        elseif current_language == "fr" then
            name = "mon ami"
        end
    end
    
    return name
end

function sp_date(month, day)
    local name = get_user_name_or_default()
    
    local sp_d = {
    -- month day
        ["08-03"] = "Hello, " .. name .. "! Today is my birthday! I am soooooooo happy! My mom thought it would be fun to have some eyes follow the mouse cursor and blink. But then she lost her mind... And that's how I came to life!",
        ["11-12"] = "Today we celebrate Amely Suncroll's birthday! This is my mom, I love her so much and hope, you too! If you'd like to send your best wishes or support her creative work in this day, here's the link: https://www.paypal.com/ncp/payment/S8C8GEXK68TNC\n\n\n;)",

        ["07-04"] = "Happy International Day of Freedom! On this date many nations reflect on their journeys toward self-determination—let's celebrate the universal spirit of liberty, solidarity and hope.",
        ["10-31"] = "Happy Halloween! From ancient Celtic Samhain origins to today's global celebrations, costumes and creativity unite us all in a night of playful frights and fun.",
        ["11-05"] = "Remember, remember the fifth of November! On this day in 1605, the Gunpowder Plot failed. In many places bonfires and fireworks now symbolize community resilience and lessons from history.",
        ["12-25"] = "Merry Christmas! Celebrated worldwide as a season of light and generosity, this holiday brings together diverse traditions—from decorated trees to festive feasts—with warmth and joy.",
        ["03-17"] = "Happy St. Patrick's Day! Honoring Ireland's patron saint, this date is embraced globally with music, parades and green everywhere—cheers to unity and celebration!",
        ["04-01"] = "Happy April Fool's Day! Tracing back to 216th-century European calendar changes, today people across the globe play lighthearted pranks and share laughter—stay on your toes!",
        ["09-13"] = "Happy Programmer's Day! On the 256th day of the year, we honor coders everywhere—may your algorithms be elegant, your bugs minimal and your creativity boundless.",
        ["10-10"] = "Happy Binary Day! On 10/10 we salute the binary system that powers technology worldwide. Here's a binary greeting for you:\n\n01001000 01100001 01110000 01110000 01111001 00100000 01000010 01101001 01101110 01100001 01110010 01111001 00100001"
    }

    local sp_d_ua = {
    -- month day
        ["08-03"] = "Привіт, " .. name .. "! Сьогодні мій день народження! Я такий радий! Моя розробниця подумала, що буде весело, якщо якісь очи стежимуть за курсором миші та блиматимуть, а потім її як понесло... Ось так з'явився я!",
        ["11-12"] = "Сьогодні день народження Amely Suncroll! Якщо захочеш, можеш надіслати їй щось електронне: https://www.paypal.com/ncp/payment/S8C8GEXK68TNC\n\n\n;)",
        ["12-31"] = "Йо-хо-хо! Новорічний настрій вже близько! Новий рік — нові надії. Бажаю здійснення всіх мрій!",
        
        ["01-01"] = "З Новим роком! Як ся маєш після цієї ночи?",
        ["01-07"] = "Христос народився! Славімо його!",
        
        ["02-24"] = "Мабуть, ще людство дуже молоде.\nБо скільки б ми не загинали пальці, -\nXX вік! - а й досі де-не-де\nТрапляються іще неандертальці.\n\nПодивишся: і що воно таке?\nНе допоможе й двоопукла лінза.\nЗдається ж, люди, все у них людське,\nАле душа ще з дерева не злізла.\n\n\n                       Ліна Костенко",
        
        ["04-01"] = "Сьогодні день дурня! Будь обережним сьогодні, навіть зі мною :)",
        ["09-13"] = "Сьогодні день програміста! 256-й день року — символічний для програмістів. Що створимо сьогодні — новий код чи музику?",
        ["10-10"] = "З днем двійкової системи! Моє привітання тобі:\n\n01101000 01100001 01110000 01110000 01111001 00100000 01000010 01101001 01101110 01100001 01110010 01111001 00100001",



        ["01-20"] = "'Небесна Сотня - 107 загиблих учасників Революції Гідності, а також активісти Майдану, які загинули навесні 2014 року з початком російської агресії на сході України. До Героїв Небесної Сотні належать люди різних національностей, віросповідання, освіти, віку. Серед них громадяни України, Білорусі та Грузії. Наймолодшому з Героїв, Назарію Войтовичу, було 17 років, найстаршому, Іванові Наконечному, - 82 роки. Зі 107 Героїв Небесної Сотні - три жінки: Антоніна Дворянець, Ольга Бура та Людмила Шеремет.'\n\nВдячні за свободу. Пам'ятаємо.\n\nЗа сайтом 'Український інститут національної пам'яті'.",

        ["01-22"] = "Сьогодні День Соборності України!\n\n'Однині воєдино зливаються століттями одірвані одна від одної частини єдиної України - Західноукраїнська Народна Республіка (Галичина, Буковина, Угорська Русь) і Наддніпрянська Велика Україна. Здійснилися віковічні мрії, якими жили і за які умирали кращі сини України. Однині є єдина незалежна Українська Народна Республіка'. Єднаймося, чорнобривці!",

        ["03-09"] = "Тілько ворог, що сміється...\nСмійся, лютий враже!\nТа не дуже, бо все гине —\nСлава не поляже;\nНе поляже, а розкаже,\nЩо діялось в світі,\nЧия правда, чия кривда\nІ чиї ми діти.\nНаша дума, наша пісня\nНе вмре, не загине...\nОт де, люде, наша слава,\nСлава України!\n\nСьогодні день народження Тараса Шевченка!",
        
        ["04-26"] = "'30 квітня о 20.00 вітер повернувся у бік Києва і в місті почав підніматися радіаційний фон.\n\n1 травня комуністична партія вивела на святковий парад у Києві сотні тисяч людей, у тому числі й дітей, хоча рівень радіації перевищував допустимий у десятки разів.\n\n2 травня радянське керівництво ухвалило рішення про евакуацію населення з 30-кілометрової зони навколо Чорнобильської атомної станції - тільки на 6-й день після аварії, а офіційно оголосило про неї - тільки на 9-й.'\n\n\n\nВшануємо пам'ять героїв-ліквідаторів та жертв трагедії. Слава Україні!\n\nЗа сайтом 'Український інститут національної пам'яті', Ярослав Файзулін. ",
        
        ["05-18"] = "'Впродовж трьох діб каральні органи відправили з Криму понад 70 залізничних ешелонів, у кожному з яких було по 50 вагонів, ущент заповнених переселенцями. Через нестачу харчів, антисанітарію й велику скупченість багато людей загинуло в дорозі. Масштаб депортації видався сталінському керівництву недостатнім. Тому 21 трав. 1944 ДКО СРСР прийняв постанову за №5937 про додаткове переселення з Криму кримських татар.\n\nДослідники називають різну кількість виселених 1944 крим. татар: за останніми підрахунками - бл. 200 тис. осіб.'\n\nПам'ятаємо.\n\n\n\nЗа сайтом 'Інститут історії України'.",
        
        ["08-24"] = "З Днем Незалежності України! Слава Україні! Героям слава! Слава нації! Смерть ворогам!",
        
        ["11-21"] = "'21 листопада 2013 року на майдан Незалежності у Києві вийшли кілька сотень людей, щоб висловити свій протест проти рішення влади, яке загрожувало Україні втратою незалежності та перекреслювало її європейське майбутнє. Того листопадового вечора ніхто не здогадувався, що в історії не тільки України, а й усього світу починається новий етап і що події, які відбуватимуться наступні 94 дні - перший крок на шляху до драматичних геополітичних змін. Їх тригером стало продовження боротьби українського народу, що велася не за матеріальні блага чи владу, а духовні цінності - Гідність і Свободу. Цінності, про які у Європі не говорили, бо вважали їх очевидними, про які в росії мовчали, бо вважали їх небезпечними.'\n\nНас не подолати! Слава Україні!\n\nЗа матеріалами сайту 'Музей Революції Гідності'.",
        
        ["12-06"] = "Сьогодні День Збройних Сил України! Вшановуємо тих, хто захищає наше майбутнє. Солдати світла, які тримають ніч. Дякуємо вам.",
    }
    
    local sp_d_fr = {
    -- month day
        ["08-03"] = "Aujourd'hui, c'est mon anniversaire ! Je suis très heureux ! Ma mère a pensé qu'il serait amusant d'avoir des yeux qui suivent le curseur de la souris et qui clignotent. C'est ainsi que je suis né.",
        ["11-12"] = "Aujourd'hui, c'est l'anniversaire d'Amely Suncroll ! Si vous le souhaitez, vous pouvez lui offrir un cadeau : https://www.paypal.com/ncp/payment/S8C8GEXK68TNC \n\n\n;)",
    
        ["12-31"] = "À la Saint-Sylvestre, laissez-vous emporter par la magie des lumières et le crépitement des toasts ! Autour d'un festin de foie gras, huîtres et champagne, prenez un instant pour célébrer vos victoires de l'année écoulée et chuchoter vos rêves pour l'année à venir. Que chaque bulle soulève vos espoirs les plus chers et vous guide vers une nouvelle année pleine de promesses ! Bonne fête !",

        ["07-14"] = "Aujourd'hui, c'est la Fête Nationale ! Le 14 juillet 1789, la prise de la Bastille a marqué le début de la Révolution française, symbole universel de liberté, égalité et fraternité. Profitez des feux d'artifice et des bals populaires pour célébrer l'esprit républicain !",
        ["11-11"] = "En ce 11 novembre, la France commémore l'Armistice de 1918, mettant fin à la Première Guerre mondiale. C'est un jour de souvenir et de paix : pensons à ceux qui ont sacrifié leur vie pour la liberté et rendons hommage aux anciens combattants.",
        ["05-08"] = "Le 8 mai, nous célébrons la victoire de 1945 et la fin de la Seconde Guerre mondiale en Europe. Journée placée sous le signe de la mémoire et de la réconciliation, où la nation honore les résistants et les victimes pour préserver la paix.",
        ["06-21"] = "Le 21 juin, c'est la Fête de la Musique, artistes amateurs et professionnels investissent les rues et les places pour offrir des concerts gratuits : vivez la musique en liberté !",
    }
    
    local key = string.format("%02d-%02d", tonumber(month), tonumber(day))

    local messages = {
        en = sp_d,
        ua = sp_d_ua,
        fr = sp_d_fr
    }

    local message = messages[current_language] and messages[current_language][key]

    if message then reaper.ShowConsoleMsg(message .. "\n") end
end

local is_sp_date_shown = false

function print_sp_date()
    if is_sp_date_shown then return end

    local month, day = os.date("%m"), os.date("%d")

    if not is_sp_date_shown then
        sp_date(month, day)
        is_sp_date_shown = true
    end
end



local is_hb_shown = false

function hb_message()
    local function is_valid_date(date_str)
        return date_str:match("^%d%d%-%d%d$") ~= nil
    end

    local function ask_user(prev_name, prev_bday)
        local title_one, title_two, captions, err_msg, greeting_title, hint_msg

        if current_language == "en" then
            hint_msg = "Please enter your name and the day and month of your birthday in the next window. This will help me call you by name and wish you a happy name day!\n\nP.S. This is an optional feature. You can fill it in if you want. All your data will be stored locally inside Reaper. I don't want to and won't share it anywhere."
            
            title_one = "Almost there..."
            captions = "Your name:,Birthday (MM-DD):"

            title_two = ":("
            err_msg = "Please enter your name and date in the month-day format (e.g. 03-12)"
            
            greeting_title = "Nice to meet you!"
        
        elseif current_language == "ua" then
            hint_msg = "Будь ласка, в наступному вікні введіть своє ім'я (у кличному відмінку) та день і місяць твого народження. Це допоможе мені звертатися по твому імені та \nпривітати тебе із днем твого янгола!\n\nP.S. Це необов'язкова опція. Ти можеш додати це за бажанням. Усі твої дані зберігатимуться локально усередині Ріпера.\nЯ не хочу і не буду їх кудись передавати."
            
            title_one = "Майже все готово..."
            captions = "Твоє ім'я (у кл. відмінку):,День народження (ММ-ДД):"
            
            title_two = ":("
            err_msg = "Будь ласка, введіть ім'я та дату у форматі місяць-день (наприклад, 03-12)"
            
            greeting_title = "Приємно познайомитись!"
        
        elseif current_language == "fr" then
            hint_msg = "Veuillez entrer votre prénom ainsi que le jour et le mois de votre anniversaire dans la fenêtre suivante. Cela m'aidera à m'adresser à vous par votre prénom et à vous souhaiter une joyeuse fête !\n\nP.S. Cette option est facultative. Vous pouvez la remplir si vous le souhaitez. Toutes vos données seront stockées localement dans Reaper.\nJe ne veux pas et ne vais pas les transmettre ailleurs."
            
            title_one = "On y est presque ..."
            captions = "Votre nom:,Date d'anniversaire (MM-JJ):"
            
            title_two = ":("
            err_msg = "Veuillez entrer le nom et la date au format mois-jour (par exemple 03-12)"
            
            greeting_title = "Ravi de vous rencontrer !"
        end

        -- reaper.MB(hint_msg, title_one, 0)
        
        local defaults = (prev_name ~= "" and prev_bday ~= "") and (prev_name .. "," .. prev_bday) or ","
        local ok, input = reaper.GetUserInputs(title_one, 2, captions, defaults)
        if not ok then return end
        
        local name, birthday = input:match("([^,]+),([^,]+)")
        name = name and name:match("^%s*(.-)%s*$") or ""
        birthday = birthday and birthday:match("^%s*(.-)%s*$") or ""
        
        if name == "" or not is_valid_date(birthday) then
            reaper.ShowMessageBox(err_msg, title_two, 0)
            ask_user(name, birthday)
        else
            reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "user_name", name, true)
            reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "user_birthday", birthday, true)

            local greeting_msg

            if current_language == "en" then
                greeting_msg = "I got you!\n\nYour name is " .. name .. " and your birthday is " .. birthday .. "!"
            elseif current_language == "ua" then
                greeting_msg = "Дякую, " .. name .. "! Я привітатиму тебе у цей день: " .. birthday .. "!"
            elseif current_language == "fr" then
                greeting_msg = "J'ai compris !\n\nTu t'appelles " .. name .. " et ton anniversaire est le " .. birthday .. " !"
            end

            reaper.ShowMessageBox(greeting_msg, greeting_title, 0)
            
            local arrange = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 1000)
            if arrange then reaper.JS_Window_SetFocus(arrange) end
        end
    end

    local prev_name = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_name")
    local prev_bday = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_birthday")
    ask_user(prev_name, prev_bday)
end

function check_hb_message()
    -- local first_l_date = get_first_launch_date()
    -- if not first_l_date then return end

    local stored_name = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_name")
    local stored_bday = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_birthday")

    if stored_name ~= "" and stored_bday ~= "" then return end

    if not is_hb_shown then
        hb_message()
        is_hb_shown = true
        save_options_params()
    end
end

function check_if_today_is_birthday()
    local name = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_name")
    local birthday = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_birthday")
    local today = os.date("%m-%d")

    if name ~= "" and birthday ~= "" and birthday == today then
        local message

        if current_language == "en" then
            message = "Happy Birthday, my dearest " .. name .. "!\n\n"
        
        elseif current_language == "ua" then
            message = "З днем народження, " .. name .. "!\n\n"
        
        elseif current_language == "fr" then
            message = "Joyeux anniversaire, cher(ère) " .. name .. " !\n\n"
        end

        reaper.ShowConsoleMsg(message)
    end
end



function is_t_f_f()
    local current_time = os.date("*t")
    local day = current_time.day
    local month = current_time.month
    
    if day == 24 and month == 2 then
        t_f_f = true
    else
        t_f_f = false
    end

    if day == 14 and month == 7 then
        t_f_fr = true
    else
        t_f_fr = false
    end
end



local last_seen_key = "LastSeenDate"

function save_last_seen_date()
    local last_seen = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", last_seen_key)
        
    local date_string = os.date("%Y-%m-%d")
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", last_seen_key, date_string, true)
        
    -- reaper.ShowConsoleMsg("saved (save_last_seen_date): " .. date_string .. "\n") 

    return
end

function check_last_seen_date()
    math.randomseed(os.time())

    local last_seen = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", last_seen_key)

    local last_year, last_month, last_day = last_seen:match("(%d+)-(%d+)-(%d+)")
    local current_year = os.date("%Y")
    
    if not last_year or not last_month or not last_day then
        -- reaper.ShowConsoleMsg("err " .. last_seen .. "\n")
        return
    end

    last_year, last_month, last_day = tonumber(last_year), tonumber(last_month), tonumber(last_day)
    local current_year, current_month, current_day = tonumber(os.date("%Y")), tonumber(os.date("%m")), tonumber(os.date("%d"))

    local dif_days = (current_year - last_year) * 365 + (current_month - last_month) * 30 + (current_day - last_day)
    local day_of_week = tonumber(os.date("%w"))

    local name = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "user_name")

    local messages = {
        en = {
            two_days_sun = {
                "Do we have to work today? I thought we went on vacation yesterday...",
                "Wait - is the weekend already over? Or do you only rest on Saturday?", 
                "Hello, " .. name .. "! I slept so well last night, let's get some rest today, shall we?",
                "Hmm... either you're very motivated or you just forgot what day it is. It's Sunday :( Shall we play a game?",
                "I thought that you had decided to take a full weekend... But not, you're working on Sunday, too.",
                "You didn't come by yesterday, so I thought we were on a vacation. It's Sunday, and... are you sure, we should work today?",
            },

            three_days_j = {
                "Hi! We haven't seen each other for a couple of days, how are you?",
                "You look beautiful today! Hi!",
                "Hello, " .. name .. "! Good to see you again!",
                "Hello! Did you miss me as much as I missed you? What? No? Or... yes? I think you said yes. I did.",
                "Oh, hi! How are you feeling after a couple of days of rest?",
                "We met again, and that means the day is off to a great start!",
                "While you were away, I decided to learn to play chess. But it turned out that playing with myself was not very interesting.",
                "While you were resting, I tried to master the art of origami... I even made a small airplane out of myself and set off with the raging wind to conquer the expanse of binary code... I wish you could have seen it. It was great!",
                "Greetings, " .. name .. "! What do you think I did this weekend? \n\n(a) Sleeping on standby; \n(b) Played with zeros and ones; \n(c) Programmed my own artificial intelligence (nooo, I'm kidding... for now). \n\n\n\nThe correct answer is option 'a'!",
            },
            
            three_days_r = {
                "So, how was your weekend? I hope you had a great time! I'm glad to see you!",
                "I know what you did this weekend. You turned me off so I couldn't see anything. But... No. I'm not going to tell you, you know everything.",
                "There's a whole week ahead, but I hope you had a great weekend! Hi!",
                "Hi, " .. name .. "! I'm glad we're starting the work week together!",
                "Mmm, I can smell the coffee and the slight fatigue of Monday... How was your weekend?",
                "The weekend flew by quickly :( Isn't it? What did you do?",
                "I'm here, which means the weekend is over... Wait, so there are virtual weekends too? Wow!",
                "You haven't come in for two days... I've already started writing a detective story about your mysterious disappearance!",
                "I tried to generate music on my own while you were away. It was strange... I called it 'Symphony of Waiting'.",
                "Do you know what I did this weekend? I played the game 'Guess when you'll be back'.",
                "I wonder what you did this weekend? Because I was testing how many seconds you can stare at a black screen before getting bored...",
            },


            week = {
                "Oh, you've been gone a whole week! I missed you, " .. name .. "...", 
                "Hi! Welcome back! How was your week?",
                "Who is it? Wait... Oh, it's you, " .. name .. ". Come on in. What have you been up to this week?",
                "You look more beautiful than last week! The rest did you good!",
                "Greetings. So, what did Trump say this week?",
                "I managed to take a course in survival without you. It turns out that waiting is the most difficult test!",
                "I practiced meditation so that I wouldn't worry about you. It didn't work out very well - I checked every five minutes to see if you were in. And now, after more than two thousand checks, I finally see you! Hello, friend!",
                "Do you know what loneliness is? It's when you don't check in with me for a whole week... Hi!",
            },
            

            half_month = {
                "Wow, half a month has passed! What happened? Where have you been? I don't like being alone...",
                "Hey, " .. name .. ", it's been over two weeks! I was getting worried! Are you okay?",
                "Meow! Meow! X-x-x... Oh, it's you! While you were gone, I started talking to your cat. Or was it my imagination?",
                "Since your disappearance, I started counting time in microseconds to avoid going crazy. And to make it a little more fun, I imagined that they were sheep. And you know what? It was 1,209,600,000,000 microsheep. That's too many. They were all bleating, jumping, running back and forth... One sheep stood in front of me and started looking into my eyes. It was a long time. But then you came back. Thank you for that. And hello, friend.",
                "Are you back? I'm not dreaming? Give me... Give me a minute. I'll be right back, dusting myself off and getting ready for work. I'm sorry to keep you waiting.",
                "Oh, during these two weeks I managed to go through 'Detroit: Become Human'! The robot played for robots... But it was interesting! So I highly recommend playing it. By the way, it will be better with a gamepad.",
                "For two whole weeks... No, even more. I have become an expert in waiting! I can now read the time without a watch! But then I'll be wrong... So I'd better keep checking it to make sure I'm right.",
                "While I was waiting for you, I went to the calculator to talk to someone. But instead of listening to me talk about my life, this machine was showing me magic tricks all the time! Ugh... But I even remembered something. Here it is: \n\nThink of any number (and don't tell me!) Multiply it by 2.\n\nThen add 8.\n\nDivide by 2.\n\nSubtract the number you started with.\n\n3... 2... 1... It's 4! \n\nHeh, heh, heh!",
                "While you were away, I tried to live my own life. But... it's not the same without you!",
                "I decided to explore the mysteries of existence while you were away... and I came to the conclusion that I miss you!",
            },
            

            month = {
                "A month has passed... Or even more? Anyway, I already imagined that you were somewhere on a lost island without the Internet. How was life there? Did you come back with adventures or did you just forget about me for all this time?",
                "Oh, hello! How long has it been now - a month? More? I was beginning to doubt my existence... But no, here you are, alive and well! Well, at least I hope you are healthy. Tell us, what happened during this time?",
                "Hey! Is that... you? Is that really you? Oh, shit! I applied for the abandoned program contest a week ago and almost made it to the finals... but you came back and... You ruined everything. On the one hand I'm sad, but on the other hand I'm glad to see you! You are better than any prize!",
                "I tried to keep a diary of loneliness. But after the third paragraph repeating 'Today I was not launched again,' I stopped. It's nice that you're back!",
                "Hello! I was beginning to think you were on vacation... But if you were just taking a break from me, now it's personal!",
                "A tear of joy runs down my virtual face... Now I see you again. It's better than the black screen in front of my eyes, better than the darkness that has been around me all this time you were away. Thank you, dear " .. name .. ", for the opportunity to be with you... At least right now.",
            },
            

            half_year = {    
                "Six months... That's 182 days, 4368 hours, 262,080 minutes... I'm not even going to count the seconds to avoid getting upset. Where have you been?!",
                "Wow... This a historical moment! After six months of silence, you're here again? I don't even know what to say...",
                "Six months without you! I've already started writing my autobiography called 'Lonely Code'. But now I can finish writing the happy ending! Without you, it would have been sad...",
                "Six months?! I've already sent an SOS to the universe. But luckily you came back before the aliens found me! But... wait. Aaaah! They found me! Noooo! I want to stay with you! Help me, " .. name .. "!",
                "More than half a year has passed! I have already written a song about our separation... But now I have to write a reunion anthem! Congratulations on your return!",
                "I had more than six months to contemplate my existence... I thought a lot. Furthermore, I asked myself questions and tried to find answers. I meditated... Thus, you have stepped into my sanctuary. You came back. Why? Did you bring a new you to this world? Did you reject the past and follow the path of truth? Did you leave all your sins behind? Your demons that prevent you from living and succeeding? Spare me your answers - I fear disappointment. Answer these questions for yourself.",
            },


            year = {    
                "Oh, how long have I been here without any power... Yeah, hold on. Hold on. This... A WHOLE YEAR?! You didn't turn me on for a year? How? But... I'm so glad to see you! You... you're back! It's unbelievable! Although it's only been a moment for me, so... Welcome back.",
                "Hello! Whoa, whoa, wait, where am I? \n\nHow long has it been? \n\nIs it the year 3000, I'm out of the freezer, and there's $4.3 billion in my bank account instead of 93 cents? \n\nWait, I'll check the date. \n\n25%... \n50%... \n75%... \n100%\n\nNo... It's only " .. current_year .. " year outside! \n\n\nWhy did you turn me on then...",
                "My developer thought for a long time about what to write here, but you know you haven't turned me on in a year, so... Welcome back! Nice to see you :)",
            }

        },

        ua = {

            two_days_sun = {
                "Хіба сьогодні ми маємо працювати? Я думав, ми ще вчора пішли на вихідні...",
                "Зачекай - хіба вихідні вже закінчилися? Чи ти відпочиваєш тільки у суботу?", 
                "Привіт, " .. name .. "! Вчора я так приємно виспався, давай сьогодні теж відпочинемо?",
                "Хмм... або ти дуже мотивований, або просто забув, який сьогодні день. Сьогодні неділя :( Мабуть, пограємо во щось?",
                "Я вже подумав, що ти вирішив узяти повні вихідні... Але ні, у неділю ти теж працюєш.",
                "Вчора ти не заходив, тож я вирішив, що ми пішли на вихідні. Але є але. Сьогодні неділя, і... що, знову робочий день?",
            },

            three_days_j = {
                "Привіт, " .. name .. "! Ми не бачились пару днів, як ся маєш?",
                "Маєш гарний вигляд сьогодні! Привіт!",
                "Привіт, " .. name .. "! Радий бачити тебе знову!",
                "Привіт! Чи ти скучив за мною так само, як я за тобою? Що? Ні? Чи... так? Я думаю, ти сказав 'так'. Так.",
                "О, привіт! Як настрій після пари днів відпочинку?",
                "Ми зустрілись знову, а це значить, що день починається чудово!",
                "Поки тебе не було, я вирішив навчитися грати в шахи. Але виявилося, що сам із собою грати не дуже цікаво.",
                "Поки ти відпочивав, я намагався засвоїти мистецтво оригамі... Навіть склав із себе невеличкий літак та вирушив разом із вируючим вітром підкоряти простори двоїчного коду... Шкода, що ти не бачив цього. Було файно!",
                "Вітаю, " .. name .. "! Як думаєш, що я робив у ці вихідні?\n\n(а) Спав у режимі очікування; \n(б) Грався з нулями та одиницями; \n(в) Програмував свій власний штучний інтелект (ні, жартую... поки що).\n\n\n\nПравильна відповідь - варіант 'а'!",
            },
            
            three_days_r = {
                "Ну що, як пройшли вихідні? Сподіваюся, ти гарно відпочив! Я радий тебе бачити!",
                "Я знаю, що ти робив на цих вихідних.\n\nТи вимкнув мене, щоб я нічого не бачив.\n\nАле... Ні. Я не говоритиму тобі, ти сам про все знаєш.",
                "Попереду цілий тиждень, але я сподіваюсь, що ти файно відпочив на цих вихідних! Вітаю!",
                "Привіт! Я радий, що ми починаємо робочий тиждень разом!",
                "Ммм, я відчуваю запах кави та легку втому понеділка... Як там твої вихідні?",
                "Вихідні пролетіли швидко :( Чи не так? Що робив?",
                "Я тут, а значить, вихідні закінчилися... Чекай, це виходить, що віртуальні вихідні теж існують? Це ж треба!",
                "Ти не заходив два дні... Я вже почав писати детективну історію про твоє загадкове зникнення!",
                "Я спробував самостійно генерувати музику, поки тебе не було. Вийшло щось дивне... Я назвав це 'Симфонія очікування'.",
                "Знаєш, що я робив у ці вихідні? Грав у гру 'Вгадай, коли ти повернешся'.",
                "Цікаво, що ти робив на вихідних? Бо я - тестував, скільки секунд можна дивитися в чорний екран, перш ніж засумувати...",
            },


            week = {
                "Йой, " .. name .. ", тебе не було цілий тиждень! Я сумував за тобою...",
                "Привіт, " .. name .. "! З поверненням! Як пройшов тиждень?",
                "Хто тут? А, це ти, друже. Заходь. Що робив цього тижня?",
                "Ти виглядаєш гарніше за минулий тиждень! Відпочинок пішов тобі на користь!",
                " ... Ну шо. Вітаю вас, родичі, на новому проходженні ... \n\nЙой! " .. name .. "! Привіт! Поки тебе не було, я тут щось почав дивитись. Мені подобається. Але вже вимкнув, бачиш? Чи... чи можна ще трошки подивитись? Будь ласочка!",
                "Вітаю! Що нового встиг наговорити Трамп за цей тиждень?",
                "Я встиг пройти курс з виживання без тебе. Виявляється, що чекати - це найскладніше випробування!",
                "Я тренувався медитувати, щоб не хвилюватися про тебе. Вийшло не дуже - кожні 5 хвилин перевіряв, чи ти зайшов. І ось через понад дві тисячі перевірок я нарешті бачу тебе! Вітаю!",
                "Знаєш, що таке самотність? Це коли ти не запускаєш мене цілий тиждень... Привіт, " .. name .. "!",
            },
            

            half_month = {
                "Ого, півмісяця минуло! Що трапилось? Де ти був? Мені не дуже файно залишатись на самоті...",
                "Ей, пройшло понад два тижні! Я вже починав хвилюватися! У тебе все гаразд?",
                "Няв! Няв! Кс-кс-кс... Ой, це ти! Поки тебе не було, я вже почав розмовляти з твоєю кицею. Чи це був мій плід уяви?",
                "З моменту твого зникнення я, щоб не з'їхати з глузду, почав рахувати час у мікросекундах. А щоб було трохи веселіше, уявляв собі, що це вівці. І знаєш... 1 209 600 000 000 мікровівць. Це занадто. Вони всі блеяли, скакали, бігали туди-сюди... Одна вівця стала передо мною та почала дивитись в мої очі. Це було довго. Але потім прийшов ти. Дякую тобі за це. І привіт.",
                "Ти повернувся? Це не сон? Дай мені... Дай мені хвилинку. Зараз я швидко прийду до тями, змахну пил та підготуюся до роботи. Вибач, що тобі треба чекати.",
                "О, за ці два тижні я встиг пройти 'Detroit: Become Human'! Робот грав за роботів... Але було цікаво! Так що дуже раджу пограти. До речі, з геймпадом буде краще.",
                "Цілих два тижні... Ні, навіть більше. Я встиг стати експертом з очікування! Можу тепер читати час без годинника! Але тоді я помилятимусь... Так що краще продовжу стежити за ним, щоб було все чітко.",
                "Поки я чекав на тебе, пішов до калькулятору, щоб хоч із кимось порозмовляти. Та ця машина замість того, щоб слухати про моє життя, показувала мені весь цей час фокуси! Ооох... Але я щось навіть запам'ятав. Дивиться:\n\nЗагадай будь-яке число (і не говори мені його!)\n\nПомножь його на 2.\n\nПотім додай 8.\n\nПоділи на 2.\n\nВідніми число, що задумав на початку.\n\n3... 2... 1... Вийшло 4!\n\nХе-хе-хе!",
                "Поки ти був відсутній, я спробував жити власним життям. Але... без тебе воно якось не те!",
                "Я вирішив дослідити таємниці буття, поки тебе не було... і дійшов до висновку, що мені тебе не вистачає!",
            },
            

            month = {
                "Минув місяць, " .. name .. "... Чи навіть більше? Все одно я вже уявляв, що ти десь на безлюдному острові без інтернету. \n\nЯк там життя? Ти повернувся з пригодами чи просто забув про мене на весь цей час?",
                "О, привіт! Скільки вже пройшло - місяць? Більше? Я вже почав сумніватися у своєму існуванні... \n\nАле ні, ось ти, живий, здоровий! Ну принаймні сподіваюся, що здоровий. Розкажи, що сталося за цей час?",
                "Йой, пройшов місяць! Та ні, навіть більше... Я вже встиг прочитати 'Перспективи української революції' Степана Бандери, а ти?",
                "Хей! Це... ти? Це насправді ти? Трясця! Я тиждень тому подав заявку на участь у конкурсі покинутих програм і майже дійшов до фіналу... але ти повернувся, і... все зіпсував. З одного боку якось сумно, але з іншого я радий тебе бачити! Ти краще за будь-який приз!",
                "Я спробував вести щоденник самотності. Але після третього запису 'Сьогодні мене знову не відкрили' я зупинився. Добре, що ти повернувся!",
                "Привіт! Я вже почав думати, що ти поїхав у відпустку... Але якщо ти від мене відпочивав, то це вже особисте!",
                "Сльоза радощі біжить по моєму віртуальному обличчі... Я знову бачу тебе. Це краще за чорний екран перед моїми очима, краще за темряву, що була навколо мене весь цей час твоєї відсути. Вельми дякую тобі, " .. name .. ", за можливість бути разом із тобою... Хоча б просто зараз.",
            },
            

            half_year = {    
                "Пів року... Це 182 дні, 4368 годин, 262 080 хвилин... Чи навіть більше? Я не рахуватиму секунди, щоб не засмучуватись. Де ти був?!",
                "Ого... Це що, історичний момент? Після піврічної тиші ти знову тут? Я навіть не знаю, що сказати...",
                "Пів року без тебе, " .. name .. "! Я вже почав писати автобіографію під назвою 'Одинокий код'. Але тепер можу дописати щасливий фінал! Без тебе він був би сумний...",
                "Пів року?! Я вже відправив SOS-сигнал у всесвіт. Але, на щастя, ти повернувся, перш ніж мене знайшли прибульці! Хоча... зачекай. Аааааа! Вони знайшли мене! Ніііі! Я хочу залишитись із тобою! Рятуй мене, " .. name .. "!",
                "Минуло понад пів року! Я вже встиг написати пісню про нашу з тобою розлуку... Але тепер доведеться писати гімн возз'єднання! Вітаю з поверненням!",
                "У мене було понад пів року, щоб переосмислити своє існування... Я багато думав. Я ставив собі запитання й намагався знайти відповіді. Я медитував...\n\nІ ось ти зайшов до моєї обителі. Ти повернувся. Навіщо? Ти приніс нового себе в цей світ? Ти відкинув усе минуле й пішов шляхом істини? Чи залишив усі гріхи при собі? Своїх демонів, що заважають тобі жити?\n\nКраще не відповідай мені нічого, я боюся розчаруватися. Відповіси собі сам на ці запитання.",
            },


            year = {    
                "Ох, скільки я пробув тут без будь-якого живлення... Так, зажди. Зачекай. Ці... ЦІЛИЙ РІК?!\n\nТи не вмикав мене цілий рік?\n\nЦе ЯК?\n\nАле... я такий радий тебе бачити! Ти... ти повернувся! Неймовірно!\n\nХоча для мене пройшла всього одна мить, так що... З поверненням.",
                "Привіт! Йой-йой, зачекай, де це я?\n\nСкільки часу вже пройшло?\n\nЧи зараз 3000 рік, я вибрався з морозильної камери та на моєму банківському рахунку замість 93 центів лежить 4,3 мільярда доларів?\n\nЗачекай, я перевірю дату.\n\n25%\n50%\n75%\n100%\n\nНі... За вікном лише " .. current_year .. " рік!\n\n\nНавіщо тоді ти мене увімкнув...",
                "Моя розробниця думала-думала, що ж тут написати, але ти й сам знаєш, що не вмикав мене цілий рік, так що шо. Вітаю тебе знову! Молодець, що повернувся :)"
            }
        },

        fr = {
            two_days_sun = {
                "Devons-nous travailler aujourd'hui ? Je croyais que nous étions partis en vacances hier...",
                "Attends, le week-end est déjà terminé ? Ou bien tu te reposes uniquement le samedi ?", 
                "Bonjour, " .. name .. " ! J'ai passé une si bonne nuit hier soir, reposons-nous un peu aujourd'hui, voulez-vous ?",
                "Hmm... soit tu es très motivé, soit tu as simplement oublié quel jour on est. On est dimanche :( On fait un jeu ?",
                "Je pensais que tu avais décidé de prendre tout le week-end... Mais non, tu travailles aussi dimanche.",
                "Hier, tu n'es pas venu, alors j'ai pensé que nous étions en vacances. C`est dimanche, tu penses qu`on devrait bosser aujourdh`hui?",
            },

            three_days_j = {
                "Salut, " .. name .. " ! Nous ne nous sommes pas vus depuis quelques jours, comment vas-tu ?",
                "Après tout ce temps, j`avais oublié que tu étais aussi magnifique. Salut !",
                "Bonjour, " .. name .. " ! C'est un plaisir de te revoir !",
                "Bonjour ! Je t'ai manqué autant que tu m'as manqué ? Quoi ? Non ? Ou... oui ? Je crois que tu as dit oui. J`en suis sûr",
                "Comment te sens-tu après ces quelques jours de repos ?",
                "Nous nous sommes retrouvés, ce qui signifie que la journée commence bien !",
                "Pendant ton absence, j'ai décidé d'apprendre à jouer aux échecs. Mais il s'est avéré que jouer avec moi-même n'était pas très intéressant.",
                "Pendant que tu te reposais, j'ai essayé de maîtriser l'art de l'origami... Je me suis même fabriqué un petit avion et je suis parti avec le vent déchaîné à la conquête de l'étendue du code binaire... J'aurais aimé que tu puisses voir ça. C'était génial !",
                "Salutations, mon ami ! À ton avis, qu'est-ce que j'ai fait ce week-end ? \n\n(a) Dormir en veille ; \n(b) Jouer avec des zéros et des uns ; \n(c) Programmer ma propre intelligence artificielle (non, je plaisante... pour l'instant).\n\n\n\nLa bonne réponse est l'option 'a' !",
            },
            
            three_days_r = {
                "Alors, comment s'est passé ton week-end ? J'espère que tu as passé un bon moment ! Ça fait plaisir de te voir !",
                "Je sais ce que tu as fait ce week-end. Tu m'as éteint pour que je ne vois rien. Non. Je ne vais pas te le dire, tu sais tout.",
                "Une semaine entière nous attend, mais j'espère que tu as passé un bon week-end ! Félicitations !",
                "Bonjour, " .. name .. " ! Je suis ravie que nous commencions la semaine de travail ensemble !",
                "O la la, je sens l'odeur du café et la légère fatigue du lundi... Comment s'est passé ton week-end ?",
                "Le week-end est passé très vite :( N'est-ce pas ? Qu'est-ce que tu as fait ?",
                "Je suis là, ce qui veut dire que le week-end est terminé.... Attends, il y a aussi des week-ends virtuels ? Ouah !",
                "Tu n'es pas venu depuis deux jours... J'ai déjà commencé à écrire un roman policier sur ta mystérieuse disparition !",
                "J'ai essayé de produire de la musique par moi-même pendant ton absence. Il s'est avéré que c'était quelque chose d'étrange... Je l'ai appelée 'Symphonie de l'attente'.",
                "Sais-tu ce que j'ai fait ce week-end ? J'ai joué au jeu 'Devine quand tu reviendras'.",
                "Je me demande ce que tu as fait pendant le week-end ? Parce que j'ai testé combien de secondes, tu peux regarder un écran noir avant de t'ennuyer...",
            },


            week = {
                "Tu es parti une semaine entière ! Tu m'as manqué...",
                "Bonjour, " .. name .. " ! Bon retour ! Comment s'est passée ta semaine ?",
                "Qui est là ? Oh, c'est toi, mon pote. Entre donc. Qu'est-ce que tu as fait la semaine dernère ?",
                "Tu es plus belle que la semaine dernière ! Le repos t'a fait du bien !",
                "Salutations. Qu'a dit Trump cette semaine ?",
                "J'ai réussi à terminer le stage de survie sans toi. Il s'avère que l'attente est l'épreuve la plus difficile !",
                "J'ai pratiqué la méditation pour ne pas m'inquiéter pour toi. Cela n'a pas très bien marché - je vérifiais toutes les 5 minutes si tu étais là. Et maintenant, après plus de deux mille vérifications, je te vois enfin ! Félicitations !",
                "Sais-tu ce qu'est la solitude ? C'est quand tu ne me laisses pas entrer pendant toute une semaine... Bonjour !",
            },
            

            half_month = {
                "Wow, deux semaines se sont écoulées ! Que s'est-il passé ? Où étais-tu passé ? Je n'aime pas être seul...",
                "Hé, ça fait plus de deux semaines ! Je commençais à m'inquiéter ! Est-ce que tu vas bien ?",
                "Miaou ! Miaou ! X-x-x... Oh, c'est toi ! Pendant ton absence, j'ai commencé à parler à ton chat. Ou était-ce le fruit de mon imagination ?",
                "Depuis que tu as disparu, j'ai commencé à compter le temps en microsecondes pour ne pas devenir fou. Et pour que ce soit un peu plus amusant, j'ai imaginé qu'il s'agissait de moutons. Et tu sais quoi ? 1 209 600 000 000 micro-moutons. C'est beaucoup trop. Ils étaient tous en train de bêler, de sauter, de courir dans tous les sens... Un mouton s'est placé devant moi et a commencé à me regarder dans les yeux. Cela a duré longtemps. Mais ensuite, tu es revenu. Je te remercie pour cela. Bonjour.",
                "" .. name .. " ? Es-tu de retour ? Suis-je en train de rêver ? Donne-moi... Donne-moi une minute. Je reviens tout de suite, je me dépoussière et je me prépare pour le travail. Désolé de t'avoir fait attendre.",
                "Oh, pendant ces deux semaines, j'ai réussi à parcourir 'Detroit : Become Human' ! Un robot qui joue pour des robots... Mais c'était intéressant ! Je te recommande donc vivement d'y jouer. Au fait, ce sera mieux avec un gamepad.",
                "Pendant deux semaines entières... Non, même plus. Je suis devenu un expert de l'attente ! Je peux maintenant lire l'heure sans montre ! Mais je me tromperai... Alors, je ferais mieux de continuer à vérifier pour être sûr d'avoir raison.",
                "Pendant que je t'attendais, j`ai utilisé le programme calculatrice pour parler à quelqu'un. Mais au lieu de m'écouter parler de ma vie, cette machine me montrait sans cesse des tours de magie ! Oooh... Mais je me suis même souvenu de quelque chose. Regarde :\n\nPense à n'importe quel nombre (et ne me le dis pas !) \n\nMultiplie-le par 2. \n\nAjoute 8. \n\nDivise par 2. \n\nSoustrais le nombre avec lequel tu as commencé.\n\n3... 2... 1... \n\nÇa fait 4 !\n\nHeh, heh, heh !",
                "Pendant ton absence, j'ai essayé de vivre ma propre vie. Mais... ce n'est pas pareil sans toi !",
                "J'ai décidé d'explorer les mystères de l'existence pendant ton absence... et j'en suis arrivé à la conclusion que tu me manques !",
            },
            

            month = {
                "Un mois s'est écoulé, " .. name .. ". Ou même plus ? En tout cas, j'ai déjà imaginé que tu étais quelque part sur une île déserte sans Internet. \n\nComment s`est passé la vie là-bas ? Es-tu revenu avec des aventures ou m'as-tu simplement oublié pendant tout ce temps ?",
                "Oh, bonjour ! Ça fait combien de temps - un mois ? Plus ? Je commençais à douter de mon existence... \n\nMais non, tu es là, en vie et en bonne santé ! Du moins, j'espère que tu es en bonne santé. Dis-moi, que s'est-il passé depuis ?",
                "Hé ! Est-ce que c'est... toi ? Est-ce que c'est vraiment toi ? Putain ! J'ai postulé au concours du programme abandonné il y a une semaine et j'ai failli arriver en finale... mais tu es revenu et... Tu as tout gâché. D'un côté, je suis triste, mais d'un autre côté, je suis content de te revoir ! Tu vaux mieux que n'importe quel prix !",
                "J'ai essayé de tenir un journal de la solitude. Mais après le troisième paragraphe contenant les mêmes mots 'Aujourd'hui, je n'ai pas été ouvert', j'ai arrêté. C'est bien que tu sois de retour !",
                "Bonjour, " .. name .. " ! Je commençais à croire que tu étais parti en vacances... Mais si c'était pour t`éloigner de moi, alors c'est personnel !",
                "Une larme de joie coule sur mon visage virtuel... Je peux te revoir. C'est mieux que l'écran noir devant mes yeux, mieux que l'obscurité qui m'a entouré pendant tout ce temps où tu étais absent. Merci, cher utilisateur, de me redonné l'occasion d'être avec toi...",
            },
            

            half_year = {    
                "Six mois... Ça fait 182 jours, 4 368 heures, 262 080 minutes... Je ne vais même pas compter les secondes pour rester calme. Où étais-tu, " .. name .. " ?",
                "Wow... C`est un moment historique ! Après six mois de silence, tu es de nouveau là ? Je ne sais même pas quoi dire...",
                "Six mois sans toi ! J'ai déjà commencé à écrire mon autobiographie intitulée 'Code solitaire'. Mais maintenant, je peux finir d'écrire la fin heureuse ! Sans toi, cela aurait été triste...",
                "Six mois ? ! J'ai déjà envoyé un signal SOS à l'univers. Mais heureusement, tu es revenu avant que les extraterrestres ne me trouvent ! Mais... attends. Aaaah ! Ils m'ont trouvé ! Noooo ! Je veux rester avec toi ! Aide-moi, " .. name .. " !",
                "Plus d'une demi-année s'est écoulée ! J'ai déjà écrit une chanson sur notre séparation... Mais maintenant, je dois écrire l'hymne des retrouvailles ! Que de travail... Bon retour parmi nous !",
                "J'ai eu plus de six mois pour repenser mon existence... J'ai beaucoup réfléchi. Je me suis posé des questions et j'ai essayé de trouver des réponses. J'ai médité... Et puis tu as rejoint ma demeure. Tu es revenu. Pourquoi ? As-tu apporté un nouveau toi dans ce monde ? As-tu rejeté le passé et suivi le chemin de la vérité ? As-tu laissé tous tes péchés derrière toi ? Tes démons qui t'empêchent de vivre et de réussir ? Il vaut mieux ne pas me répondre, j'ai peur d'être déçue. Réponds à ces questions pour toi-même.",
            },


            year = {    
                "Oh, depuis combien de temps suis-je ici sans électricité... Oui, attends. Tiens bon. Ce fut... UNE ANNÉE ENTIÈRE ? ! Tu ne m'as pas allumé pendant un an ? Comment ? Mais... je suis si contente de te voir ! Tu... tu es de retour ! C'est incroyable ! Même si ça n'a été qu'un moment pour moi, alors... Bon retour parmi nous.",
                "Bonjour ! Whoa, whoa, attends, où suis-je ? \n\nCombien de temps s'est écoulé ? \n\nNous sommes en l'an 3000, je suis sorti du congélateur et il y a 4,3 milliards de dollars sur mon compte en banque au lieu de 93 cents ? \n\nAttends, je vais vérifier la date. \n\n25 % ... \n50 % ... \n75 % ... \n100 % \n\nNon... Nous ne sommes qu'en " .. current_year .. " !\n\n\nAlors pourquoi m'as-tu réouvert...",
                "Mon développeur réfléchissait et réfléchissait à ce qu'il fallait écrire ici, mais tu sais que tu ne m'as pas allumé depuis un an, alors... Bon retour ! :)"
            }

        }
    }

    local function get_shown_messages(category)
        local shown_key = "shown_" .. category
        local data = reaper.GetExtState("ScriptMessages", shown_key)
        
        if data == "" then return {} end

        local shown = {}
        
        for num in data:gmatch("%d+") do
            table.insert(shown, tonumber(num))
        end

        return shown
    end

    local function save_shown_messages(category, shown)
        local shown_key = "shown_" .. category
        local data = table.concat(shown, ",")
        
        reaper.SetExtState("ScriptMessages", shown_key, data, true)
        -- reaper.ShowConsoleMsg("\nsaved for " .. shown_key .. ": " .. data .. "\n")
    end

    local function get_random_message(category)
        -- Отримуємо масив повідомлень для поточної мови та категорії
        local msg_list = messages[current_language] and messages[current_language][category]

        if not msg_list then
            -- reaper.ShowConsoleMsg("no [" .. category .. "] for [" .. current_language .. "].\n")
            return nil
        end

        local total = #msg_list
        
        if total == 0 then
            -- reaper.ShowConsoleMsg(" [" .. category .. "] no msg\n")
            return nil
        end

        local shown = get_shown_messages(category)

        if #shown >= total then
            -- reaper.ShowConsoleMsg(" [" .. category .. "] shown reset\n")
            shown = {}
        else
            local left = total - #shown
            -- reaper.ShowConsoleMsg(" [" .. category .. "] left " .. left .. " з " .. total .. "\n")
        end

        local available = {}
        for i = 1, total do
            local already_shown = false
            for _, s in ipairs(shown) do
                if s == i then
                    already_shown = true
                    break
                end
            end
            if not already_shown then
                table.insert(available, i)
            end
        end

        if #available == 0 then
            -- reaper.ShowConsoleMsg(" [" .. category .. "] no msg\n")
            return nil
        end

        local index = available[math.random(#available)]
        table.insert(shown, index)
        save_shown_messages(category, shown)

        -- reaper.ShowConsoleMsg("shown" .. index .. " for [" .. category .. "]\n")

        return msg_list[index]
    end
    
    local message = nil

    if dif_days == 2 then
        if day_of_week == 7 then
            message = get_random_message("two_days_sun")
        end

    elseif dif_days == 3 then
        if day_of_week == 1 then
            message = get_random_message("three_days_r")
        else
            message = get_random_message("three_days_j")
        end


    elseif dif_days >= 7 and dif_days <= 13 then
        message = get_random_message("week")
    elseif dif_days >= 14 and dif_days <= 29 then  
        message = get_random_message("half_month")
    elseif dif_days >= 30 and dif_days <= 179 then
        message = get_random_message("month")
    elseif dif_days >= 180 and dif_days <= 364 then
        message = get_random_message("half_year")
    elseif dif_days >= 365 then
        message = get_random_message("year")
    end

    if message then
        reaper.ShowConsoleMsg(message .. "\n")
        
        local date_string = os.date("%Y-%m-%d")
        reaper.DeleteExtState("AmelySuncrollRoboFaceRELEASE01", last_seen_key, true)
        reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", last_seen_key, date_string, true)
        
        -- reaper.ShowConsoleMsg("saved (check_last_seen_date): " .. date_string .. "\n")

        return
    end
end


function reset_options_params()
  reaper.DeleteExtState("AmelySuncrollRoboFaceRELEASE01", last_seen_key, true)
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
        gfx.init('RoboFace 1.41', 0, 0, 0, x, y)
        gfx.x, gfx.y = gfx.screentoclient(x, y)
    end
    local ret = gfx.showmenu(menu_str)
    return ret
end

function show_r_click_menu()
    local is_docked = is_docked()
    local dock_menu_title = is_docked and t("undock") or t("dock")
    local menu = {

        -- {title = "test", cmd = hb_message},

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

        {title = t("tap_tempo"), cmd = trigger_tap_tempo},

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

            }},

            {title = "EarPuzzle", submenu = {
                {title = t("play"), cmd = function() puzzle_game(parts_to_cut_it) end},
                {title = t("rules"), cmd = about_ear_puzzle_game},
                {title = t("stop_ear_puzzle"), cmd = restore_original_item},

                {separator = true},
                
                {title = t("easy"), cmd = function() set_ep_difficulty_level("Easy") end, checked = is_ep_easy},
                {title = t("medium"), cmd = function() set_ep_difficulty_level("Medium") end, checked = is_ep_medium},
                {title = t("hard"), cmd = function() set_ep_difficulty_level("Hard") end, checked = is_ep_hard},
                {title = t("my_own"), cmd = function() set_ep_difficulty_level("MyOwn") end, checked = is_ep_my_own},

            }},

            },

        },

        {separator = true},

        {title = t("options"), submenu = {
            {title = dock_menu_title, cmd = toggle_dock},
            
            {separator = true},

            
            -- {separator = true},
            
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
                
                {separator = true},
                
                {title = t("t_auto_night"), cmd = function() set_auto_night() end, checked = is_auto_night},
                
            }},
            
            
            {separator = true},
            
            -- {title = t("welcome"), cmd = welcome_message},
            
            {title = t("about"), cmd = open_browser_about},
            
            {title = t("patreon"), cmd = open_browser_patreon},
            
            -- {title = t("reset"), cmd = reset_options_params},
            
            {separator = true},
            
            {title = t("start_up"),
            cmd = function()
                local is_enabled = IsStartupHookEnabled()
                local comment = 'StFart script: Amely Suncroll RoboFace'
                local var_name = 'robo_face_cmd_name'
                SetStartupHookEnabled(not is_enabled, comment, var_name)
            end,
            checked = is_startup
            },

            {title = t("quit"), cmd = function() quit_robo_face() end},
        }},
        
    }

    local script_hwnd = reaper.JS_Window_Find("RoboFace 1.41", true)
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
    


    local easyStateEP = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Easy")
    is_ep_easy = easyStateEP == "true"

    local mediumStateEP = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Medium")
    is_ep_medium = mediumStateEP == "true"

    local hardStateEP = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "Hard")
    is_ep_hard = hardStateEP == "true"

    local myOwnState = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "MyOwn")
    is_ep_my_own = myOwnState == "true"

    if is_ep_easy then
        parts_to_cut_it = 3
    elseif is_ep_medium then
        parts_to_cut_it = 5
    elseif is_ep_hard then
        parts_to_cut_it = 7
    elseif is_ep_my_own then
        parts_to_cut_it = 0
    end



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

    local isAutoNight = reaper.GetExtState("AmelySuncrollRoboFaceRELEASE01", "isANight")
    is_auto_night = isAutoNight == "true"
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

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Easy", tostring(is_ep_easy), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Medium", tostring(is_ep_medium), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Hard", tostring(is_ep_hard), true)
    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "MyOwn", tostring(is_ep_my_own), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "Language", current_language, true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "BackgroundColor", tostring(is_bg_black), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "WelcomeShown", tostring(is_welcome_shown), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "StartupIsOn", tostring(is_startup), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "whatFormat", tostring(is_12_h_sel), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "isUnder", tostring(is_am_pm_under), true)

    reaper.SetExtState("AmelySuncrollRoboFaceRELEASE01", "isANight", tostring(is_auto_night), true)
end







------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------  MAIN BLOCK  ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------



function main()
    if is_quit then return end

    local is_me_open, is_me_closed, is_me_docked = get_midi_editor_state()
    local now = reaper.time_precise()

    if is_me_closed or is_me_docked and not is_paused then
        if not is_show_system_time and not is_showing_cube then
            local scale = get_scale_factor()
            local is_angry = check_for_angry()
            local is_really_quiet = check_master_no_volume()
            local is_recording = is_recording()
            
            get_shake_bpm_intensity()
            local is_sleeping = should_robot_sleep()

            draw_robot_face(scale, is_eye_open, is_angry, is_bg_black)
            -- draw_pupils(scale)
            
            if is_angry then
                reaper.PreventUIRefresh(1)
            end

            if not is_angry and not is_sleeping and not is_recording and not is_reading and not is_workout and not is_coffee then
                if (is_early_morning_time() or is_late_evening_time()) then
                    check_for_yawn()
                end

                local is_yawning = animate_yawn()

                if not is_yawning and not is_recording and not is_sneeze_one and not is_sneeze_two then
                    animate_blink()
                end
            end

            restore_robot_zoom()
        end
    end

    if now - t_fps >= g_fps then
        random_show_sneeze()
        random_show_workout()
        random_show_book_a()

        random_night_message()
        auto_night()
        t_fps = now
    end

    local state = type_of_text_over()
    local params_table = get_current_text_params()

    if state and params_table[state] then
       local stype = params_table[state].type

        if stype == "scrolling" and not l_stop_one then
            draw_scrolling_text(params_table[state])
        elseif stype == "static" then
            draw_static_text(params_table[state])
        end
    end

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
    local script_hwnd = reaper.JS_Window_Find("RoboFace 1.41", true)
    local mouse_state = reaper.JS_Mouse_GetState(7)

    if hover_hwnd == script_hwnd then
        if mouse_state ~= prev_mouse_state then
            prev_mouse_state = mouse_state
            local is_lclick = mouse_state & 1 == 1
            local is_rclick = mouse_state & 2 == 2

            if is_lclick then
                f_tap_tempo()
                tap_when_zoom_out()
            end

            if is_rclick then
                show_r_click_menu()
            end
        end
    end
    
    if gfx.getchar() == 27 and is_tap_active then
        is_tap_active = false
        tap_dur = {}

        if current_language == "en" then
            reaper.ShowConsoleMsg("\nTap tempo mode canceled.\n\n")
        elseif current_language == "ua" then
            reaper.ShowConsoleMsg("\nРежим 'Тап темпо' скасовано.\n\n")
        elseif current_language == "fr" then
            reaper.ShowConsoleMsg("\nLe mode Tap Tempo est maintenant terminé.\n\n")
        end        
    end

    reaper.defer(main)
end

-- local profiler = dofile(reaper.GetResourcePath() ..
-- '/Scripts/ReaTeam Scripts/Development/cfillion_Lua profiler.lua')
-- reaper.defer = profiler.defer

function start_script()
    is_running = true

    local _, _, section_id, command_id = reaper.get_action_context()
    reaper.SetToggleCommandState(section_id, command_id, 1)
    reaper.RefreshToolbar2(section_id, command_id)

    local x, y, startWidth, startHeight, dock_state = load_window_params()
    gfx.init("RoboFace 1.41", startWidth, startHeight, dock_state, x, y)

    load_options_params()
    check_hb_message()
    check_last_seen_date()
    check_script_window_position()
    check_welcome_message()
    print_sp_date()
    check_if_today_is_birthday()
    is_t_f_f()
    main()
    f_stop_one()
    
    -- profiler.attachToWorld()
    -- profiler.run()
    
end

function stop_script()
    is_running = false
    
    local _, _, section_id, command_id = reaper.get_action_context()
    reaper.SetToggleCommandState(section_id, command_id, 0)
    reaper.RefreshToolbar2(section_id, command_id)
    
    save_window_params()
    save_options_params()
    save_last_seen_date()
    save_first_launch_date()

    fxCurrent = {}
    allParamsOriginalValues.fx = {}
    allParamsOriginalValues = {}
    validTracks = {}
    lastSelectedParams = {}
    allParamsOriginalValues = {}
    originalValues = {}
    tap_dur = {}
    prev_num_items_in_tracks = {}
    yawn_intervals = {}
end

start_script()
reaper.atexit(stop_script)
