-- @description Ukrainian Localization (auto update tool)
-- @author Amely Suncroll
-- @version 1.03
-- @website https://t.me/reaper_ua
-- @changelog
--    + init @
--    + 1.01 add p.s. if install for a first time
--    + 1.02 fix command to download localization file on Windows
--    + 1.03 add message loc-on is up to date

-- @about Add this script to autorun when you start REAPER: 1. Розширення / SWS/S&M / Startup actions / Set global startup action OR 2. Get 'Global Startup Action Tool' script in ReaPack and follow instructions.
    
-- @donation https://www.paypal.com/paypalme/suncroll

-- Support:
-- https://t.me/amely_suncroll_support
-- amelysuncroll@gmail.com
-- https://github.com/AmelySuncroll



local url_file = "https://raw.githubusercontent.com/AmelySuncroll/ReaperLangPackUA/main/Ukrainian%20for%20v7.55+.ReaperLangPack"
local url_api = "https://api.github.com/repos/AmelySuncroll/ReaperLangPackUA/commits/main"
local langpack_name = "Ukrainian for v7.55+.ReaperLangPack"

function Msg(val)
    -- reaper.ShowConsoleMsg(tostring(val) .. "\n")
end

local function fetch(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result
end

local function get_current_local_version(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    local version = content:match(",%s*v([%d%.]+)")
    return version
end

function update_localization()
    local os_name = reaper.GetOS()
    local separator = package.config:sub(1,1)
    local full_path = reaper.GetResourcePath() .. separator .. "LangPack" .. separator .. langpack_name
    local api_cmd = string.format('curl -s -H "User-Agent: Reaper-Script" "%s"', url_api)
    local response = fetch(api_cmd)
    local remote_version_full = response:match('"message":%s*"(.-)"')
    local remote_version = remote_version_full and remote_version_full:match("([%d%.]+)")

    if not remote_version then return end

    local local_version = get_current_local_version(full_path)

    if local_version == remote_version then
        reaper.MB("Все гаразд! Ваша версія локалізації є найновішою.", ":)", 0)
        return
    end

    local msg_text = string.format(
        "Добрий день!\n\nДоступна нова версія локалізації: %s\n\nБажаєте встановити?", 
        remote_version_full
        -- local_version or "[не вдалося отримати номер версії]"
    )
    
    local ret = reaper.MB(msg_text, "Оп-па!", 4)
    if ret ~= 6 then return end

    local dl_cmd

    if os_name:match("Win") then
        dl_cmd = string.format('powershell -command "& {Invoke-WebRequest \'%s\' -OutFile \'%s\'; echo $?}"', url_file, full_path)
    else
        dl_cmd = string.format("curl -L -s '%s' -o '%s' -w '%%{http_code}'", url_file, full_path)
    end

    local response = fetch(dl_cmd)
    
    local is_success = false

    if os_name:match("Win") then
        is_success = response:match("True")
    else
        is_success = response:match("200")
    end

    if is_success then
        reaper.MB("Локалізацію успішно оновлено!\nБудь ласка, перезапустіть REAPER, щоб застосувати зміни.\n\nP.S. Якщо Ви встановлюєте перший раз, спочатку змініть мову в налаштуваннях: Settings / Preferences / General / Language і лише тоді перезапустіть REAPER.", "Готово", 0)
    else
        reaper.MB("Не вдалося завантажити файл. Чи є інтернет у хаті?", "Халепа :(", 0)
    end
end

update_localization()
