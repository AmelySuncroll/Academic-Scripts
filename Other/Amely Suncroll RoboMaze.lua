-- @description RoboMaze
-- @author Amely Suncroll
-- @version 0.9
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @

-- @about Your little game inside Reaper

-- @donation https://www.paypal.com/ncp/payment/S8C8GEXK68TNC

-- @website https://www.patreon.com/c/AmelySuncroll

-- font website https://nalgames.com/fonts/iregula

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

local game_state = "menu"  -- or "playing" or "finished"
-- local game_state = "playing"  -- or "playing" or "finished"



local vertical_walls = {}
local horizontal_walls = {}

local special_fields = {}
local teleport_fields = {}
local level_fields = {}
local checkpoint_fields = {}


local grid_size = 100
local visible_grid_size = 0  


local player_x = 1
local player_y = 1

local player_speak = nil
local speak_timer = 0
local speak_duration = 0.8
local speak_font_size = 0.6 


local prev_player_x = player_x
local prev_player_y = player_y

local start_x = 0
local start_y = 0

local finish_x = 0
local finish_y = 0

local checkpoint_x = nil
local checkpoint_y = nil


local current_level = 1
local h_m_levels_is = 23


local move_dx = 0
local move_dy = 0
local is_moving = false

local total_steps = 0



local player_alpha = 1.0       
local is_fading = false        
local fade_direction = "out"   
local fade_speed = 0.021        
local is_teleporting = false
local teleport_destination = nil
local is_finishing = false


local i_found_key = 0

local lock_timer = 0
local lock_delay = 0.8
local is_unlocking = false
local current_lock = nil

local level_start_time = 0
local level_end_time = 0
local last_timer_check = 0
local last_player_move_time = 0

local flashlight_size = 0







local is_us_lang = is_us_lang == 'true' and true or false

if is_us_lang == false then
    is_us_lang = true
end

local current_language = "en"

local translations = {
    en = {
        time = "Show time",
        robomaze_game = "Robomaze Game",
        press_enter_to_start_new_game = "N  -  new game",
        press_c_to_continue = "ENTER  -  continue",
        press_l_to_select_level = "L  -  select level",
        open_settings = "S  -  settings"
    },
    ua = {
        time = "Час",
        robomaze_game = "Robomaze",
        press_enter_to_start_new_game = "Enter - нова гра",
        press_c_to_continue = "C - продовжити",
        press_l_to_select_level = "L - обрати рівень",
        open_settings = "S - налаштування"
    }
}

function t(key)
    return translations[current_language][key]
end

function change_language(lang)
    current_language = lang
    ShowChordBoxMenu()
    save_maze_settings()
end








local maze_difficulty_is = ''
local total_heart = 0

if maze_difficulty_is == "easy" then
    total_heart = 1000
elseif maze_difficulty_is == "medium" then
    total_heart = 10
elseif maze_difficulty_is == "hard" then
    total_heart = 3
elseif maze_difficulty_is == "impo" then
    total_heart = 1
end

local i_found_heart = total_heart



local last_console_x = nil
local last_console_y = nil

function update_player_console_position()
    if last_console_x ~= player_x or last_console_y ~= player_y then
        
        local coord = index_to_coord(player_x, player_y)

        last_console_x = player_x
        last_console_y = player_y
        last_player_move_time = reaper.time_precise()
        return true  
    end
    return false
end

function is_robo_face_open()
    local hwnd = reaper.JS_Window_Find("RoboFace", true)
    return hwnd ~= nil
end





-------------------------------------------------------------------------------------------------------------------------------- LEVELS
local levels = {

    { 
        number = 1,
        setup = function() -- 1
            visible_grid_size = 8

            start_x = 2
            start_y = 3

            player_x = 2
            player_y = 3

            finish_x = 7
            finish_y = 3

            add_w("b3", "d")
            add_w("b3", "l")
            add_w("b3", "u")
            
            add_w("d3", "u")
            add_w("d3", "r")
            add_w("e3", "u")
            
            add_w("d5", "l")
            add_w("d5", "d")
            
            add_w("e5", "d")
            add_w("e5", "r")
            
            add_w("g3", "d")
            add_w("g3", "r")
            add_w("g3", "u")

        end
    },

    { 
        number = 2,
        setup = function() -- 2 
            visible_grid_size = 10
            
            start_x = 4
            start_y = 2
            
            player_x = 4
            player_y = 2
            
            finish_x = 2
            finish_y = 7
            
            add_w("b2", "d")
            add_w("b2", "l")
            add_w("b2", "u")
            add_w("g2", "r")
            add_w("g6", "d")
            add_w("d6", "l")
            add_w("d3", "u")
            add_w("i8", "r")
            add_w("i3", "r")
            add_w("d8", "d")
            add_w("i7", "d")
            add_w("b7", "d")
            add_w("b7", "l")
            add_w("b7", "u")
        end
    },

    { 
        number = 3,
        setup = function() -- 3
            visible_grid_size = 11

            start_x = 2
            start_y = 5

            player_x = 2
            player_y = 5

            finish_x = 9
            finish_y = 9
            
            add_w("b5", "l")
            add_w("b5", "u")
            add_w("b5", "d")
            add_w("d6", "u")
            add_w("d6", "l")
            add_w("e4", "u")
            add_w("e4", "l")
            add_w("f4", "r")
            add_w("g5", "u")
            add_w("g5", "r")
            add_w("g3", "l")
            add_w("g3", "u")
            add_w("h2", "l")
            add_w("h2", "u")
            add_w("i2", "u")
            add_w("i2", "r")
            add_w("i3", "r")
            add_w("i4", "r")
            add_w("h4", "u")
            add_w("h4", "r")
            add_w("j6", "u")
            add_w("j6", "r")
            add_w("j7", "r")
            add_w("j8", "r")
            add_w("j9", "r")
            add_w("j9", "d")
            add_w("j8", "u")
            add_w("i9", "d")
            add_w("h9", "d")
            add_w("g9", "d")
            add_w("g9", "l")
            add_w("i9", "l")
            add_w("i8", "d")
            add_w("i8", "l")
            add_w("g7", "d")
            add_w("g7", "l")
            add_w("f8", "d")
            add_w("f8", "l")
            add_w("f8", "d")
            add_w("f10", "r")
            add_w("f10", "d")
            add_w("f10", "d")
            add_w("e10", "l")
            add_w("d9", "d")
            add_w("d9", "l")

            add_s_f("h2", show_tip("!", true), nil, "tip")
            add_s_f("g9", show_tip("!", true), nil, "tip")
            
            
        end
    },

    { 
        number = 4,
        setup = function() -- 4
            visible_grid_size = 10

            start_x = 1
            start_y = 6

            player_x = 1
            player_y = 6

            finish_x = 10
            finish_y = 6

            -- add_s_f("j5", show_tip("Now you should move back to teleport!\n\n", false), nil, 'tip')

            add_w("c5", "d")
            add_w("c5", "l")
            add_w("c4", "l")
            add_w("c4", "u")
            
            add_w("c7", "l")
            add_w("c7", "u")
            add_w("c8", "l")
            add_w("c8", "d")
            
            add_w("e5", "u")
            add_w("e5", "r")
            add_w("e6", "r")
            add_w("e7", "r")
            add_w("e7", "d")
            
            add_w("f2", "u")
            add_w("f2", "l")
            
            add_w("h4", "u")
            add_w("h4", "r")
            
            add_w("h8", "r")
            add_w("h8", "d")
            
            add_w("j6", "d")
            
            add_w("f9", "d")
            add_w("j5", "d")
            
            add_w("j2", "l")
            add_w("j2", "u")
            add_t_f("j2", 1)
            add_t_f("h6", 1)
            
        end
    },

    { 
        number = 5,
        setup = function() -- 5
            visible_grid_size = 21
            
            start_x = 2
            start_y = 2
            
            player_x = 2
            player_y = 2
            
            finish_x = 20
            finish_y = 18

            add_w("t14", "r")
            add_w("t14", "d")

            
            add_t_f("r5", 1)
            add_t_f("j5", 1)
            add_w("p5", "u")
            add_w("p5", "r")
            add_w("b5", "u")
            add_w("b5", "l")
            add_w("p15", "r")
            add_w("p15", "d")
            add_w("e9", "r")
            add_w("d6", "u")
            add_t_f("t14", 2)
            add_t_f("i8", 2)
            add_w("l19", "r")
            add_t_f("p20", 3)
            add_w("f2", "u")
            add_t_f("l6", 3)
            add_w("e6", "d")
            add_w("d6", "l")
            add_w("e2", "u")
            add_w("e2", "r")
            add_w("h6", "r")
            add_w("h6", "d")
            add_w("i7", "d")
            add_w("i7", "l")
            add_w("h4", "u")
            add_w("h4", "l")
            add_w("i3", "u")
            add_w("i3", "l")
            add_w("k4", "u")
            add_w("k4", "r")
            add_w("k6", "r")
            add_w("k6", "d")
            add_w("m8", "d")
            add_w("m8", "l")
            add_w("n7", "d")
            add_w("n7", "r")
            add_w("n3", "l")
            add_w("n2", "u")
            add_w("n2", "l")
            add_w("m2", "d")
            add_d_w("l2", "b")
            add_w("r2", "u")
            add_w("r2", "r")
            add_w("e10", "u")
            add_w("e10", "l")
            add_w("d10", "u")
            add_d_w("c10", "f")
            add_w("e12", "d")
            add_w("e12", "l")
            add_d_w("d13", "b")
            add_d_w("b13", "f")
            add_w("b15", "d")
            add_w("b15", "l")
            add_w("c14", "d")
            add_w("c14", "l")
            add_d_w("d15", "b")
            add_w("d16", "d")
            add_w("d16", "l")
            -- add_d_w("f17", "b")
            add_w("i16", "d")
            add_w("i16", "r")
            add_d_w("i15", "f")
            add_w("l15", "u")
            add_w("l15", "r")
            add_w("l18", "r")
            add_w("l18", "d")
            add_w("j18", "u")
            add_w("j18", "l")
            add_w("j19", "l")
            add_w("j19", "d")
            add_w("o20", "d")
            add_w("o20", "l")
            add_w("p20", "d")
            add_w("p20", "r")
            add_w("p19", "u")
            add_w("p19", "r")
            add_w("n18", "d")
            add_w("n18", "l")
            add_w("n17", "u")
            add_w("n17", "l")
            add_w("o17", "u")
            add_w("o17", "r")
            add_w("r8", "r")
            add_w("r8", "d")
            add_w("s9", "d")
            add_w("s9", "l")
            add_w("s10", "r")
            add_w("r12", "r")
            add_w("r12", "d")
            add_d_w("s13", "f")

        end
    },

    { 
        number = 6,
        setup = function() -- 6
            visible_grid_size = 23

            start_x = 2
            start_y = 8

            player_x = 2
            player_y = 8

            finish_x = 5
            finish_y = 4

            add_t_f("b4", 11)
            add_t_f("j6", 1)
            add_t_f("i6", 5)
            add_t_f("l6", 5)
            add_t_f("j5", 4)
            add_t_f("d7", 1)
            add_t_f("h7", 4)
            add_t_f("m9", 11)
            add_t_f("s10", 6)
            --add_t_f("u12", 12)
            add_t_f("o12", 9)
            add_t_f("o13", 7)
            add_t_f("j12", 2)
            add_t_f("h12", 3)
            add_t_f("g11", 3)
            add_t_f("d11", 2)
            add_t_f("j16", 8)
            add_t_f("k16", 10)
            add_t_f("o16", 6)
            add_t_f("r16", 8)
            add_t_f("s16", 10)
            add_t_f("o20", 9)
            add_t_f("o21", 7)

            add_w("b4", "d")
            add_w("b4", "l")
            add_w("b4", "u")
            add_w("e4", "d")
            add_w("e4", "u")
            add_w("e4", "r")
            add_w("b6", "l")
            add_w("b6", "d")
            add_w("g6", "d")
            add_w("i4", "l")
            add_w("i4", "u")
            add_w("h6", "d")
            add_w("i6", "d")
            add_w("i6", "u")
            add_w("i6", "r")
            add_w("j5", "l")
            add_w("j5", "u")
            add_w("k5", "u")
            add_w("l5", "u")
            --add_w("m5", "u")
            add_w("n5", "u")
            add_w("n5", "r")
            add_w("n6", "r")
            add_w("n6", "d")
            add_w("l6", "r")
            add_w("l6", "d")
            add_w("l6", "l")
            add_w("l5", "l")
            add_w("j6", "u")
            add_w("j6", "r")
            add_w("m6", "u")
            add_w("o4", "u")
            add_w("o4", "r")
            add_w("o5", "r")
            add_w("o3", "r")
            add_w("p3", "u")
            add_w("q3", "u")
            add_w("q3", "r")
            add_w("q4", "r")
            add_w("r5", "u")
            add_w("r5", "r")
            add_w("r6", "r")
            add_w("r6", "d")
            add_w("q6", "d")
            add_w("q6", "l")
            add_w("p5", "u")
            add_w("d7", "u")
            add_w("d7", "l")
            add_w("d7", "d")
            add_w("e7", "u")
            add_w("f7", "u")
            add_w("h7", "l")
            add_w("h7", "d")
            add_w("f7", "l")
            add_w("h8", "l")
            add_w("l7", "r")
            add_w("n7", "r")
            add_w("n7", "r")
            add_w("n8", "r")
            add_w("l8", "l")
            add_w("d9", "u")
            add_w("d9", "l")
            add_w("d10", "l")
            add_w("d10", "d")
            add_w("e10", "d")
            add_w("e10", "r")
            add_w("f10", "d")
            add_w("g10", "d")
            add_w("g10", "r")
            add_w("g9", "r")
            add_w("g9", "u")
            add_w("i9", "u")
            add_w("i9", "l")
            add_w("i10", "l")
            add_w("i10", "d")
            add_w("j9", "r")
            add_w("j9", "d")
            add_w("k9", "u")
            add_w("l8", "d")
            add_w("m8", "d")
            add_w("n8", "d")
            add_w("m9", "l")
            add_w("m9", "r")
            add_w("m10", "l")
            add_w("m10", "r")
            add_w("m11", "l")
            add_w("m11", "r")
            add_w("l10", "d")
            add_w("n10", "d")
            add_w("o10", "d")
            add_w("o10", "r")
            add_w("q10", "l")
            add_w("q10", "u")
            add_w("q9", "u")
            add_w("r9", "r")
            add_w("r9", "u")
            add_w("r10", "r")
            add_w("r10", "d")
            add_w("s10", "u")
            add_w("t10", "u")
            add_w("t10", "r")
            add_w("t11", "r")
            add_w("t11", "d")
            add_w("s11", "d")
            add_w("s12", "l")
            add_w("u12", "l")
            add_w("u12", "u")
            add_w("u12", "r")
            add_w("q11", "l")
            add_w("q12", "l")
            add_w("o12", "l")
            add_w("o12", "r")
            add_w("o12", "d")
            add_w("m12", "l")
            add_w("o13", "l")
            add_w("o13", "r")
            add_w("d11", "l")
            add_w("d11", "r")
            add_w("d12", "l")
            add_w("d12", "d")
            add_w("e12", "d")
            add_w("e12", "r")
            add_w("f11", "r")
            add_w("g11", "l")
            add_w("g11", "r")
            add_w("h11", "l")
            add_w("h11", "r")
            add_w("h12", "l")
            add_w("h12", "r")
            add_w("h12", "d")
            add_w("g13", "l")
            add_w("g13", "d")
            add_w("f13", "d")
            add_w("e13", "l")
            add_w("e14", "l")
            add_w("e14", "d")
            add_w("h14", "d")
            add_w("i14", "d")
            add_w("l14", "d")
            add_w("l14", "r")
            add_w("l13", "r")
            add_w("l12", "d")
            add_w("k12", "d")
            add_w("j12", "u")
            add_w("j12", "l")
            add_w("j12", "r")
            add_w("j13", "l")
            add_w("j13", "d")
            add_w("k13", "d")
            add_w("h13", "r")
            add_w("h14", "r")
            add_w("i15", "l")
            add_w("i16", "l")
            add_w("i16", "d")
            add_w("j16", "d")
            add_w("k16", "d")
            add_w("j16", "r")
            add_w("j16", "u")
            add_w("k16", "u")
            add_w("k17", "r")
            add_w("l17", "d")
            add_w("l15", "r")
            add_w("r16", "u")
            add_w("r16", "r")
            add_w("r16", "d")
            add_w("s16", "u")
            add_w("s16", "d")
            add_w("r17", "r")
            add_w("u15", "d")
            add_w("u15", "l")
            add_w("v15", "u")
            add_w("v15", "r")
            add_w("v19", "r")
            add_w("v19", "d")
            add_w("r20", "r")
            add_w("r20", "d")
            add_w("t21", "r")
            add_w("t21", "d")
            add_w("o20", "r")
            add_w("o20", "d")
            add_w("o20", "l")
            add_w("o21", "r")
            add_w("o21", "l")
            add_w("n19", "d")
            add_w("n19", "l")
            add_w("p21", "d")
            add_w("q13", "u")
            add_w("r13", "u")

            add_s_f("p3", show_tip("Порада тут", false), nil, "tip")
        end
    },

    { 
        number = 7,
        setup = function() -- 7
            visible_grid_size = 31
            
            start_x = 16
            start_y = 12

            player_x = 16
            player_y = 12

            finish_x = 10
            finish_y = 25
            
            add_w("g6", "l")
            add_w("g6", "u")
            add_w("h6", "u")
            add_w("h6", "r")
            add_w("h8", "l")
            add_w("h8", "d")
            add_w("h9", "r")
            add_w("h9", "d")
            add_w("g9", "d")
            add_w("g9", "l")
            add_w("g10", "r")
            add_w("g10", "d")
            add_w("g11", "l")
            add_w("h11", "r")
            add_w("h11", "d")
            add_w("h12", "l")
            add_w("i11", "u")
            add_w("j11", "u")
            add_w("j11", "r")
            add_w("k11", "u")
            add_w("k10", "r")
            add_w("n10", "r")
            add_w("n11", "r")
            add_w("n9", "r")
            add_w("n8", "r")
            add_w("n8", "l")
            add_w("n7", "l")
            add_w("n7", "u")
            add_w("o7", "u")
            add_w("o7", "r")
            add_w("p7", "u")
            add_w("p8", "r")
            add_w("p8", "d")
            add_w("o8", "d")
            add_t_f("q8", 1)
            add_w("q8", "u")
            add_w("r8", "u")
            add_w("s8", "u")
            add_w("s8", "r")
            add_w("s9", "r")
            add_w("s9", "d")
            add_w("r9", "d")
            add_w("r7", "u")
            add_t_f("r6", 4)
            add_w("t6", "r")
            add_w("t6", "d")
            add_w("t4", "r")
            add_w("t4", "u")
            add_w("s4", "d")
            add_w("s4", "l")
            add_w("s3", "u")
            add_w("s3", "r")
            add_w("r3", "d")
            add_w("q4", "r")
            add_w("q4", "d")
            add_w("q2", "u")
            add_w("q2", "l")
            add_w("o3", "l")
            add_w("o3", "u")
            add_w("w2", "u")
            add_w("w2", "r")
            add_w("o5", "r")
            add_w("o5", "d")
            add_w("n5", "d")
            add_w("m5", "d")
            add_w("m6", "l")
            add_w("k5", "u")
            add_w("k5", "l")
            add_w("l4", "u")
            add_w("l4", "l")
            add_w("t7", "r")
            add_w("t8", "r")
            add_w("u8", "u")
            add_w("v8", "u")
            add_w("v7", "r")
            add_w("w8", "d")
            add_w("w9", "r")
            add_w("w10", "r")
            add_w("w10", "l")
            add_w("w11", "r")
            add_w("w12", "r")
            add_w("w12", "d")
            add_w("w13", "r")
            add_w("u13", "u")
            add_w("u13", "l")
            add_w("u14", "l")
            add_t_f("t13", 3)
            add_w("t12", "l")
            add_w("s12", "u")
            add_w("s12", "l")
            add_t_f("s12", 1)
            add_w("r12", "l")
            add_w("r12", "u")
            add_t_f("r12", 3)
            add_w("q12", "l")
            add_w("p12", "u")
            add_w("p12", "d")
            add_w("o12", "d")
            add_w("o12", "l")
            add_w("o11", "u")
            add_w("o11", "l")
            add_w("p11", "u")
            add_w("o10", "l")
            add_w("o10", "l")
            add_w("t13", "d")
            add_w("t13", "l")
            add_t_f("v10", 2)
            add_w("v10", "u")
            add_w("v10", "l")
            add_w("v9", "l")
            add_w("u10", "u")
            add_w("t10", "u")
            add_w("t10", "l")
            add_w("t11", "l")
            add_w("q8", "d")
            add_w("m8", "d")
            add_t_f("h9", 7)
            add_w("n12", "u")
            add_w("m12", "u")
            add_w("m12", "l")
            add_w("m13", "l")
            add_w("m13", "r")
            add_w("m14", "l")
            add_w("m14", "d")
            add_w("n15", "l")
            add_w("n15", "d")
            add_t_f("n15", 2)
            add_w("n15", "r")
            add_w("n14", "r")
            add_w("o14", "u")
            add_w("o16", "l")
            add_w("o17", "l")
            add_w("o17", "u")
            add_w("o18", "l")
            add_w("o18", "d")
            add_w("p16", "d")
            add_w("p16", "r")
            add_w("q16", "d")
            add_w("p15", "l")
            add_w("p15", "u")
            add_w("q14", "u")
            add_w("q14", "l")
            add_w("q13", "l")
            add_w("w15", "r")
            add_w("w15", "d")
            add_w("w16", "r")
            add_w("w17", "r")
            add_w("w17", "d")
            add_w("w18", "r")
            add_w("w19", "l")
            add_w("v19", "d")
            add_w("u19", "d")
            add_w("u19", "l")
            add_w("u18", "l")
            add_w("u18", "u")
            add_w("v17", "l")
            add_w("v17", "u")
            add_w("v16", "l")
            add_w("t18", "d")
            add_w("s16", "r")
            add_w("s16", "d")
            add_w("y7", "u")
            add_w("y7", "r")
            add_w("y19", "l")
            add_w("y19", "d")
            add_w("z19", "u")
            add_w("z19", "r")
            add_w("y20", "r")
            add_w("y20", "d")
            add_t_f("y20", 5)
            add_w("z22", "r")
            add_w("z22", "d")
            add_w("w21", "r")
            add_w("w21", "d")
            add_w("r21", "d")
            add_w("q21", "u")
            add_w("q21", "r")
            add_w("q22", "r")
            add_w("q22", "d")
            add_w("n22", "d")
            add_w("n22", "l")
            add_w("m22", "u")
            add_w("m23", "r")
            add_w("m23", "d")
            add_w("l22", "u")
            add_w("k22", "l")
            add_w("k22", "d")
            add_w("k21", "u")
            add_w("k21", "r")
            add_w("j20", "l")
            add_w("j20", "d")
            add_w("k20", "d")
            add_w("k20", "r")
            add_w("k19", "r")
            add_w("k19", "u")
            add_w("k19", "l")
            add_t_f("k19", 4)
            add_w("j19", "l")
            add_w("j18", "l")
            add_w("j18", "u")
            add_w("i18", "d")
            add_w("g18", "d")
            add_w("g18", "l")
            add_w("h17", "u")
            add_w("h17", "r")
            add_w("h16", "l")
            add_w("g15", "u")
            add_w("g15", "l")
            add_w("f17", "u")
            add_w("f17", "l")
            add_w("k17", "u")
            add_w("k17", "r")
            add_w("l18", "u")
            add_w("l18", "r")
            add_w("m18", "d")
            add_w("n18", "d")
            add_w("n20", "u")
            add_w("n20", "l")
            add_w("f21", "l")
            add_w("f21", "d")
            add_w("i23", "u")
            add_w("i23", "l")
            add_w("h24", "l")
            add_w("h24", "d")
            add_w("h24", "r")
            add_t_f("h24", 5)
            add_w("j25", "r")
            add_w("j25", "u")
            add_w("j25", "l")
            add_w("j26", "l")
            add_w("j26", "d")
            add_w("j27", "l")
            add_w("j28", "r")
            add_w("j28", "d")
            add_w("i28", "d")
            add_w("i28", "l")
            add_w("l28", "l")
            add_w("l28", "d")
            add_w("l28", "r")
            add_t_f("l28", 6)
            add_w("l27", "r")
            add_w("l27", "u")
            add_w("m26", "u")
            add_w("m26", "r")
            add_w("m27", "r")
            add_w("n28", "l")
            add_w("n28", "d")
            add_w("m30", "l")
            add_w("m30", "d")
            add_w("v30", "r")
            add_w("v30", "d")
            add_w("t28", "r")
            add_w("t28", "d")
            add_w("v24", "u")
            add_w("v24", "r")
            add_w("t24", "u")
            add_w("t24", "l")
            add_w("s25", "u")
            add_w("s25", "r")
            add_w("s26", "r")
            add_w("s27", "r")
            add_w("s27", "d")
            add_w("r27", "d")
            add_w("q27", "l")
            add_w("q26", "l")
            add_w("q25", "u")
            add_w("q25", "l")
            add_w("r25", "u")
            add_t_f("r26", 6)
            add_w("z27", "r")
            add_w("z27", "d")
            add_w("z27", "l")
            add_t_f("z27", 7)
            add_w("n13", "d")
            add_w("w8", "l")
            add_w("t11", "d")

            add_s_f("r4", show_tip("Порада тут", false), nil, "tip")
        end

    },

    { 
        number = 8,
        setup = function() -- 8
            visible_grid_size = 40
            
            start_x = 26
            start_y = 7

            player_x = 26
            player_y = 7

            finish_x = 24
            finish_y = 5
            
            add_w("i5", "u")
            add_w("i5", "l")
            add_w("h6", "u")
            add_w("h6", "l")
            add_w("k6", "u")
            add_w("k6", "r")
            add_w("k9", "l")
            add_w("k9", "d")
            add_w("k9", "r")
            add_t_f("k9", 3)
            add_w("n4", "l")
            add_w("n4", "u")
            add_w("n4", "r")
            add_t_f("n4", 1)
            add_w("q7", "l")
            add_w("q7", "u")
            add_w("r7", "u")
            add_w("r7", "r")
            add_w("u7", "l")
            add_w("u7", "d")
            add_w("u6", "l")
            add_w("u6", "u")
            add_t_f("u6", 1)
            add_w("u5", "r")
            add_w("u4", "l")
            add_w("u4", "u")
            add_w("v5", "u")
            add_w("w5", "u")
            add_w("w5", "r")
            add_w("w6", "r")
            add_w("w7", "r")
            add_w("w7", "d")
            add_w("v8", "r")
            add_w("v8", "d")
            add_w("u8", "u")
            add_w("u8", "l")
            add_w("t8", "d")
            add_w("t9", "l")
            add_w("s9", "d")
            add_w("s10", "r")
            add_w("x5", "u")
            add_w("x5", "d")
            add_w("y5", "d")
            add_w("y4", "l")
            add_w("x2", "u")
            add_w("x2", "l")
            add_w("aa2", "u")
            add_w("aa2", "r")
            add_w("aa5", "r")
            add_w("aa5", "d")
            add_w("z6", "l")
            add_w("z6", "d")
            add_w("z7", "r")
            add_w("z7", "d")
            add_w("aa7", "d")
            add_w("ab8", "d")
            add_w("ab8", "l")
            add_w("ac9", "d")
            add_w("ac9", "l")
            add_w("ac10", "l")
            add_w("ad10", "u")
            add_w("ad10", "r")
            add_w("ae10", "d")
            add_w("ae11", "r")
            add_w("y10", "r")
            add_w("y10", "d")
            add_w("x11", "r")
            add_w("x11", "d")
            add_w("w11", "d")
            add_w("w11", "l")
            add_w("w10", "l")
            add_w("w10", "u")
            add_w("q10", "d")
            add_w("q10", "l")
            --add_w("p9", "u")
            add_w("p9", "r")
            add_w("p9", "d")
            --add_w("p9", "l")
            --add_w("o9", "u")
            --add_w("o9", "r")
            add_w("o9", "d")
            --add_w("o9", "l")
            add_w("o10", "l")
            add_w("n12", "l")
            add_w("n12", "d")
            add_w("ac12", "r")
            add_w("ac12", "d")
            add_w("ab13", "r")
            add_w("ab13", "d")
            add_w("aa14", "r")
            add_w("aa14", "d")
            add_w("ab15", "d")
            add_w("ab15", "r")
            add_w("ac14", "d")
            add_w("ac14", "r")
            add_w("ad13", "d")
            add_w("ad13", "r")
            add_w("ae15", "r")
            add_w("ae15", "d")
            add_w("ae16", "r")
            add_w("w15", "u")
            add_w("w15", "l")
            add_w("u15", "r")
            add_w("u15", "d")
            add_w("t15", "d")
            add_w("t15", "l")
            add_w("s15", "u")
            add_w("s15", "l")
            add_w("s14", "l")
            add_w("s13", "l")
            add_w("r15", "d")
            add_w("r17", "r")
            add_w("r17", "u")
            add_w("r17", "l")
            add_w("r17", "d")
            add_t_f("s17", 2)
            add_t_f("o17", 6)
            add_w("n17", "u")
            add_w("n17", "r")
            add_w("n17", "d")
            add_w("n17", "l")
            add_t_f("n18", 4)
            add_w("o18", "r")
            add_w("o18", "d")
            add_w("o18", "l")
            add_w("o18", "u")
            add_w("n18", "d")
            add_w("m18", "d")
            add_w("m18", "l")
            add_w("l18", "d")
            add_w("k18", "d")
            add_w("j18", "d")
            add_w("i18", "u")
            add_w("i18", "l")
            add_w("i19", "r")
            add_w("k19", "r")
            add_w("m16", "u")
            add_w("m16", "l")
            add_w("n15", "d")
            add_w("n15", "r")
            add_w("n15", "u")
            add_w("n15", "l")
            add_w("l14", "u")
            add_w("l14", "r")
            add_w("i15", "r")
            add_w("i15", "d")
            add_w("i15", "l")
            add_t_f("i15", 3)
            add_w("h14", "l")
            add_w("h14", "d")
            add_w("i21", "l")
            add_w("i21", "d")
            add_w("n21", "u")
            add_w("n21", "r")
            add_w("m23", "u")
            add_w("m23", "r")
            add_w("j23", "d")
            add_w("j23", "l")
            add_w("j27", "u")
            add_w("j27", "l")
            add_w("j27", "d")
            add_w("j28", "l")
            add_w("k27", "d")
            add_w("k27", "r")
            add_w("l27", "d")
            add_w("l28", "l")
            add_w("m26", "d")
            add_w("m26", "l")
            add_w("v18", "r")
            add_w("v18", "u")
            add_w("v18", "l")
            add_w("v18", "d")
            add_t_f("v19", 2)
            add_w("w19", "r")
            add_w("w19", "u")
            add_w("w19", "l")
            add_w("w19", "d")
            add_w("x19", "u")
            add_w("z18", "u")
            add_w("z18", "r")
            add_w("z18", "d")
            add_w("z18", "l")
            add_w("ab18", "u")
            add_w("ab18", "l")
            add_w("ab18", "d")
            add_w("ac18", "d")
            add_w("ad18", "d")
            add_w("ad18", "r")
            add_w("ad18", "u")
            add_w("ad19", "l")
            add_w("ae19", "u")
            add_w("ae19", "d")
            add_t_f("ad19", 4)
            add_t_f("ab19", 5)
            add_w("ab20", "u")
            add_w("ab20", "l")
            add_w("ae22", "r")
            add_w("ae22", "d")
            add_w("ae22", "l")
            add_t_f("ae22", 5)
            add_w("aa22", "r")
            add_w("aa22", "u")
            add_w("aa22", "l")
            add_t_f("aa22", 6)
            add_w("y22", "r")
            add_w("y22", "d")
            add_w("x23", "r")
            add_w("x23", "d")
            add_w("x24", "r")
            add_w("x25", "r")
            add_w("x25", "d")
            add_w("t25", "l")
            add_w("t25", "d")
            add_w("u24", "d")
            add_w("u24", "l")
            add_w("u23", "l")
            add_w("u23", "u")
            add_w("t23", "u")
            add_w("s23", "l")
            add_w("s22", "r")
            add_w("s22", "d")
            add_w("s26", "r")
            add_w("s26", "d")
            add_w("s27", "r")
            add_w("s27", "d")
            add_w("s27", "l")
            add_w("u28", "u")
            add_w("u28", "r")
            add_w("u30", "u")
            add_w("u30", "r")
            add_w("v30", "d")
            add_w("w30", "d")
            add_w("w30", "r")
            add_w("x30", "u")
            add_w("x31", "l")
            add_w("x32", "l")
            add_w("w32", "d")
            add_w("v33", "u")
            add_w("v33", "l")
            add_w("u33", "d")
            add_w("t33", "d")
            add_w("t33", "l")
            add_w("t32", "u")
            add_w("t32", "l")
            add_w("s32", "d")
            add_w("r32", "l")
            add_w("r32", "d")
            add_w("q32", "u")
            add_w("r31", "u")
            add_w("r31", "l")
            add_w("r30", "l")
            add_w("r29", "u")
            add_w("r29", "l")
            add_w("p33", "u")
            add_w("p33", "l")
            add_w("p35", "r")
            add_w("p36", "r")
            add_w("p36", "d")
            add_w("q37", "r")
            add_w("q37", "d")
            add_w("q37", "l")
            add_t_f("q37", 8)
            add_w("r37", "u")
            add_w("r38", "r")
            add_w("r38", "d")
            add_w("r36", "u")
            add_w("s35", "l")
            add_w("s35", "d")
            add_w("v34", "r")
            add_w("v34", "d")
            add_w("x33", "r")
            add_w("x33", "d")
            add_w("z32", "d")
            add_w("z32", "l")
            add_w("aa32", "d")
            add_w("aa32", "r")
            add_w("aa30", "r")
            add_w("aa30", "u")
            add_w("aa28", "u")
            add_w("z28", "u")
            add_w("z28", "l")
            add_w("z27", "r")
            add_w("ac28", "u")
            add_w("ac28", "r")
            add_w("ad29", "r")
            add_w("ad29", "u")
            add_w("ae27", "u")
            add_w("ae27", "r")
            add_w("q35", "d")
            add_w("ad35", "r")
            add_w("ad35", "d")
            add_w("ac36", "r")
            add_w("ac36", "d")
            add_w("ae37", "r")
            add_w("ae37", "d")
            add_w("n39", "r")
            add_w("n39", "d")
            add_w("j39", "d")
            add_w("j39", "l")
            add_w("g38", "d")
            add_w("g38", "l")
            add_w("h36", "d")
            add_w("h36", "l")
            add_w("g35", "u")
            add_w("g35", "l")
            add_w("h34", "u")
            add_w("h34", "l")
            add_w("j35", "u")
            add_w("j35", "r")
            add_w("j32", "l")
            add_w("j32", "d")
            add_w("k31", "d")
            add_w("k31", "l")
            add_w("l31", "d")
            add_w("l31", "r")
            add_w("ac19", "l")
            add_w("ac19", "d")
            add_w("ad19", "d")
            add_w("x7", "d")
            add_t_f("j27", 8)
            add_w("af20", "r")
            add_w("af10", "r")
            add_w("af10", "u")
            add_w("ae8", "r")
            add_w("ae8", "u")
            add_w("ab7", "u")
            add_w("ab7", "r")
            add_w("aa6", "r")

            add_s_f("z3", show_tip("You was close...\n\n", false), nil, "tip")

        end

    },

    { 
        number = 9,
        setup = function() -- 9
            visible_grid_size = 33
            
            start_x = 22
            start_y = 17

            player_x = 22
            player_y = 17

            finish_x = 29
            finish_y = 16
            
            add_w("d17", "l")
            add_w("v17", "l")
            add_w("v17", "d")
            add_w("v17", "r")
            add_w("d17", "u")
            add_w("ac16", "u")
            add_w("ac16", "r")
            add_w("ac16", "d")
            add_w("e18", "l")
            add_w("e18", "d")
            add_w("f19", "d")
            add_w("f19", "l")
            add_w("h19", "d")
            add_w("h19", "r")
            add_w("i18", "d")
            add_w("i18", "r")
            add_w("j15", "r")
            add_w("j15", "d")
            add_w("l16", "d")
            add_w("l16", "r")
            add_w("g16", "u")
            add_w("g16", "r")
            add_w("g16", "d")
            add_w("f16", "u")
            add_w("f16", "l")
            add_w("e15", "l")
            add_w("l11", "u")
            add_w("l11", "r")
            add_w("h11", "l")
            add_w("h11", "d")
            add_w("h8", "l")
            add_w("h8", "u")
            add_w("i7", "l")
            add_w("i7", "u")
            add_w("j6", "l")
            add_w("j6", "u")
            add_w("k5", "l")
            add_w("k5", "u")
            add_w("l4", "l")
            add_w("l4", "u")
            add_w("m3", "l")
            add_w("m3", "u")
            add_w("m3", "r")
            add_t_f("m3", 1)
            add_w("n5", "u")
            add_w("n5", "l")
            add_w("m6", "u")
            add_w("m6", "l")
            add_w("l7", "u")
            add_w("l7", "l")
            add_w("k8", "u")
            add_w("k8", "l")
            add_w("j8", "d")
            add_w("q2", "u")
            add_w("q2", "l")
            add_w("r5", "u")
            add_w("r5", "l")
            add_w("q7", "r")
            add_w("q7", "u")
            add_w("p7", "u")
            add_w("p7", "l")
            add_w("p8", "l")
            add_w("p8", "d")
            add_w("o9", "u")
            add_w("o9", "l")
            add_w("q10", "d")
            add_w("q10", "l")
            add_w("r9", "l")
            add_w("r9", "d")
            add_w("s9", "d")
            add_w("s9", "r")
            add_w("s8", "u")
            add_w("s8", "r")
            add_w("t10", "u")
            add_w("t10", "r")
            add_w("u11", "u")
            add_w("u11", "r")
            add_w("s11", "u")
            add_w("s11", "l")
            add_w("r12", "u")
            add_w("r12", "l")
            add_w("s14", "l")
            add_w("s14", "d")
            add_w("r16", "d")
            add_w("r16", "l")
            add_w("t16", "d")
            add_w("t16", "r")
            add_w("u15", "d")
            add_w("u15", "l")
            add_w("v14", "u")
            add_w("v14", "r")
            add_w("w13", "l")
            add_w("w13", "d")
            add_w("x12", "u")
            add_w("x12", "r")
            add_w("x15", "r")
            add_w("x15", "d")
            add_w("x16", "l")
            add_w("ab11", "u")
            add_w("ab11", "r")
            add_w("aa2", "u")
            add_w("aa2", "r")
            add_w("w5", "u")
            add_w("w5", "r")
            add_w("v4", "u")
            add_w("v4", "r")
            add_w("x6", "u")
            add_w("x6", "r")
            add_w("z13", "u")
            add_w("z13", "r")
            add_w("o13", "l")
            add_w("o13", "d")
            add_w("e15", "u")
            add_w("g22", "r")
            add_w("g22", "d")
            add_w("g22", "l")
            add_t_f("g22", 3)
            add_w("d21", "l")
            add_w("d21", "d")
            add_w("g25", "d")
            add_w("g25", "r")
            add_w("g25", "u")
            add_w("f25", "u")
            add_w("f25", "l")
            add_t_f("g25", 4)
            add_w("g26", "l")
            add_t_f("g26", 3)
            add_w("h26", "d")
            add_w("h26", "r")
            add_w("i26", "u")
            add_w("h27", "l")
            add_w("m24", "d")
            add_w("m24", "l")
            add_w("h26", "l")
            add_w("g32", "d")
            add_w("g32", "l")
            add_w("h32", "d")
            add_w("h32", "r")
            add_w("i31", "d")
            add_w("i31", "r")
            add_w("f31", "d")
            add_w("f31", "l")
            add_w("y19", "u")
            add_w("y19", "r")
            add_w("z18", "r")
            add_w("z18", "d")
            add_w("y22", "r")
            add_w("y22", "d")
            add_w("y22", "l")
            add_t_f("y22", 1)
            add_w("ab22", "l")
            add_w("ab22", "d")
            add_w("ab22", "r")
            add_t_f("ab22", 2)
            add_w("ac21", "d")
            add_w("ac21", "r")
            add_w("ab25", "u")
            add_w("ab25", "r")
            add_t_f("ab25", 4)
            add_w("aa25", "r")
            add_w("aa25", "u")
            add_w("aa25", "l")
            add_t_f("aa25", 2)
            add_w("aa24", "r")
            add_w("p18", "l")
            add_w("p18", "d")
            add_w("q19", "d")
            add_w("q19", "l")
            add_w("ab27", "r")
            add_w("ab27", "d")
            add_w("aa28", "r")
            add_w("aa28", "d")
            add_w("z29", "r")
            add_w("z29", "d")
            add_w("y30", "r")
            add_w("y30", "d")
            add_w("x31", "r")
            add_w("x31", "d")
            add_w("w31", "d")
            add_w("v31", "d")
            add_w("v31", "l")
            add_w("u30", "d")
            add_w("t30", "d")
            add_w("t30", "l")
            add_w("s29", "d")
            add_w("s29", "l")
            add_w("r28", "d")
            add_w("r28", "l")
            add_w("r26", "u")
            add_w("r26", "r")
            add_w("s27", "u")
            add_w("s27", "r")
            add_w("t28", "u")
            add_w("t28", "r")
            add_w("u29", "u")
            add_w("v29", "u")
            add_w("v29", "r")
            add_w("w29", "d")
            add_w("x29", "u")
            add_w("x29", "l")
            add_w("y28", "u")
            add_w("y28", "l")
            add_w("z27", "u")
            add_w("z27", "l")

            add_s_f("g16", show_tip("Створити прозори стінки", false), nil, "tip")

        end

    },
    
    { 
        number = 10,
        setup = function() -- 10
            visible_grid_size = 12
            
            start_x = 2
            start_y = 2
    
            player_x = 2
            player_y = 2
    
            finish_x = 6
            finish_y = 4
            
            add_d_w("d2", "b")
            add_d_w("d6", "b")
            add_d_w("h6", "f")
            add_d_w("h2", "f")
            add_t_f("j2", 1)
            add_t_f("b6", 1)
            add_d_w("d9", "b")
            add_d_w("k9", "f")
            add_d_w("k6", "b")
            add_d_w("h11", "f")
            add_d_w("f11", "b")
            
            add_w("b6", "u")
            add_w("b6", "l")
            add_w("b6", "d")
            add_w("j2", "u")
            add_w("j2", "r")
            add_w("j2", "d")
            
        
            
            
            
            
        end
            
            
    },
    
    { 
        number = 11,
        setup = function() -- 11
            visible_grid_size = 18
            
            start_x = 2
            start_y = 2
    
            player_x = 2
            player_y = 2
    
            finish_x = 15
            finish_y = 16
            
            add_d_w("d2", "b")
            add_d_w("d6", "b")
            add_d_w("h6", "f")
            add_d_w("h2", "f")
            add_t_f("j2", 1)
            add_t_f("b6", 1)
            add_d_w("d9", "b")
            add_d_w("k9", "f")
            add_d_w("k6", "b")
            add_d_w("h11", "f")
            add_d_w("f11", "b")
            
            add_w("b6", "u")
            add_w("b6", "l")
            add_w("b6", "d")
            add_w("j2", "u")
            add_w("j2", "r")
            add_w("j2", "d")
            
            add_t_f("f4", 2)
            add_t_f("b15", 2)
            add_d_w("e15", "b")
            add_d_w("e17", "b")
            add_w("h17", "d")
            add_w("h17", "r")
            add_w("h15", "u")
            add_w("h15", "l")
            add_d_w("j15", "f")
            add_w("l15", "d")
            add_w("l15", "r")
            add_w("l13", "r")
            add_w("l13", "u")
            add_w("j13", "u")
            add_w("j13", "l")
            add_d_w("j17", "b")
            add_w("l17", "d")
            add_w("l17", "r")
            add_t_f("b16", 3)
            add_w("b16", "u")
            add_t_f("k14", 3)
            add_d_w("n9", "f")
            add_d_w("n6", "b")
            add_w("k2", "u")
            add_d_w("q2", "b")
            add_w("q16", "r")
            add_w("q16", "d")
            add_w("n16", "r")
            add_d_w("o14", "b")
            add_w("o15", "d")
            add_d_w("m12", "b")
            add_d_w("b12", "b")
            add_d_w("p7", "b")
            add_d_w("p17", "f")
            add_w("o17", "d")
            add_w("o17", "l")
        end
            
            
    },

    { 
        number = 12,
        setup = function() -- 12
            visible_grid_size = 34
            
            start_x = 0
            start_y = 0
    
            player_x = 11
            player_y = 9
    
            finish_x = 8
            finish_y = 7
            
            add_d_w("g33", "b")
            add_d_w("h32", "b")
            add_d_w("i31", "b")
            add_d_w("g29", "f")
            add_d_w("h28", "f")
            add_d_w("i27", "f")
            add_d_w("j25", "b")
            add_d_w("j22", "f")
            add_w("k21", "u")
            add_w("k21", "l")
            add_d_w("n21", "f")
            add_d_w("o20", "f")
            add_w("o19", "u")
            add_w("o19", "r")
            add_w("o18", "l")
            add_d_w("k33", "f")
            add_d_w("n32", "f")
            add_d_w("o31", "f")
            add_d_w("p30", "f")
            add_d_w("m30", "b")
            add_d_w("o28", "f")
            add_d_w("p27", "f")
            add_d_w("p24", "f")
            add_d_w("s24", "f")
            add_d_w("r25", "f")
            add_d_w("r28", "f")
            add_d_w("s27", "f")
            add_d_w("t29", "f")
            add_d_w("u25", "f")
            add_d_w("v24", "f")
            add_w("w23", "l")
            add_w("w23", "d")
            add_w("z23", "d")
            add_w("z23", "r")
            add_w("z18", "u")
            add_w("z18", "r")
            add_w("w20", "u")
            add_w("w20", "r")
            add_w("v19", "u")
            add_w("v19", "r")
            add_d_w("u22", "b")
            add_d_w("t21", "b")
            add_d_w("s20", "b")
            add_w("r20", "u")
            add_w("q20", "u")
            add_w("p20", "u")
            add_w("p14", "u")
            add_w("p14", "l")
            add_w("q13", "u")
            add_w("q13", "l")
            add_w("w13", "r")
            add_w("w13", "d")
            add_w("v14", "r")
            add_w("v14", "d")
            add_d_w("v9", "b")
            add_d_w("r9", "b")
            add_d_w("s10", "b")
            add_w("n9", "r")
            add_w("n9", "d")
            add_w("k9", "u")
            add_w("k9", "l")
            add_w("h7", "r")
            add_w("h7", "u")
            add_w("h7", "l")
            add_w("h13", "l")
            add_w("h13", "d")
            add_w("s6", "u")
            add_w("s6", "r")
            add_w("s6", "d")
            add_w("s6", "l")
            add_d_w("r3", "f")
            add_w("p4", "u")
            add_w("p4", "l")
            add_w("o5", "u")
            add_w("o5", "l")
            add_w("n6", "u")
            add_w("n6", "l")
            add_d_w("w3", "b")
            add_d_w("w2", "f")
            add_w("x3", "u")
            add_w("x3", "r")
            add_w("x5", "r")
            add_w("x5", "d")
            add_w("z4", "r")
            add_w("z4", "d")
            add_d_w("z2", "b")
            add_d_w("m25", "b")
        end
            
            
    },

    { 
        number = 13,
        setup = function() -- 13
            visible_grid_size = 28

            start_x = 0
            start_y = 0

            player_x = 6
            player_y = 10

            finish_x = 2
            finish_y = 11
            
            add_w("y23", "u")
            add_w("b11", "u")
            add_w("b11", "l")
            add_w("b11", "d")
            add_w("f10", "u")
            add_w("f10", "l")
            add_w("d13", "r")
            add_w("d13", "d")
            add_w("d16", "d")
            add_w("d16", "l")
            add_w("h17", "d")
            add_w("h17", "l")
            add_w("i18", "d")
            add_w("i18", "l")
            add_w("k19", "u")
            add_w("k19", "l")
            add_w("j16", "u")
            add_w("j16", "r")
            add_w("i22", "r")
            add_w("i22", "d")
            add_w("k24", "d")
            add_w("k24", "l")
            add_w("p24", "u")
            add_w("p24", "l")
            add_w("n22", "r")
            add_w("n22", "d")
            add_w("i13", "u")
            add_w("i13", "r")
            add_w("g13", "r")
            add_w("g13", "d")
            add_w("j10", "u")
            add_w("j10", "l")
            add_w("l9", "r")
            add_w("l9", "d")
            add_w("n10", "u")
            add_w("n10", "r")
            add_w("o8", "d")
            add_w("o8", "l")
            add_w("p9", "d")
            add_w("p9", "l")
            add_w("q12", "u")
            add_w("q12", "r")
            add_w("q14", "d")
            add_w("q14", "l")
            add_w("s14", "u")
            add_w("s14", "l")
            add_w("r17", "u")
            add_w("r17", "r")
            add_w("r20", "u")
            add_w("r20", "l")
            add_w("u19", "d")
            add_w("u19", "l")
            add_w("x23", "r")
            add_w("w9", "u")
            add_w("w9", "r")
            add_w("x11", "r")
            add_w("x11", "d")
            add_w("aa12", "u")
            add_w("aa12", "l")
            add_w("z8", "l")
            add_w("z8", "d")
            add_w("m12", "d")
            add_w("m12", "l")
            add_w("n15", "u")
            add_w("n15", "r")
            add_w("l16", "d")
            add_w("t11", "l")
            add_w("t11", "d")
            add_w("t9", "u")
            add_w("t9", "r")
            add_w("u9", "d")
            add_w("p6", "d")
            add_w("p6", "r")
            add_w("v7", "u")
            add_w("v7", "l")
            add_w("w21", "r")
            add_w("w21", "d")
            add_w("e21", "d")
            add_w("e21", "l")
            add_w("e14", "u")
            add_w("e14", "l")
            add_w("g7", "l")
            add_w("t5", "l")
            add_w("t5", "d")
            add_w("s11", "d")
            add_w("e5", "u")
            add_w("e5", "l")
            add_w("f7", "d")
        end
    },

    {
        number = 14,
        setup = function() -- 14
            visible_grid_size = 14
            
            start_x = 2
            start_y = 8
            
            player_x = 2
            player_y = 8
            
            finish_x = 8
            finish_y = 2
            
            -- add_s_f("b9", show_tip("Порада тут", false), nil, "tip")
            add_w("e8", "l")
            add_w("e8", "d")
            add_w("d11", "u")
            add_w("d11", "r")
            add_w("h10", "u")
            add_w("h10", "l")
            add_w("j12", "u")
            add_w("j12", "r")
            add_w("k7", "u")
            add_w("k7", "l")
            add_w("m5", "d")
            add_w("m5", "l")
            add_key("m11")
            add_w("n11", "l")
            add_w("g6", "d")
            add_w("g6", "r")
            add_lock("h4")
            -- add_s_f("h2", call_func(blablabla, false), nil, "func")
            
            
        end
    },
    

    { 
        number = 15,
        setup = function() -- 15
            visible_grid_size = 12
            
            start_x = 2
            start_y = 4
            
            player_x = 2
            player_y = 4
            
            finish_x = 11
            finish_y = 4
            
            add_w("f4", "u")
            add_w("f4", "r")
            add_w("f8", "d")
            add_w("b8", "u")
            add_w("b8", "l")
            add_w("b8", "d")
            add_key("b8")
            add_w("k8", "d")
            add_w("k8", "r")
            add_lock("k6")
        end
    },

    {
        number = 16,
        setup = function() -- 16
            visible_grid_size = 12
            
            start_x = 6
            start_y = 2
            
            player_x = 6
            player_y = 2
            
            finish_x = 6
            finish_y = 11

            add_w("b2", "u")
            add_w("f2", "d")
            add_w("b2", "l")
            add_key("b2")
            add_w("b8", "l")
            add_w("b8", "d")
            add_lock("g8")
            add_w("k8", "d")
            add_w("k8", "r")
            add_lock("k5")
            add_w("k2", "u")
            add_w("k2", "r")

        end
    },
    
    { 
        number = 17,
        setup = function() -- 17
            visible_grid_size = 13
            
            start_x = 3
            start_y = 3
            
            player_x = 3
            player_y = 3
            
            finish_x = 11
            finish_y = 3
            
            add_lock("g7")
            add_w("k8", "r")
            add_w("k8", "d")
            add_w("c6", "u")
            add_w("c6", "l")
            add_w("c11", "d")
            add_w("c11", "l")
            add_w("g3", "r")
            add_w("g3", "u")
            add_w("k3", "u")
            add_w("k3", "r")
            add_w("g12", "l")
            add_w("g12", "d")
            add_w("g12", "r")
            add_w("g11", "r")
            add_w("f11", "d")
            add_key("g12")
            add_w("h11", "u")
        end
    },
    
    { 
        number = 18,
        setup = function() -- 18
            visible_grid_size = 27
            
            start_x = 0
            start_y = 0
            
            player_x = 19
            player_y = 9
            
            finish_x = 19
            finish_y = 8
            
            add_w("f5", "r")
            add_w("f5", "u")
            add_w("f5", "l")
            add_t_f("f5", 2)
            add_w("f11", "u")
            add_w("f11", "l")
            add_w("j14", "u")
            add_w("j14", "l")
            add_w("n12", "l")
            add_w("n12", "d")
            add_w("o12", "d")
            add_w("o12", "r")
            add_w("n11", "u")
            add_w("n11", "l")
            add_t_f("n11", 1)
            add_w("n10", "u")
            add_w("n10", "r")
            add_t_f("n10", 3)
            add_w("p9", "u")
            add_w("p9", "r")
            add_w("p9", "d")
            add_w("p9", "l")
            add_w("q12", "u")
            add_w("q12", "l")
            add_w("r13", "l")
            add_w("r13", "d")
            add_w("r13", "r")
            add_t_f("r13", 2)
            add_w("r11", "u")
            add_w("r11", "r")
            add_w("s8", "r")
            add_w("s8", "d")
            add_w("s8", "l")
            add_lock("s7")
            add_d_w("s5", "b")
            add_w("r4", "u")
            add_w("r4", "r")
            add_w("m3", "d")
            add_w("m3", "l")
            add_w("m6", "d")
            add_w("m6", "l")
            add_w("n1", "d")
            add_w("o1", "d")
            add_d_w("k2", "f")
            add_d_w("k5", "b")
            add_w("m18", "r")
            add_w("m18", "d")
            add_w("m18", "l")
            add_t_f("m18", 3)
            add_w("j20", "d")
            add_w("j20", "l")
            add_w("p20", "u")
            add_w("p20", "r")
            add_key("p23")
            add_w("p26", "r")
            add_w("p26", "d")
            add_w("j26", "u")
            add_w("j26", "l")
            add_w("j26", "d")
            add_t_f("j26", 1)
            add_w("v15", "u")
            add_w("v15", "r")
            add_w("v10", "u")
            add_w("v10", "r")
            add_w("o2", "r")
            add_w("q6", "r")
            add_w("q5", "d") 

            add_w("s24", "u")
            add_w("s24", "l")
            add_w("g23", "u")
            add_w("g23", "r")
            add_w("h7", "u")
            add_w("h7", "l")

        end
    },
    
    {
        number = 19,
        setup = function() -- 19
            visible_grid_size = 20
            
            start_x = 0
            start_y = 0
            
            player_x = 3
            player_y = 3
            
            finish_x = 3
            finish_y = 8

            add_lock("c10")
            add_lock("c12")
            add_key("q17")
            add_key("o13")

            
            add_t_f("h2", 1)
            add_t_f("q8", 1)
            add_t_f("q5", 2)
            add_t_f("j7", 2)
            add_t_f("k15", 3)
            add_t_f("s7", 3)
            add_t_f("o7", 4)
            add_t_f("m19", 4)
            add_t_f("e18", 5)
            add_t_f("h4", 6)
            add_t_f("q9", 5)
            add_t_f("q18", 6)
            
            
            add_w("q9", "l")
            add_w("e17", "r")
            
            
            
            
            add_w("b19", "l")
            add_w("b19", "d")
            add_d_w("d19", "f")
            add_w("e18", "l")
            add_w("e18", "d")
            add_w("e18", "u")
            add_w("b16", "u")
            add_w("b16", "l")
            add_w("c14", "l")
            add_w("c14", "d")
            add_d_w("f14", "f")
            add_w("h13", "u")
            add_w("h13", "l")
            add_w("h19", "l")
            add_w("h19", "d")
            add_w("m19", "u")
            add_w("m19", "r")
            add_w("m19", "d")
            
            add_w("q18", "u")
            add_w("q18", "r")
            add_w("q18", "d")
            add_w("s16", "r")
            add_w("s16", "d")
            add_d_w("r14", "f")
            add_w("s13", "u")
            add_w("s13", "r")
            add_w("q12", "u")
            add_w("q12", "r")
            add_w("o13", "u")
            add_w("o13", "l")
            add_w("o14", "d")
            add_w("m13", "u")
            add_w("m13", "r")
            add_w("m12", "l")
            add_w("d11", "u")
            add_w("d11", "l")
            add_d_w("f10", "f")
            add_w("c8", "r")
            add_w("c8", "u")
            add_w("c8", "l")
            add_w("r10", "u")
            add_w("r10", "r")
            add_w("q9", "u")
            add_w("q9", "r")
            
            add_w("s7", "u")
            add_w("s7", "r")
            add_w("s7", "d")
            
            add_w("o7", "u")
            add_w("o7", "l")
            add_w("o7", "d")
            
            add_w("q8", "r")
            add_w("q8", "l")
            add_w("q5", "r")
            add_w("q5", "u")
            add_w("q5", "l")
            add_w("m3", "r")
            add_w("m3", "u")
            add_w("h2", "u")
            add_w("h2", "r")
            add_d_w("h3", "f")
            
            -- add_w("h2", "d")
            add_w("h4", "l")
            add_w("h4", "d")
            -- add_w("h5", "r")
            add_w("c3", "u")
            add_w("c3", "l")
            add_w("c3", "d")
            add_s_f("c2", show_tip("Порада тут", false), nil, "tip")
            add_w("j7", "u")
            add_w("j7", "l")
            add_w("k7", "u")
            add_w("k7", "r")
            add_w("k15", "r")
            add_w("k15", "d")
            add_w("j15", "d")
            add_w("j15", "l")        
        end
    },

    { 
        number = 20,
        setup = function() -- 20
            visible_grid_size = 38
            
            start_x = 0
            start_y = 0
            
            player_x = 13
            player_y = 8
            
            finish_x = 27
            finish_y = 36
            
            add_s_f("y33", show_tip("Порада тут", false), nil, "tip")
            
            add_w("i12", "u")
            add_w("i12", "l")
            add_w("i12", "d")
            add_t_f("i12", 4)
            add_w("j12", "d")
            --add_w("j12", "l")
            add_w("j13", "l")
            add_w("j15", "r")
            add_w("j15", "u")
            add_w("j15", "l")
            add_t_f("j15", 2)
            add_w("m14", "u")
            add_w("m14", "r")
            add_w("m14", "d")
            add_t_f("m14", 8)
            --add_key("m8")
            add_d_w("k7", "b")
            add_d_w("j7", "f")
            add_d_w("k5", "f")
            add_d_w("o6", "f")
            add_d_w("o7", "b")
            add_w("p9", "l")
            add_w("p9", "d")
            add_d_w("q8", "f")
            add_w("r10", "l")
            add_w("r10", "d")
            add_w("t10", "l")
            add_w("t10", "d")
            add_w("v10", "r")
            add_w("v10", "d")
            add_w("y9", "r")
            add_w("y9", "d")
            add_w("y2", "u")
            add_w("y2", "r")
            add_w("t2", "u")
            add_w("t2", "l")
            add_w("q2", "l")
            add_w("q2", "u")
            add_w("q2", "r")
            add_t_f("q2", 2)
            add_w("r3", "u")
            add_w("r3", "r")
            add_w("p3", "u")
            add_w("p3", "l")
            add_d_w("q5", "f")
            add_d_w("s4", "f")
            add_d_w("v4", "b")
            add_d_w("u5", "b")
            add_d_w("v6", "f")
            add_d_w("v7", "b")
            add_w("m8", "d")
            add_d_w("u8", "f")
            add_d_w("s8", "b")
            add_d_w("q8", "f")
            add_w("ab12", "u")
            add_w("ab12", "r")
            add_w("ab12", "d")
            add_t_f("ab12", 3)
            add_w("s14", "d")
            add_w("s14", "l")
            add_w("w14", "u")
            add_w("w14", "r")
            add_w("v15", "r")
            add_w("v15", "u")
            add_w("v15", "l")
            add_t_f("v15", 9)
            add_w("w17", "r")
            add_w("w17", "d")
            --add_w("w18", "l")
            add_w("u18", "u")
            add_w("u18", "r")
            add_w("u19", "r")
            add_w("u19", "d")
            add_w("t19", "d")
            add_w("t19", "l")
            add_w("t17", "u")
            add_w("t17", "l")
            add_w("s17", "u")
            add_w("r17", "u")
            add_w("r17", "l")
            add_w("r18", "l")
            add_w("r18", "d")
            add_w("r19", "l")
            add_t_f("r19", 1)
            add_w("r20", "l")
            add_w("r20", "d")
            add_w("r21", "r")
            add_w("s20", "r")
            add_w("s20", "d")
            add_w("o21", "l")
            add_w("o21", "d")
            add_w("m22", "u")
            add_w("m22", "l")
            add_w("m22", "d")
            add_t_f("m22", 5)
            add_w("m23", "l")
            add_w("m23", "r")
            add_t_f("m23", 6)
            add_w("q23", "u")
            add_w("q23", "l")
            add_w("q24", "l")
            add_w("q24", "d")
            add_w("r24", "d")
            add_w("r24", "r")
            add_w("t23", "u")
            add_w("t23", "r")
            add_w("t23", "d")
            add_t_f("t23", 1)
            add_w("w22", "r")
            add_w("w22", "d")
            add_w("x25", "u")
            add_w("x25", "l")
            add_w("z18", "u")
            add_w("ae28", "d")
            add_w("ae28", "r")
            
            add_t_f("r2", 10)
            add_d_w("l4", "f")
            add_d_w("l16", "f")
            add_d_w("i16", "f")
            add_key("i22")
            add_w("x33", "r")
            
            add_w("ab25", "u")
            add_w("ab25", "l")
            add_w("aa22", "r")
            add_w("aa22", "d")
            add_w("ad23", "l")
            add_w("ad23", "d")
            add_w("ac27", "r")
            add_w("ac27", "d")
            add_w("y18", "r")
            --add_w("y18", "d")
            add_d_w("q27", "b")
            add_w("t27", "u")
            add_w("t27", "r")
            add_w("t27", "d")
            add_t_f("t27", 7)
            add_w("n27", "r")
            add_w("n27", "u")
            add_w("n27", "l")
            add_t_f("n27", 7)
            add_d_w("k27", "f")
            add_w("h27", "u")
            add_w("h27", "l")
            add_w("h27", "d")
            add_t_f("h27", 5)
            add_w("j17", "l")
            add_w("j17", "d")
            add_w("k17", "d")
            add_w("k17", "r")
            add_w("p29", "r")
            add_w("y33", "u")
            add_w("z33", "u")
            add_w("aa33", "u")
            add_w("ab33", "u")
            add_w("ab33", "r")
            add_w("p29", "u")
            add_w("p29", "l")
            add_t_f("p29", 3)
            add_w("l29", "r")
            add_w("l29", "u")
            add_w("l29", "l")
            add_t_f("l29", 4)
            add_w("n31", "r")
            add_w("n31", "d")
            add_w("n31", "l")
            add_t_f("n31", 6)
            add_t_f("n32", 8)
            add_d_w("o32", "b")
            add_w("p32", "d")
            add_d_w("q32", "f")
            add_d_w("m32", "f")
            add_w("l32", "d")
            add_d_w("k32", "b")
            add_lock("n34")
            add_w("n35", "l")
            add_w("n35", "d")
            add_w("n35", "r")
            add_w("m35", "d")
            add_w("m35", "l")
            add_t_f("m35", 9)
            add_w("o35", "r")
            add_w("o35", "d")
            add_w("y28", "l")
            add_w("y28", "d")
            add_w("aa30", "u")
            add_w("aa30", "l")
            add_w("v34", "r")
            add_w("v34", "d")
            add_w("u35", "u")
            add_w("u35", "l")
            add_key("u35")
            add_w("v35", "r")
            add_w("v35", "d")
            add_w("v36", "l")
            add_w("u36", "l")
            add_w("u37", "l")
            add_w("u37", "d")
            add_w("v37", "d")
            add_w("v37", "r")
            add_w("w37", "d")
            add_w("x37", "d")
            add_w("y37", "d")
            add_w("z37", "d")
            add_w("z37", "r")
            add_w("z36", "r")
            add_w("z36", "u")
            add_w("y36", "u")
            add_w("y36", "l")
            add_w("y35", "l")
            add_w("x35", "d")
            add_w("w35", "d")
            add_w("w34", "u")
            add_w("x34", "u")
            add_w("y34", "u")
            add_w("z34", "u")
            add_w("z34", "r")
            --add_w("ab34", "u")
            add_w("ab34", "r")
            add_w("ab35", "r")
            add_lock("ab34")
            add_w("ab36", "r")
            add_w("ab36", "d")
            add_w("aa36", "d")
            add_w("aa35", "d")
            add_w("aa35", "r")
            add_t_f("o35", 10)
            add_t_f("x35", 12)
            add_t_f("y36", 11)
            add_t_f("n35", 11)
            add_t_f("v35", 13)
            add_w("s34", "u")
            add_w("s34", "r")
            add_w("s34", "d")
            add_w("i34", "u")
            add_w("i34", "l")
            add_w("i34", "d")
            add_t_f("i34", 13)
            add_t_f("s34", 12)
        end
    },
    
    { 
        number = 21,
        setup = function() -- 21
            visible_grid_size = 43
            
            start_x = 0
            start_y = 0
            
            player_x = 23
            player_y = 12
            
            finish_x = 35
            finish_y = 40
            
            
            
            add_w("o11", "u")
            add_w("o11", "l")
            add_w("l22", "l")


            
            add_w("u21", "r")
            add_s_f("ak15", show_tip("", false), nil, "tip")
            add_s_f("ak16", show_tip("A", false), nil, "tip")
            add_s_f("ak17", show_tip("A", false), nil, "tip")
            add_s_f("ak18", show_tip("A", false), nil, "tip")
            add_s_f("ak19", show_tip("A", false), nil, "tip")
            add_s_f("ak20", show_tip("A", false), nil, "tip")
            add_s_f("ak21", show_tip("A", false), nil, "tip")
            add_s_f("ak22", show_tip("A", false), nil, "tip")
            add_s_f("ak23", show_tip("A", false), nil, "tip")
            add_s_f("ak24", show_tip("A", false), nil, "tip")
            add_s_f("ak25", show_tip("A", false), nil, "tip")
            add_s_f("ak26", show_tip("A", false), nil, "tip")
            add_s_f("ak27", show_tip("A", false), nil, "tip")
            add_s_f("ak28", show_tip("A", false), nil, "tip")
            add_s_f("ak29", show_tip("A", false), nil, "tip")
            add_s_f("ak30", show_tip("A", false), nil, "tip")
            add_s_f("ak31", show_tip("", false), nil, "tip")
            
            
            
            add_s_f("ae5", show_tip("Порада тут", false), nil, "tip")
            -- add_s_f("ai4", show_tip("Порада тут", false), nil, "tip")
            add_key("o42")
            add_key("al40")
            
            add_s_f("ak42", show_tip("Порада тут", false), nil, "tip")
            
            
            add_lock("ag4")
            add_lock("ag6")
            
            
            
            add_w("ah22", "u")
            add_w("ah22", "r")
            add_t_f("ah22", 6)
            add_w("x16", "l")
            
            
            
            add_w("i4", "u")
            add_w("i4", "l")
            add_w("k4", "u")
            add_w("k4", "r")
            add_w("k4", "d")
            add_t_f("k4", 22)
            add_w("i6", "l")
            add_w("i6", "d")
            add_w("n4", "u")
            add_w("n4", "l")
            add_w("o6", "u")
            add_w("o6", "l")
            add_w("o6", "d")
            add_t_f("o6", 21)
            add_w("n8", "r")
            add_w("n8", "u")
            add_w("n8", "l")
            add_w("p8", "u")
            add_w("p8", "l")
            add_t_f("n8", 20)
            add_w("r6", "r")
            add_w("r6", "d")
            add_t_f("r6", 9)
            add_w("s6", "u")
            add_w("r3", "r")
            add_w("r3", "u")
            add_w("r3", "l")
            add_t_f("r3", 20)
            add_w("u6", "r")
            add_w("u6", "u")
            add_w("u8", "r")
            add_w("u8", "d")
            add_w("u8", "l")
            add_t_f("u8", 14)
            add_w("t8", "u")
            add_w("t8", "l")
            add_t_f("t8", 11)
            add_w("s9", "u")
            add_w("s9", "l")
            add_w("s9", "d")
            add_t_f("s9", 3)
            add_w("v7", "r")
            add_w("v7", "d")
            add_w("w7", "u")
            add_d_w("y8", "b")
            add_w("w10", "u")
            add_w("w10", "r")
            add_w("w10", "d")
            add_t_f("w10", 2)
            add_w("u10", "r")
            add_w("u10", "u")
            add_w("u10", "l")
            add_t_f("u10", 2)
            add_w("w12", "u")
            add_w("w12", "r")
            add_w("t12", "u")
            add_w("t12", "l")
            add_w("t12", "d")
            add_t_f("t12", 1)
            add_w("t14", "r")
            add_w("t14", "u")
            add_w("t14", "l")
            add_t_f("t14", 1)
            add_d_w("t16", "b")
            add_w("v15", "l")
            add_w("v15", "d")
            add_w("v15", "r")
            add_t_f("v15", 3)
            add_w("w14", "r")
            add_w("w14", "d")
            add_w("y15", "r")
            add_w("y15", "d")
            add_w("x16", "r")
            add_w("x17", "r")
            add_w("x17", "d")
            add_w("x17", "l")
            add_t_f("x17", 4)
            add_w("w18", "r")
            add_w("w18", "d")
            add_w("u20", "r")
            add_w("u20", "u")
            add_w("u20", "l")
            add_t_f("u20", 5)
            add_w("t20", "u")
            add_w("t20", "l")
            add_t_f("t20", 4)
            add_w("s20", "d")
            add_w("s19", "u")
            add_w("s19", "l")
            add_w("r21", "u")
            add_w("r21", "l")
            add_w("r22", "l")
            add_w("r22", "d")
            add_w("s22", "d")
            add_w("t23", "l")
            add_w("t23", "d")
            add_t_f("t23", 6)
            add_w("u23", "d")
            add_w("u23", "r")
            add_w("u22", "r")
            add_w("u22", "u")
            add_w("t22", "u")
            add_w("r24", "l")
            add_w("q24", "d")
            add_w("x20", "r")
            add_w("x20", "u")
            add_w("x20", "l")
            add_t_f("x20", 7)
            add_t_f("x22", 5)
            add_key("z22")
            add_key("x24")
            add_w("ab22", "u")
            add_w("ab22", "r")
            add_w("ab22", "d")
            add_t_f("ab22", 8)
            add_w("x26", "r")
            add_w("x26", "d")
            add_w("x26", "l")
            add_t_f("x26", 9)
            add_w("w27", "u")
            add_w("w27", "l")
            add_w("y27", "u")
            add_w("y27", "r")
            add_w("z28", "u")
            add_w("q23", "r")
            add_w("z28", "r")
            add_w("ab29", "u")
            add_w("ab29", "r")
            add_w("ad30", "u")
            add_w("ad30", "r")
            add_w("ag31", "r")
            add_w("ag31", "d")
            add_w("ag31", "l")
            add_t_f("ag31", 8)
            add_w("aa31", "u")
            add_w("aa31", "r")
            add_w("aa32", "r")
            add_w("aa32", "d")
            add_w("z33", "r")
            add_w("z33", "d")
            add_w("ab33", "r")
            add_w("ab33", "d")
            add_w("ab34", "l")
            add_w("z32", "u")
            add_w("z32", "l")
            add_w("y33", "u")
            add_d_w("x33", "f")
            add_w("u33", "u")
            add_w("u33", "l")
            add_w("v32", "u")
            add_w("v32", "l")
            add_w("s32", "d")
            add_w("s32", "l")
            add_w("r31", "d")
            add_w("r31", "l")
            add_w("p30", "u")
            add_w("p30", "l")
            add_w("q29", "u")
            add_w("q29", "l")
            add_w("r27", "l")
            add_w("r27", "d")
            add_w("s34", "u")
            add_w("s34", "r")
            add_w("t35", "l")
            add_w("t35", "d")
            add_w("u36", "l")
            add_w("u36", "d")
            add_w("w36", "u")
            add_w("w36", "r")
            add_w("w36", "d")
            add_t_f("w36", 7)
            add_d_w("x37", "b")
            add_d_w("x39", "b")
            add_d_w("aa39", "f")
            add_d_w("aa37", "f")
            add_w("ad37", "r")
            add_w("ad37", "d")
            add_w("ad38", "r")
            add_w("ac40", "u")
            add_w("ac40", "l")
            add_w("ac40", "d")
            add_w("ac41", "d")
            add_w("ac41", "l")
            add_w("ad42", "r")
            add_w("ad42", "d")
            -- add_key("ae40")
            add_lock("af40")
            add_w("ah40", "u")
            add_w("ah40", "r")
            add_w("ah40", "d")
            add_t_f("ac40", 17)
            add_t_f("ac41", 16)
            add_t_f("ah40", 18)
                                add_t_f("ai4", 30)
            add_t_f("aj40", 22)
            add_t_f("ak40", 24)
            add_w("ai40", "d")
            add_w("ai40", "r")
            add_w("aj40", "d")
            add_w("aj40", "r")
            add_w("ak40", "d")
            add_w("al40", "d")
            add_w("al40", "r")
            add_w("ak42", "u")
            add_w("ak42", "r")
            add_w("ak42", "d")
            add_w("ai42", "u")
            add_w("ai42", "l")
            add_w("ai42", "d")
            add_t_f("ai42", 28)
            add_w("s37", "l")
            add_w("s37", "d")
            add_w("q36", "r")
            add_w("q36", "d")
            add_w("p37", "r")
            add_w("p37", "d")
            add_w("o38", "r")
            add_w("o38", "d")
            add_w("n39", "r")
            add_w("n39", "d")
            add_w("m40", "d")
            add_w("m40", "r")
            add_w("l40", "d")
            add_w("k40", "d")
            add_w("k40", "l")
            add_w("j39", "l")
            add_w("j39", "d")
            add_w("j41", "d")
            add_w("j41", "l")
            add_w("i40", "d")
            add_w("i40", "l")
            add_w("h39", "d")
            add_w("h39", "l")
            add_w("i38", "d")
            add_w("i38", "l")
            add_w("n42", "l")
            add_w("n42", "d")
            add_w("n42", "r")
            add_t_f("n42", 18)
            add_t_f("s42", 28)
            add_lock("v42")
            add_w("o41", "d")
            add_w("o41", "r")
            add_w("p40", "d")
            add_w("p40", "r")
            add_w("q39", "d")
            add_w("q39", "r")
            add_w("r39", "u")
            add_w("i34", "u")
            add_w("i34", "l")
            add_w("h35", "u")
            add_w("h35", "l")
            add_w("h32", "u")
            add_w("h32", "l")
            add_w("h32", "d")
            add_t_f("h32", 16)
            add_w("h31", "u")
            add_w("h31", "l")
            add_t_f("h31", 17)
            add_w("k37", "l")
            add_w("k37", "d")
            add_w("l38", "l")
            add_w("l38", "d")
            add_w("m38", "u")
            add_w("m38", "l")
            add_w("n37", "u")
            add_w("n37", "l")
            add_w("o36", "u")
            add_w("o36", "l")
            add_w("o35", "r")
            add_w("k30", "l")
            add_w("k30", "d")
            add_w("k30", "r")
            add_t_f("k30", 12)
            add_w("l29", "d")
            add_w("l29", "r")
            add_w("m28", "d")
            add_w("m28", "r")
            add_w("n27", "d")
            add_w("n27", "r")
            add_w("n26", "r")
            add_w("n26", "r")
            add_w("n25", "r")
            add_w("n25", "u")
            add_w("m24", "u")
            add_w("m24", "r")
            add_w("l23", "u")
            add_w("l23", "r")
            add_w("j23", "l")
            add_w("j23", "d")
            add_w("k24", "d")
            add_w("k24", "l")
            add_w("l25", "d")
            add_w("l25", "l")
            add_w("l26", "r")
            add_w("l26", "d")
            add_w("k27", "r")
            add_w("k27", "d")
            add_w("j28", "r")
            add_w("j28", "d")
            add_w("j29", "l")
            add_w("i20", "u")
            add_w("i20", "l")
            add_w("i20", "d")
            add_t_f("i20", 23)
            add_w("j19", "r")
            add_w("j19", "u")
            add_w("j19", "l")
            add_t_f("j19", 19)
            add_w("j18", "l")
            add_w("j18", "r")
            add_t_f("j18", 21)
            add_w("k18", "u")
            add_w("j16", "u")
            add_w("j16", "l")
            add_w("ag22", "r")
            add_w("ag22", "u")
            add_w("ag22", "l")
            add_t_f("ag22", 15)
            add_w("ag25", "d")
            add_w("ag25", "r")
            add_w("ah25", "d")
            add_w("ad19", "r")
            add_w("ad19", "d")
            add_w("ad16", "r")
            add_w("ad16", "d")
            add_w("ad16", "l")
            add_t_f("ad16", 12)
            add_w("ad13", "u")
            add_w("ad13", "l")
            add_w("ae13", "d")
            add_w("ae13", "r")
            add_w("af12", "d")
            add_w("af12", "r")
            add_w("ag11", "u")
            add_w("ag11", "r")
            add_w("ag11", "d")
            add_w("ag10", "r")
            add_w("ah9", "u")
            add_w("ah9", "r")
            add_w("ah9", "d")
            add_w("ag8", "u")
            add_w("ag8", "r")
            add_w("ag7", "r")
            add_w("af7", "u")
            add_w("af7", "r")
            add_w("ae6", "u")
            add_w("ae6", "r")
            add_w("ae5", "r")
            add_w("ad5", "u")
            add_w("ad5", "r")
            add_w("ac4", "u")
            add_w("ac4", "r")
            add_w("ac6", "d")
            add_w("ac6", "l")
            add_w("ad7", "d")
            add_w("ad7", "l")
            add_w("ae8", "d")
            add_w("ae8", "l")
            add_w("ae10", "u")
            add_w("ae10", "l")
            add_w("ae10", "d")
            add_w("ae11", "l")
            add_w("ad12", "u")
            add_w("ad12", "l")
            add_w("ad12", "d")
            add_w("ad13", "l")
            add_lock("ag5")
            add_w("ag3", "r")
            add_w("ag3", "u")
            add_w("ag3", "l")
            add_w("ae3", "r")
            add_w("ae3", "u")
            add_w("ae3", "l")
            add_w("ai4", "u")
            add_w("ai4", "l")
            add_w("aj4", "l")
            add_w("aj4", "u")
            add_w("aj4", "r")
            add_w("ak3", "r")
            add_w("ak3", "u")
            add_w("ak3", "l")
            add_w("al4", "r")
            add_w("al4", "u")
            add_w("al4", "l")
            add_t_f("ad8", 14)
            add_t_f("ah9", 11)
            add_t_f("ad12", 15)
            add_t_f("ae10", 10)
            add_t_f("ag11", 10)
            add_t_f("ag7", 30)
            add_t_f("ae3", 27)
            add_t_f("ag3", 26)
            add_t_f("aj4", 23)
            add_t_f("ak3", 27)
            add_t_f("al4", 26)
            add_w("y4", "u")
            add_w("y4", "l")
            add_w("y4", "d")
            add_t_f("y4", 19)
            add_w("v2", "r")
            add_w("v2", "u")
            add_w("v2", "l")
            add_t_f("v2", 24)
            
            
            
            
            
            
        end
    },
    
    { 
        number = 22,
        setup = function() -- 22
            visible_grid_size = 42
            
            
            start_x = 0
            start_y = 0
            
            player_x = 27
            player_y = 7
            
            finish_x = 10
            finish_y = 19

            if maze_difficulty_is == 'easy' then
                add_s_f("ad31", set_checkpoint, nil, "checkpoint")
            elseif maze_difficulty_is ~= 'easy' then
                add_s_f("ad31", show_tip("CHECKPOINT! But... No, it was just a joke. Sorry.\n", false), nil, "tip")
            end
            
            add_s_f("ae31", show_tip("You was almost there... Almost.", false), nil, "tip")
            

            add_key("ag40")
            add_lock("k14")
            add_w("k39", "d")
            add_w("k39", "l")
            add_w("j38", "r")
            add_w("j38", "d")
            add_w("j38", "l")
            add_w("i37", "d")
            add_w("i37", "l")
            add_key("j36")
            add_key("j34")
            add_w("j32", "r")
            add_w("j32", "u")
            add_w("j32", "l")
            add_t_f("j32", 3)
            add_w("i33", "u")
            add_w("i33", "l")
            add_w("h32", "l")
            add_w("h32", "d")
            add_w("l38", "u")
            add_w("l38", "l")
            add_w("l38", "d")
            add_t_f("l38", 4)
            add_w("n38", "d")
            add_w("n38", "r")
            add_w("o37", "d")
            add_w("o37", "r")
            add_lock("r37")
            add_w("r35", "u")
            add_w("r35", "r")
            add_w("p34", "r")
            add_w("p34", "d")
            add_w("p34", "l")
            add_t_f("p34", 2)
            add_w("q33", "r")
            add_w("q33", "d")
            add_t_f("q33", 4)
            add_w("o33", "d")
            add_w("o33", "l")
            add_t_f("o33", 3)
            add_w("n33", "u")
            add_w("o35", "u")
            add_w("o35", "l")
            add_w("p30", "r")
            add_w("p30", "u")
            add_w("p30", "l")
            add_t_f("p30", 1)
            add_w("p28", "r")
            add_w("p28", "u")
            add_w("p28", "l")
            add_t_f("p28", 2)
            add_w("q29", "r")
            add_w("q29", "u")
            add_w("o29", "u")
            add_w("o29", "l")
            add_w("n29", "d")
            add_w("m28", "d")
            add_w("m28", "l")
            add_w("k29", "d")
            add_w("k29", "l")
            add_lock("k25")
            add_w("l26", "d")
            add_w("l26", "l")
            add_w("m26", "r")
            add_w("m26", "u")
            add_w("l24", "u")
            add_w("l24", "l")
            add_w("n24", "u")
            add_w("n24", "r")
            add_w("o25", "r")
            add_w("o25", "d")
            add_w("o26", "l")
            add_w("q26", "r")
            add_w("q26", "u")
            add_w("u26", "u")
            add_w("u26", "l")
            add_w("t24", "u")
            add_w("t24", "l")
            add_lock("w23")
            add_w("i25", "u")
            add_w("i25", "l")
            add_w("i25", "d")
            add_t_f("i25", 6)
            add_w("i26", "l")
            add_w("h22", "u")
            add_w("h22", "l")
            add_w("j22", "u")
            add_w("j22", "r")
            add_w("j21", "l")
            add_w("j19", "r")
            add_w("j19", "u")
            add_w("j19", "l")
            add_w("u28", "r")
            add_w("u28", "d")
            add_w("u29", "l")
            add_w("v28", "u")
            add_w("u31", "d")
            add_w("u31", "l")
            add_lock("x31")
            add_w("y32", "r")
            add_w("y32", "u")
            add_w("z32", "d")
            add_w("z35", "u")
            add_w("z35", "l")
            add_w("ab33", "d")
            add_w("ab33", "l")
            add_w("ad33", "d")
            add_w("ad33", "r")
            add_w("ad31", "r")
            add_w("ad31", "u")
            add_w("ad31", "l")
            add_w("ae32", "r")
            add_w("ae32", "u")
            add_w("ag32", "u")
            add_w("ag32", "l")
            add_w("ah32", "d")
            add_w("ah32", "r")
            add_w("ab31", "r")
            add_w("ab31", "u")
            add_w("z29", "r")
            add_w("z29", "u")
            add_key("aa28")
            add_w("ac28", "u")
            add_w("ac28", "r")
            add_w("ac28", "d")
            add_w("y28", "u")
            add_w("y28", "l")
            add_w("ab25", "d")
            add_w("ab25", "l")
            add_w("aa24", "d")
            add_w("aa24", "r")
            add_w("ad26", "r")
            add_w("ad26", "u")
            add_w("ag25", "d")
            add_w("ag25", "r")
            add_key("ag21")
            add_w("ag20", "u")
            add_w("ag20", "r")
            add_w("ag20", "d")
            add_t_f("ag20", 6)
            add_w("ad21", "r")
            add_w("ad21", "u")
            add_w("aa21", "u")
            add_w("aa21", "l")
            add_w("ab20", "u")
            add_w("ab20", "l")
            add_lock("x20")
            add_w("o21", "r")
            add_w("o21", "u")
            add_lock("q22")
            add_w("r40", "d")
            add_w("r40", "l")
            add_w("u40", "d")
            add_w("u40", "r")
            add_w("v39", "d")
            add_w("v39", "r")
            add_w("x39", "d")
            add_w("x39", "l")
            add_w("y40", "d")
            add_w("y40", "l")
            add_key("w40")
            add_w("w41", "d")
            add_w("w41", "l")
            add_w("w37", "u")
            add_w("w37", "l")
            add_w("w37", "d")
            add_t_f("w37", 1)
            add_lock("z38")
            add_w("ae35", "d")
            add_w("ae35", "r")
            add_w("af38", "d")
            add_w("ag38", "d")
            add_w("ag38", "r")
            add_w("ag39", "d")
            add_w("ag39", "l")
            add_w("ag40", "r")
            add_w("ag40", "d")
            add_w("af41", "d")
            add_w("af41", "r")
            add_w("ah28", "u")
            add_w("ah28", "r")
            add_lock("ab15")
            add_lock("y16")
            add_lock("x14")
            add_lock("u17")
            add_lock("t13")
            add_lock("p15")
            add_lock("w10")
            add_lock("v7")
            add_lock("s6")
            add_lock("ac5")
            add_lock("ad3")
            add_lock("ab7")
            add_lock("w4")
            add_lock("x2")
            add_lock("t2")
            add_lock("o8")
            
        end
    },

    {
        number = 23,
        setup = function() -- 23
            visible_grid_size = 57
            
            start_x = 0
            start_y = 0
            
            player_x = 6
            player_y = 11
            
            finish_x = 54
            finish_y = 38
            
            add_w("aq30", "d")
            add_w("aq30", "l")
            add_t_f("af24", 18)
            add_t_f("b10", 21)
            
            
            add_w("e3", "u")
            add_w("e3", "r")
            add_w("h2", "d")
            add_w("h2", "l")
            add_w("h4", "d")
            add_w("h4", "l")
            add_w("k4", "u")
            add_w("k4", "r")
            add_w("k7", "r")
            add_w("k7", "d")
            add_t_f("i7", 4)
            add_w("i8", "u")
            add_w("i8", "r")
            add_w("i8", "d")
            add_w("i8", "l")
            add_w("g7", "u")
            add_w("g7", "l")
            add_w("f8", "u")
            add_w("f8", "l")
            add_w("d10", "u")
            add_w("d10", "l")
            add_w("b10", "r")
            add_w("b10", "u")
            add_w("b10", "l")
            add_w("c7", "d")
            add_w("c7", "r")
            add_w("l9", "d")
            add_w("l9", "r")
            add_w("m9", "u")
            add_w("i11", "u")
            add_w("i11", "r")
            add_w("i11", "d")
            add_t_f("i11", 1)
            add_s_f("f11", show_tip("Порада тут", false), nil, "tip")
            add_w("f14", "d")
            add_w("f14", "l")
            add_w("h15", "l")
            add_w("h15", "d")
            add_w("h15", "r")
            add_t_f("h15", 3)
            add_w("i14", "u")
            add_w("i14", "r")
            add_w("i14", "d")
            add_t_f("i14", 2)
            add_w("l15", "d")
            add_w("l15", "r")
            add_w("n16", "u")
            add_w("n16", "l")
            add_w("g18", "u")
            add_w("g18", "l")
            add_w("d17", "u")
            add_w("d17", "l")
            add_w("d16", "l")
            add_w("l20", "l")
            add_w("l21", "r")
            add_w("l21", "u")
            add_w("l21", "l")
            add_t_f("l21", 2)
            add_w("k21", "u")
            add_w("k21", "l")
            add_t_f("k21", 1)
            add_w("m21", "u")
            add_w("m21", "r")
            add_t_f("m21", 3)
            add_w("n23", "d")
            add_w("n23", "l")
            add_w("o24", "d")
            add_w("o24", "l")
            add_t_f("o24", 5)
            add_w("p25", "d")
            add_w("p25", "l")
            add_w("q26", "d")
            add_w("q26", "l")
            add_w("r27", "d")
            add_w("r27", "l")
            add_w("s28", "d")
            add_w("s28", "l")
            add_w("s29", "r")
            add_w("u30", "d")
            add_w("u30", "r")
            add_w("v31", "d")
            add_w("v31", "r")
            add_w("w32", "d")
            add_w("w32", "r")
            add_w("j24", "u")
            add_w("j24", "r")
            add_w("k25", "u")
            add_w("k25", "r")
            add_w("l26", "u")
            add_w("l26", "r")
            add_w("m27", "u")
            add_w("m27", "r")
            add_w("n28", "u")
            add_w("n28", "r")
            add_w("o29", "u")
            add_w("o29", "r")
            add_w("p30", "u")
            add_w("p30", "r")
            add_w("q31", "u")
            add_w("q31", "r")
            add_w("r32", "u")
            add_w("r32", "r")
            add_w("s33", "u")
            add_w("s33", "r")
            add_w("t33", "d")
            add_w("i26", "l")
            add_w("i26", "d")
            add_t_f("i27", 6)
            add_w("j28", "u")
            add_w("j28", "r")
            add_w("j27", "l")
            add_t_f("j28", 4)
            add_w("k29", "u")
            add_w("k29", "r")
            add_w("l30", "u")
            add_w("l30", "r")
            add_w("m30", "d")
            add_w("u27", "u")
            add_w("u27", "l")
            add_w("v26", "u")
            add_w("v26", "l")
            add_w("w25", "u")
            add_w("w25", "l")
            add_w("y25", "u")
            add_w("y25", "r")
            add_w("z26", "u")
            add_w("z26", "r")
            add_w("aa27", "u")
            add_w("aa27", "r")
            add_w("x24", "d")
            add_w("x24", "r")
            add_w("x23", "r")
            add_w("x23", "u")
            add_w("w23", "d")
            add_w("w23", "l")
            add_w("w21", "u")
            add_w("w21", "r")
            add_d_w("v24", "f")
            add_d_w("u25", "f")add_w("c24", "u")
            add_w("c24", "l")
            add_w("b25", "u")
            add_w("b25", "l")
            add_w("n35", "d")
            add_w("n35", "l")
            add_w("o36", "d")
            add_w("o36", "l")
            add_w("p37", "d")
            add_w("p37", "l")
            add_w("n39", "d")
            add_w("n39", "r")
            add_w("o40", "d")
            add_w("o40", "l")
            add_w("j40", "r")
            add_w("j40", "d")
            add_d_w("j39", "b")
            add_d_w("i41", "f")
            add_w("e41", "d")
            add_w("e41", "l")
            add_d_w("e40", "f")
            add_w("e39", "u")
            add_w("e39", "l")
            add_w("c41", "l")
            add_w("c41", "d")
            add_w("c41", "r")
            add_t_f("c41", 7)
            add_d_w("b40", "b")
            add_w("b37", "u")
            add_w("b37", "l")
            add_w("b36", "l")
            add_w("ab33", "u")
            add_w("ab33", "r")
            add_w("aa35", "r")
            add_w("aa35", "d")
            add_w("z36", "r")
            add_w("z36", "d")
            add_w("y37", "r")
            add_w("y37", "d")
            add_w("y38", "l")
            add_w("y40", "d")
            add_w("y40", "r")
            add_w("ab40", "r")
            add_w("ab40", "u")
            add_w("ab40", "l")
            add_w("ab38", "d")
            add_w("ab38", "r")
            add_w("r17", "u")
            add_w("r17", "r")
            add_w("q9", "u")
            add_w("q9", "r")
            add_w("q2", "r")
            add_w("q2", "d")
            add_w("q2", "l")
            add_t_f("q2", 13)
            add_w("u3", "u")
            add_w("u3", "l")
            add_w("u3", "d")
            add_t_f("u3", 16)
            add_w("v3", "u")
            add_w("v3", "r")
            add_w("v5", "d")
            add_w("v5", "l")
            add_w("w5", "d")
            add_w("x5", "d")
            add_w("x5", "r")
            add_w("x4", "u")
            add_w("x4", "l")
            add_t_f("x3", 17)
            add_w("x3", "l")
            add_w("x2", "u")
            add_w("x2", "l")
            add_w("z2", "u")
            add_w("z2", "r")
            add_w("z4", "r")
            add_w("z4", "d")
            add_w("ad38", "u")
            add_w("ad38", "l")
            add_w("ad38", "d")
            add_w("ae39", "l")
            add_w("ae39", "d")
            add_w("ae39", "r")
            add_w("af38", "d")
            add_w("af38", "r")
            add_w("ah38", "d")
            add_w("ah38", "l")
            add_w("ai39", "l")
            add_w("ai39", "d")
            add_w("ai39", "r")
            add_w("aj38", "u")
            add_w("aj38", "r")
            add_w("aj38", "d")
            add_w("ai37", "u")
            add_w("ai37", "r")
            add_w("ah36", "u")
            add_w("ag40", "l")
            add_w("ag40", "d")
            add_w("ag40", "r")
            add_w("ah36", "r")
            add_w("ag35", "u")
            add_w("ag35", "r")
            add_w("ag35", "l")
            add_w("af36", "u")
            add_w("af36", "l")
            add_w("ae37", "u")
            add_w("ae37", "l")
            add_t_f("ab40", 17)
            add_t_f("ad38", 10)
            add_t_f("ae39", 11)
            add_t_f("ag40", 12)
            add_t_f("ai39", 12)
            add_t_f("aj38", 11)
            add_t_f("ag35", 13)
            add_w("af3", "u")
            add_w("af3", "l")
            add_t_f("af3", 9)
            add_w("ag3", "u")
            add_w("ag3", "r")
            add_w("ah3", "u")
            add_w("ah3", "r")
            add_w("ah4", "r")
            add_w("ah5", "r")
            add_w("ah5", "d")
            add_w("ag5", "d")
            add_w("af5", "d")
            add_w("af5", "l")
            add_w("af5", "u")
            add_w("af4", "l")
            add_t_f("ag4", 7)
            add_t_f("ah3", 15)
            add_t_f("ah5", 16)
            add_t_f("af5", 14)
            add_d_w("ak6", "f")
            add_w("af9", "d")
            add_w("af9", "r")
            add_w("ag9", "u")
            add_w("af10", "r")
            add_w("ad10", "u")
            add_w("ad10", "l")
            add_w("ad10", "d")
            add_t_f("ad10", 15)
            add_w("aj20", "u")
            add_w("aj20", "l")
            add_w("ah20", "r")
            add_w("ah20", "u")
            add_w("ae19", "d")
            add_w("ae19", "l")
            add_w("af20", "d")
            add_w("af20", "l")
            add_w("ag21", "d")
            add_w("ag21", "l")
            add_w("ah22", "d")
            add_w("ah22", "l")
            add_w("ah23", "l")
            add_w("aj22", "d")
            add_w("aj22", "r")
            add_w("ak21", "d")
            add_w("ak21", "r")
            add_w("al20", "d")
            add_w("al20", "r")
            add_w("al18", "r")
            add_w("al18", "u")
            add_t_f("an16", 5)
            add_w("ao15", "u")
            add_w("ao15", "r")
            add_w("ao12", "r")
            add_w("ao12", "u")
            add_w("ao9", "r")
            add_w("ao9", "u")
            add_w("ap10", "r")
            add_w("ap10", "d")
            add_w("ap10", "l")
            add_t_f("ap10", 20)
            add_w("ap7", "u")
            add_w("ap7", "l")
            add_w("ar7", "u")
            add_w("ar7", "r")
            add_w("ae11", "u")
            add_w("ae11", "l")
            add_w("af12", "l")
            add_w("af12", "d")
            add_w("ag13", "d")
            add_w("ag13", "l")
            add_w("ah14", "d")
            add_w("ah14", "l")
            add_w("aj14", "r")
            add_w("aj14", "u")
            add_w("ai13", "r")
            add_w("ai13", "u")
            add_w("ah12", "r")
            add_w("ah12", "u")
            add_w("aj16", "r")
            add_w("aj16", "d")
            add_w("ai17", "r")
            add_w("ai17", "d")
            add_w("ah18", "r")
            add_w("ah18", "d")
            add_w("af18", "u")
            add_w("af18", "l")
            add_w("ag17", "u")
            add_w("ag17", "l")
            add_w("ah16", "u")
            add_w("ah16", "l")
            add_w("ae15", "l")
            add_w("ae15", "d")
            add_d_w("ad14", "f")
            add_w("aj18", "u")
            add_w("aj18", "l")
            add_w("aj18", "d")
            add_t_f("aj18", 16)
            add_t_f("aj17", 19)
            add_w("af24", "r")
            add_w("af24", "d")
            add_w("af24", "l")
            add_d_w("ad21", "b")
            add_w("ao20", "u")
            add_w("ao20", "l")
            add_w("an21", "u")
            add_w("an21", "l")
            add_w("aq5", "d")
            add_w("aq5", "l")
            add_w("aq3", "u")
            add_w("aq3", "l")
            add_d_w("as3", "f")
            add_d_w("at2", "f")
            add_w("au2", "u")
            add_w("au2", "r")
            add_w("av2", "u")
            add_d_w("av4", "b")
            add_w("aw5", "u")
            add_w("aw5", "l")
            add_w("ax4", "d")
            add_w("ax4", "l")
            add_w("ax3", "u")
            add_w("ax3", "l")
            add_w("ay3", "u")
            add_w("az2", "r")
            add_w("az2", "u")
            add_w("az2", "l")
            add_t_f("az2", 9)
            add_w("ba3", "u")
            add_w("bb3", "u")
            add_w("bb3", "r")
            add_w("ba4", "u")
            add_w("ba4", "r")
            add_w("ba5", "r")
            add_w("ba5", "d")
            add_w("az5", "d")
            add_w("az5", "l")
            add_w("ay5", "u")
            add_w("ay6", "d")
            add_w("ay6", "l")
            add_w("bb6", "d")
            add_w("bb6", "r")
            add_w("bb8", "d")
            add_w("bb8", "r")
            add_d_w("as5", "b")
            add_d_w("at4", "b")
            add_d_w("au5", "f")
            add_w("av7", "d")
            add_w("av7", "l")
            add_w("aw8", "d")
            add_w("aw8", "l")
            add_w("aj25", "u")
            add_w("aj25", "l")
            add_w("ak25", "u")
            add_w("ak25", "r")
            add_w("am24", "u")
            add_w("am24", "r")
            add_w("an24", "u")
            add_w("an28", "d")
            add_w("an28", "l")
            add_lock("ak27")
            add_w("al29", "r")
            add_w("al29", "u")
            add_w("ak30", "r")
            add_w("ak30", "d")
            add_w("aj30", "d")
            add_w("aj30", "l")
            add_w("aj29", "u")
            add_w("aj29", "l")
            add_w("ap27", "d")
            add_w("ap27", "l")
            add_w("aq26", "u")
            add_w("aq26", "l")
            add_w("as26", "u")
            add_w("as26", "r")
            add_w("at26", "u")
            add_w("at27", "d")
            add_w("at27", "l")
            add_w("au27", "d")
            add_w("au27", "r")
            add_w("av27", "u")
            add_w("aw26", "r")
            add_w("aw26", "d")
            add_w("ax25", "d")
            add_w("ax25", "r")
            add_w("ay24", "d")
            add_w("ay24", "r")
            add_w("aw24", "r")
            add_w("aw24", "u")
            add_t_f("aw24", 6)
            add_t_f("av27", 8)
            add_d_w("av24", "f")
            add_w("av25", "d")
            add_w("av25", "l")
            add_w("au24", "u")
            add_w("au24", "l")
            add_w("av23", "u")
            add_w("av23", "l")
            add_w("ax22", "u")
            add_w("ax22", "l")
            add_w("ax21", "l")
            add_w("au21", "u")
            add_w("au21", "r")
            add_w("au21", "d")
            add_w("at21", "u")
            add_w("at21", "l")
            add_w("as21", "d")
            add_w("au20", "l")
            add_w("at22", "d")
            add_w("at22", "r")
            add_w("at18", "u")
            add_w("at18", "l")
            add_w("aw18", "u")
            add_w("aw18", "r")
            add_w("ax18", "u")
            add_w("az18", "u")
            add_w("az18", "l")
            add_w("ba18", "u")
            add_w("ba18", "r")
            add_w("ba22", "u")
            add_w("ba22", "l")
            add_w("ba22", "d")
            add_t_f("ba22", 8)
            add_w("bb22", "u")
            add_w("bb22", "r")
            add_w("bb23", "r")
            add_w("bb23", "l")
            add_w("bb24", "d")
            add_w("bb24", "r")
            add_w("ba24", "d")
            add_w("ba24", "l")
            add_w("ba25", "r")
            add_w("az26", "u")
            add_w("az26", "r")
            add_w("az27", "r")
            add_w("az27", "d")
            add_w("ax27", "d")
            add_w("ax27", "r")
            add_w("av28", "r")
            add_w("av28", "d")
            add_w("au29", "u")
            add_w("au29", "l")
            add_w("au31", "l")
            add_w("au31", "d")
            add_key("aw31")
            add_key("ax31")
            add_w("az31", "d")
            add_w("az31", "r")
            add_w("bb30", "u")
            add_w("bb30", "r")
            add_w("ay29", "u")
            add_w("ay29", "l")
            add_w("aw29", "d")
            add_w("aw29", "r")
            add_lock("aw30")
            add_lock("bb34")
            add_lock("bb35")
            add_w("bb35", "r")
            add_key("ba35")
            add_s_f("bb38", call_func(blablabla, false), nil, "func")
            add_lock("aw38")
            add_w("at38", "d")
            add_w("at38", "l")
            add_w("av40", "l")
            add_w("av40", "d")
            add_w("av40", "r")
            add_t_f("av40", 10)
            add_w("as28", "d")
            add_w("as28", "l")
            add_d_w("ao33", "f")
            add_d_w("ap34", "b")
            add_d_w("am34", "f")
            add_d_w("al33", "b")
            add_w("aj34", "d")
            add_w("aj34", "l")
            add_w("ay11", "u")
            add_w("ay11", "l")
            add_w("ay11", "d")
            add_t_f("ay11", 14)
            add_w("bb12", "l")
            add_w("bb12", "u")
            add_w("bb12", "r")
            add_w("bc12", "u")
            add_w("bc12", "r")add_w("bd13", "u")
            add_w("bd13", "r")
            add_w("bd13", "d")
            add_w("bc14", "r")
            add_w("bc14", "d")
            add_w("bb14", "d")
            add_w("bb14", "l")
            add_w("ba13", "u")
            add_w("ba13", "l")
            add_w("ba13", "d")
            add_t_f("bc12", 18)
            add_t_f("bb12", 19)
            add_t_f("ba13", 23)
            add_t_f("bb14", 20)
            add_t_f("bc14", 23)
            add_t_f("bd13", 21)
            add_w("ar23", "d")
            add_w("ar23", "r")
            add_w("at24", "d") 
        end
    },

    {
        number = 24,
        setup = function() -- 24
            visible_grid_size = 13
            
            start_x = 0
            start_y = 0
            
            player_x = 4
            player_y = 5
            
            finish_x = 7
            finish_y = 4

            add_w("d5", "u")
            add_w("d5", "l")
            add_w("j5", "u")
            add_w("j5", "r")


            add_w("b2", "u")
            add_w("b2", "l")
            add_w("g5", "u")
            add_w("g5", "r")
            add_t_f("j5", 1)
            add_lock("j7")
            add_w("j9", "r")
            add_w("j9", "d")
            add_w("g9", "d")
            add_w("d9", "u")
            add_w("d9", "l")
            add_w("d9", "d")
            add_key("d9")
            add_w("b12", "d")
            add_w("b12", "l")
            add_w("l12", "d")
            add_w("l12", "r")
            add_w("l2", "u")
            add_w("l2", "r")
            add_lock("f2")
            add_lock("b8")
            add_key("l12")
            add_w("g12", "d")
            add_t_f("g10", 1)
        end
    },

    {
        number = 25,
        setup = function() -- 25
            visible_grid_size = 20
            
            start_x = 9
            start_y = 7
            
            player_x = 9
            player_y = 7
            
            finish_x = 12
            finish_y = 17

            add_w("i7", "u")
            add_w("i7", "l")
            add_w("o7", "u")
            add_w("o7", "r")
            add_w("o11", "r")
            add_w("o11", "d")
            add_s_f("o11", set_checkpoint, nil, "checkpoint")
            add_w("e11", "u")
            add_w("e11", "l")
            add_key("e11")
            add_w("e15", "d")
            add_w("e15", "l")
            add_lock("e15")
            add_w("r15", "r")
            add_key("r15")
            add_w("r5", "r")
            add_w("r5", "u")
            add_w("r5", "l")
            add_key("r5")
            add_lock("r8")
            add_w("r17", "r")
            add_w("r17", "d")
            add_lock("o17")

        end
    },

    {
        number = 26,
        setup = function() -- 26
            visible_grid_size = 20
            
            start_x = 9
            start_y = 7
            
            player_x = 9
            player_y = 7
            
            finish_x = 13
            finish_y = 18
        end
    },

    {
        number = 27,
        setup = function() -- 27
            visible_grid_size = 20
            
            start_x = 9
            start_y = 7
            
            player_x = 9
            player_y = 7
            
            finish_x = 14
            finish_y = 19
        end
    },

    {
        number = 28,
        setup = function() -- 28
            visible_grid_size = 20
            
            start_x = 9
            start_y = 7
            
            player_x = 9
            player_y = 7
            
            finish_x = 15
            finish_y = 20
        end
    },

    {
        number = 29,
        setup = function() -- 29
            visible_grid_size = 20
            
            start_x = 9
            start_y = 7
            
            player_x = 9
            player_y = 7
            
            finish_x = 16
            finish_y = 21
        end
    },

    {
        number = 30,
        setup = function() -- 30
            visible_grid_size = 20
            
            start_x = 9
            start_y = 7
            
            player_x = 9
            player_y = 7
            
            finish_x = 17
            finish_y = 22
        end
    },
    














    { 
        number = 99,
        setup = function() -- level select
            visible_grid_size = 10
            
            start_x = 5
            start_y = 6

            player_x = 5
            player_y = 6

            finish_x = 0
            finish_y = 0

            add_w("b3", "l")
            add_w("b2", "u")
            add_w("g8", "u")
            add_w("e2", "d")
            add_w("e2", "r")
            
            add_w("b6", "l")
            add_w("b7", "d")
            add_w("a7", "r")



                                        add_s_f("e1", function() 
                                            current_level = 1
                                            load_level(1)
                                            game_state = "level_selected"
                                        end, 1)
                                        
                                        add_s_f("a6", function() 
                                            current_level = 2
                                            load_level(2) 
                                            game_state = "level_selected"
                                        end, 2)
                                        
                                        add_s_f("e10", function() 
                                            current_level = 3
                                            load_level(3) 
                                            game_state = "level_selected"
                                        end, 3)
            
            
            
            
            
        end

    }
}









-------------------------------------------------------------------------------------------------------------------------- LEVEL POINTS

function add_s_f(coord, func, level_number, field_type)
    local x, y = coord_to_index(coord)
    table.insert(special_fields, {x = x, y = y, func = func, number = level_number, type = field_type, shown = false, player_standing = false})
end

function draw_special_fields(cell_size)
    local field_size = cell_size * 0.7
    local offset = (cell_size - field_size) / 2

    for _, field in ipairs(special_fields) do
        if visible_grid_size > 0 and visible_grid_size <= 10 then
            gfx.setfont(1, "Iregula", 35)
            speak_font_size = 0.4
            flashlight_size = 4
        elseif visible_grid_size >= 11 and visible_grid_size <= 20 then
            gfx.setfont(1, "Iregula", 27)
            speak_font_size = 0.4
            flashlight_size = 7
        elseif visible_grid_size >= 21 and visible_grid_size <= 30 then
            gfx.setfont(1, "Iregula", 22)
            speak_font_size = 0.7
            flashlight_size = 10
        elseif visible_grid_size >= 31 and visible_grid_size <= 40 then
            gfx.setfont(1, "Iregula", 17)
            speak_font_size = 0.8
            flashlight_size = 14
        elseif visible_grid_size >= 41 and visible_grid_size <= 50 then
            gfx.setfont(1, "Iregula", 14)
            speak_font_size = 1.1
            flashlight_size = 17
        elseif visible_grid_size >= 51 and visible_grid_size <= 60 then
            gfx.setfont(1, "Iregula", 12)
            speak_font_size = 1.3
            flashlight_size = 20
        else
            gfx.setfont(1, "Iregula", 8)
        end

        if field.type == 'death' then
            --gfx.set(1, 0, 0) 
            --gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)

            -- gfx.setfont(1, "Iregula", 30)
            gfx.set(1, 0.4, 0.4)
            local text = "X"
            local text_width = gfx.measurestr(text)
            gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
            gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
            gfx.drawstr(text)
        elseif field.type == 'tip' then
            if game_state == "level_transition" then
                gfx.set(0, 0.5, 0.5)
                gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)

                gfx.set(0.8, 0.8, 0.8)
                local text = "t"
                local text_width = gfx.measurestr(text)
                gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
                gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
                gfx.drawstr(text)
            end
        elseif field.type == 'func' then
            gfx.set(0, 0, 0.5)
            gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)

            gfx.set(0.8, 0.8, 0.8)
            local text = "f"
            local text_width = gfx.measurestr(text)
            gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
            gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
            gfx.drawstr(text)
        elseif field.type == 'lock' then
            if field == current_lock and is_unlocking then
                gfx.set(0.8, 0, 0)
            elseif field.locked then
                gfx.set(0.8, 0, 0)  -- red
            else
                gfx.set(0, 0.5, 0)  -- gr
            end

            gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)

            local text = "L"
            gfx.set(0.9, 0.9, 0.9) -- wt

            if field == current_lock and is_unlocking then
                text = "L"
            else
                text = "L"
            end

            local text_width = gfx.measurestr(text)
            gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
            gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
            gfx.drawstr(text)
        elseif field.type == 'lock2' then
                local thickness = math.max(2, cell_size * 0.1) 
                local pad = thickness / 2 

                if field.locked then
                    gfx.set(0.2, 0.2, 0.2)
                else
                    gfx.set(0, 0.5, 0)
                end

                gfx.rect((field.x - 1) * cell_size + offset + pad, 
                        (field.y - 1) * cell_size + offset + cell_size * 0.1, 
                        thickness, field_size / 2, true)

                gfx.rect((field.x - 1) * cell_size + offset + pad, 
                        (field.y - 1) * cell_size + offset + cell_size * 0.2 - thickness, 
                        field_size - 2 * pad, thickness, true)

                gfx.rect((field.x - 1) * cell_size + offset + field_size - thickness - pad, 
                        (field.y - 1) * cell_size + offset + cell_size * 0.1, 
                        thickness, field_size / 2, true)

                gfx.rect((field.x - 1) * cell_size + offset, 
                        (field.y - 1) * cell_size + offset + 0.4 * cell_size, 
                        field_size, field_size - 0.35 * cell_size, true)

                gfx.set(0.8, 0.8, 0.8) 
                local circle_x = (field.x - 1) * cell_size + offset + field_size / 2
                local circle_y = (field.y - 1) * cell_size + offset + 0.75 * field_size
                gfx.circle(circle_x, circle_y, thickness, true) 
        elseif field.type == 'key' then
                gfx.set(1, 1, 0)  
                gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)

                gfx.set(0.2, 0.2, 0.2)  
                local text = "K"
                local text_width = gfx.measurestr(text)
                gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
                gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
                gfx.drawstr(text)
        elseif field.type == 'checkpoint' then
                gfx.set(1, 0.4, 0)
                gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)
            
                gfx.set(0.9, 0.9, 0.9)
                local text = "C"
                local text_width = gfx.measurestr(text)
                gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
                gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
                gfx.drawstr(text)
            
        else
            gfx.set(0.5, 0.5, 0.5)
            gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)

            if field.number then
                gfx.setfont(1, "Iregula", 20)
                gfx.set(0.9, 0.9, 0.9)
                local text = tostring(field.number)
                local text_width = gfx.measurestr(text)
                gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
                gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
                gfx.drawstr(text)
            end
        end
    end
end

function show_tip(message, show_once)
    return function(field, player_on_field)
        if player_on_field then
            if (not show_once or not field.shown) and not field.player_standing then
                reaper.ShowConsoleMsg(message .. "\n\n")
                field.shown = true
                field.player_standing = true
            end
        else
            field.player_standing = false
        end
    end
end

function call_func(func, show_once)
    return function(field, player_on_field)
        if player_on_field then
            if (not show_once or not field.shown) and not field.player_standing then
                func()
                field.shown = true
                field.player_standing = true
            end
        else
            field.player_standing = false
        end
    end
end

function add_lock(coord)
    local x, y = coord_to_index(coord)
    table.insert(special_fields, {x = x, y = y, type = 'lock', locked = true})
end

function is_locked_lock_at(x, y)
    for _, field in ipairs(special_fields) do
        if field.x == x and field.y == y and field.type == 'lock' and field.locked then
            return field
        end
    end
    return nil
end

function update_lock_timer()
    if is_unlocking and current_lock then
        local elapsed = reaper.time_precise() - lock_timer
        if elapsed >= lock_delay then
            current_lock.locked = false
            i_found_key = i_found_key - 1
            is_unlocking = false
            current_lock = nil
            player_x = player_x + move_dx
            player_y = player_y + move_dy
        end
    end
end

function add_key(coord)
    local x, y = coord_to_index(coord)
    table.insert(special_fields, {x = x, y = y, type = 'key'})
end

function draw_key_count()
    gfx.setfont(1, "Iregula", 30)
    gfx.set(1, 1, 0)  -- yellow
    local text = "Keys: " .. i_found_key
    gfx.x = 10
    gfx.y = 10
    gfx.drawstr(text)
end



function blablabla()
    -- reaper.ShowConsoleMsg("хохохо\n")
end

function what_player_speak()
    local function i_m_here()
        local player_moved = update_player_console_position()

        if reaper.time_precise() - last_timer_check >= 5 and maze_difficulty_is == 'easy' then
            last_timer_check = reaper.time_precise()
            if reaper.time_precise() - last_player_move_time >= 15 and not player_speak then
                player_speak = "I'm here!"
                speak_timer = reaper.time_precise() + speak_duration
            end
        elseif reaper.time_precise() - last_timer_check >= 5 and maze_difficulty_is == 'medium' then
            last_timer_check = reaper.time_precise()
            if reaper.time_precise() - last_player_move_time >= 30 and not player_speak then
                player_speak = "I'm here!"
                speak_timer = reaper.time_precise() + speak_duration
            end
        end
    end

    i_m_here()
end


function check_special_fields(player_x, player_y)
    local fields_to_remove = {}

    for idx, field in ipairs(special_fields) do
        local player_on_field = (player_x == field.x and player_y == field.y)

        if player_on_field then
            if field.type == 'death' then
                field.func(field, player_on_field) 
                return
            elseif field.type == 'key' then
                i_found_key = i_found_key + 1

                player_speak = "FOUND KEY!"
                speak_timer = reaper.time_precise() + speak_duration

                table.insert(fields_to_remove, idx)
            elseif field.type == 'lock' then
                -- do nothing
            elseif field.type == 'checkpoint' then
                field.func(field, player_on_field)
            else
                field.func(field, player_on_field)
            end
        else
            if field.func then
                field.func(field, player_on_field)
            end
        end
    end

    for i = #fields_to_remove, 1, -1 do
        table.remove(special_fields, fields_to_remove[i])
    end

    check_teleport(player_x, player_y)
end



function clear_special_fields()
    special_fields = {} 
end




-------------------------------------------------------------------------------------------------------------------------- TELEP POINTS

function add_t_f(coord, number)
    local x, y = coord_to_index(coord)
    table.insert(teleport_fields, {x = x, y = y, number = number})
end

function check_teleport()
    if is_teleporting then return false end

    for _, field in ipairs(teleport_fields) do
        if player_x == field.x and player_y == field.y then
            for _, target_field in ipairs(teleport_fields) do
                if target_field.number == field.number and (target_field.x ~= field.x or target_field.y ~= field.y) then
                    is_teleporting = true
                    teleport_destination = {x = target_field.x, y = target_field.y}
                    move_dx = 0  
                    move_dy = 0  
                    is_moving = false
                    fade_direction = "out"
                    is_fading = true
                    -- player_speak = "TELEPORTING..."
                    -- speak_timer = reaper.time_precise() + speak_duration
                    return true
                end
            end
        end
    end
    return false  
end



function draw_teleport_fields(cell_size)
    local field_size = cell_size * 0.7
    local offset = (cell_size - field_size) / 2

    if game_state ~= "level_transition" then
        for _, field in ipairs(teleport_fields) do
            gfx.set(0.784, 0.784, 0.784)
            gfx.rect((field.x - 1) * cell_size + offset, (field.y - 1) * cell_size + offset, field_size, field_size, true)

            if field.number then
                if visible_grid_size >= 1 and visible_grid_size <= 10 then
                    gfx.setfont(1, "Iregula", 40)
                elseif visible_grid_size >= 11 and visible_grid_size <= 20 then
                    gfx.setfont(1, "Iregula", 30)
                elseif visible_grid_size >= 21 and visible_grid_size <= 30 then
                    gfx.setfont(1, "Iregula", 25)
                elseif visible_grid_size >= 31 and visible_grid_size <= 40 then
                    gfx.setfont(1, "Iregula", 20)
                elseif visible_grid_size >= 41 and visible_grid_size <= 50 then
                    gfx.setfont(1, "Iregula", 18)
                elseif visible_grid_size >= 51 and visible_grid_size <= 60 then
                    gfx.setfont(1, "Iregula", 15)
                else
                    gfx.setfont(1, "Iregula", 10)
                end

                gfx.set(0.93, 0.93, 0.93)
                local text = tostring(field.number)
                local text_width = gfx.measurestr(text)
                gfx.x = (field.x - 1) * cell_size + (cell_size - text_width) / 2
                gfx.y = (field.y - 1) * cell_size + (cell_size - gfx.texth) / 2
                gfx.drawstr(text)
            end
        end
    end
end

function clear_teleport_fields()
    teleport_fields = {} 
end

function set_checkpoint(field, player_on_field)
    if player_on_field and not field.player_standing then
        checkpoint_x = field.x
        checkpoint_y = field.y
        field.player_standing = true

        player_speak = "CHECKPOINT"
        speak_timer = reaper.time_precise() + speak_duration

    elseif not player_on_field then
        field.player_standing = false
    end
end
















    -- add_w("a1", "r")
    -- add_d_w("a2", 'b')
    -- add_t_f("a3", 1)
    -- add_s_f("a4", player_die, nil, 'death')
    -- add_s_f("a5", show_tip("Повідомлення тут", false), nil, 'tip')
    -- add_s_f("a6", call_func(blablabla, false), nil, 'func')
    -- add_lock("a7")
    -- add_key("a8")



function load_level(level_number)
    local level_found = false

    last_console_x = nil
    last_console_y = nil

    for _, level in ipairs(levels) do
        if level.number == level_number then
            init_walls(grid_size)
            clear_diagonal_walls()
            clear_special_fields()
            clear_teleport_fields()
            level.setup()
            
            prev_player_x = player_x
            prev_player_y = player_y

            move_dx = 0
            move_dy = 0
            is_moving = false

            level_start_time = reaper.time_precise()
            last_timer_check = level_start_time
            last_player_move_time = level_start_time

            if visible_grid_size >= 1 and visible_grid_size <= 10 then
                flashlight_size = 4
            elseif visible_grid_size >= 11 and visible_grid_size <= 20 then
                flashlight_size = 7
            elseif visible_grid_size >= 21 and visible_grid_size <= 30 then
                flashlight_size = 10
            elseif visible_grid_size >= 31 and visible_grid_size <= 40 then
                flashlight_size = 14
            elseif visible_grid_size >= 41 and visible_grid_size <= 50 then
                flashlight_size = 17
            elseif visible_grid_size >= 51 and visible_grid_size <= 60 then
                flashlight_size = 20
            else
                flashlight_size = 0
            end
            
            level_found = true

            break
        end
    end
    
    if not level_found then
        -- reaper.ShowConsoleMsg("Рівня з номером " .. level_number .. " не існує!\n")
    end
end

function save_current_level()
    reaper.SetExtState("RoboMaze", "CurrentLevel", tostring(current_level), true)
end

function load_saved_level()
    local saved_level = reaper.GetExtState("RoboMaze", "CurrentLevel")

    if saved_level ~= "" then
        return tonumber(saved_level)
    end

    return nil
end

function save_maze_settings()
    reaper.SetExtState("RoboMaze", "Difficulty", maze_difficulty_is, true)
    reaper.SetExtState("RoboMaze", "Language", current_language, true)
end

function load_maze_settings()
    local saved_difficulty = reaper.GetExtState("RoboMaze", "Difficulty")
    local saved_language = reaper.GetExtState("RoboMaze", "Language")

    if saved_difficulty == "" then
        maze_difficulty_is = "medium"
    else
        maze_difficulty_is = saved_difficulty
    end

    if saved_language == "" then
        current_language = "en"
        is_us_lang = true
    else
        current_language = saved_language
        is_us_lang = (current_language == "en")
    end

    if maze_difficulty_is == "easy" then
        total_heart = 1000
    elseif maze_difficulty_is == "medium" then
        total_heart = 10
    elseif maze_difficulty_is == "hard" then
        total_heart = 3
    elseif maze_difficulty_is == "impo" then
        total_heart = 1
    end

    i_found_heart = total_heart
end

function set_background_color(r, g, b)
    gfx.set(r / 255, g / 255, b / 255)  
    gfx.rect(0, 0, gfx.w, gfx.h, true) 
end

function coord_to_index(coord)
    local col_letters = coord:match("^%a+")
    local row_numbers = coord:match("%d+$")
    local column_number = 0
    local len = #col_letters

    for i = 1, len do
        local char = col_letters:sub(i, i)
        local char_value = string.byte(char) - string.byte('a') + 1
        column_number = column_number * 26 + char_value
    end
    
    local row_number = tonumber(row_numbers)
    return column_number, row_number
end

function index_to_coord(x, y)
    local col_letters = ""
    local n = x

    while n > 0 do
        local remainder = (n - 1) % 26
        local char = string.char(remainder + string.byte('a'))
        col_letters = char .. col_letters
        n = math.floor((n - 1) / 26)
    end
    return col_letters .. tostring(y)
end



























function init_walls(grid_size)
    for i = 1, grid_size do
        vertical_walls[i] = {}
        horizontal_walls[i] = {}
        for j = 1, grid_size do
            vertical_walls[i][j] = false
            horizontal_walls[i][j] = false
        end
    end
end

function add_w(coord, position)
    local x, y = coord_to_index(coord)
    
    if position == "d" then
        horizontal_walls[x][y] = true
    elseif position == "u" then
        horizontal_walls[x][y - 1] = true
    elseif position == "l" then
        vertical_walls[x - 1][y] = true
    elseif position == "r" then
        vertical_walls[x][y] = true
    end
end

local wall_thickness = 2.5

function draw_walls(grid_size, cell_size, wall_thickness)
    if game_state == "level_transition" then
        gfx.set(1, 1, 1)
    else
        gfx.set(0.2, 0.2, 0.2)
    end

    for i = 1, grid_size do
        for j = 1, grid_size do
            if vertical_walls[i][j] then
                gfx.rect(i * cell_size - wall_thickness / 2, (j - 1) * cell_size, wall_thickness, cell_size, true)
            end

            if horizontal_walls[i][j] then
                gfx.rect((i - 1) * cell_size, j * cell_size - wall_thickness / 2, cell_size, wall_thickness, true)
            end
        end
    end
end

function add_d_w(coord, orientation)
    local x, y = coord_to_index(coord)
    table.insert(diagonal_walls, {x = x, y = y, orientation = orientation})
end

local wall_diag_thickness = 2

function draw_diagonal_walls(cell_size, wall_diag_thickness)
    if game_state == "level_transition" then
        gfx.set(1, 1, 1)
    else
        gfx.set(0.2, 0.2, 0.2)
    end

    local half_thickness = math.floor(wall_diag_thickness / 2)

    for _, wall in ipairs(diagonal_walls) do
        local x1 = (wall.x - 1) * cell_size
        local y1 = (wall.y - 1) * cell_size
        local x2 = x1 + cell_size
        local y2 = y1 + cell_size

        if wall.orientation == 'f' then  -- '/'
            for i = -half_thickness, half_thickness do
                gfx.line(x1 + i, y2, x2, y1 + i)
            end
        elseif wall.orientation == 'b' then  -- '\'
            for i = -half_thickness, half_thickness do
                gfx.line(x1 + i, y1, x2, y2 - i)
            end
        end
    end
end

function check_diagonal_wall_collision(prev_x, prev_y, new_x, new_y)
    for _, wall in ipairs(diagonal_walls) do
        if new_x == wall.x and new_y == wall.y then
            if wall.orientation == 'b' then  -- '\'
                if move_dx == 1 and move_dy == 0 then 
                    move_dx, move_dy = 0, 1 
                elseif move_dx == -1 and move_dy == 0 then 
                    move_dx, move_dy = 0, -1 
                elseif move_dx == 0 and move_dy == 1 then 
                    move_dx, move_dy = 1, 0 
                elseif move_dx == 0 and move_dy == -1 then 
                    move_dx, move_dy = -1, 0 
                end
            elseif wall.orientation == 'f' then 
                if move_dx == 1 and move_dy == 0 then 
                    move_dx, move_dy = 0, -1 
                elseif move_dx == -1 and move_dy == 0 then 
                    move_dx, move_dy = 0, 1 
                elseif move_dx == 0 and move_dy == 1 then 
                    move_dx, move_dy = -1, 0 
                elseif move_dx == 0 and move_dy == -1 then 
                    move_dx, move_dy = 1, 0 
                end
            end
            return
        end
    end
end

function clear_diagonal_walls()
    diagonal_walls = {}
end




















function get_scale_factor()
    return math.min(gfx.w / 800, gfx.h / 800)
end

local base_eye_size = 100
local base_pupil_size = 120
local eye_offset = 100 

local base_pupil_size2 = 30
local eye_offset2 = 45 
local last_blink_time = reaper.time_precise()
local blink_interval = math.random(7, 10)
local blink_duration = 0.2
local is_eye_open = true
local blink_count = 0

function draw_pupils_menu()
    local pupil_size = base_pupil_size

    local left_eye_x = gfx.w / 2 - eye_offset
    local right_eye_x = gfx.w / 2 + eye_offset
    local eye_y = gfx.h / 4
    local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y

    local function get_pupil_position(eye_x, eye_y, mouse_x, mouse_y)
        local max_offset = pupil_size
        local dx = math.max(-max_offset, math.min(max_offset, mouse_x - eye_x))
        local dy = math.max(-max_offset, math.min(max_offset, mouse_y - eye_y))
        return eye_x + dx / 4, eye_y + dy / 4
    end

    if is_eye_open then
        gfx.set(0.9, 0.9, 0.9) -- L
        local left_pupil_x, left_pupil_y = get_pupil_position(left_eye_x, eye_y, mouse_x, mouse_y)
        gfx.rect(left_pupil_x - pupil_size / 2, left_pupil_y - pupil_size / 2, pupil_size, pupil_size, true)

        gfx.set(0.9, 0.9, 0.9) -- R
        local right_pupil_x, right_pupil_y = get_pupil_position(right_eye_x, eye_y, mouse_x, mouse_y)
        gfx.rect(right_pupil_x - pupil_size / 2, right_pupil_y - pupil_size / 2, pupil_size, pupil_size, true)
    else
        gfx.set(0.9, 0.9, 0.9)
        local blink_thickness = pupil_size / 4

        gfx.rect(left_eye_x - pupil_size / 2, eye_y - blink_thickness / 2, pupil_size, blink_thickness, true)
        gfx.rect(right_eye_x - pupil_size / 2, eye_y - blink_thickness / 2, pupil_size, blink_thickness, true)
    end
end

function draw_pupils_player(grid_size, cell_size)
    local player_size = cell_size * 0.7  
    local offset = (cell_size - player_size) / 2

    
    local pupil_size = player_size * 0.3  

    
    local left_eye_x = (player_x - 1) * cell_size + offset + player_size * 0.3
    local right_eye_x = (player_x - 1) * cell_size + offset + player_size * 0.7
    local eye_y = (player_y - 1) * cell_size + offset + player_size * 0.4

    
    local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y

    
    local function get_pupil_position(eye_x, eye_y, mouse_x, mouse_y)
        local max_offset = pupil_size / 2  
        local dx = math.max(-max_offset, math.min(max_offset, mouse_x - eye_x))
        local dy = math.max(-max_offset, math.min(max_offset, mouse_y - eye_y))
        return eye_x + dx / 4, eye_y + dy / 4
    end

    if is_eye_open then
        gfx.set(0.9, 0.9, 0.9)  

        local left_pupil_x, left_pupil_y = get_pupil_position(left_eye_x, eye_y, mouse_x, mouse_y)
        gfx.rect(left_pupil_x - pupil_size / 2, left_pupil_y - pupil_size / 2, pupil_size, pupil_size, true)

        
        local right_pupil_x, right_pupil_y = get_pupil_position(right_eye_x, eye_y, mouse_x, mouse_y)
        gfx.rect(right_pupil_x - pupil_size / 2, right_pupil_y - pupil_size / 2, pupil_size, pupil_size, true)
    else
        gfx.set(0.9, 0.9, 0.9)
        local blink_thickness = pupil_size / 3

        gfx.rect(left_eye_x - pupil_size / 2, eye_y - blink_thickness / 2, pupil_size, blink_thickness, true)
        gfx.rect(right_eye_x - pupil_size / 2, eye_y - blink_thickness / 2, pupil_size, blink_thickness, true)
    end
end

function animate_blink()
    local current_time = reaper.time_precise()
    if is_eye_open and current_time - last_blink_time >= blink_interval then
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

















function draw_start(grid_size, cell_size)
    local start_size = cell_size * 0.7 
    local offset = (cell_size - start_size) / 2
    
    gfx.set(0.3, 0.3, 0.3)  
    gfx.rect((start_x - 1) * cell_size + offset, (start_y - 1) * cell_size + offset, start_size, start_size, true)

    if visible_grid_size >= 1 and visible_grid_size <= 10 then
        gfx.setfont(1, "Iregula", 35)
    elseif visible_grid_size >= 11 and visible_grid_size <= 20 then
        gfx.setfont(1, "Iregula", 27)
    elseif visible_grid_size >= 21 and visible_grid_size <= 30 then
        gfx.setfont(1, "Iregula", 22)
    elseif visible_grid_size >= 31 and visible_grid_size <= 40 then
        gfx.setfont(1, "Iregula", 17)
    elseif visible_grid_size >= 41 and visible_grid_size <= 50 then
        gfx.setfont(1, "Iregula", 14)
    elseif visible_grid_size >= 51 and visible_grid_size <= 60 then
        gfx.setfont(1, "Iregula", 12)
    else
        gfx.setfont(1, "Iregula", 10)
    end

    local text_offset_x = (start_x - 1) * cell_size + cell_size / 2  
    local text_offset_y = (start_y - 1) * cell_size + cell_size / 2  
    
    gfx.set(0.9, 0.9, 0.9) 
    
    gfx.x = text_offset_x - gfx.measurestr("S") / 2  
    gfx.y = text_offset_y - gfx.texth / 2  
    gfx.drawstr("S")  
end

function draw_finish(grid_size, cell_size)
    local finish_size = cell_size * 0.7  -- size
    local offset = (cell_size - finish_size) / 2

    if is_finishing then
        gfx.set(0.784, 0.784, 0.784)  -- bg
    else
        gfx.set(0.9, 0.5, 0.5)  -- bg
    end

    gfx.rect((finish_x - 1) * cell_size + offset, (finish_y - 1) * cell_size + offset, finish_size, finish_size, true)

    if visible_grid_size >= 1 and visible_grid_size <= 10 then
        gfx.setfont(1, "Iregula", 35)
    elseif visible_grid_size >= 11 and visible_grid_size <= 20 then
        gfx.setfont(1, "Iregula", 27)
    elseif visible_grid_size >= 21 and visible_grid_size <= 30 then
        gfx.setfont(1, "Iregula", 22)
    elseif visible_grid_size >= 31 and visible_grid_size <= 40 then
        gfx.setfont(1, "Iregula", 17)
    elseif visible_grid_size >= 41 and visible_grid_size <= 50 then
        gfx.setfont(1, "Iregula", 14)
    elseif visible_grid_size >= 51 and visible_grid_size <= 60 then
        gfx.setfont(1, "Iregula", 12)
    else
        gfx.setfont(1, "Iregula", 10)
    end

    local text_offset_x = (finish_x - 1) * cell_size + cell_size / 2  
    local text_offset_y = (finish_y - 1) * cell_size + cell_size / 2  
    
    gfx.set(0.9, 0.9, 0.9)  -- f color
    
    gfx.x = text_offset_x - gfx.measurestr("F") / 2 
    gfx.y = text_offset_y - gfx.texth / 2 
    gfx.drawstr("F")
end

function check_finish()
    if player_x == finish_x and player_y == finish_y and not is_finishing then
        -- level_end_time = reaper.time_precise()
        is_finishing = true
        fade_direction = "out"
        is_fading = true
        move_dx = 0
        move_dy = 0
        is_moving = false
    end
end


function draw_level_n_keys_n_hearts()
    local rect_width = 50  
    local rect_height = 50 

    if game_state ~= "level_transition" then
        gfx.set(0.3, 0.3, 0.3, 1)
        gfx.rect(gfx.w - rect_width, 0, rect_width, rect_height, true)

        gfx.setfont(1, "Iregula", 23)
        gfx.set(0.9, 0.9, 0.9, 1)

        local text_x = gfx.w - rect_width / 2
        local text_y = rect_height / 2

        gfx.x = text_x - gfx.measurestr(tostring(current_level)) / 2
        gfx.y = text_y - gfx.texth / 2
        gfx.drawstr(tostring(current_level))

        local offset = rect_width

        if i_found_key ~= 0 then
            local key_rect_width = 50

            gfx.set(1, 1, 0)  
            gfx.rect(gfx.w - offset - key_rect_width, 0, key_rect_width, rect_height, true)

            gfx.setfont(1, "Iregula", 23)
            gfx.set(0.2, 0.2, 0.2, 1)

            local key_text_x = gfx.w - offset - key_rect_width / 2
            local key_text_y = rect_height / 2

            gfx.x = key_text_x - gfx.measurestr(tostring(i_found_key)) / 2
            gfx.y = key_text_y - gfx.texth / 2
            gfx.drawstr(tostring(i_found_key))

            offset = offset + key_rect_width
        end

        if i_found_heart ~= 0 and maze_difficulty_is ~= 'easy' then
            local heart_rect_width = 50

            gfx.set(1, 0, 0)  
            gfx.rect(gfx.w - offset - heart_rect_width, 0, heart_rect_width, rect_height, true)

            gfx.setfont(1, "Iregula", 23)
            gfx.set(0.9, 0.9, 0.9, 1)

            local heart_text_x = gfx.w - offset - heart_rect_width / 2
            local heart_text_y = rect_height / 2

            gfx.x = heart_text_x - gfx.measurestr(tostring(i_found_heart)) / 2
            gfx.y = heart_text_y - gfx.texth / 2
            gfx.drawstr(tostring(i_found_heart))
        end
    end
end





local title_font_size = 70
local sub_message_font_size = 30
local continue_message_font_size = 30
local level_message_font_size = 30

function draw_menu_screen()
    gfx.set(0.2, 0.2, 0.2) 
    gfx.rect(0, 0, gfx.w, gfx.h, true)

    draw_pupils_menu(1)
    
    
    gfx.setfont(1, "Iregula", 70)
    
    gfx.set(0.9, 0.9, 0.9)  
    local message = t("robomaze_game")
    local sub_message = t("press_enter_to_start_new_game")
    local settings_message = t("open_settings")
    
    
    local text_width = gfx.measurestr(message)
    local text_height = gfx.texth
    gfx.x = (gfx.w - text_width) / 2
    gfx.y = gfx.h / 2 - text_height
    gfx.drawstr(message)
    
    
    gfx.setfont(2, "Iregula", 30)
    local sub_text_width = gfx.measurestr(sub_message)
    gfx.x = (gfx.w - sub_text_width) / 2
    gfx.y = gfx.h / 2 + text_height * 2
    gfx.drawstr(sub_message)

    
    gfx.x = (gfx.w - gfx.measurestr(settings_message)) / 2
    gfx.y = gfx.h / 2 + text_height * 4
    gfx.drawstr(settings_message)

    
    
    if load_saved_level() then
        local continue_message = t("press_c_to_continue")
        local continue_text_width = gfx.measurestr(continue_message)
        gfx.x = (gfx.w - continue_text_width) / 2
        gfx.y = gfx.h / 2 + text_height * 3
        gfx.drawstr(continue_message)

        --[[
        local level_message = t("press_l_to_select_level")
        local continue_text_width = gfx.measurestr(level_message)
        gfx.x = (gfx.w - continue_text_width) / 2
        gfx.y = gfx.h / 2 + text_height * 4
        gfx.drawstr(level_message)
        ]]--
    end
end

function draw_settings_screen()
    gfx.set(0.2, 0.2, 0.2)
    gfx.rect(0, 0, gfx.w, gfx.h, true)

    gfx.setfont(1, "Iregula", 50)
    gfx.set(0.9, 0.9, 0.9)

    local title = "Settings"
    local tw = gfx.measurestr(title)
    gfx.x = (gfx.w - tw)/2
    gfx.y = gfx.h/6
    gfx.drawstr(title)

    gfx.setfont(1, "Iregula", 30)
    local difficulty_msg = "" .. maze_difficulty_is .. ""
    local dw = gfx.measurestr(difficulty_msg)
    gfx.x = (gfx.w - dw)/2
    gfx.y = gfx.h/2 - 40
    gfx.drawstr(difficulty_msg)

    local lang_msg = "" .. current_language .. ""
    local lw = gfx.measurestr(lang_msg)
    gfx.x = (gfx.w - lw)/2
    gfx.y = gfx.h/2
    gfx.drawstr(lang_msg)

    local save_msg = "Press Enter to save"
    local sw = gfx.measurestr(save_msg)
    gfx.x = (gfx.w - sw)/2
    gfx.y = gfx.h/2 + 80
    gfx.drawstr(save_msg)
end


function draw_new_game_screen()
    gfx.set(0.2, 0.2, 0.2)  -- bg
    gfx.rect(0, 0, gfx.w, gfx.h, true)
    
    gfx.setfont(1, "Iregula", 40)
    gfx.set(0.9, 0.9, 0.9)  -- font

    local title = "LITTLE HISTORY"
    local message = "Hello!\n\nI created this game a long years ago,\nwhen I was 13...\nAnd even now I have original paperbook's scans\nso I decided to make this game here.\n \nPlay if you want to take a break\nor flip your brain attention."
    local sub_message = "Press Enter to start new game"

    gfx.setfont(1, "Iregula", 60) -- title
    local title_width = gfx.measurestr(title)
    gfx.x = (gfx.w - title_width) / 2
    gfx.y = gfx.h / 6
    gfx.drawstr(title)

    local lines = {}
    for line in message:gmatch("[^\n]+") do
        table.insert(lines, line)
    end
    
    gfx.setfont(1, "Trebuchet MS", 35) -- message
    local total_text_height = gfx.texth * #lines
    local start_y = gfx.h / 2 - total_text_height / 2

    for i, line in ipairs(lines) do
        local line_width = gfx.measurestr(line)
        gfx.x = (gfx.w - line_width) / 2
        gfx.y = start_y + (i - 1) * gfx.texth
        gfx.drawstr(line)
    end

    gfx.setfont(2, "Iregula", 30) -- sub_message
    local sub_text_width = gfx.measurestr(sub_message)
    gfx.x = (gfx.w - sub_text_width) / 2
    gfx.y = start_y + total_text_height + 100
    gfx.drawstr(sub_message)
end

function draw_level_transition_screen()
    draw_anything()

    gfx.set(0.2, 0.2, 0.2, 0.9)
    gfx.rect(0, 0, gfx.w, gfx.h, true)

    gfx.setfont(1, "Iregula", 70)

    gfx.set(0.9, 0.9, 0.9)
    local message = "Level " .. current_level .. " Complete!"
    local text_width = gfx.measurestr(message)
    local text_height = gfx.texth
    gfx.x = (gfx.w - text_width) / 2
    gfx.y = gfx.h / 2 - text_height
    gfx.drawstr(message)

    gfx.setfont(2, "Iregula", 30)
    local steps_message = "Total steps: " .. total_steps
    local steps_text_width = gfx.measurestr(steps_message)
    gfx.x = (gfx.w - steps_text_width) / 2
    gfx.y = gfx.h / 2 + text_height + 20
    gfx.drawstr(steps_message)

    local sub_message_1 = "Press Enter to start next level"
    gfx.x = (gfx.w - gfx.measurestr(sub_message_1)) / 2
    gfx.y = gfx.h / 2 + text_height + 100
    gfx.drawstr(sub_message_1)

    local sub_message_2 = "Press R to restart this level"
    gfx.x = (gfx.w - gfx.measurestr(sub_message_2)) / 2
    gfx.y = gfx.h / 2 + text_height + 140
    gfx.drawstr(sub_message_2)
end



function draw_end_screen()
    gfx.set(0.2, 0.2, 0.2)  -- bg
    gfx.rect(0, 0, gfx.w, gfx.h, true)
    
    gfx.setfont(1, "Iregula", 40)
    
    gfx.set(0.9, 0.9, 0.9)  -- font

    local message = "Congratulations! \nYou finished all levels!"
    local sub_message = "Press Enter to return to main menu"
    
    local text_width = gfx.measurestr(message)
    local text_height = gfx.texth

    gfx.x = (gfx.w - text_width) / 2
    gfx.y = gfx.h / 2 - text_height
    gfx.drawstr(message)
    
    gfx.setfont(2, "Iregula", 30)  
    
    local sub_text_width = gfx.measurestr(sub_message)
    gfx.x = (gfx.w - sub_text_width) / 2
    gfx.y = gfx.h / 2 + text_height * 2  
    gfx.drawstr(sub_message)
end

function player_die()
    game_state = "dead"
end



function draw_death_message()
    gfx.set(0.8, 0.2, 0.2)  -- bg
    gfx.rect(0, 0, gfx.w, gfx.h, true)
    
    gfx.setfont(1, "Iregula", 80)
    
    gfx.set(0.9, 0.9, 0.9)  -- font

    local message = "Game over!"
    local sub_message = "Press Enter to try again"
    
    local text_width = gfx.measurestr(message)
    local text_height = gfx.texth

    gfx.x = (gfx.w - text_width) / 2
    gfx.y = gfx.h / 2 - text_height
    gfx.drawstr(message)
    
    gfx.setfont(2, "Iregula", 30)  
    
    local sub_text_width = gfx.measurestr(sub_message)
    gfx.x = (gfx.w - sub_text_width) / 2
    gfx.y = gfx.h / 2 + text_height
    gfx.drawstr(sub_message)
end





function draw_footer()
    local footer_font_size = 0
    local footer_message = ""
    local footer_height_pix = 0
    local footer_font_height = 2

    local function footer()
        gfx.setfont(1, "Trebuchet MS", footer_font_size)
        local text_width = gfx.measurestr(footer_message)
        local text_height = gfx.texth

        local footer_height = footer_height_pix
        local footer_y = gfx.h - footer_height

        gfx.set(0.3, 0.3, 0.3)
        gfx.rect(0, footer_y, gfx.w, footer_height, true)

        gfx.x = (gfx.w - text_width) / 2
        gfx.y = footer_y + (footer_height - text_height) / footer_font_height

        gfx.set(0.9, 0.9, 0.9)
        gfx.drawstr(footer_message)
    end

    if current_level == 1 then
        footer_height_pix = 125
        footer_font_size = 50
        footer_font_height = 2
        footer_message = "Use arrow or wsad keys to navigate and find finish"
        footer()
    end

    if current_level == 4 and maze_difficulty_is == 'medium' then
        footer_height_pix = 100
        footer_font_size = 35
        footer_font_height = 4
        footer_message = "On 'medium' difficulty player will be hidden after teleporting.\nYou need to find it manually and continue moving."
        footer()
    end

    if current_level == 1 and maze_difficulty_is == 'hard' then
        footer_height_pix = 100
        footer_font_size = 45
        footer_font_height = -6
        footer_message = "Use arrow or wsad keys to navigate and find finish\n      Move mouse to change flashlight direction"
        footer()
    end
end







function draw_level_selected_screen()
    gfx.set(0.2, 0.2, 0.2)
    gfx.rect(0, 0, gfx.w, gfx.h, true)

    gfx.setfont(1, "Iregula", 50) 

    gfx.set(0.9, 0.9, 0.9)  
    local message = "Level " .. current_level .. ""
    local sub_message = "Press Enter to Start"

    local text_width = gfx.measurestr(message)
    gfx.x = (gfx.w - text_width) / 2
    gfx.y = gfx.h / 2 - gfx.texth
    gfx.drawstr(message)
    gfx.setfont(2, "Iregula", 30)
    local sub_text_width = gfx.measurestr(sub_message)
    gfx.x = (gfx.w - sub_text_width) / 2
    gfx.y = gfx.h / 2 + gfx.texth
    gfx.drawstr(sub_message)
end

function draw_levels(grid_size, cell_size, num_levels)
    local level_size = cell_size * 0.7
    local offset = (cell_size - level_size) / 2

    gfx.setfont(1, "Iregula", 40) 

    level_fields = {}

    for level = 1, num_levels do
        local level_x = (level - 1) % grid_size + 1 
        local level_y = math.floor((level - 1) / grid_size) + 1

        gfx.set(0.3, 0.3, 0.3)  
        gfx.rect((level_x - 1) * cell_size + offset, (level_y - 1) * cell_size + offset, level_size, level_size, true)

        table.insert(level_fields, {
            number = level,
            x = (level_x - 1) * cell_size,
            y = (level_y - 1) * cell_size,
            size = level_size
        })

        local text_offset_x = (level_x - 1) * cell_size + cell_size / 2  
        local text_offset_y = (level_y - 1) * cell_size + cell_size / 2  

        gfx.set(0.9, 0.9, 0.9)
        
        gfx.x = text_offset_x - gfx.measurestr(level) / 2  
        gfx.y = text_offset_y - gfx.texth / 2  
        gfx.drawstr(tostring(level))
    end
end

function check_level_touch(player_x, player_y, cell_size)
    for _, field in ipairs(level_fields) do
        local field_x = field.x / cell_size + 1
        local field_y = field.y / cell_size + 1

        if player_x == field_x and player_y == field_y then
            load_level(field.number)
        end
    end
end










function draw_player(grid_size, cell_size)
    local player_size = cell_size * 0.7
    local offset = (cell_size - player_size) / 2
    gfx.set(0.4, 0.4, 0.4, player_alpha)
    gfx.rect((player_x - 1) * cell_size + offset, (player_y - 1) * cell_size + offset, player_size, player_size, true)

    if not is_robo_face_open() then
        draw_pupils_player(grid_size, cell_size)
    end

    if player_speak and reaper.time_precise() < speak_timer then
        gfx.setfont(1, "Iregula", cell_size * speak_font_size)
        local text_width = gfx.measurestr(player_speak)
        local text_height = gfx.texth
        local text_x = (player_x - 1) * cell_size + (cell_size - text_width) / 2
        local text_y = (player_y - 1) * cell_size - text_height - 5
        
        --[[
        gfx.setfont(1, "Iregula", cell_size + 1 * speak_font_size)
        gfx.set(0.7, 0.7, 0.7)
        gfx.x = text_x
        gfx.y = text_y
        gfx.drawstr(player_speak)
        ]]--
        
        gfx.set(0.3, 0.3, 0.3)
        gfx.x = text_x
        gfx.y = text_y
        gfx.drawstr(player_speak)

    else
        player_speak = nil
    end
end

function get_mouse_direction(player_x, player_y, cell_size)
    local player_center_x = (player_x - 1) * cell_size + cell_size / 2
    local player_center_y = (player_y - 1) * cell_size + cell_size / 2

    local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y
    local dx = mouse_x - player_center_x
    local dy = mouse_y - player_center_y

    if math.abs(dx) > math.abs(dy) then
        if dx > 0 then
            if math.abs(dy / dx) > 0.5 then
                return dy > 0 and "down_right" or "up_right"
            else
                return "right"
            end
        else
            if math.abs(dy / dx) > 0.5 then
                return dy > 0 and "down_left" or "up_left"
            else
                return "left"
            end
        end
    else
        if dy > 0 then
            if math.abs(dx / dy) > 0.5 then
                return dx > 0 and "down_right" or "down_left"
            else
                return "down"
            end
        else
            if math.abs(dx / dy) > 0.5 then
                return dx > 0 and "up_right" or "up_left"
            else
                return "up"
            end
        end
    end
end

function point_in_triangle(p, vertices)
    local function sign(p1, p2, p3)
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
    end

    local b1 = sign(p, vertices[1], vertices[2]) < 0.0
    local b2 = sign(p, vertices[2], vertices[3]) < 0.0
    local b3 = sign(p, vertices[3], vertices[1]) < 0.0

    return b1 == b2 and b2 == b3
end

function rect_intersects_triangle(rect, vertices)
    local corners = {
        {x = rect.x, y = rect.y},
        {x = rect.x + rect.w, y = rect.y},
        {x = rect.x, y = rect.y + rect.h},
        {x = rect.x + rect.w, y = rect.y + rect.h},
    }

    for _, corner in ipairs(corners) do
        if point_in_triangle(corner, vertices) then
            return true
        end
    end

    for _, vertex in ipairs(vertices) do
        if vertex.x >= rect.x and vertex.x <= rect.x + rect.w and
           vertex.y >= rect.y and vertex.y <= rect.y + rect.h then
            return true
        end
    end

    return false
end

function get_cells_under_triangle(vertices, cell_size)
    local cells = {}
    local shrink_factor = 0.9

    for x = 1, visible_grid_size do
        for y = 1, visible_grid_size do
            local rect = {
                x = (x - 1) * cell_size + (cell_size * (1 - shrink_factor)) / 2,
                y = (y - 1) * cell_size + (cell_size * (1 - shrink_factor)) / 2,
                w = cell_size * shrink_factor,
                h = cell_size * shrink_factor
            }

            if rect_intersects_triangle(rect, vertices) then
                table.insert(cells, {x = x, y = y})
            end
        end
    end

    return cells
end

function draw_triangle_near_player(player_x, player_y, cell_size)
    local direction = get_mouse_direction(player_x, player_y, cell_size)
    local triangle_size = cell_size * flashlight_size -- triangle
    local triangle_width = 1.5
    local player_center_x = (player_x - 1) * cell_size + cell_size / 2
    local player_center_y = (player_y - 1) * cell_size + cell_size / 2

    local vertices = {}

    if direction == "up" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x - (triangle_size / 2) * triangle_width, y = player_center_y - triangle_size},
            {x = player_center_x + (triangle_size / 2) * triangle_width, y = player_center_y - triangle_size},
        }
    elseif direction == "down" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x - (triangle_size / 2) * triangle_width, y = player_center_y + triangle_size},
            {x = player_center_x + (triangle_size / 2) * triangle_width, y = player_center_y + triangle_size},
        }
    elseif direction == "left" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x - triangle_size, y = player_center_y - (triangle_size / 2) * triangle_width},
            {x = player_center_x - triangle_size, y = player_center_y + (triangle_size / 2) * triangle_width},
        }
    elseif direction == "right" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x + triangle_size, y = player_center_y - (triangle_size / 2) * triangle_width},
            {x = player_center_x + triangle_size, y = player_center_y + (triangle_size / 2) * triangle_width},
        }
    elseif direction == "up_left" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x - triangle_size, y = player_center_y},
            {x = player_center_x, y = player_center_y - triangle_size},
        }
    elseif direction == "up_right" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x + triangle_size, y = player_center_y},
            {x = player_center_x, y = player_center_y - triangle_size},
        }
    elseif direction == "down_left" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x - triangle_size, y = player_center_y},
            {x = player_center_x, y = player_center_y + triangle_size},
        }
    elseif direction == "down_right" then
        vertices = {
            {x = player_center_x, y = player_center_y},
            {x = player_center_x + triangle_size, y = player_center_y},
            {x = player_center_x, y = player_center_y + triangle_size},
        }
    end

    cleared_cells = get_cells_under_triangle(vertices, cell_size)

    gfx.set(0.7, 0.7, 0.7, 0.3) -- triangle color
    gfx.triangle(
        vertices[1].x, vertices[1].y,
        vertices[2].x, vertices[2].y,
        vertices[3].x, vertices[3].y
    )
end


cleared_cells = get_cells_under_triangle(vertices, cell_size)

function draw_shadow(grid_size, cell_size)
    local padding = -1
    gfx.set(0.2, 0.2, 0.2, 0.995)

    for x = 1, grid_size do
        for y = 1, grid_size do
            local skip = false

            for _, cell in ipairs(cleared_cells) do
                if cell.x == x and cell.y == y then
                    skip = true
                    break
                end
            end

            if not skip then
                local rect_x = (x - 1) * cell_size + padding
                local rect_y = (y - 1) * cell_size + padding
                local rect_width = cell_size - 2 * padding
                local rect_height = cell_size - 2 * padding

                gfx.rect(rect_x, rect_y, rect_width, rect_height, true)
            end
        end
    end
end

function draw_full_darkness()
    gfx.set(0.2, 0.2, 0.2, 0.995)
    gfx.rect(0, 0, gfx.w, gfx.h, true)
end







function reset_player_to_start()
    player_x = start_x
    player_y = start_y
end

function animate_fade()
    if is_fading then
        if fade_direction == "out" then
            player_alpha = player_alpha - fade_speed
            if player_alpha <= 0 then
                player_alpha = 0
                is_fading = false
                if is_finishing then
                    is_finishing = false
                    game_state = "level_transition"
                    player_alpha = 1.0
                elseif is_teleporting then
                    player_x = teleport_destination.x
                    player_y = teleport_destination.y
                    fade_direction = "in"
                    is_fading = true
                end
            end
        elseif fade_direction == "in" then
            player_alpha = player_alpha + fade_speed
            if player_alpha >= 1 then
                player_alpha = 1
                is_fading = false
                if is_teleporting then
                    is_teleporting = false  
                    teleport_destination = nil
                end
            end
        end
    end
end



function move_player(dx, dy, grid_size)
    prev_player_x = player_x
    prev_player_y = player_y

    local new_x = player_x + dx
    local new_y = player_y + dy

    if new_x < 1 or new_x > visible_grid_size or new_y < 1 or new_y > visible_grid_size then
        game_state = "dead"
        load_level(current_level)
        return
    end

    local hit_wall = false

    if maze_difficulty_is == 'easy' or maze_difficulty_is == 'medium' or maze_difficulty_is == 'hard' then
        if dx > 0 and vertical_walls[player_x][player_y] then  -- r
            hit_wall = true
        elseif dx < 0 and vertical_walls[player_x - 1][player_y] then  -- l
            hit_wall = true
        elseif dy > 0 and horizontal_walls[player_x][player_y] then  -- d
            hit_wall = true
        elseif dy < 0 and horizontal_walls[player_x][player_y - 1] then  -- u
            hit_wall = true
        end
    elseif maze_difficulty_is == 'impo' and is_eye_open then
        if dx > 0 and vertical_walls[player_x][player_y] then  -- r
            hit_wall = true
        elseif dx < 0 and vertical_walls[player_x - 1][player_y] then  -- l
            hit_wall = true
        elseif dy > 0 and horizontal_walls[player_x][player_y] then  -- d
            hit_wall = true
        elseif dy < 0 and horizontal_walls[player_x][player_y - 1] then  -- u
            hit_wall = true
        end
    end

    if hit_wall then
        -- reaper.ShowConsoleMsg("Wall blocking\n")
        return
    end

    local lock_field = is_locked_lock_at(new_x, new_y)
    if lock_field and lock_field.locked then
        if i_found_key > 0 then
            if not is_unlocking then
                is_unlocking = true
                lock_timer = reaper.time_precise()
                current_lock = lock_field

                player_speak = "WAIT..."
                speak_timer = reaper.time_precise() + speak_duration
            end
            
            return
        else
            if not lock_field.message_shown then
                --[[
                player_speak = "LOCKED!"
                speak_timer = reaper.time_precise() + speak_duration
                ]]--

                lock_field.message_shown = true
            end
            return
        end
    else
        player_x = new_x
        player_y = new_y
        total_steps = total_steps + 1
    end


    check_finish()
    check_diagonal_wall_collision(prev_player_x, prev_player_y, player_x, player_y)
end


function check_movement()
    if player_x ~= prev_player_x or player_y ~= prev_player_y then
        is_moving = true
    else
        is_moving = false
    end
end

function update_player(grid_size)
    if is_teleporting or is_finishing then
        animate_fade()
    else
        if move_dx ~= 0 or move_dy ~= 0 then
            move_player(move_dx, move_dy, grid_size)
            check_movement()
            check_level_touch(player_x, player_y, grid_size)
            check_special_fields(player_x, player_y)
            -- update_player_console_position() -- record steps
        end
    end
end




local difficulties = {"easy", "medium", "hard"}
local languages = {"en"}

local function getIndex(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return 1
end

function handle_keypress()
    local key = gfx.getchar()

    if key == 27 then  -- exit esc
        return false



    elseif game_state == "menu" and key == 110 then  -- n, hello screen
        game_state = "new_game"
        draw_new_game_screen()
    elseif game_state == "menu" and key == 115 then -- s, settings
        game_state = "settings"    
    elseif game_state == "new_game" and key == 13 then  -- enter, new game
        game_state = "playing"
        current_level = 1
        load_level(1)
        i_found_heart = total_heart
    elseif game_state == "menu" and key == 13 then  -- enter, continue game
        local saved_level = load_saved_level()

        if saved_level then
            current_level = saved_level
            game_state = "playing"
            load_level(current_level)
        end



    elseif game_state == "menu" and key == 108 then  -- l, level select menu
        game_state = "playing"
        current_level = 99 
        load_level(99)
    elseif game_state == "level_selected" and key == 13 then  -- enter, select level
        game_state = "playing"



    elseif game_state == "playing" and key == 8 then  -- backspace, main menu
        checkpoint_x = nil
        checkpoint_y = nil

        save_current_level()
        game_state = "menu"
        total_steps = 0



    elseif game_state == "dead" and key == 13 then  -- enter, try again
        i_found_heart = i_found_heart - 1

        if i_found_heart == 0 then
            game_state = "menu"
            i_found_heart = total_heart
            current_level = 1
            total_steps = 0
            save_current_level()
        else
            if checkpoint_x and checkpoint_y then
                player_x = checkpoint_x
                player_y = checkpoint_y
                i_found_key = 0
                game_state = "playing"
            else
                load_level(current_level)
                i_found_key = 0
                game_state = "playing"
                total_steps = 0
            end
        end
    elseif game_state == "dead" and key == 8 then -- backspace, main menu
        checkpoint_x = nil
        checkpoint_y = nil

        save_current_level()
        game_state = "menu"
        total_steps = 0



    elseif game_state == "level_transition" and key == 13 then  -- enter, next level
        checkpoint_x = nil
        checkpoint_y = nil

        current_level = current_level + 1

        if current_level > h_m_levels_is then
            game_state = "finished"
        else
            load_level(current_level)
            game_state = "playing"
            save_current_level()
        end

        total_steps = 0
    elseif game_state == "level_transition" and key == 114 then -- r, replay this level
        checkpoint_x = nil
        checkpoint_y = nil
        
        load_level(current_level)  
        i_found_key = 0
        game_state = "playing"
        total_steps = 0
        
    elseif game_state == "playing" and key == 114 then -- r, how many keys
        player_speak = "".. i_found_key ..""
        speak_timer = reaper.time_precise() + speak_duration


    elseif game_state == "finished" and key == 13 then  -- enter, main menu
        checkpoint_x = nil
        checkpoint_y = nil

        game_state = "menu"
        current_level = 1
        total_steps = 0

    elseif game_state == "settings" then
        local current_diff_index = getIndex(difficulties, maze_difficulty_is)
        local current_lang_index = getIndex(languages, current_language)
    
        if key == 13 then
            save_maze_settings()
            game_state = "menu"
    
        elseif key == 0x6C656674 then
            current_diff_index = current_diff_index - 1

            if current_diff_index < 1 then
                current_diff_index = #difficulties
            end

            maze_difficulty_is = difficulties[current_diff_index]
    
        elseif key == 0x72676874 then
            current_diff_index = current_diff_index + 1

            if current_diff_index > #difficulties then
                current_diff_index = 1
            end

            maze_difficulty_is = difficulties[current_diff_index]
    
        elseif key == 30064 then
            current_lang_index = current_lang_index - 1

            if current_lang_index < 1 then
                current_lang_index = #languages
            end

            current_language = languages[current_lang_index]
            is_us_lang = (current_language == "en")
    
        elseif key == 1685026670 then
            current_lang_index = current_lang_index + 1

            if current_lang_index > #languages then
                current_lang_index = 1
            end

            current_language = languages[current_lang_index]
            is_us_lang = (current_language == "en")
    
        end
    
        draw_settings_screen()
        gfx.update()
    



    elseif not is_moving and not is_teleporting and not is_finishing and not is_unlocking then
            if key == 105 or key == 30064 or key == 119 then  -- i, u
                move_dx, move_dy = 0, -1
            elseif key == 106 or key == 0x6C656674 or key == 97 then  -- j, l
                move_dx, move_dy = -1, 0
            elseif key == 107 or key == 1685026670 or key == 115 then  -- k, d
                move_dx, move_dy = 0, 1
            elseif key == 108 or key == 0x72676874 or key == 100 then  -- l, r
                move_dx, move_dy = 1, 0
            end
            -- handle_keypress2(key)
    end

    return true
end








function draw_grid_coordinates(visible_grid_size, cell_size)
    gfx.set(0.7, 0.7, 0.7)
    gfx.setfont(1, "Consolas", 15)

    for i = 1, visible_grid_size do
        for j = 1, visible_grid_size do
            local coord = index_to_coord(i, j)
            local x = (i - 1) * cell_size + cell_size / 2
            local y = (j - 1) * cell_size + cell_size / 2

            gfx.x = x - gfx.measurestr(coord) / 2
            gfx.y = y - gfx.texth / 2
            gfx.drawstr(coord)
        end
    end
end


































local move1_dx = 0
local move1_dy = 0
local is_moving1 = false

local move2_dx = 0
local move2_dy = 0
local is_moving2 = false

local player2_x = 1
local player2_y = 1

local prev_player2_x = player2_x
local prev_player2_y = player2_y

function index_to_coord2(x, y)
    local col_letters = ""
    local n = x
    while n > 0 do
        local remainder = (n - 1) % 26
        local char = string.char(remainder + string.byte('a'))
        col_letters = char .. col_letters
        n = math.floor((n - 1) / 26)
    end
    return col_letters .. tostring(y)
end

function draw_player2(grid_size, cell_size)
    local player_size = cell_size * 0.7
    local offset = (cell_size - player_size) / 2
    gfx.set(0.8, 0.2, 0.2)
    gfx.rect((player2_x - 1) * cell_size + offset, (player2_y - 1) * cell_size + offset, player_size, player_size, true)
end

function check_movement2()
    if player2_x ~= prev_player2_x or player2_y ~= prev_player2_y then
        is_moving2 = true
    else
        is_moving2 = false
    end
end

function move_player2(dx, dy, grid_size)
    prev_player2_x = player2_x
    prev_player2_y = player2_y

    local new_x = player2_x + dx
    local new_y = player2_y + dy

    if new_x < 1 or new_x > visible_grid_size or new_y < 1 or new_y > visible_grid_size then
        return
    end

    if dx > 0 then  
        --if not vertical_walls[player2_x][player2_y] then  
            player2_x = new_x
        --end
    elseif dx < 0 then  
        --if not vertical_walls[player2_x - 1][player2_y] then  
            player2_x = new_x
        --end
    elseif dy > 0 then  
        --if not horizontal_walls[player2_x][player2_y] then  
            player2_y = new_y
        --end
    elseif dy < 0 then  
        --if not horizontal_walls[player2_x][player2_y - 1] then  
            player2_y = new_y
        --end
    end
end

function update_player2(grid_size)
    if move2_dx ~= 0 or move2_dy ~= 0 then
        move_player2(move2_dx, move2_dy, grid_size)
        check_movement2()
        if current_level == 3 then
            local coord = index_to_coord2(player2_x, player2_y)
        end

        move2_dx, move2_dy = 0, 0
    end
end

function draw_player2(grid_size, cell_size)
    local player_size = cell_size * 0.7
    local offset = (cell_size - player_size) / 2
    gfx.set(0.8, 0.2, 0.2)
    gfx.rect((player2_x - 1) * cell_size + offset, (player2_y - 1) * cell_size + offset, player_size, player_size, true)
end




function draw_grid()
    local width, height = gfx.w, gfx.h
    local min_dimension = math.min(width, height)
    local cell_size = min_dimension / visible_grid_size

    for i = 0, visible_grid_size do
        gfx.set(0.7, 0.7, 0.7)
        gfx.line(0, i * cell_size, visible_grid_size * cell_size, i * cell_size)
        gfx.line(i * cell_size, 0, i * cell_size, visible_grid_size * cell_size)
    end
end

function draw_anything(grid_size, cell_size)
    local width, height = gfx.w, gfx.h
    local min_dimension = math.min(width, height)
    local cell_size = min_dimension / visible_grid_size

    if game_state ~= "level_transition" then
        draw_grid(grid_size)
        draw_footer()
    end
    
    if maze_difficulty_is == 'easy' then
        draw_walls(visible_grid_size, cell_size, wall_thickness)
        draw_diagonal_walls(cell_size, wall_diag_thickness)
        
        
        draw_start(visible_grid_size, cell_size) 
        draw_finish(visible_grid_size, cell_size)
        draw_special_fields(cell_size)
        draw_teleport_fields(cell_size)
        
        draw_player(visible_grid_size, cell_size)

        draw_level_n_keys_n_hearts()
        
    elseif maze_difficulty_is == 'medium' then
        draw_walls(visible_grid_size, cell_size, wall_thickness)
        draw_diagonal_walls(cell_size, wall_diag_thickness)
        
        
        draw_start(visible_grid_size, cell_size) 
        draw_finish(visible_grid_size, cell_size)
        draw_special_fields(cell_size)

        draw_player(visible_grid_size, cell_size)
        
        draw_teleport_fields(cell_size)
        

        draw_level_n_keys_n_hearts()

        
    elseif maze_difficulty_is == 'hard' then
        if is_eye_open then
            draw_walls(visible_grid_size, cell_size, wall_thickness)
            draw_diagonal_walls(cell_size, wall_diag_thickness)
            
            draw_start(visible_grid_size, cell_size) 
            draw_finish(visible_grid_size, cell_size)
            draw_special_fields(cell_size)
            
            
            draw_teleport_fields(cell_size)

            if game_state ~= "level_transition" then
                draw_triangle_near_player(player_x, player_y, cell_size)
            end
        else
            draw_full_darkness()
        end
        
        
        if game_state ~= "level_transition" then
            draw_shadow(visible_grid_size, cell_size)
            draw_footer()
        end
        
        draw_player(visible_grid_size, cell_size)
        draw_level_n_keys_n_hearts()
        
    elseif maze_difficulty_is == 'impo' and is_eye_open then
        draw_walls(visible_grid_size, cell_size, wall_thickness)
        draw_diagonal_walls(cell_size, wall_diag_thickness)
        
        draw_start(visible_grid_size, cell_size) 
        draw_finish(visible_grid_size, cell_size)
        draw_special_fields(cell_size)
        draw_teleport_fields(cell_size)

        if not is_robo_face_open() then
            draw_level_n_keys_n_hearts()
        end
    end
    
    
    -- draw_grid_coordinates(visible_grid_size, cell_size)
    -- draw_player2(grid_size, cell_size)
end

load_maze_settings()

function main()
    animate_blink()
    animate_fade()
    update_lock_timer()
    
    if game_state == "menu" then
        draw_menu_screen()
        gfx.update()
    elseif game_state == "settings" then
        draw_settings_screen()
        gfx.update()
    elseif game_state == "level_selected" then
        draw_level_selected_screen()
        gfx.update()
    elseif game_state == "playing" then
        load_maze_settings()
        what_player_speak()
        set_background_color(200, 200, 200)
        gfx.set(0.7, 0.7, 0.7)
        draw_anything()
        update_player(grid_size)
        update_player2()
    elseif game_state == "dead" then
        set_background_color(200, 30, 30)
        draw_death_message()
        gfx.update()
        reaper.ClearConsole()
    elseif game_state == "level_transition" then
        draw_level_transition_screen() 
        gfx.update()
        reaper.ClearConsole()
    elseif game_state == "finished" then
        draw_end_screen() 
        gfx.update()
    end

    if handle_keypress() then
        reaper.defer(main)
    end
end



init_walls(grid_size)

gfx.init("RoboMaze Game", 1000, 1000, _, 490, 30)

reaper.ClearConsole()
main()
gfx.update()
