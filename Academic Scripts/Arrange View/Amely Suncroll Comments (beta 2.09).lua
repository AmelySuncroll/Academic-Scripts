-- @description Comments (beta)
-- @author Amely Suncroll
-- @version 0.2.9
-- @website https://forum.cockos.com/showthread.php?t=291012
-- @changelog
--    + init @
--    + change font and color
--    + pin docker
--    + improuve mouse scroll
--    + keep show time and show duration state
-- @about see all your empty_notes with text in one window. Navigate between them. Mute it with checkboxes. See where are you by highlights on every empty_note. Create empty_notes for each selection item or just one for all of them. SWS is required.

-- @donation https://www.paypal.com/paypalme/suncroll

-- @website https://t.me/reaper_ua

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com

function load_window_params()
    local x = tonumber(reaper.GetExtState("AmelySuncrollCommentsBETABETABETA", "WindowPosX")) or 200
    local y = tonumber(reaper.GetExtState("AmelySuncrollCommentsBETABETABETA", "WindowPosY")) or 200
    local startWidth = tonumber(reaper.GetExtState("AmelySuncrollCommentsBETABETABETA", "WindowWidth")) or 500
    local startHeight = tonumber(reaper.GetExtState("AmelySuncrollCommentsBETABETABETA", "WindowHeight")) or 400
    local dock_state = tonumber(reaper.GetExtState("AmelySuncrollCommentsBETABETABETA", "DockState")) or 0

    return x, y, startWidth, startHeight, dock_state
end

function save_window_params()
    local dock_state, x, y, width, height = gfx.dock(-1, 0, 0, 0, 0)
    if dock_state == 0 then
        reaper.SetExtState("AmelySuncrollCommentsBETABETABETA", "WindowPosX", tostring(x), true)
        reaper.SetExtState("AmelySuncrollCommentsBETABETABETA", "WindowPosY", tostring(y), true)
        reaper.SetExtState("AmelySuncrollCommentsBETABETABETA", "WindowWidth", tostring(width), true)
        reaper.SetExtState("AmelySuncrollCommentsBETABETABETA", "WindowHeight", tostring(height), true)
    end
    reaper.SetExtState("AmelySuncrollCommentsBETABETABETA", "DockState", tostring(dock_state), true)
end

function save_button_states()
    reaper.SetExtState("AmelySuncrollCommentsBETABETABETA", "ShowStartTime", tostring(showStartTime), true)
    reaper.SetExtState("AmelySuncrollCommentsBETABETABETA", "ShowDuration", tostring(showDuration), true)
end

function load_button_states()
    local showStartTimeState = reaper.GetExtState("AmelySuncrollCommentsBETABETABETA", "ShowStartTime")
    local showDurationState = reaper.GetExtState("AmelySuncrollCommentsBETABETABETA", "ShowDuration")
    showStartTime = showStartTimeState == "true"
    showDuration = showDurationState == "true"
end

load_button_states()

local x, y, startWidth, startHeight, dock_state = load_window_params()
gfx.init("Comments (beta 2.09)", startWidth, startHeight, dock_state, x, y)

local selectedItemIndex = -1
local textCoords = {}
local currentScenario = 1
local checkboxes = {}

local needToUpdate = false
local scrollOffset = 0

local mouseWasDown = false


local x, y, startWidth, startHeight, dock_state = load_window_params()
load_button_states()
gfx.init("Comments (beta 2.08)", startWidth, startHeight, dock_state, x, y)

local function getSortedTextItems()
    local textItems = {}
    local itemCount = reaper.CountMediaItems(0)
    for i = 0, itemCount - 1 do
        local item = reaper.GetMediaItem(0, i)
        local note = reaper.ULT_GetMediaItemNote(item)
        local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if note and note ~= "" then
            local hierarchyLevel = 1
            for _, existingItem in ipairs(textItems) do
                if itemStart < existingItem.endTime and itemEnd > existingItem.startTime then
                    hierarchyLevel = hierarchyLevel + 1
                end
            end
            table.insert(textItems, {item = item, index = i, startTime = itemStart, endTime = itemEnd, level = hierarchyLevel})
        end
    end
    table.sort(textItems, function(a, b) return a.startTime < b.startTime end)
    return textItems
end
  
local function checkSelectedItem()
    local cursorPosition
    if reaper.GetPlayState() == 1 then
        cursorPosition = reaper.GetPlayPosition()
    else
        cursorPosition = reaper.GetCursorPosition()
    end

    local itemCount = reaper.CountMediaItems(0)
    for i = 0, itemCount - 1 do
        local item = reaper.GetMediaItem(0, i)
        local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        
        if cursorPosition >= itemStart and cursorPosition <= itemEnd then
            local note = reaper.ULT_GetMediaItemNote(item)
            if note and note ~= "" then
                selectedItemIndex = i
                return
            end
        end
    end
    selectedItemIndex = -1
end
  
local function updateSelectedItemFromProject()
    local itemCount = reaper.CountMediaItems(0)
    for i = 0, itemCount - 1 do
        local item = reaper.GetMediaItem(0, i)
        if reaper.IsMediaItemSelected(item) then
            local note = reaper.ULT_GetMediaItemNote(item)
            if note and note ~= "" then
                selectedItemIndex = i
                return
            end
        end
    end
    selectedItemIndex = -1
end
  
local function breakTextToFitWidth(text, maxWidth)
    local words = {}
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end

    local lines = {}
    local currentLine = words[1]
    for i = 2, #words do
        local testLine = currentLine .. " " .. words[i]
        local testWidth = gfx.measurestr(testLine)
        if testWidth <= maxWidth then
            currentLine = testLine
        else
            table.insert(lines, currentLine)
            currentLine = words[i]
        end
    end
    table.insert(lines, currentLine)
    return lines
end






------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------  ONE EACH BLOCK  ----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

function trackExists(trackName)
    local trackCount = reaper.CountTracks(0)
    for i = 0, trackCount - 1 do
      local track = reaper.GetTrack(0, i)
      local _, name = reaper.GetTrackName(track, "")
      if name:lower() == trackName:lower() then
        return track
      end
    end
    return nil
end
  
function createTrackIfNotExists(trackName)
    local track = trackExists(trackName)
    if track then
        return track
    else
        reaper.InsertTrackAtIndex(0, true)
        local newTrack = reaper.GetTrack(0, 0)
        if newTrack then
            reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", trackName, true)
            return newTrack
        else
            return nil
        end
    end
end

function createEmptyItemOnTrack(track, start_time, end_time)
    local new_item = reaper.AddMediaItemToTrack(track)
    reaper.SetMediaItemPosition(new_item, start_time, false)
    reaper.SetMediaItemLength(new_item, end_time - start_time, false)
    reaper.SetMediaItemSelected(new_item, true)  -- true is select new empty_item; false to off
    reaper.UpdateArrange()
end

function createSingleEmptyItemOnNotesTrack()
    local sel_items_count = reaper.CountSelectedMediaItems(0)
    if sel_items_count == 0 then
        --reaper.ShowMessageBox("No items selected.", ":(", 0)
        return
    end

    local first_item = reaper.GetSelectedMediaItem(0, 0)
    local start_time = reaper.GetMediaItemInfo_Value(first_item, "D_POSITION")
    local end_time = start_time + reaper.GetMediaItemInfo_Value(first_item, "D_LENGTH")

    for i = 0, sel_items_count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local item_end = item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if item_start < start_time then
            start_time = item_start
        end
        if item_end > end_time then
            end_time = item_end
        end
    end

    reaper.Main_OnCommand(40289, 0) -- unselect all items

    local notesTrack = createTrackIfNotExists("Notes")
    if notesTrack then
        createEmptyItemOnTrack(notesTrack, start_time, end_time)
    end

    reaper.Main_OnCommand(40850, 0) -- set time selection to items
    reaper.Main_OnCommand(40297, 0) -- unselect all tracks
end
  
function createEmptyItemsOnNotesTrack()
    local sel_items_count = reaper.CountSelectedMediaItems(0)
    if sel_items_count == 0 then
        --reaper.ShowMessageBox("No items selected.", ":(", 0)
        return
    end

    local notesTrack = createTrackIfNotExists("Notes")
    if not notesTrack then
        reaper.ShowMessageBox("Failed to create or find the 'Notes' track.", ":(", 0)
        return
    end

    local items = {}
    for i = 0, sel_items_count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        table.insert(items, {
            start = reaper.GetMediaItemInfo_Value(item, "D_POSITION"),
            length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        })
    end

    for _, item_data in ipairs(items) do
        local item_end = item_data.start + item_data.length
        createEmptyItemOnTrack(notesTrack, item_data.start, item_end)
    end

    reaper.Main_OnCommand(40289, 0) -- unselect all items
    reaper.Main_OnCommand(40297, 0) -- unselect all tracks

    reaper.UpdateArrange()
end






------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------  DRAW BLOCK  ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------


  
local function drawScenarioStatus()
    gfx.setfont(1, "Consolas", 16)
    gfx.set(0, 0, 0)
    local statusText = "" .. (currentScenario == 1 and "Cursor" or "Item")
    local textWidth, textHeight = gfx.measurestr(statusText)
    gfx.x = (gfx.w - textWidth) / 2
    gfx.y = gfx.h - textHeight - 12.5
    gfx.drawstr(statusText)
end
  
local function createCheckbox(x, y, linkedItemIndex)
    local item = reaper.GetMediaItem(0, linkedItemIndex)
    local isMuted = item and reaper.GetMediaItemInfo_Value(item, "B_MUTE") > 0 or false
    table.insert(checkboxes, {x = x, y = y, width = 17, height = 17, checked = isMuted, linkedItemIndex = linkedItemIndex})
end
  
local function drawCheckboxes()
    for _, checkbox in ipairs(checkboxes) do
        gfx.set(0, 0, 0, 1) 
        gfx.rect(checkbox.x, checkbox.y, checkbox.width, checkbox.height, 1) 
        gfx.set(1, 1, 1, 1)

        -- Отрисовка чекбокса
        gfx.rect(checkbox.x, checkbox.y, checkbox.width, checkbox.height, 0)
        if checkbox.checked then
            gfx.line(checkbox.x, checkbox.y, checkbox.x + checkbox.width, checkbox.y + checkbox.height)
            gfx.line(checkbox.x, checkbox.y + checkbox.height, checkbox.x + checkbox.width, checkbox.y)
        end
    end
end

local mouseClicked = false

local function drawTextItems(sortedTextItems)
    gfx.clear = 3355443
    local y = 40 - scrollOffset  -- Начальная позиция с учетом прокрутки
    gfx.setfont(1, "Consolas", 16)
    textCoords = {}
    checkboxes = {}
    local maxInfoWidth = 200
    local lineHeight = 20  -- Фиксированная высота строки

    for index, textItem in ipairs(sortedTextItems) do
        if y >= 40 and y <= gfx.h - 60 then  -- Проверка на допустимую область отрисовки
            local itemStart = reaper.GetMediaItemInfo_Value(textItem.item, "D_POSITION")
            local itemLength = reaper.GetMediaItemInfo_Value(textItem.item, "D_LENGTH")
            local startTimeStr = string.format("%02d:%02d", math.floor(itemStart / 60), math.floor(itemStart % 60))
            local durationStr = string.format("%.2f sec", itemLength)
            local infoText = index .. ". "  -- Нумерация строк начиная с 1

            if showStartTime then
                infoText = infoText .. startTimeStr .. " | "
            end
            if showDuration then
                infoText = infoText .. durationStr .. "  "
            end

            local note = reaper.ULT_GetMediaItemNote(textItem.item)
            local checkboxX = 178

            if not showStartTime and not showDuration then
                checkboxX = 35
                maxInfoWidth = 80
            elseif not showDuration then
                checkboxX = 85
                maxInfoWidth = 130
            elseif not showStartTime then
                checkboxX = 114
                maxInfoWidth = 150
            end

            if textItem.index == selectedItemIndex then
                gfx.set(1, 1, 1)
            else
                gfx.set(0.5, 0.5, 0.5)
            end

            gfx.x, gfx.y = 10, y
            gfx.drawstr(infoText, 0, maxInfoWidth, gfx.y + lineHeight)

            table.insert(checkboxes, {x = checkboxX, y = y, width = 17, height = 17, checked = reaper.GetMediaItemInfo_Value(textItem.item, "B_MUTE") > 0, linkedItemIndex = textItem.index})

            local brokenLines = breakTextToFitWidth(note, gfx.w - maxInfoWidth - 20 - (textItem.level - 1) * 15)
            for _, line in ipairs(brokenLines) do
                gfx.x, gfx.y = checkboxX + 30, y
                gfx.drawstr(line)
                table.insert(textCoords, {yStart = y, yEnd = y + lineHeight, index = textItem.index})
                y = y + lineHeight
            end
        else
            y = y + lineHeight * (1 + #breakTextToFitWidth(reaper.ULT_GetMediaItemNote(textItem.item), gfx.w - maxInfoWidth - 20 - (textItem.level - 1) * 15))
        end
    end
    drawCheckboxes()
    gfx.update()
end

local function handleMouseClicks()
    local mouseDown = gfx.mouse_cap & 1 == 1

    if mouseDown and not mouseWasDown then
        local mouseX, mouseY = gfx.mouse_x, gfx.mouse_y

        if not handleCheckboxClick(mouseX, mouseY) then
            handleToggleButtonClick(mouseX, mouseY)
            handleOpenNotesButtonClick(mouseX, mouseY)
            handleCreateItemsButtonClick(mouseX, mouseY)
            handleCreateSingleItemButtonClick(mouseX, mouseY)

            for _, coords in ipairs(textCoords) do
                if mouseY >= coords.yStart and mouseY <= coords.yEnd then
                    selectedItemIndex = coords.index
                    local item = reaper.GetMediaItem(0, selectedItemIndex)
                    if currentScenario == 1 then
                        local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                        reaper.SetEditCurPos(itemStart, true, true)
                    elseif currentScenario == 2 then
                        reaper.SelectAllMediaItems(0, false)
                        reaper.SetMediaItemSelected(item, true)
                        reaper.UpdateArrange()
                    end
                    updateSelection()
                    needToUpdate = true  -- Устанавливаем флаг для обновления
                    break
                end
            end
        end

        mouseWasDown = true
    elseif not mouseDown then
        mouseWasDown = false
    end
end
  
local function updateAndDrawCheckboxes(sortedTextItems)
    checkboxes = {}

    local y = 40 + scrollOffset  -- Добавляем смещение прокрутки к координате Y
    for _, textItem in ipairs(sortedTextItems) do
        createCheckbox(180, y, textItem.index)
        y = y + 20  -- Отступ для следующего чекбокса
    end

    drawCheckboxes()
end

local function handleCheckboxClick(mouseX, mouseY)
    for _, checkbox in ipairs(checkboxes) do
        if mouseX >= checkbox.x and mouseX <= checkbox.x + checkbox.width and mouseY >= checkbox.y and mouseY <= checkbox.y + checkbox.height then
            checkbox.checked = not checkbox.checked
            needToUpdate = true

            local item = reaper.GetMediaItem(0, checkbox.linkedItemIndex)
            if item then
                local isMuted = checkbox.checked
                reaper.SetMediaItemInfo_Value(item, "B_MUTE", isMuted and 1 or 0)
                reaper.UpdateItemInProject(item)
            end

            drawTextItems(getSortedTextItems())

            return true  -- Возвращаем true, чтобы указать, что клик обработан
        end
    end
    return false  -- Возвращаем false, если клик не был обработан
end





------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------  BUTTON BLOCK  ----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

local function handleToggleButtonClick(mouseX, mouseY)
    -- Обработка клика по кнопке отображения времени начала
    local startX, startY, startWidth, startHeight = 10, 10, 100, 20
    if mouseX >= startX and mouseX <= startX + startWidth and mouseY >= startY and mouseY <= startY + startHeight then
        showStartTime = not showStartTime
        needToUpdate = true
    end

    -- Обработка клика по кнопке отображения продолжительности
    local durationX, durationY, durationWidth, durationHeight = 120, 10, 100, 20
    if mouseX >= durationX and mouseX <= durationX + durationWidth and mouseY >= durationY and mouseY <= durationY + durationHeight then
        showDuration = not showDuration
        needToUpdate = true
    end
end
  
local function drawOpenNotesButton()
    local buttonX, buttonY, buttonWidth, buttonHeight = 10, gfx.h - 30, 70, 20  -- Координаты и размеры кнопки
    gfx.set(1, 1, 1, 1)  -- Цвет кнопки
    gfx.rect(buttonX, buttonY, buttonWidth, buttonHeight, 1)  -- Отрисовка кнопки
    gfx.set(0, 0, 0, 1)  -- Цвет текста
    gfx.x, gfx.y = buttonX + 14, buttonY + 1
    gfx.drawstr("Notes")  -- Текст на кнопке
end

function drawCreateSingleItemButton()
    local buttonWidth, buttonHeight = 40, 20
    local buttonX = gfx.w - buttonWidth - 70  -- Координаты от правого края окна с отступом 120 пикселей
    local buttonY = gfx.h - 30  -- Координаты от нижнего края окна
    gfx.set(1, 1, 1, 1)  -- Цвет кнопки
    gfx.rect(buttonX, buttonY, buttonWidth, buttonHeight, 1)  -- Отрисовка кнопки
    gfx.set(0, 0, 0, 1)  -- Цвет текста
    gfx.x, gfx.y = buttonX + 7, buttonY + 1
    gfx.drawstr("One")  -- Текст на кнопке
end

function drawCreateItemsButton()
    local buttonWidth, buttonHeight = 40, 20
    local buttonX = gfx.w - buttonWidth - 10  -- Координаты от правого края окна с отступом 10 пикселей
    local buttonY = gfx.h - 30  -- Координаты от нижнего края окна
    gfx.set(1, 1, 1, 1)  -- Цвет кнопки
    gfx.rect(buttonX, buttonY, buttonWidth, buttonHeight, 1)  -- Отрисовка кнопки
    gfx.set(0, 0, 0, 1)  -- Цвет текста
    gfx.x, gfx.y = buttonX + 4, buttonY + 1
    gfx.drawstr("Each")  -- Текст на кнопке
end

local function drawToggleButtons()
    -- Кнопка для включения/выключения отображения времени начала
    local startX, startY, startWidth, startHeight = 10, 10, 100, 20
    gfx.set(0.2, 0.2, 0.2, 1)
    gfx.rect(startX, startY, startWidth, startHeight, 1)
    gfx.set(1, 1, 1, 1)
    gfx.x, gfx.y = startX + 5, startY + 2
    gfx.drawstr(showStartTime and "Hide Start" or "Show Start")

    -- Кнопка для включения/выключения отображения продолжительности
    local durationX, durationY, durationWidth, durationHeight = 120, 10, 100, 20
    gfx.set(0.2, 0.2, 0.2, 1)
    gfx.rect(durationX, durationY, durationWidth, durationHeight, 1)
    gfx.set(1, 1, 1, 1)
    gfx.x, gfx.y = durationX + 5, durationY + 2
    gfx.drawstr(showDuration and "Hide Duration" or "Show Duration")
end
  
local function handleOpenNotesButtonClick(mouseX, mouseY)
    local buttonX, buttonY, buttonWidth, buttonHeight = 10, gfx.h - 30, 70, 20
    if mouseX >= buttonX and mouseX <= buttonX + buttonWidth and mouseY >= buttonY and mouseY <= buttonY + buttonHeight then
        reaper.Main_OnCommand(reaper.NamedCommandLookup("40850"), 0)  
    end
end

function handleCreateSingleItemButtonClick(mouseX, mouseY)
    local buttonWidth, buttonHeight = 40, 20
    local buttonX = gfx.w - buttonWidth - 70
    local buttonY = gfx.h - 30
    if mouseX >= buttonX and mouseX <= buttonX + buttonWidth and mouseY >= buttonY and mouseY <= buttonY + buttonHeight then
        reaper.Undo_BeginBlock()
        createSingleEmptyItemOnNotesTrack()
        reaper.Undo_EndBlock("Create empty item on track 'Notes'", -1)
    end
end

function handleCreateItemsButtonClick(mouseX, mouseY)
    local buttonWidth, buttonHeight = 40, 20
    local buttonX = gfx.w - buttonWidth - 10
    local buttonY = gfx.h - 30
    if mouseX >= buttonX and mouseX <= buttonX + buttonWidth and mouseY >= buttonY and mouseY <= buttonY + buttonHeight then
        reaper.Undo_BeginBlock()
        createEmptyItemsOnNotesTrack()
        reaper.Undo_EndBlock("Create individual empty items on track 'Notes'", -1)
    end
end









  
local function updateSelection()
    if currentScenario == 1 then
        checkSelectedItem()
    else
        updateSelectedItemFromProject()
    end
end
  
local lastWidth, lastHeight = gfx.w, gfx.h

local function handleMouseClicks()
    local mouseDown = gfx.mouse_cap & 1 == 1

    if mouseDown and not mouseWasDown then
        local mouseX, mouseY = gfx.mouse_x, gfx.mouse_y

        if not handleCheckboxClick(mouseX, mouseY) then
            handleToggleButtonClick(mouseX, mouseY)
            handleOpenNotesButtonClick(mouseX, mouseY)
            handleCreateItemsButtonClick(mouseX, mouseY)
            handleCreateSingleItemButtonClick(mouseX, mouseY)

            for _, coords in ipairs(textCoords) do
                if mouseY >= coords.yStart and mouseY <= coords.yEnd then
                    selectedItemIndex = coords.index
                    local item = reaper.GetMediaItem(0, selectedItemIndex)
                    if currentScenario == 1 then
                        local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                        reaper.SetEditCurPos(itemStart, true, true)
                    elseif currentScenario == 2 then
                        reaper.SelectAllMediaItems(0, false)
                        reaper.SetMediaItemSelected(item, true)
                        reaper.UpdateArrange()
                    end
                    updateSelection()
                    needToUpdate = true  -- Устанавливаем флаг для обновления
                    break
                end
            end
        end

        mouseWasDown = true
    elseif not mouseDown then
        mouseWasDown = false
    end
end

local function updateScrollOffset(sortedTextItems)
    local mouse_wheel = gfx.mouse_wheel
    if mouse_wheel ~= 0 then
        local lineHeight = 20  -- Фиксированная высота строки
        local linesInView = math.floor((gfx.h - 80) / lineHeight) -- Количество видимых строк
        local totalLines = #sortedTextItems -- Общее количество строк

        -- Обновляем смещение прокрутки и ограничиваем его
        scrollOffset = scrollOffset - math.floor(mouse_wheel / 120) * lineHeight  -- Обновляем смещение прокрутки (инвертируем прокрутку)
        --scrollOffset = math.max(0, math.min(scrollOffset, (totalLines * lineHeight) - (gfx.h - 80)))  -- Ограничиваем прокрутку

        gfx.mouse_wheel = 0  -- Сброс значения колесика мышки
        needToUpdate = true
    end
end


function main()
    local sortedTextItems = getSortedTextItems()

    updateSelection()
    drawTextItems(sortedTextItems)

    local char = gfx.getchar()
    if char == -1 then 
        return
    elseif char == 27 then
        gfx.quit()
        return
    else
        if char == 32 then
            reaper.OnStopButton()
        elseif char == 49 then
            currentScenario = 1
        elseif char == 50 then
            currentScenario = 2
        end
        reaper.defer(main)
    end

    -- Отрисовка белого прямоугольника в верхней части окна
    gfx.set(0.2, 0.2, 0.2, 1)  -- Устанавливаем темно-серый цвет
    gfx.rect(0, 0, gfx.w, 40, 1)  -- Отрисовка прямоугольника

    -- Отрисовка белого прямоугольника в нижней части окна
    gfx.set(1, 1, 1)  -- Устанавливаем белый цвет
    gfx.rect(0, gfx.h - 40, gfx.w, 50, 1)  -- Отрисовка прямоугольника

    drawScenarioStatus()  
    drawOpenNotesButton() 
    drawCreateItemsButton()
    drawCreateSingleItemButton()
    drawToggleButtons()

    handleMouseClicks() -- Обработка кликов мыши

    updateScrollOffset(sortedTextItems)

    if gfx.w ~= lastWidth or gfx.h ~= lastHeight then
        lastWidth, lastHeight = gfx.w, gfx.h
        updateAndDrawCheckboxes(getSortedTextItems())
    end

    if needToUpdate then
        drawTextItems(getSortedTextItems())
        needToUpdate = false
    end
end

local x, y, startWidth, startHeight, dock_state = load_window_params()
gfx.init("Comments beta 2.09", startWidth, startHeight, dock_state, x, y)
main()
reaper.atexit(save_window_params)   
reaper.atexit(save_button_states)   
