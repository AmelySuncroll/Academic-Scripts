-- @description Global Startup Action List 2
-- @author Amely Suncroll, Alex_Ik
-- @version 1.11
-- @changelog
--    + init @
--    + 1.1 add tabs
--    + 1.11 add folder for files
-- @noIndex

local r = reaper

-- ID: 1
local mainWindowActions = {'_______________________________________________________________________arrange_view',
'   ',
}

-- ID: 2
local midiEeditorActions = {'   ',
'________________________________________________________________________midi_editor',
'   ',
}

local function runMainWindowActions()
for _, action in ipairs(mainWindowActions) do
  r.Main_OnCommandEx(r.NamedCommandLookup(action), 0)
end  
end

function runMidiEditorActions()
if r.MIDIEditor_GetActive() == nil then
  r.defer(runMidiEditorActions)
else
  local me = r.MIDIEditor_GetActive()
  r.PreventUIRefresh(1)
  for _, action in ipairs(midiEeditorActions) do
    r.MIDIEditor_OnCommand(me, r.NamedCommandLookup(action), 0)
  end
  r.PreventUIRefresh(-1)
end
end

r.defer(runMainWindowActions)
r.defer(runMidiEditorActions)
