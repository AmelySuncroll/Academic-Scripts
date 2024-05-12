--[[

  @ReaScript Name: Comments
  @Instructions: Just open it with Actions -  New action - Load ReaScript
  @Author: Amely Suncroll
  @REAPER: 6+
  @Extensions: SWS
  @Version: beta 2.01

  @Description: Select and navigate between your text items (insert_empty_item in Action List)


  @Donation: 
  https://www.paypal.com/paypalme/suncroll

  @Website: https://t.me/reaper_ua

  Support:
  https://t.me/yxo_composer_support
  amelysuncroll@gmail.com


]]--

function load_window_params()
  local x = tonumber(reaper.GetExtState("AmelySuncrollComments", "WindowPosX")) or 200
  local y = tonumber(reaper.GetExtState("AmelySuncrollComments", "WindowPosY")) or 200
  local startWidth = tonumber(reaper.GetExtState("AmelySuncrollComments", "WindowWidth")) or 500
  local startHeight = tonumber(reaper.GetExtState("AmelySuncrollComments", "WindowHeight")) or 400
  local dock_state = tonumber(reaper.GetExtState("AmelySuncrollComments", "DockState")) or 0
  return x, y, startWidth, startHeight, dock_state
end

function save_window_params()
  local dock_state, x, y, startWidth, startHeight = gfx.dock(-1, 0, 0, 0, 0)
  reaper.SetExtState("AmelySuncrollComments", "DockState", tostring(dock_state), true)
  reaper.SetExtState("AmelySuncrollComments", "WindowPosX", tostring(x), true)
  reaper.SetExtState("AmelySuncrollComments", "WindowPosY", tostring(y), true)
  reaper.SetExtState("AmelySuncrollComments", "WindowWidth", tostring(width), true)
  reaper.SetExtState("AmelySuncrollComments", "WindowHeight", tostring(height), true)
end

local x, y, startWidth, startHeight, dock_state = load_window_params()
gfx.init("Comments (beta 2.01)", startWidth, startHeight, dock_state, x, y)

save_window_params()

local selectedItemIndex = -1
local textCoords = {}
local currentScenario = 1
local checkboxes = {}

local needToUpdate = false


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

local function drawScenarioStatus()
    gfx.setfont(1, "Consolas", 16)
    gfx.set(1, 1, 1)
    local statusText = "Current mode: " .. (currentScenario == 1 and "Cursor" or "Selected Item")
    local textWidth, textHeight = gfx.measurestr(statusText)
    gfx.x = (gfx.w - textWidth) / 2
    gfx.y = gfx.h - textHeight - 10
    gfx.drawstr(statusText)
end

local function createCheckbox(x, y, linkedItemIndex)
    if type(linkedItemIndex) ~= "number" then
        error("linkedItemIndex должен быть числом, получен: " .. tostring(linkedItemIndex))
    end
    local item = reaper.GetMediaItem(0, linkedItemIndex)
    local isMuted = false
    if item then
        isMuted = reaper.GetMediaItemInfo_Value(item, "B_MUTE") > 0
    end
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
    local y = 20
    gfx.setfont(1, "Consolas", 16)
    textCoords = {}
    local maxInfoWidth = 200

    for _, textItem in ipairs(sortedTextItems) do
        local itemStart = reaper.GetMediaItemInfo_Value(textItem.item, "D_POSITION")
        local itemLength = reaper.GetMediaItemInfo_Value(textItem.item, "D_LENGTH")
        local startTimeStr = string.format("%02d:%02d", math.floor(itemStart / 60), math.floor(itemStart % 60))
        local durationStr = string.format("%.2f sec", itemLength)
        local infoText = _ .. ". " .. startTimeStr .. " | " .. durationStr
        local note = reaper.ULT_GetMediaItemNote(textItem.item)

        createCheckbox(180, y, textItem.index)

        if textItem.index == selectedItemIndex then
            gfx.set(1, 1, 1)
        else
            gfx.set(0.5, 0.5, 0.5)
        end

        gfx.x, gfx.y = 10 + (textItem.level - 1) * 15, y
        gfx.drawstr(infoText, 0, maxInfoWidth, gfx.y + 20)

        local brokenLines = breakTextToFitWidth(note, gfx.w - maxInfoWidth - 20 - (textItem.level - 1) * 15)
        for _, line in ipairs(brokenLines) do
            gfx.x, gfx.y = maxInfoWidth + 10, y
            gfx.drawstr(line)
            table.insert(textCoords, {yStart = y, yEnd = y + 20, index = textItem.index})
            y = y + 20
        end
    end
    drawScenarioStatus()
    drawCheckboxes()
    gfx.update()
end

local function updateAndDrawCheckboxes(sortedTextItems)
    checkboxes = {}

    local y = 20
    for _, textItem in ipairs(sortedTextItems) do
        createCheckbox(180, y, textItem.index)
        y = y + 20  -- Отступ для следующего чекбокса
    end

    drawCheckboxes()
end

local function handleCheckboxClick(mouseX, mouseY)
    if mouseClicked then return end
    mouseClicked = true

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

            break
        end
    end
end

local function drawOpenNotesButton()
    local buttonX, buttonY, buttonWidth, buttonHeight = 10, gfx.h - 30, 100, 20  -- Координаты и размеры кнопки
    gfx.set(0.8, 0.8, 0.8, 1)  -- Цвет кнопки
    gfx.rect(buttonX, buttonY, buttonWidth, buttonHeight, 1)  -- Отрисовка кнопки
    gfx.set(0, 0, 0, 1)  -- Цвет текста
    gfx.x, gfx.y = buttonX + 14, buttonY + 1
    gfx.drawstr("Open Notes")  -- Текст на кнопке
end

local function handleOpenNotesButtonClick(mouseX, mouseY)
    local buttonX, buttonY, buttonWidth, buttonHeight = 10, gfx.h - 30, 100, 20
    if mouseX >= buttonX and mouseX <= buttonX + buttonWidth and mouseY >= buttonY and mouseY <= buttonY + buttonHeight then
        reaper.Main_OnCommand(reaper.NamedCommandLookup("_S&M_ITEMNOTES"), 0)  
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

function main()
    local sortedTextItems = getSortedTextItems()

    if gfx.mouse_cap & 1 == 1 and gfx.mouse_y > 20 then
        handleCheckboxClick(gfx.mouse_x, gfx.mouse_y)
        
        for _, coords in ipairs(textCoords) do
            if gfx.mouse_y >= coords.yStart and gfx.mouse_y <= coords.yEnd then
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
                break
            end
        end
    else
        updateSelection()
        updateAndDrawCheckboxes(getSortedTextItems())
    end

    if gfx.mouse_cap & 1 == 1 then
        if not mouseClicked then
            handleCheckboxClick(gfx.mouse_x, gfx.mouse_y)
        end
    else
        mouseClicked = false 
    end

    drawTextItems(getSortedTextItems())

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

    --drawOpenNotesButton()  -- Отрисовка кнопки

    if gfx.mouse_cap & 1 == 1 then
        handleOpenNotesButtonClick(gfx.mouse_x, gfx.mouse_y)  
    end

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
gfx.init("Comments (beta 2.01)", startWidth, startHeight, dock_state, x, y)
main()
