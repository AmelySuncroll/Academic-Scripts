-- @description Ukrainian Localization (auto update tool)
-- @author Amely Suncroll
-- @version 1.0
-- @website https://t.me/reaper_ua
-- @changelog
--    + init @

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

local function GetCurrentLocalVersion(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    local version = content:match(",%s*v([%d%.]+)")
    return version
end

function UpdateLocalization()
    local os_name = reaper.GetOS()
    local separator = package.config:sub(1,1)
    local full_path = reaper.GetResourcePath() .. separator .. "LangPack" .. separator .. langpack_name
    local api_cmd = string.format('curl -s -H "User-Agent: Reaper-Script" "%s"', url_api)
    local response = fetch(api_cmd)
    local remote_version_full = response:match('"message":%s*"(.-)"')
    local remote_version = remote_version_full and remote_version_full:match("([%d%.]+)")

    if not remote_version then return end

    local local_version = GetCurrentLocalVersion(full_path)

    if local_version == remote_version then 
        return 
    end

    local msg_text = string.format(
        "Добрий день!\n\nДоступна нова версія локалізації: %s\n\nБажаєте завантажити оновлення?", 
        remote_version_full
        -- local_version or "[не вдалося отримати номер версії]"
    )
    
    local ret = reaper.MB(msg_text, "Тук-тук", 4)
    if ret ~= 6 then return end

    local dl_cmd

    if os_name:match("Win") then
        dl_cmd = string.format('curl -L -s "%s" -o "%s" -w "%%{http_code}"', url_file, full_path)
    else
        dl_cmd = string.format("curl -L -s '%s' -o '%s' -w '%%{http_code}'", url_file, full_path)
    end

    local http_code = fetch(dl_cmd):match("%d+")

    if http_code == "200" then
        reaper.MB("Локалізацію успішно оновлено!\nБудь ласка, перезапустіть Reaper, щоб застосувати зміни.\n\nP.S. Якщо Ви встановлюєте перший раз, спочатку змініть мову в налаштуваннях: Settings / Preferences / General / Language і лише тоді перезапустіть REAPER.", "Готово", 0)
    else
        reaper.MB("Не вдалося завантажити файл. Код: " .. (http_code or "nil"), "Помилка :(", 0)
    end
end

UpdateLocalization()
