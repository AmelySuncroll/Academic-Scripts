-- @description Global Startup Action (settings)
-- @author Amely Suncroll, Alex_Ik
-- @version 1.0
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @

-- @about Set any actions as a startup - just add them here and forget forever.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- amelysuncroll@gmail.com

local startX = 570
local startY = 350 
local startWidth = 800 
local startHeight = 450
local script_window_title = "Global Startup Action (settings)"
gfx.init(script_window_title, startWidth, startHeight, 0, startX, startY)

local inputText = ""  
local scriptPath = reaper.GetResourcePath() .. "/Scripts/Academic-Scripts/Other/Global Startup Action/Amely Suncroll Global Startup Action List.lua"
local dictionaryContent = ""  
local fontSize = 20  
local scriptCoords = {}  
local scriptLines = {} 
local is_arrange_view = true
local is_midi_editor = false 

local checkboxStates = {}
local is_checked = false

local blink_interval = 0.5
local last_blink_time = reaper.time_precise()
local show_cursor = true


function focus_on_script_window_by_name(window_name)
    local hwnd = reaper.JS_Window_Find(window_name, true)
    if hwnd then
        reaper.JS_Window_SetFocus(hwnd)
    end
end

local function get_command_name(cmd)
    local is_checked = cmd:match("^%-%- ")

    if is_checked then
        cmd = cmd:gsub("^%-%- ", "")
    end

    cmd = cmd:gsub("^%s*['\"](.-)['\"]%s*$", "%1")

    local cmdName = reaper.CF_GetCommandText(0, reaper.NamedCommandLookup(cmd))
    if cmdName == "" then
        cmdName = reaper.CF_GetCommandText(32060, reaper.NamedCommandLookup(cmd))
        if cmdName == "" then
            cmdName = cmd
        end
    end

    if is_checked then
        cmdName = "-- " .. cmdName
    end

    return cmdName
end

local function load_dictionary_content()
    local file = io.open(scriptPath, "r")
    if not file then 
        dictionaryContent = "Failed to load the file. Be sure it is located to:\n" .. scriptPath .. ""
        return
    end
    
    local content = file:read("*all")
    file:close()
    
    dictionaryContent = ""
    scriptCoords = {}  
    scriptLines = {}  
    checkboxStates = {}

    local current_line = 1

    for id_section, dictionary_name, items in content:gmatch("(%-%- ID: %d+)%s+local (%w+)%s*=%s*{(.-)}") do
        local itemList = ""

        for cmd in items:gmatch("[^,]+") do
            cmd = cmd:gsub("^%s+", ""):gsub("%s+$", "")
            
            if cmd ~= "" then
                local is_checked = true

                if cmd:match("^%-%- ") then
                    is_checked = false
                    cmd = cmd:gsub("^%-%- ", "")
                end

                local cmdName = get_command_name(cmd)
                table.insert(scriptLines, {cmd = cmdName, line = current_line})
                itemList = itemList .. cmdName .. "\n"
                checkboxStates[current_line] = is_checked
                current_line = current_line + 1
            end
        end
        
        if dictionaryContent ~= "" then
            dictionaryContent = dictionaryContent .. "\n"
        end
        dictionaryContent = dictionaryContent .. itemList
    end
    
    if dictionaryContent == "" then
        dictionaryContent = "No dictionaries found in the file."
    end
end


local function insert_into_dictionary(dictionary_id, new_id)
    local file = io.open(scriptPath, "r")
    if not file then return end
    
    local content = file:read("*all")
    file:close()
    
    local updated_content = content:gsub(
        "(%-%- ID: " .. dictionary_id .. "%s+local %w+%s*=%s*{(.-)})",
        function(dictionary)
            local formatted_id
            if new_id:sub(1, 1) == "_" then
                formatted_id = "'" .. new_id .. "'"
            else
                formatted_id = new_id
            end
            return dictionary:gsub("}", "  " .. formatted_id .. ",\n}")
        end
    )
    
    file = io.open(scriptPath, "w")
    if file then
        file:write(updated_content)
        file:close()
        reaper.ShowMessageBox("Script with ID '" .. new_id .. "' was added to the Global Startup Action.", ":)", 0)
        load_dictionary_content()
        focus_on_script_window_by_name(script_window_title)
    else
        reaper.ShowMessageBox("Error saving the file!", ":(", 0)
    end
end

local function remove_script_by_line(line_number)
    local file = io.open(scriptPath, "r")
    if not file then return end
    
    local content = {}
    for line in file:lines() do
        table.insert(content, line)
    end
    file:close()
    
    local current_line = 1
    local inside_table = false
    local updated_content = {}
    
    for i, line in ipairs(content) do
        if line:match("local %w+%s*=%s*{") then
            inside_table = true
        elseif inside_table and line:match("}") then
            inside_table = false
        end
        
        if inside_table and current_line == line_number then
        else
            table.insert(updated_content, line)
        end

        if inside_table then
            current_line = current_line + 1
        end
    end
    
    file = io.open(scriptPath, "w")
    if file then
        file:write(table.concat(updated_content, "\n"))
        file:close()
        load_dictionary_content()
    else
        reaper.ShowMessageBox("Error saving the file!", ":(", 0)
    end
end

local function confirm_deletion(line_number, script)
    local confirmation = reaper.ShowMessageBox("Do you want to delete the script: " .. script .. "?\n\nYou can not to undo this action.", "Confirm Deletion", 4)
    if confirmation == 6 then  
        remove_script_by_line(line_number)
        reaper.ShowMessageBox("Script was deleted.", ":)", 0)
    end
    focus_on_script_window_by_name(script_window_title)
end

local ignore_actions = {
    "   ",
    "_______________________________________________________________________arrange_view",
    "________________________________________________________________________midi_editor",
    "____________________________________________________________________________archive",
    "Failed to load the file. Be sure it is located to:",
    "" .. scriptPath .. "",
    "No dictionaries found in the file."
}

local function should_ignore_action(script)
    for _, ignore in ipairs(ignore_actions) do
        if script == ignore then
            return true
        end
    end
    return false
end

local function update_script_line(line_number, line, should_deactivate)
    local file = io.open(scriptPath, "r")
    if not file then return end
    
    local content = {}
    for line_content in file:lines() do
        table.insert(content, line_content)
    end
    file:close()

    local current_line = 1
    local inside_table = false

    for i, line_content in ipairs(content) do
        if line_content:match("local %w+%s*=%s*{") then
            inside_table = true
        elseif inside_table and line_content:match("}") then
            inside_table = false
        end

        if inside_table then
            if current_line == line_number then
                if should_deactivate then
                    content[i] = line_content:gsub("^%-%- ", "")
                else
                    if not line_content:match("^%-%- ") then
                        content[i] = "-- " .. line_content
                    end
                end
                break
            end
            current_line = current_line + 1
        end
    end

    file = io.open(scriptPath, "w")
    if file then
        file:write(table.concat(content, "\n"))
        file:close()
    else
        reaper.ShowMessageBox("Error saving the file!", ":(", 0)
    end
end


local mouseWasDown = false 

local function handle_mouse_clicks(x, y)
    local mouseDown = gfx.mouse_cap & 1 == 1

    if mouseDown and not mouseWasDown then
        local mouseX, mouseY = gfx.mouse_x, gfx.mouse_y
        for _, coord in ipairs(scriptCoords) do
            if mouseY >= coord.yStart and mouseY <= coord.yEnd then
                if mouseX >= 10 and mouseX <= 24 then
                    if not should_ignore_action(coord.script) then
                        local is_checked = not checkboxStates[coord.line]
                        checkboxStates[coord.line] = is_checked
                        update_script_line(coord.line, coord.script, is_checked)
                    end
                else
                    if not should_ignore_action(coord.script) then
                        confirm_deletion(coord.line, coord.script)
                    end
                end
                break
            end
        end

        mouseWasDown = true
    elseif not mouseDown then
        mouseWasDown = false
    end
end

local function handle_input(char)
    if char == 13 then
        if inputText ~= "" then
            if is_arrange_view then
                local dictionary_id = "1"
                insert_into_dictionary(dictionary_id, inputText)
                inputText = ""
            elseif is_midi_editor then
                local dictionary_id = "2"
                insert_into_dictionary(dictionary_id, inputText)
                inputText = ""
            end
        end
    elseif char == 22 then
        local clipboardText = reaper.CF_GetClipboard()
        if clipboardText then
            inputText = inputText .. clipboardText
        end
    elseif char >= 32 and char <= 126 then
        inputText = inputText .. string.char(char)
    elseif char == 8 then
        inputText = inputText:sub(1, -2)
    end
end

local function draw_button(x, y, w, h, label, is_active)
    if is_active then
        gfx.set(0.4, 0.4, 0.4)
    else
        gfx.set(0.2, 0.2, 0.2)
    end
    
    gfx.rect(x, y, w, h, true)
    
    if is_active then
        gfx.set(1, 1, 1)
    else
        gfx.set(0.6, 0.6, 0.6)
    end
    
    gfx.x = x + (w - gfx.measurestr(label)) / 2
    gfx.y = y + (h - gfx.texth) / 2
    gfx.drawstr(label)
    
    if gfx.mouse_cap == 1 and gfx.mouse_x >= x and gfx.mouse_x <= (x + w) and gfx.mouse_y >= y and gfx.mouse_y <= (y + h) then
        return true
    end

    return false
end

local function draw_buttons()
    if draw_button(10, 10, 100, 30, "Arrange", is_arrange_view) then
        is_arrange_view = true
        is_midi_editor = false
        is_actions = false
        is_about = false
        load_dictionary_content()
    end
    
    if draw_button(120, 10, 100, 30, "MIDI", is_midi_editor) then
        is_arrange_view = false
        is_midi_editor = true
        is_actions = false
        is_about = false
        load_dictionary_content()
    end
    
    if draw_button(590, 10, 100, 30, "Actions") then
        if is_arrange_view then
            reaper.Main_OnCommand(40605, 1)
        elseif is_midi_editor then
            local section = 32060
            reaper.ShowActionList(section, 0)
        end
    end

    if draw_button(690, 10, 100, 30, "About", is_about) then
        is_arrange_view = false
        is_midi_editor = false
        is_actions = false
        is_about = true
    end
    gfx.update()
end

function draw_footer()
    local footer_text = "NOTE: if you already set some scripts to startup (like Lil Chordbox, Adaptive grid or RoboFace) - DO NOT add them here."
    local footer_font_size = 12
    gfx.setfont(1, "Consolas", footer_font_size)
    
    local text_width = gfx.measurestr(footer_text)
    local x_position = (gfx.w - text_width) / 2
    local y_position = gfx.h - footer_font_size - 10
    
    if inputText == "" then
        gfx.set(0.7, 0.7, 0.7)
    else
        gfx.set(1, 1, 1)
    end

    gfx.x = x_position
    gfx.y = y_position
    gfx.drawstr(footer_text)
end
    
local function draw_text_with_grad(text, max_width, is_checked)
    local window_width = gfx.w
    local text_width = gfx.measurestr(text)
    
    gfx.drawstr(text)
    
    if text_width > max_width then
        local gradient_width = 25
        local rect_x = window_width - gradient_width
        local rect_y = gfx.y
        local rect_height = gfx.texth

        for i = 0, gradient_width - 1 do
            local alpha = i / gradient_width
            gfx.set(0.2, 0.2, 0.2, alpha)
            gfx.line(rect_x + i, rect_y, rect_x + i, rect_y + rect_height)
        end
    end
    
    if not is_checked and not should_ignore_action(text) then
        local left_gradient_width = 500
        local left_rect_x = 30
        local left_rect_y = gfx.y
        local left_rect_height = gfx.texth

        for i = 0, left_gradient_width - 1 do
            local alpha = (left_gradient_width - i) / left_gradient_width
            gfx.set(0.2, 0.2, 0.2, alpha)
            gfx.line(left_rect_x + i, left_rect_y, left_rect_x + i, left_rect_y + left_rect_height)
        end
    end
end

local function draw_checkbox(x, y, is_checked)
    local box_size = 14

    if inputText == "" then
        if is_checked then
            gfx.set(0.8, 0.8, 0.8)
        else
            gfx.set(0.3, 0.3, 0.3)
        end
    else
        gfx.set(0.4, 0.4, 0.4)
    end

    gfx.rect(x, y, box_size + 1, box_size + 1, false)

    if is_checked then
        if inputText == "" then
            gfx.set(0.7, 0.7, 0.7)
        else
            gfx.set(0.4, 0.4, 0.4)
        end

        --gfx.line(x, y, x + box_size, y + box_size)
        --gfx.line(x + box_size, y, x, y + box_size)

        gfx.rect(x + 3, y + 3, box_size - 5, box_size - 5, true)
    end
end

local aboutText = 
"1. Set 'Global Startup Action List' as global startup action.\n" ..
"   Go to Extensions - Startup Actions - Set global startup action - ... - Save\n" ..
"   and then reopen this window.\n\n" ..

"2. Select a tab where you want to place your script - Arrange (View) or MIDI (Editor).\n" ..
"   Copy and paste here (Ctrl+V) your favorite action or script ID number.\n" ..
"   Press Enter button to add it (it will be saved automaticaly).\n\n" ..

"3. Click on a checkbox to turn script off/on.\n" ..
"   Click on the action to remove it (can not be undone).\n" ..
"   'Actions' tab is open REAPER's action list. If MIDI tab is active here,\n" ..
"   you will open actions for MIDI Editor.\n\n" ..
"NOTE:\n" ..
"If you already set some scripts to startup (like Lil Chordbox, Adaptive grid\n" ..
"or RoboFace) - do not add them here.\n"

function grafics()
    gfx.set(0.2, 0.2, 0.2, 1)
    gfx.rect(0, 0, gfx.w, gfx.h, true)

    gfx.set(0.4, 0.4, 0.4, 1)
    gfx.rect(10, 40, 780, 40, true)
    
    gfx.setfont(1, "Consolas", fontSize)
    gfx.x, gfx.y = 20, 50
    
    if is_arrange_view then
        if inputText == "" then
            gfx.set(0.9, 0.9, 0.9)
            gfx.printf("Enter arrange view action ID: ")
        else
            gfx.set(0.5, 0.5, 0.5)
            gfx.printf("Enter arrange view action ID: ")
        end

        gfx.set(1, 1, 1)
        gfx.printf(inputText)

        if show_cursor then
            gfx.set(0.9, 0.9, 0.9)
            gfx.printf("|")
        end

    elseif is_midi_editor then
        if inputText == "" then
            gfx.set(0.9, 0.9, 0.9)
            gfx.printf("Enter midi editor action ID: ")
        else
            gfx.set(0.5, 0.5, 0.5)
            gfx.printf("Enter midi editor action ID: ")
        end

        gfx.set(1, 1, 1)
        gfx.printf(inputText)

        if show_cursor then
            gfx.set(0.9, 0.9, 0.9)
            gfx.printf("|")
        end
        
    elseif is_about then
        gfx.set(0.2, 0.2, 0.2)
        gfx.printf("                                                      amely suncroll, alex_Ik. v1.0")
        
        gfx.x, gfx.y = 20, 100
        gfx.set(1, 1, 1)
        gfx.drawstr(aboutText)
    end

    gfx.x, gfx.y = 10, 100
    
    if not is_about then
        local currentY = gfx.y
        local lineCounter = 1
        scriptCoords = {}

        for line in dictionaryContent:gmatch("[^\n]+") do
            gfx.x, gfx.y = 10, currentY

            local is_checked = checkboxStates[lineCounter] or false

            if not should_ignore_action(line) then
                draw_checkbox(10, currentY + 3, is_checked)
            end
            
            gfx.x = 30 
            if inputText == "" then
                gfx.set(0.9, 0.9, 0.9)
            else
                gfx.set(0.4, 0.4, 0.4)
            end
            
            draw_text_with_grad(line, 0, is_checked)
            
            table.insert(scriptCoords, {script = line, yStart = currentY, yEnd = currentY + fontSize, line = lineCounter})
            currentY = currentY + fontSize
            lineCounter = lineCounter + 1
        end
    end

    draw_buttons()

    if not is_about then
        draw_footer()
    end

    gfx.update()
end

function main()
    local char = gfx.getchar()
    if char == 27 then
        return
    elseif char >= 0 then
        handle_input(char)
        reaper.defer(main)
    end
    
    if not is_about then
        handle_mouse_clicks()
    end
    
    if reaper.time_precise() - last_blink_time > blink_interval then
        show_cursor = not show_cursor
        last_blink_time = reaper.time_precise()
    end

    grafics()
    
    gfx.update()
end

load_dictionary_content()
main()