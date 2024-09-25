-- @description Text Editor for Comments (beta)
-- @author Amely Suncroll
-- @version 0.2.5
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + 0.2.5 add arrows and delete keys

-- @about Get empty_items with text as you want it - by each stroke, paragraph, from selection or timecodes with special markers (00:00 and 00:00:00).

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com


function load_window_params()
    local x = tonumber(reaper.GetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowPosX")) or 200
    local y = tonumber(reaper.GetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowPosY")) or 200
    local startWidth = tonumber(reaper.GetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowWidth")) or 700
    local startHeight = tonumber(reaper.GetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowHeight")) or 400
    local dock_state = tonumber(reaper.GetExtState("AmelySuncrollTextEditorBETABETABETA", "DockState")) or 0
    
    return x, y, startWidth, startHeight, dock_state
  end
  
  function save_window_params()
    local dock_state, x, y, startWidth, startHeight = gfx.dock(-1, 0, 0, 0, 0)
    reaper.SetExtState("AmelySuncrollTextEditorBETABETABETA", "DockState", tostring(dock_state), true)
    reaper.SetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowPosX", tostring(x), true)
    reaper.SetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowPosY", tostring(y), true)
    reaper.SetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowWidth", tostring(width), true)
    reaper.SetExtState("AmelySuncrollTextEditorBETABETABETA", "WindowHeight", tostring(height), true)
  end
  
  local x, y, startWidth, startHeight, dock_state = load_window_params()
  gfx.init("Text Editor for Comments (beta 0.2.5)", startWidth, startHeight, dock_state, x, y)
  
  
  
  ------------------------------------------------------------------------------------------------------------------------ LOCAL'S
  
  local lines = {""}
  local font_size = 16
  local line_spacing = 4
  local cursor_pos = 1 
  local current_line = 1
  local cursor_visible = true
  local cursor_blink_rate = 0.5
  local last_blink_time = reaper.time_precise()
  local cursor_x = 0
  local cursor_y = 0
  local scrollOffset = 0  
  local scrollPos = 0
  local linesInView = 0
  local last_mouse_cap = 0
  
  local selection_start_line = nil
  local selection_start_pos = nil
  local selection_end_line = nil
  local selection_end_pos = nil
  
  
  
  
  local function update_window_size()
    window_width, window_height = gfx.w, gfx.h
  end
  
  
  gfx.init(window_title, window_width, window_height)
  gfx.setfont(1, "Consolas", font_size)
  
  
  local function get_edit_cursor_position()
  return reaper.GetCursorPosition()
  end
  
  
  ------------------------------------------------------------------------------------------------------------------------- CURSOR
  
  local function draw_cursor()
    if cursor_visible then
        gfx.set(0, 0, 0, 1) 
        gfx.line(cursor_x, cursor_y, cursor_x, cursor_y + font_size)
    end
  end
  
  local function update_cursor_pos()
  if not current_line then current_line = 1 end
  if not cursor_pos then cursor_pos = 1 end
  if lines[current_line] then
      cursor_x = gfx.measurestr(lines[current_line]:sub(1, cursor_pos - 1)) + 10
      cursor_y = (current_line - 1 - scrollPos) * (font_size + line_spacing) + 10
  else
      cursor_x = 10
      cursor_y = (current_line - 1 - scrollPos) * (font_size + line_spacing) + 10
  end
  end
  
  local function update_cursor_blink()
    local current_time = reaper.time_precise()
    if current_time - last_blink_time > cursor_blink_rate then
        cursor_visible = not cursor_visible
        last_blink_time = current_time
    end
  end
  
  
  
  
  
  
  -------------------------------------------------------------------------------------------------------------------------- MOUSE
  local mouse_cap = 0
  local last_mouse_cap = 0
  local mouse_x, mouse_y = 0, 0
  
  local function handle_mouse_click(x, y)
  local line_height = font_size + line_spacing
  local clicked_line = math.floor((y - 10) / line_height) + 1 + scrollPos
  
  if clicked_line >= 1 and clicked_line <= #lines then
      current_line = clicked_line
      local str = lines[current_line]
      local str_width = gfx.measurestr(str)
      cursor_pos = #str + 1
      for i = 1, #str do
          local w = gfx.measurestr(str:sub(1, i))
          if x < (10 + w) then
              cursor_pos = i
              break
          end
      end
  
      if x > (10 + str_width) then
          cursor_pos = #str + 1
      end
      update_cursor_pos()
      selection_start_line, selection_start_pos = current_line, cursor_pos
      selection_end_line, selection_end_pos = nil, nil
  end
  end
  
  
  local function handle_mouse_drag(x, y)
  if selection_start_line then
      local line_height = font_size + line_spacing
      local clicked_line = math.floor((y - 10) / line_height) + 1 + scrollPos
  
      if clicked_line >= 1 and clicked_line <= #lines then
          local str = lines[clicked_line]
          local str_width = gfx.measurestr(str)
          local pos = #str + 1
          for i = 1, #str do
              local w = gfx.measurestr(str:sub(1, i))
              if x < (10 + w) then
                  pos = i
                  break
              end
          end
  
          selection_end_line, selection_end_pos = clicked_line, pos
      end
  end
  end
  
  
  local function handle_mouse_release()
  if selection_start_line and selection_end_line then
      if selection_start_line > selection_end_line or (selection_start_line == selection_end_line and selection_start_pos > selection_end_pos) then
          selection_start_line, selection_end_line = selection_end_line, selection_start_line
          selection_start_pos, selection_end_pos = selection_end_pos, selection_start_pos
      end
      current_line, cursor_pos = selection_end_line, selection_end_pos
      update_cursor_pos()
  end
  end
  
  
  local function draw_selection()
    if selection_start_line and selection_end_line then
        gfx.set(0.8, 0.8, 0.8, 0.5) 
        local line_height = font_size + line_spacing
        for line = selection_start_line, selection_end_line do
            if lines[line] then
                local start_pos = (line == selection_start_line) and selection_start_pos or 1
                local end_pos = (line == selection_end_line) and selection_end_pos or #lines[line] + 1
                local x_start = 10 + gfx.measurestr(lines[line]:sub(1, start_pos - 1))
                local x_end = 10 + gfx.measurestr(lines[line]:sub(1, end_pos - 1))
                local y_pos = (line - scrollPos - 1) * line_height + 10
                gfx.rect(x_start, y_pos, x_end - x_start, font_size + line_spacing, true)
            end
        end
    end
  end
  
  
  local function delete_selection()
  if selection_start_line and selection_end_line then
      if selection_start_line == selection_end_line then
          lines[selection_start_line] = lines[selection_start_line]:sub(1, selection_start_pos - 1) .. lines[selection_start_line]:sub(selection_end_pos)
      else
          local start_line_text = lines[selection_start_line]:sub(1, selection_start_pos - 1)
          local end_line_text = lines[selection_end_line]:sub(selection_end_pos)
          lines[selection_start_line] = start_line_text .. end_line_text
          for line = selection_end_line, selection_start_line + 1, -1 do
              table.remove(lines, line)
          end
      end
      current_line, cursor_pos = selection_start_line, selection_start_pos
      selection_start_line, selection_start_pos = nil, nil
      selection_end_line, selection_end_pos = nil, nil
      if not current_line then current_line = 1 end
      if not cursor_pos then cursor_pos = 1 end
      update_cursor_pos()
  end
  end
  
  local undo_stack = {}
  local redo_stack = {}
  
  local function save_state()
    table.insert(undo_stack, {lines = {table.unpack(lines)}, current_line = current_line, cursor_pos = cursor_pos})
    redo_stack = {}
  end
  
  local function load_state(state)
    if state then
        lines = {table.unpack(state.lines)}
        current_line = state.current_line
        cursor_pos = state.cursor_pos
        update_cursor_pos()
    end
  end
  
  local function undo()
    if #undo_stack > 0 then
        local state = table.remove(undo_stack)
        table.insert(redo_stack, {lines = {table.unpack(lines)}, current_line = current_line, cursor_pos = cursor_pos})
        load_state(state)
    end
  end
  
  local function redo()
    if #redo_stack > 0 then
        local state = table.remove(redo_stack)
        table.insert(undo_stack, {lines = {table.unpack(lines)}, current_line = current_line, cursor_pos = cursor_pos})
        load_state(state)
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  ------------------------------------------------------------------------------------------------------------- KEY- and CLIPBOARD
  local function paste_from_clipboard()
  local clipboard_text = reaper.CF_GetClipboard()
  if clipboard_text and clipboard_text ~= "" then
      local clipboard_lines = {}
      for line in clipboard_text:gmatch("([^\r\n]*)\r?\n?") do
          table.insert(clipboard_lines, line)
      end
  
      local first_line = true
      for _, line in ipairs(clipboard_lines) do
          if first_line then
              first_line = false
          else
              current_line = current_line + 1
              cursor_pos = 1
              table.insert(lines, current_line, "")
          end
  
          if line == "" then
              if lines[current_line] ~= "" then
                  current_line = current_line + 1
                  cursor_pos = 1
                  table.insert(lines, current_line, "")
              end
          else
              local before_cursor = lines[current_line]:sub(1, cursor_pos - 1)
              local after_cursor = lines[current_line]:sub(cursor_pos)
              lines[current_line] = before_cursor .. line .. after_cursor
              cursor_pos = cursor_pos + #line
          end
      end
      update_cursor_pos()
  end
  end
  
  local function copy_selection_to_clipboard()
  if selection_start_line and selection_end_line then
      local selected_text = ""
      if selection_start_line == selection_end_line then
          selected_text = lines[selection_start_line]:sub(selection_start_pos, selection_end_pos - 1)
      else
          selected_text = lines[selection_start_line]:sub(selection_start_pos) .. "\n"
          for line = selection_start_line + 1, selection_end_line - 1 do
              selected_text = selected_text .. lines[line] .. "\n"
          end
          selected_text = selected_text .. lines[selection_end_line]:sub(1, selection_end_pos - 1)
      end
      reaper.CF_SetClipboard(selected_text)
  end
  end
  
  local function select_all_text()
  selection_start_line = 1
  selection_start_pos = 1
  selection_end_line = #lines
  selection_end_pos = #lines[#lines] + 1
  current_line, cursor_pos = selection_end_line, selection_end_pos
  update_cursor_pos()
  end
  
  local function insert_char(char)
    lines[current_line] = lines[current_line]:sub(1, cursor_pos - 1) .. char .. lines[current_line]:sub(cursor_pos)
    cursor_pos = cursor_pos + 1
    update_cursor_pos()
  end

function handle_input(char, ctrl, shift)

    local LEFT_ARROW = 1818584692
    local RIGHT_ARROW = 1919379572
    local UP_ARROW = 30064
    local DOWN_ARROW = 1685026670
    local DELETE_KEY = 6579564

    if char == LEFT_ARROW then 
        if cursor_pos > 1 then
            cursor_pos = cursor_pos - 1
        elseif current_line > 1 then
            current_line = current_line - 1
            cursor_pos = #lines[current_line] + 1
        end
        selection_start_line, selection_start_pos = nil, nil
        selection_end_line, selection_end_pos = nil, nil
        update_cursor_pos()
    elseif char == RIGHT_ARROW then 
        if cursor_pos <= #lines[current_line] then
            cursor_pos = cursor_pos + 1
        elseif current_line < #lines then
            current_line = current_line + 1
            cursor_pos = 1
        end
        selection_start_line, selection_start_pos = nil, nil
        selection_end_line, selection_end_pos = nil, nil
        update_cursor_pos()
    elseif char == UP_ARROW then
        if current_line > 1 then
            current_line = current_line - 1
            cursor_pos = math.min(cursor_pos, #lines[current_line] + 1)
            update_cursor_pos()
        end
        selection_start_line, selection_start_pos = nil, nil
        selection_end_line, selection_end_pos = nil, nil
    elseif char == DOWN_ARROW then 
        if current_line < #lines then
            current_line = current_line + 1
            cursor_pos = math.min(cursor_pos, #lines[current_line] + 1)
            update_cursor_pos()
        end
        selection_start_line, selection_start_pos = nil, nil
        selection_end_line, selection_end_pos = nil, nil
    elseif char == DELETE_KEY or char == 127 then 
        if selection_start_line and selection_end_line then
            delete_selection()
        else
            local line_text = lines[current_line]
            if cursor_pos <= #line_text then
                lines[current_line] = line_text:sub(1, cursor_pos - 1) .. line_text:sub(cursor_pos + 1)
            elseif current_line < #lines then
                lines[current_line] = line_text .. lines[current_line + 1]
                table.remove(lines, current_line + 1)
            end
            update_cursor_pos()
        end
    else
        if char == 13 or (char >= 32 and char <= 126) or char == 8 or char == 22 or char == 127 then
            save_state()
        end

        if char == 13 then -- Enter key
            table.insert(lines, current_line + 1, lines[current_line]:sub(cursor_pos))
            lines[current_line] = lines[current_line]:sub(1, cursor_pos - 1)
            current_line = current_line + 1
            cursor_pos = 1
        elseif char == 8 then -- Backspace key
            if selection_start_line and selection_end_line then
                delete_selection()
            elseif cursor_pos > 1 then
                lines[current_line] = lines[current_line]:sub(1, cursor_pos - 2) .. lines[current_line]:sub(cursor_pos)
                cursor_pos = cursor_pos - 1
            elseif current_line > 1 then
                cursor_pos = #lines[current_line - 1] + 1
                lines[current_line - 1] = lines[current_line - 1] .. table.remove(lines, current_line)
                current_line = current_line - 1
            end
        elseif char == 22 then -- Ctrl + v
            paste_from_clipboard()
        elseif char == 1 then -- Ctrl + A
            select_all_text()
        elseif char == 3 then -- Ctrl + C
            copy_selection_to_clipboard()
        elseif char >= 32 and char <= 126 then
            if selection_start_line and selection_end_line then
                delete_selection()
            end
            insert_char(string.char(char))
        elseif ctrl and not shift and char == 26 then -- Ctrl + z
                undo()
        elseif ctrl and shift and char == 26 then -- Ctrl + Shift + z
                redo()
        else
            if char == 13 or (char >= 32 and char <= 126) or char == 8 or char == 22 or char == 127 then
                    save_state()
            end
        end    

        if current_line - scrollPos >= linesInView then
            scrollPos = scrollPos + 1
        elseif current_line - scrollPos < 1 then
            scrollPos = scrollPos - 1
        end     
        update_cursor_pos()
    end
end

  
  
  
  
  
  
  ---------------------------------------------------------------------------------------------------- FUNCTION TO SPLIT SENTENCES
  local function split_into_sentences()
  local updated_lines = {}
  for i, line in ipairs(lines) do
      local sentence_start = 1
      local j = 1
      while j <= #line do
          local char = line:sub(j, j)
          if char == "." or char == "!" or char == "?" then
              if (char == "!" or char == "?") and line:sub(j + 1, j + 2) == ".." then
                  j = j + 2
              elseif line:sub(j + 1, j + 1) == "!" or line:sub(j + 1, j + 1) == "?" then
                  if line:sub(j + 2, j + 2) == "!" or line:sub(j + 2, j + 2) == "?" then
                      j = j + 2
                  else
                      j = j + 1
                  end
              end
  
              if char == "." and line:sub(j + 1, j + 2) == ".." then
                  j = j + 2
              end
  
              local sentence = line:sub(sentence_start, j):gsub("^%s+", "")
              table.insert(updated_lines, sentence)
              sentence_start = j + 2
          end
          j = j + 1
      end
  
      if sentence_start <= #line then
          local remaining = line:sub(sentence_start):gsub("^%s+", "") 
          if remaining ~= "" then
              table.insert(updated_lines, remaining)
          end
      end
  end
  lines = updated_lines
  current_line = 1
  cursor_pos = 1
  update_cursor_pos()
  end
  
  
  
  
  
  
  local function GetOrCreateNotesTrack()
    local track_count = reaper.CountTracks(0)
    for i = 0, track_count - 1 do
        local track = reaper.GetTrack(0, i)
        local _, track_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
        if track_name == 'NOTES' then
            return track
        end
    end
    
    reaper.InsertTrackAtIndex(0, true)
    local notes_track = reaper.GetTrack(0, 0)
    reaper.GetSetMediaTrackInfo_String(notes_track, 'P_NAME', 'NOTES', true)
    return notes_track
  end
  
  local function CreateTextItemsFromLines()
  local notes_track = GetOrCreateNotesTrack() 
  local item_start_pos = get_edit_cursor_position()
  local item_length = 1
  
  reaper.Undo_BeginBlock()
  
  reaper.PreventUIRefresh(1)
  
  for _, line in ipairs(lines) do
      if line ~= "" then
          local new_item = reaper.AddMediaItemToTrack(notes_track)
          reaper.SetMediaItemPosition(new_item, item_start_pos, false)
          reaper.SetMediaItemLength(new_item, item_length, false)
          reaper.ULT_SetMediaItemNote(new_item, line)
          item_start_pos = item_start_pos + item_length + 0.5  -- duration of space between items
      end
  end
  
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.TrackList_AdjustWindows(false)
  reaper.Undo_EndBlock('Create Text Items From Lines', -1)
  end
  
  local function CreateTextItemsFromParagraphs()
  local notes_track = GetOrCreateNotesTrack() 
  local item_start_pos = get_edit_cursor_position() 
  local item_length = 1 
  
  reaper.Undo_BeginBlock()
  reaper.PreventUIRefresh(1)
  
  local paragraph = ""
  for _, line in ipairs(lines) do
      if line:match("^%s*$") then 
          if paragraph ~= "" then
              local new_item = reaper.AddMediaItemToTrack(notes_track)
              reaper.SetMediaItemPosition(new_item, item_start_pos, false)
              reaper.SetMediaItemLength(new_item, item_length, false)
              reaper.ULT_SetMediaItemNote(new_item, paragraph)
              item_start_pos = item_start_pos + item_length + 0.1
              paragraph = ""
          end
      else
          if paragraph ~= "" then
              paragraph = paragraph .. "\n" .. line
          else
              paragraph = line
          end
      end
  end
  
  if paragraph ~= "" then
      local new_item = reaper.AddMediaItemToTrack(notes_track)
      reaper.SetMediaItemPosition(new_item, item_start_pos, false)
      reaper.SetMediaItemLength(new_item, item_length, false)
      reaper.ULT_SetMediaItemNote(new_item, paragraph)
  end
  
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.TrackList_AdjustWindows(false)
  reaper.Undo_EndBlock('Create Text Items From Paragraphs', -1)
  
  -- force update "Notes" window
  reaper.Main_OnCommand(40029, 0) -- do undo
  reaper.Main_OnCommand(40030, 0) -- do redo
  end
  
  
  local function CreateItemFromSelection()
  if selection_start_line and selection_end_line then
      local notes_track = GetOrCreateNotesTrack() 
      local item_start_pos = get_edit_cursor_position()
      local item_length = 1
      
      reaper.Undo_BeginBlock()
      reaper.PreventUIRefresh(1)
      
      local selected_text = ""
      if selection_start_line == selection_end_line then
          selected_text = lines[selection_start_line]:sub(selection_start_pos, selection_end_pos - 1)
      else
          selected_text = lines[selection_start_line]:sub(selection_start_pos) .. "\n"
          for line = selection_start_line + 1, selection_end_line - 1 do
              selected_text = selected_text .. lines[line] .. "\n"
          end
          selected_text = selected_text .. lines[selection_end_line]:sub(1, selection_end_pos - 1)
      end
      
      if selected_text ~= "" then
          local new_item = reaper.AddMediaItemToTrack(notes_track)
          reaper.SetMediaItemPosition(new_item, item_start_pos, false)
          reaper.SetMediaItemLength(new_item, item_length, false)
          reaper.ULT_SetMediaItemNote(new_item, selected_text)
      end
      
      reaper.PreventUIRefresh(-1)
      reaper.UpdateArrange()
      reaper.TrackList_AdjustWindows(false)
      reaper.Undo_EndBlock('Create Item From Selection', -1)
      
      -- force update "Notes" window
      reaper.Main_OnCommand(40029, 0) -- do undo
      reaper.Main_OnCommand(40030, 0) -- do redo
  end
  end
  
  local function MarkerExists(time_in_seconds, text)
  local num_markers = reaper.CountProjectMarkers(0)
  for i = 0, num_markers - 1 do
      local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
      if not isrgn and pos == time_in_seconds and name == text then
          return true
      end
  end
  return false
  end
  
  local function ItemExists(track, time_in_seconds, length, text)
  local num_items = reaper.CountTrackMediaItems(track)
  for i = 0, num_items - 1 do
      local item = reaper.GetTrackMediaItem(track, i)
      local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
      local item_note = reaper.ULT_GetMediaItemNote(item)
      if item_pos == time_in_seconds and item_length == length and item_note == text then
          return true
      end
  end
  return false
  end
  
  
  local function CreateMarkersAndItemsFromTimecodes()
  local notes_track = GetOrCreateNotesTrack()
  
  reaper.Undo_BeginBlock()
  reaper.PreventUIRefresh(1)
  
  for _, line in ipairs(lines) do
      local timecode, text = line:match("^(%d?%d:%d%d:%d%d)%s*%-?%s*(.*)")
      if not timecode then
          timecode, text = line:match("^(%d?%d:%d%d)%s*%-?%s*(.*)")
      end
      
      if timecode then
          local time_in_seconds = 0
          local h, m, s = timecode:match("^(%d?%d):(%d%d):(%d%d)")
          if h and m and s then
              time_in_seconds = tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
          else
              m, s = timecode:match("^(%d?%d):(%d%d)")
              if m and s then
                  time_in_seconds = tonumber(m) * 60 + tonumber(s)
              end
          end
          
          if not MarkerExists(time_in_seconds, "FIX") then
              reaper.AddProjectMarker(0, false, time_in_seconds, 0, "FIX", -1)
          end
          
          if not ItemExists(notes_track, time_in_seconds, 10, text) then
              local new_item = reaper.AddMediaItemToTrack(notes_track)
              reaper.SetMediaItemPosition(new_item, time_in_seconds, false)
              reaper.SetMediaItemLength(new_item, 10, false) -- item duration is 10 seconds
              reaper.ULT_SetMediaItemNote(new_item, text) 
          end
      end
  end
  
  reaper.PreventUIRefresh(-1)
  reaper.UpdateArrange()
  reaper.TrackList_AdjustWindows(false)
  reaper.Undo_EndBlock('Create Markers and Items From Timecodes', -1)
  end
  
  function OpenBrowser(url)
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
  
  local show_about = false
  
  function draw_about_screen()
    gfx.set(0.2, 0.2, 0.2, 1) 
    gfx.rect(0, 0, window_width, window_height - 40, 1)
  
    gfx.set(1, 1, 1, 1)  
    gfx.x, gfx.y = 20, 20
    gfx.drawstr("Welcome!\n\n\n\nMake empty_items by each stroke, paragraph and with your text selection.\nCreate markers by timecodes with empty_items which contains all text\nafter timecode.\n\nSplit function - split all your sentences automaticaly to each stroke.\n\n\n\nP.S. Type in english only.")  
  end
  
  
  
  
  
  
  
  ------------------------------------------------------------------------------------------------------------------ DRAW BUTTONS
  local buttonWidth, buttonHeight = 100, 20
  local buttonY = gfx.h - 30
  
  local spacing = 0 
  
  local buttonX = 10
  local stroke_button_x = buttonX + buttonWidth - 45 + spacing
  local paragraph_button_x = stroke_button_x + buttonWidth - 40 + spacing
  local selection_button_x = paragraph_button_x + buttonWidth - 10 + spacing
  local timecode_button_x = selection_button_x + buttonWidth - 20 + spacing
  local about_button_x = timecode_button_x + buttonWidth - 15 + spacing
  local amely_suncroll_button_x = gfx.w - 190
  
  
  function color_buttons()
    if show_about then
        gfx.set(0.3, 0.3, 0.3, 1) 
    else
        gfx.set(1, 1, 1, 1) 
    end
  end

  
  
  local function draw_split_button()
    if window_width >= 460 then
        --gfx.set(1, 0.2, 0.2, 1)
        --gfx.rect(buttonX, gfx.h - 30, buttonWidth / 2, buttonHeight, 1)  
        color_buttons()
        gfx.x, gfx.y = buttonX + 4, gfx.h - 30
        gfx.drawstr("Split")  
    else
        --gfx.set(1, 0.2, 0.2, 1)  
        --gfx.rect(buttonX, gfx.h - 30, buttonWidth / 2, buttonHeight, 1)  
        gfx.set(1, 1, 1, 1)  
        gfx.x, gfx.y = buttonX + 4, gfx.h - 30
        gfx.drawstr("Split")  
    end
  end
  
  local function draw_create_text_items_button()
        --gfx.set(1, 0.2, 0.2, 1)  
        --gfx.rect(stroke_button_x, gfx.h - 30, buttonWidth / 2, buttonHeight, 1)  
        color_buttons()
        gfx.x, gfx.y = stroke_button_x + 1, gfx.h - 30
        gfx.drawstr("Stroke")  
  end
  
  local function draw_paragraph_button()
        --gfx.set(1, 0.2, 0.2, 1)  
        --gfx.rect(paragraph_button_x, gfx.h - 30, buttonWidth / 1.15, buttonHeight, 1)  
  
        color_buttons()
        gfx.x, gfx.y = paragraph_button_x + 2, gfx.h - 30
        gfx.drawstr("Paragraphs")
  end
  
  local function draw_selection_button()
        --gfx.set(1, 0.2, 0.2, 1)  
        --gfx.rect(selection_button_x, gfx.h - 30, buttonWidth / 1.3, buttonHeight, 1)  
  
        color_buttons()
        gfx.x, gfx.y = selection_button_x + 2, gfx.h - 30
        gfx.drawstr("Selection")  
  end
  
  local function draw_timecode_button()
        --gfx.set(1, 0.2, 0.2, 1)  
        --gfx.rect(timecode_button_x, gfx.h - 30, buttonWidth / 1.3, buttonHeight, 1)  
  
        color_buttons()
        gfx.x, gfx.y = timecode_button_x + 2, gfx.h - 30
        gfx.drawstr("Timecodes")  
  end
  
  local function draw_about_button()
        --gfx.set(1, 0.2, 0.2, 1)  
        --gfx.rect(about_button_x, gfx.h - 30, buttonWidth / 2.2, buttonHeight, 1)  
  
        if show_about then
            gfx.set(1, 1, 1, 1)  
        else
            gfx.set(0.4, 0.4, 0.4, 1)  
        end
  
        gfx.x, gfx.y = about_button_x + 2, gfx.h - 30
        gfx.drawstr("About")  
  end
  
  local function draw_amely_suncroll_button()
    if window_width >= 600 then
        --gfx.set(0.5, 0.5, 0.5, 1)  
        --gfx.rect(amely_suncroll_button_x, gfx.h - 30, buttonWidth, buttonHeight, 1)  
  
        if show_about then
            gfx.set(1, 1, 1, 1)
        else
            gfx.set(0.25, 0.25, 0.25, 1)  
        end
        
        gfx.x, gfx.y = gfx.w - 170, gfx.h - 30
        gfx.drawstr("amely suncroll, 2024")  
    end
  end
  
  local function handle_split_button_click(mouseX, mouseY)
  if mouseX >= buttonX and mouseX <= buttonX + buttonWidth / 2 and mouseY >= gfx.h - 30 and mouseY <= gfx.h - 30 + buttonHeight then
      split_into_sentences()
  end
  end
  
  local function handle_create_text_items_button_click(mouseX, mouseY)
  if mouseX >= stroke_button_x and mouseX <= stroke_button_x + buttonWidth / 2 and mouseY >= gfx.h - 30 and mouseY <= gfx.h - 30 + buttonHeight then
      CreateTextItemsFromLines()
  end
  end
  
  local function handle_paragraph_button_click(mouseX, mouseY)
  if mouseX >= paragraph_button_x and mouseX <= paragraph_button_x + buttonWidth / 1.15 and mouseY >= gfx.h - 30 and mouseY <= gfx.h - 30 + buttonHeight then
      CreateTextItemsFromParagraphs()
  end
  end
  
  local function handle_selection_button_click(mouseX, mouseY)
  if mouseX >= selection_button_x and mouseX <= selection_button_x + buttonWidth / 1.3 and mouseY >= gfx.h - 30 and mouseY <= gfx.h - 30 + buttonHeight then
      CreateItemFromSelection()
  end
  end
  
  local function handle_timecode_button_click(mouseX, mouseY)
  if mouseX >= timecode_button_x and mouseX <= timecode_button_x + buttonWidth / 1.3 and mouseY >= gfx.h - 30 and mouseY <= gfx.h - 30 + buttonHeight then
      CreateMarkersAndItemsFromTimecodes()
  end
  end
  
  local function handle_about_button_click(mouseX, mouseY)
    if mouseX >= about_button_x and mouseX <= about_button_x + buttonWidth / 2.2 and mouseY >= gfx.h - 30 and mouseY <= gfx.h - 30 + buttonHeight then
        show_about = not show_about
    end
  end
  
  local function handle_amely_suncroll_button_click(mouseX, mouseY)
    if window_width >= 600 then
        if mouseX >= gfx.w - 170 and mouseX <= gfx.w - 10 and mouseY >= gfx.h - 30 and mouseY <= gfx.h - 30 + buttonHeight then
            OpenBrowser("https://forum.cockos.com/showthread.php?t=291012")
        end
    end
  end
  
  
  
  ------------------------------------------------------------------------------------------------------------- DRAW TEXT AND WALL
  
  local function draw_footer()
    gfx.set(0.2, 0.2, 0.2)  
    
    --[[
    if window_width <= 460 then 
        gfx.rect(0, gfx.h - 60, gfx.w, 60, 1) 
    else 
        gfx.rect(0, gfx.h - 40, gfx.w, 50, 1) 
    end 
    ]]--
  
    gfx.rect(0, gfx.h - 40, gfx.w, 50, 1) 
  
    draw_amely_suncroll_button()
    draw_split_button()
    draw_create_text_items_button()
    draw_paragraph_button()
    draw_selection_button()
    draw_timecode_button()
    draw_about_button()
  end
  
  local function draw_text_n_wall()
  gfx.set(0.9, 0.9, 0.9, 1) 
  gfx.rect(0, 0, window_width, window_height - 40, 1) 
  
  gfx.set(0, 0, 0, 1) 
  local ypos = 10
  linesInView = math.floor((window_height - 50) / (font_size + line_spacing)) 
  local endLine = scrollPos + linesInView
  
  for i = scrollPos + 1, math.min(#lines, endLine) do
      gfx.x = 10
      gfx.y = ypos
      gfx.drawstr(lines[i])
      ypos = ypos + font_size + line_spacing 
  end
  draw_selection() 
  end
  
  
  
  
  
  
  
  local function main()
    update_window_size()
    update_cursor_blink()
  
    local char = gfx.getchar()
    if char == 27 then
        return  
    elseif char > 0 then
        local ctrl = gfx.mouse_cap & 4 == 4
        local shift = gfx.mouse_cap & 8 == 8
        handle_input(char, ctrl, shift)
    end
  
    mouse_cap = gfx.mouse_cap
    mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y
    if mouse_cap & 1 == 1 and last_mouse_cap & 1 == 0 then
        if mouse_y < gfx.h - 40 then
            handle_mouse_click(mouse_x, mouse_y)
        end
    elseif mouse_cap & 1 == 1 then
        if mouse_y < gfx.h - 40 then
            handle_mouse_drag(mouse_x, mouse_y)
        end
    elseif mouse_cap & 1 == 0 and last_mouse_cap & 1 == 1 then
        handle_mouse_release()
        if mouse_y >= gfx.h - 40 then
            handle_split_button_click(mouse_x, mouse_y)
            handle_create_text_items_button_click(mouse_x, mouse_y)
            handle_paragraph_button_click(mouse_x, mouse_y)
            handle_selection_button_click(mouse_x, mouse_y)
            handle_timecode_button_click(mouse_x, mouse_y)
            handle_about_button_click(mouse_x, mouse_y)
            handle_amely_suncroll_button_click(mouse_x, mouse_y)
        end
    end
  
    last_mouse_cap = mouse_cap  
    local mouse_wheel = gfx.mouse_wheel
  
    if mouse_wheel ~= 0 then
        scrollPos = scrollPos - math.floor(mouse_wheel / 120) 
        scrollPos = math.max(0, math.min(scrollPos, #lines - linesInView))
        gfx.mouse_wheel = 0
    end
  
    if show_about then
        draw_about_screen()
    else
        draw_text_n_wall()
        draw_cursor()
    end
  
    draw_footer()
    gfx.update()    
    if char ~= -1 then
        reaper.defer(main)
    end
  end
  
  
  local x, y, startWidth, startHeight, dock_state = load_window_params()
  gfx.init("Text Editor for Comments (beta 0.2.5)", startWidth, startHeight, dock_state, x, y)
  main()
  reaper.atexit(save_window_params)
