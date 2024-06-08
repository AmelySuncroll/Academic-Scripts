local function calculateTotalDuration(note_lengths)
  local total = 0
  for _, length in ipairs(note_lengths) do
    total = total + length
  end
  return total
end

  

local function ornament(take, pitch, startppqpos, endppqpos, vel, note_lengths, pitch_offsets, repeatable)
  
  local selected_note_duration = endppqpos - startppqpos
  
  for j, _ in ipairs(note_lengths) do
    local new_pitch = pitch + pitch_offsets[j]
    
    local new_end = startppqpos + selected_note_duration
    
    reaper.MIDI_InsertNote(take, false, false, startppqpos, new_end, 0,
                           new_pitch, vel, true)   
    if not repeatable then
      break
    end
  end

  if repeatable then
    startppqpos = startppqpos + selected_note_duration
  end
end




local ornaments = {
  
  major = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  minor = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,    

  major4 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 12}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  minor4 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 12}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,  

  augmented = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  diminished = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 6}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,  
    

  -- Септаккорды

  maj7 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,    
  m7 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  dominant = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  dim7 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 6, 9}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  m7b5 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 6, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,


  -- Другие аккорды

  add9 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {3840, 3840, 3840, 3840} 
    local pitch_offsets = {0, 4, 7, 14}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,    

  add11 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {3840, 3840, 3840, 3840} 
    local pitch_offsets = {0, 4, 7, 17}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  add13 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {3840, 3840, 3840, 3840} 
    local pitch_offsets = {0, 4, 7, 9}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  sus2 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {3840, 3840, 3840} 
    local pitch_offsets = {0, 2, 7}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  sus4 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {3840, 3840, 3840} 
    local pitch_offsets = {0, 5, 7}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

}




-- Таблица синонимов
local aliases = {
    M = "major",
    m = "minor",
    aug = "augmented",
    dim = "diminished",
    d7 = "dominant",


  -- ... другие синонимы ...
}

local command_id = 40153

local function shortenSelectedNotes()
  -- ID команды для уменьшения длительности нот на один пиксель
  reaper.MIDIEditor_LastFocused_OnCommand(40445, false)
end

local function lengthenSelectedNotes()
  -- ID команды для увеличения длительности нот на один пиксель
  reaper.MIDIEditor_LastFocused_OnCommand(40444, false)
end

function main()
  local user_input
  local ornament_function
  repeat
    local retval
    retval, user_input = reaper.GetUserInputs("Academic Chords", 1, "Type of chord:", "")
    if not retval then return end

    user_input = user_input:lower()
    local alias = aliases[user_input]
    if alias then
      user_input = alias 
    end

    ornament_function = ornaments[user_input]

    if not ornament_function then
      reaper.ShowMessageBox("Chord not recognized. Please try again. \n \nBest, Amely Suncroll", "Error", 0)
    end
  until ornament_function

  local editor = reaper.MIDIEditor_GetActive()
  local take = reaper.MIDIEditor_GetTake(editor)
  if not take then return end

  local _, notecnt, _, _ = reaper.MIDI_CountEvts(take)
  local note_found = false



  local lowest_note
  local lowest_note_pitch
  local notes_to_delete = {} -- Массив для хранения индексов нот, которые нужно удалить
  local highest_endppqpos = 0 -- Для определения самой поздней конечной позиции среди выбранных нот

  shortenSelectedNotes()
  
  for i = 0, notecnt-1 do
    local retval, selected, _, startppqpos, endppqpos, _, pitch, vel = reaper.MIDI_GetNote(take, i)
    if selected then
      table.insert(notes_to_delete, i) -- Добавляем индекс ноты в массив
      if not lowest_note or pitch < lowest_note_pitch then
        lowest_note = {startppqpos, endppqpos, pitch, vel}
        lowest_note_pitch = pitch
      end
      if endppqpos > highest_endppqpos then
        highest_endppqpos = endppqpos -- Обновляем самую позднюю конечную позицию
      end
      note_found = true
    end
  end

  -- Удаляем все выбранные ноты
  for i = #notes_to_delete, 1, -1 do
    reaper.MIDI_DeleteNote(take, notes_to_delete[i])
  end

  if not note_found then
    reaper.ShowMessageBox("No note selected!", "Error", 0)
    return
  elseif lowest_note then
    ornament_function(take, lowest_note[3], lowest_note[1], lowest_note[2], lowest_note[4]) -- Применяем орнамент к самой низкой ноте
  end

  -- Поиск и выделение следующей ноты
  local next_note_index
  for i = 0, notecnt-1 do
    local retval, _, _, startppqpos, _, _, _, _ = reaper.MIDI_GetNote(take, i)
    if startppqpos > highest_endppqpos then
      next_note_index = i
      break
    end
  end

  if next_note_index then
    reaper.MIDI_SetNote(take, next_note_index, true, nil, nil, nil, nil, nil, nil, true) -- Выделяем следующую ноту
  end


  local next_chord_start = nil
  for i = 0, notecnt-1 do
  local retval, _, _, startppqpos, _, _, _, _ = reaper.MIDI_GetNote(take, i)
  if startppqpos > highest_endppqpos then
    if not next_chord_start then
      next_chord_start = startppqpos
    elseif startppqpos > next_chord_start then
      break
    end
  end
end

-- Выделение всех нот в следующем аккорде
if next_chord_start then
  for i = 0, notecnt-1 do
    local retval, _, _, startppqpos, _, _, _, _ = reaper.MIDI_GetNote(take, i)
    if startppqpos == next_chord_start then
      reaper.MIDI_SetNote(take, i, true, nil, nil, nil, nil, nil, nil, true)
    end
  end
end

  reaper.MIDI_Sort(take)
  reaper.UpdateArrange()
end

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("Insert Ornament", -1)