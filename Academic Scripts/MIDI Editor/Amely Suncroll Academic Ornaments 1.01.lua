e-- @description Academic Ornaments
-- @author Amely Suncroll
-- @version 1.01
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + v1.01 keep midi editor focused
-- @about Set trills and forshlags here. And now YOU CAN CREATE YOUR OWN ORNAMENTS (instructions is inside the code).
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- https://t.me/yxo_composer_support
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll
-- https://www.youtube.com/@yxo_composer


local function calculateTotalDuration(note_lengths)
  local total = 0
  for _, length in ipairs(note_lengths) do
    total = total + length
  end
  return total
end



local function ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  local current_pos = start_pos 
  local total_duration = calculateTotalDuration(note_lengths) 
  
  repeat
    for j, len in ipairs(note_lengths) do
      local new_pitch = pitch + pitch_offsets[j]
      local new_start = current_pos
      local new_end = new_start + len

      
      if not repeatable and j == #note_lengths then
        new_end = end_pos
      elseif new_end > end_pos then
        new_end = end_pos
        len = new_end - new_start 
      end
     
      reaper.MIDI_InsertNote(take, false, false, new_start, new_end, 0,
                             new_pitch, vel, true)

      current_pos = new_end 
      
      if current_pos >= end_pos then
        return
      end
    end
  until not repeatable and current_pos + total_duration > end_pos 
end


------------------------------------------------------------------------------------------------------
--------------------------------  CONSTRUCT YOUR OWN ORNAMENTS HERE  ---------------------------------
------------------------------------------------------------------------------------------------------

-- NOTE LENGTHS: 1 = 7680; 2 = 3840; 4 = 1920; 8 = 960; 16 = 480; 32 = 240
local ornaments = {

  mordant = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {240, 240, 960} -- length and number of each note (here is three notes)
    local pitch_offsets = {0, -1, 0}  -- pitch of each note
    local repeatable = false -- repeat notes is off
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,


  trill2 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {3840, 3840} -- length and number of each note (here is two notes)
    local pitch_offsets = {2, 0}
    local repeatable = true -- repeat notes is on
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  trill4 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {1920, 1920} 
    local pitch_offsets = {2, 0}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  trill8 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {960, 960} 
    local pitch_offsets = {2, 0}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  trill16 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {480, 480} 
    local pitch_offsets = {2, 0}
    local repeatable = true 
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,


  trill32 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {240, 240}
    local pitch_offsets = {2, 0}
    local repeatable = true
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  trill64 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {120, 120}
    local pitch_offsets = {2, 0}
    local repeatable = true
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  trill128 = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {60, 60}
    local pitch_offsets = {2, 0}
    local repeatable = true
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  forshlug = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {120, 7680}
    local pitch_offsets = {-2, 0}
    local repeatable = false
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  slide = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240}
    local pitch_offsets = {-12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0}
    local repeatable = false
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,

  gliss = function(take, pitch, start_pos, end_pos, vel)
    local note_lengths = {240, 240, 240, 240, 240, 240, 240, 240} 
    local pitch_offsets = {-12, -10, -8, -7, -5, -3, -1, 0}
    local repeatable = false
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
  end,


  
  ---------------------------  CONSTRUCT YOUR OWN ORNAMENTS HERE  ----------------------------

  your_example = function(take, pitch, start_pos, end_pos, vel) -- name of your own ornament
    local note_lengths = {240, 240, 240} -- length and number of each note (now is three notes here)
    local pitch_offsets = {2, 0, -2}  -- pitch of each note
    local repeatable = true  -- repeat notes until selection is off ( = "false" is on)
    ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable) 
  end,

 


}



local aliases = {
  mor = "mordant",
  tr2 = "trill2",
  tr4 = "trill4",
  tr8 = "trill8",
  tr16 = "trill16",
  tr = "trill16",
  tr32 = "trill32",
  trill = "trill32",
  tr64 = "trill64",
  tr128 = "trill128",
  acci = "forshlug",
  short = "forshlug",
  nach = "forshlug",
  nachschlag = "forshlug",

  ye = "your_example",  -------------------------------------------- YOUR OWN ALIAS HERE

}




local command_id = 40153

function focusMidiEditor()
  local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
  reaper.Main_OnCommand(focus_midi_editor, 0)
end

function main()
  local user_input
  local ornament_function
  repeat
    local retval
    retval, user_input = reaper.GetUserInputs("Academic Ornaments 1.01", 1, "Type of ornament:", "")
    if not retval then return end 

    user_input = user_input:lower()
    
    local alias = aliases[user_input]
    if alias then
      user_input = alias 
    end

    ornament_function = ornaments[user_input]

    if not ornament_function then
      reaper.ShowMessageBox("Ornament not recognized. Please try again. \n \nBest, Amely Suncroll", "Error", 0)
    end
  until ornament_function

  local editor = reaper.MIDIEditor_GetActive()
  local take = reaper.MIDIEditor_GetTake(editor)
  if not take then return end

  local _, notecnt, _, _ = reaper.MIDI_CountEvts(take)
  local note_found = false

  for i = 0, notecnt-1 do
    local retval, selected, _, startppqpos, endppqpos, _, pitch, vel = reaper.MIDI_GetNote(take, i)
    if selected then
      reaper.MIDI_DeleteNote(take, i) 
      ornament_function(take, pitch, startppqpos, endppqpos, vel, 1) 
      note_found = true
      break 
    end
  end
  
  if not note_found then
    reaper.ShowMessageBox("No note selected!", "Error", 0)
    return
  end

  reaper.MIDI_Sort(take)
  reaper.UpdateArrange()
end

reaper.Undo_BeginBlock()
main()
focusMidiEditor()

reaper.Undo_EndBlock("Insert Ornament", -1)
