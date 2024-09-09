script_name("autoupdate")
script_version("1.5")

local http = require("socket.http")
local ltn12 = require("ltn12")

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local AdPath = "autoupdate.lua"
local AdUrl = "https://raw.githubusercontent.com/Theopochka/update-lavka/main/autoupdate.lua"

local function downloadFile(url, path)

  local response = {}
  local _, status_code, _ = http.request{
    url = url,
    method = "GET",
    sink = ltn12.sink.file(io.open(path, "w")),
    headers = {
      ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0;Win64) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36",

    },
  }

  if status_code == 200 then
    return true
  else
    return false
  end
end

sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} Проверка наличия обновлений...", 0x8B00FF)
    local currentVersionFile = io.open(AdPath, "r")
    local currentVersion = currentVersionFile:read("*a")
    currentVersionFile:close()
    local response = http.request(AdUrl)
    if response and response ~= currentVersion then
    	sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} У вас не актуальная версия! Для обновления перейдите во вкладку Инфо", 0x8B00FF)
    else
    	sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} У вас актуальная версия скрипта.", 0x8B00FF)
    end
    
local function updateScript(scriptUrl, scriptPath)
    sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} Проверка наличия обновлений...", 0x8B00FF)
	local response = http.request(scriptUrl)
    if response and response ~= currentVersion then
        sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} Доступна новая версия скрипта! Обновление...", 0x8B00FF)
        
        local success = downloadFile(scriptUrl, scriptPath)
        if success then
            sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} Скрипт успешно обновлен.", 0x8B00FF)
            thisScript():reload()
        else
            sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} Не удалось обновить скрипт.", 0x8B00FF)
        end
    else
        sampAddChatMessage(u8:decode"[Sashe4ka Police Helper]: {FFFFFF} Скрипт уже является последней версией.", 0x8B00FF)
    end
end

function main()
    while not isSampAvailable() do wait(0) end
    while not sampIsLocalPlayerSpawned() do wait(0) end
    sampAddChatMessage(u8:decode'Скрипт загружен', -1)
    
    sampRegisterChatCommand("up", updateScript)
    while true do
        wait(-1)
    
    end
end
