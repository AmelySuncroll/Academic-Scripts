-- @description Academic Chords
-- @author Amely Suncroll
-- @version 2.11
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + v2.0 add 117 chords, add random and double random chords (r, rr)
--    + v2.01 fix not update arrange view when docked piano roll
--    + v2.1 add tonality function
--    + v2.11 fix overlaps notes in tonality function
-- @about Get up to 117 chords! Select notes, chords or chords and notes together and go. Make new chords using big library. Get random chord for all notes and chords you select. Get random chords individually to each note and chord you select. Rein this horse by making a filters - and all random chords will contain what you want. Experimental function: make chords and replace them by tonality you will set there. Type 'i' to get instruction inside script.
-- Try to type next:
-- list - full list of chords
-- i - instructions
-- #9 or 7 or smth else after the chord to filter them with what you type
-- R - one random chord to all notes and chords you select
-- RR - different random chords to all notes and chords you select
-- Gm, G, F#m, C - set tonality
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- @website: https://t.me/reaper_ua

-- Support:
-- amelysuncroll@gmail.com

-- Other links:
-- https://github.com/AmelySuncroll

math.randomseed(os.time())

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
    
    reaper.MIDI_InsertNote(take, true, false, startppqpos, new_end, 0,
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

  ["7"] = function(take, pitch, start_pos, end_pos, vel)
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

  major7b5 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 6, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

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

  ["6"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 9}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  m6 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 9}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  maj9 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  maj11 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 14, 17}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  maj13 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 14, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["6/9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 9, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["maj#4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  m7b6 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m+7"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  m9 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  m11 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 10, 14, 17}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  m13 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 10, 14, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 7, 10, 14, 17}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 14, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 13}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 15}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  alt7 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 10, 13}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 7, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  susb9 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 7, 10, 13}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840} 
      local pitch_offsets = {0, 7}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["maj7#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["maj9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 14, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  sus24 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 2, 5, 7}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  majorb6 = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["maj9#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,


  ["7#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#5#9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 10, 15}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9#5#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 10, 14, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#5b9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 10, 13}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#5b9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 10, 13, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["+add#9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 15}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major#5add9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 8, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major6#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 9, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major7add13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 9, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["6/9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 9, 14, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b6"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 8, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["maj7#9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 15, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major13#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 14, 18, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major7b9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 11, 13}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#11b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 18, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 15, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13#9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 15, 18, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#9#11b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 15, 18, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13#9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 15, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#9b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 15, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 14, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 14, 18, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9#11b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 14, 18, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 13, 18}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13b9#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 13, 18, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b9b13#11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 13, 18, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13b9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 13, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b9b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 13, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b9#9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 10, 13, 15}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["majoradd9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["majoraddb9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 7, 13}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["majorb5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 6}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13b5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 6, 9, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major9b5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 6, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 6, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9b5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 6, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7no5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 10, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9no5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13no5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 10, 14, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 10, 14, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["madd4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 5, 7}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 8}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m6/9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 9, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["mmaj7b6"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 8, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["mmaj9b6"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 8, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["mmaj9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m7add11"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 10, 17}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["madd9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 7, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["o7major7"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 6, 9, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["omajor7"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 6, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["mb6major7"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 8, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m7#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 8, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m9#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 8, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m11#5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 8, 10, 14, 17}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m9b5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 6, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major9b5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 4, 6, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["m11b5"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 6, 10, 14, 17}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["mb6b9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 3, 8, 13}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major7#5sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 8, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major9#5sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 8, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7#5sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 8, 10}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major7sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 7, 11}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["major9sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 7, 11, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["9sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 7, 10, 14}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["13sus4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 7, 10, 14, 21}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["7sus4b9b13"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 7, 10, 13, 20}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["4"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 5, 10, 15}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,

  ["11b9"] = function(take, pitch, start_pos, end_pos, vel)
      local note_lengths = {3840, 3840, 3840, 3840, 3840} 
      local pitch_offsets = {0, 7, 10, 13, 17}
      local repeatable = true 
      ornament(take, pitch, start_pos, end_pos, vel, note_lengths, pitch_offsets, repeatable)
    end,



}




-- Таблица синонимов
local aliases = {
    maj = "major",
    min = "minor",
    aug = "augmented",
    dim = "diminished",
    hd = "m7b5",
    halfdim = "m7b5",
    o7 = "dim7",
    cm9 = "maj9",
    cm11 = "maj11",
    cm13 = "maj13",
    cm6 = "6",
    add13 = "6",
    lyd = "maj#4",
    ["mmajor7"] = "m+7",
    ["m/maj7"] = "m+7",
    phryg = "susb9",
    b9sus = "susb9",
    sus4b9 = "susb9",
    sus4add9 = "sus24",
    ["7+5"] = "7#5",
    ["maj9+5"] = "maj9#5",
    ["maj7+5"] = "maj7#5",
    ["maj9+5"] = "maj9#5",
    ["7#9b13"] = "7#5#9",
    ["+add9"] = "major#5add9",
    ["6#11"] = "major6#11",
    ["m6b5"] = "major6#11",
    ["6b5"] = "major6#11",
    ["maj13#11"] = "major13#11",
    ["m13+4"] = "major13#11",
    ["m13#4"] = "major13#11",
    ["7b5b13"] = "7#11b13",
    ["7b5#9"] = "7#9#11",
    ["9+4"] = "9#11",
    ["9#4"] = "9#11",
    ["9b5b13"] = "9#11b13",
    ["7b5b9"] = "7b9#11",
    ["7b9#11b13"] = "7b9b13#11",
    ["7b5b9b13"] = "7b9b13#11",
    ["2"] = "majoradd9",
    ["add2"] = "majoradd9",
    ["addb2"] = "majoraddb9",
    ["-2"] = "majoraddb9",
    ["m+"] = "m#5",
    ["mb6"] = "m#5",
    ["-maj9"] = "mmaj9",
    ["m7add4"] = "m7add11",
    ["dim7m7"] = "o7major7",
    ["dimm7"] = "omajor7",
    ["m7+5"] = "m7#5",
    ["m9+5"] = "m9#5",
    ["m11+5"] = "m11#5",
    ["7b9b13sus4"] = "7sus4b9b13",

}

local command_id = 40153

function forceMidiEditorRedraw(editor)
  reaper.MIDIEditor_OnCommand(editor, 40445) 
  reaper.MIDIEditor_OnCommand(editor, 40444)
end

local function randomChord(filter1, filter2)
  local keys = {}
  for key, _ in pairs(ornaments) do
      if (not filter1 or key:find(filter1)) and (not filter2 or key:find(filter2)) then
          table.insert(keys, key)
      end
  end
  if #keys == 0 then return nil end
  return keys[math.random(#keys)]
end


local take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
local _, notecnt, _, _ = reaper.MIDI_CountEvts(take)

function applyRandomChordsIndividually(filter1, filter2)
  local chordCount, singleNotes, startPositions, notesToDelete, notes = count_chords_and_notes()
  table.sort(notesToDelete, function(a, b) return a > b end)
  for _, note_index in ipairs(notesToDelete) do
    reaper.MIDI_DeleteNote(take, note_index)
  end

  for _, indices in pairs(startPositions) do
    local notesAtPos = {}
    for _, note_index in ipairs(indices) do
      table.insert(notesAtPos, notes[note_index])
    end

    table.sort(notesAtPos, function(a, b) return a[3] < b[3] end)
    local lowest_note = notesAtPos[1]

    if lowest_note then
      local pitch = lowest_note[3]
      local startppqpos = lowest_note[1]
      local endppqpos = lowest_note[2]
      local vel = lowest_note[4]
      local randomKey = randomChord(filter1, filter2)
      if randomKey then
        local ornament_function = ornaments[randomKey]
        if ornament_function then
          ornament_function(take, pitch, startppqpos, endppqpos, vel)
        end
      end
    end
  end
  local editor = reaper.MIDIEditor_GetActive()
  if editor then
    forceMidiEditorRedraw(editor)
  end
end


function count_chords_and_notes()
  local notes = {}
  local chordCount = 0
  local singleNotes = 0
  local startPositions = {}
  local notesToDelete = {}
  local timeThreshold = 200

  for i = 0, notecnt - 1 do
      local _, selected, _, startpos, endpos, _, pitch, vel = reaper.MIDI_GetNote(take, i)
      if selected then
          notes[i] = {startpos, endpos, pitch, vel}
          local found = false
          for pos, notesAtPos in pairs(startPositions) do
              if math.abs(pos - startpos) <= timeThreshold then
                  table.insert(notesAtPos, i)
                  found = true
                  break
              end
          end
          if not found then
              startPositions[startpos] = {i}
          end
      end
  end

  for _, indices in pairs(startPositions) do
      if #indices > 1 then
          chordCount = chordCount + 1
          for _, idx in ipairs(indices) do
              table.insert(notesToDelete, idx)
          end
      else
          singleNotes = singleNotes + 1
          table.insert(notesToDelete, indices[1])
      end
  end

  return chordCount, singleNotes, startPositions, notesToDelete, notes
end



function count_chords_and_notes2(take, notecnt)
    local notes = {}
    local chordCount = 0
    local singleNotes = 0
    local startPositions = {}
    local notesToDelete = {}
    local timeThreshold = 200

    for i = 0, notecnt - 1 do
        local _, selected, _, startpos, endpos, _, pitch, vel = reaper.MIDI_GetNote(take, i)
        if selected then
            notes[i] = {startpos, endpos, pitch, vel, index=i}
            local found = false
            for pos, notesAtPos in pairs(startPositions) do
                if math.abs(pos - startpos) <= timeThreshold then
                    table.insert(notesAtPos, notes[i])
                    found = true
                    break
                end
            end
            if not found then
                startPositions[startpos] = {notes[i]}
            end
        end
    end

    for _, notesAtPos in pairs(startPositions) do
        if #notesAtPos > 1 then
            chordCount = chordCount + 1
            table.sort(notesAtPos, function(a, b) return a[3] < b[3] end)  
            for i = 2, #notesAtPos do  
                table.insert(notesToDelete, notesAtPos[i].index)
            end
        else
            singleNotes = singleNotes + 1
        end
    end

    return chordCount, singleNotes, startPositions, notesToDelete, notes
end

function delete_lowest_notes()
    local editor = reaper.MIDIEditor_GetActive()
    local take = reaper.MIDIEditor_GetTake(editor)

    if not take or not reaper.ValidatePtr(take, "MediaItem_Take*") then
        reaper.ShowMessageBox("No active MIDI take found.", "Error", 0)
        return
    end

    local notecnt, _, _ = reaper.MIDI_CountEvts(take)
    local _, _, _, notesToDelete, _ = count_chords_and_notes2(take, notecnt)
    table.sort(notesToDelete, function(a, b) return a > b end)  

    for _, noteIdx in ipairs(notesToDelete) do
        reaper.MIDI_DeleteNote(take, noteIdx)
    end

    reaper.MIDI_Sort(take)
    reaper.MIDIEditor_OnCommand(editor, 40435)  -- Unselect all notes
end



function note_to_midi_number(note)
  local notes = {C=0, D=2, E=4, F=5, G=7, A=9, B=11}
  local accidental = note:sub(2, 2)
  local base_note = notes[note:sub(1, 1):upper()]
  if accidental == '#' then
      base_note = base_note + 1
  elseif accidental == 'b' then
      base_note = base_note - 1
  end
  local octave = 4  
  return base_note + (octave + 1) * 12
end

function parse_tonality(input)
    local note_name, scale_type = input:match("^([A-Ga-g][#b]?)(%s+minor|%s+major)$")
    if note_name and scale_type then
        note_name = note_name:sub(1, 1):upper() .. note_name:sub(2)
        local tonic = note_to_midi_number(note_name)
        scale_type = scale_type:match("minor") and 'minor' or 'major'
        return tonic, scale_type
    else
        return nil, nil
    end
  end


function note_to_scale_degree(note, tonic, scale_type)
  local scale_intervals = scale_type == 'minor' and {0, 2, 3, 5, 7, 8, 10} or {0, 2, 4, 5, 7, 9, 11}
  local degree = (note - tonic) % 12
  for i, interval in ipairs(scale_intervals) do
      if degree == interval then
          return i
      end
  end
  return nil  
end

function apply_chords_by_scale(take, tonic, scale_type)
    reaper.Undo_BeginBlock()
    local chordCount, singleNotes, startPositions, notesToDelete, notes = count_chords_and_notes2(take, notecnt)
    local chord_types = {
        major = {'major', 'minor', 'minor', 'major', '7', 'minor', 'diminished'},
        minor = {'minor', 'diminished', 'major', 'minor', '7', 'major', 'major'}
    }

    table.sort(notesToDelete, function(a, b) return a > b end)
    for _, noteIdx in ipairs(notesToDelete) do
        reaper.MIDI_DeleteNote(take, noteIdx)
    end

    for start_pos, indices in pairs(startPositions) do
        local notesAtPos = {}
        for _, note_info in ipairs(indices) do
            local pitch = note_info[3]
            if note_to_scale_degree(pitch, tonic, scale_type) then
                table.insert(notesAtPos, note_info)
            end
        end

        if #notesAtPos > 0 then
            table.sort(notesAtPos, function(a, b) return a[3] < b[3] end)
            local lowest_note = notesAtPos[1]
            local pitch = lowest_note[3]
            local startppqpos = lowest_note[1]
            local endppqpos = lowest_note[2]
            local vel = lowest_note[4]
            local degree = note_to_scale_degree(pitch, tonic, scale_type)
            if degree then
                local chord_type = chord_types[scale_type][degree]
                local ornament_function = ornaments[chord_type]
                if ornament_function then
                    ornament_function(take, pitch, startppqpos, endppqpos, vel)
                end
            end
        end
    end

    local editor = reaper.MIDIEditor_GetActive()
    if editor then
        forceMidiEditorRedraw(editor)
    end
    reaper.Undo_EndBlock("Set tonality", -1)
end


function focusMidiEditor()
  local focus_midi_editor = reaper.NamedCommandLookup("_SN_FOCUS_MIDI_EDITOR")
  reaper.Main_OnCommand(focus_midi_editor, 0)
end



function main()
  local user_input
  local ornament_function
  repeat
    local retval
    retval, user_input = reaper.GetUserInputs("Academic Chords 2.11", 1, "Type of chord (i to get info):", "")
    if not retval then return end

    user_input = user_input:lower()

    if user_input == "instruction" or user_input == "i" then
      reaper.ShowMessageBox("Thank you to download this script! \n \n \nYou can type here any chord you know. \nExample: major or 7b9b13#11 \n \nType just R or RR to get one or more random chord(s) \n \nType #9 or 7 after the chord to filter it only with what you type \n \nType LIST to get chords list.   \n \n \nYou can support me via PayPal: \n@suncroll \n \nBest, Amely Suncroll", "Instruction", 0)
      return
    end

    if user_input == "list" then
      reaper.ShowMessageBox("MAJOR: \nmajor, major4, maj7, maj9, maj11, maj13, major7b5, majorb6, maj9#11, maj#4, major6#11, major7add13, major7b9, major7#5sus4, major9#5sus4, major7sus4, major9sus4, major9b5, majoradd9, majoraddb9, majorb5; \n \nMINOR: \nminor, minor4, m7, m6, m7b5, m7b6, m+7, m9, m11, m13, madd4, m#5, m6/9, mmaj7b6, mmaj9b6, mmaj9, m7add11, madd9, mb6major7, m7#5, m9#5, m11#5, m9b5, m11b5, mb6b9; \n \nAUGMENTED, DIMINISHED AND SUSPENDED: \naugmented, diminished, dim7, sus2, sus4, sus24; \n \nSEVENTH: \n7, 7b5, 7no5, 7b13, 7#11, 7b9, 7#9, 7sus4, 7#5, 7#5#9, 7#5b9, 7#5b9#11, +add#9, 7#9#11, 7b9#11, 7#11b13, 7#9b13, 7b9b13#11, 7#9#11b13, 7b6, 7b9#9, 7#9b13; \n \nNINE, ELEVEN AND THIRTEEN: \n9, 9#5, 9b5, 9no5, 9b13, 9#11, 9#11b13, 11, 11b9, 13, 13no5, 13#9, 13#11, 13b9, 13b5, 13b9#11, 13#9#11, 13#11b13, 13b9b13#11, 13#9b13, 6/9, 6/9#11; \n \nOTHERS: \nalt7, susb9, 5, maj7#5, maj9#5, 9#5#11, o7major7, omajor7 (o means half) \n \nNOTE \nTHERE NO DIFFERENSE between m and M. So here 'm' is minor and 'major' is major. Madd9 is majoradd9 here :(", "Chords list", 0)
      return
    end

    local alias = aliases[user_input]
    if alias then
      user_input = alias 
    end

    if user_input == "r" or user_input == "random" then
        local keys = {}
        for key, _ in pairs(ornaments) do
          table.insert(keys, key)
        end
        local randomKey = keys[math.random(#keys)]
        user_input = randomKey
    end

    if user_input == "rr" then
      applyRandomChordsIndividually()
      return
    end

    if user_input:match("^r ([^%s]+) ([^%s]+)$") then
      local filter1, filter2 = user_input:match("^r ([^%s]+) ([^%s]+)$")
      user_input = randomChord(filter1, filter2)
  
    elseif user_input:match("^rr ([^%s]+) ([^%s]+)$") then
      local filter1, filter2 = user_input:match("^rr ([^%s]+) ([^%s]+)$")
      applyRandomChordsIndividually(filter1, filter2)
      return
  
    elseif user_input:match("^r (.+)$") then
      local filter = user_input:match("^r (.+)$")
      user_input = randomChord(filter)
  
    elseif user_input:match("^rr (.+)$") then
      local filter = user_input:match("^rr (.+)$")
      applyRandomChordsIndividually(filter)
      return
    end

    if user_input:match("^([A-Ga-g][#b]?)(m?)$") then
      local tonic_note, minor = user_input:match("^([A-Ga-g][#b]?)(m?)$")
      tonic_note = note_to_midi_number(tonic_note) 
      local scale_type = minor == 'm' and 'minor' or 'major'
      delete_lowest_notes()
      apply_chords_by_scale(take, tonic_note, scale_type)
      return
    end
  
  
  
    ornament_function = ornaments[user_input]

    if not ornament_function then
      reaper.ShowMessageBox("Chord not recognized. Please try again.", ":(", 0)
    end
  until ornament_function

  local chordCount, singleNotes, startPositions, notesToDelete, notes = count_chords_and_notes()
  table.sort(notesToDelete, function(a, b) return a > b end)

  for _, note_index in ipairs(notesToDelete) do
    reaper.MIDI_DeleteNote(take, note_index)
  end

  for _, indices in pairs(startPositions) do
    local notesAtPos = {}
    for _, note_index in ipairs(indices) do
        table.insert(notesAtPos, notes[note_index])
    end

    table.sort(notesAtPos, function(a, b) return a[3] < b[3] end) 
    local lowest_note = notesAtPos[1]

    if lowest_note then
        local pitch = lowest_note[3]
        local startppqpos = lowest_note[1]
        local endppqpos = lowest_note[2]
        local vel = lowest_note[4]
        ornament_function(take, pitch, startppqpos, endppqpos, vel) 
    end
  end

  reaper.MIDI_Sort(take)
  reaper.UpdateArrange()
end

reaper.Undo_BeginBlock()
main()
focusMidiEditor()
reaper.Undo_EndBlock("Insert Ornament", -1)
