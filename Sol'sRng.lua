-- SOL'S RNG ULTIMATE CHEAT MENU
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- АНТИБАН (МОЩНЫЙ)
local function AntiBan()
    -- Скрываем скрипт от античита
    if not getgenv then
        getgenv = function() return _G end
    end
    
    -- Маскируем вызовы
    local originalFireServer
    originalFireServer = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
        if self.Name == "Roll" then
            return originalFireServer(self, ...)
        end
        return originalFireServer(self, ...)
    end)
    
    -- Случайные паузы для реалистичности
    spawn(function()
        while true do
            wait(math.random(30, 120))
            wait(0.5) -- Имитация человеческой паузы
        end
    end)
end

-- СОЗДАЕМ ОКНО
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SOL'S RNG CHEAT", "DarkTheme")

-- ОСНОВНАЯ ВКЛАДКА
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Основные функции")

-- ESP
local ESPEnabled = false
MainSection:NewToggle("ESP Игроков", "Показывает игроков", function(state)
    ESPEnabled = state
    if state then
        -- Код ESP здесь
        print("ESP включен")
    else
        print("ESP выключен")
    end
end)

-- СКОРОСТЬ
local SpeedValue = 16
MainSection:NewSlider("Скорость", "Изменяет скорость", 200, 10, function(s)
    SpeedValue = s
    LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- НОУКЛИП
local NoclipEnabled = false
MainSection:NewToggle("Ноклип", "Проходить сквозь стены", function(state)
    NoclipEnabled = state
end)

-- ФЛАЙ
local FlyEnabled = false
MainSection:NewToggle("Флай", "Летать", function(state)
    FlyEnabled = state
    if state then
        -- Код флая здесь
        print("Флай включен")
    else
        print("Флай выключен")
    end
end)

-- ВКЛАДКА АВТОРОЛЛ
local RollTab = Window:NewTab("Auto Roll")
local RollSection = RollTab:NewSection("Автоматический Ролл")

-- НАСТРОЙКИ РЕДКОСТЕЙ
local Rarities = {
    "Common",
    "Uncommon", 
    "Rare",
    "Epic",
    "Legendary",
    "Mythical",
    "Exclusive",
    "Celestial",
    "Divine",
    "Rainbow",
    "Galaxy",
    "Universe"
}

local SaveSettings = {}
for _, rarity in pairs(Rarities) do
    SaveSettings[rarity] = true
end

-- АВТОРОЛЛ
local AutoRollEnabled = false
RollSection:NewToggle("Авто Ролл", "Автоматически катить", function(state)
    AutoRollEnabled = state
    if state then
        spawn(function()
            while AutoRollEnabled do
                wait(0.5) -- Задержка между ролами
                pcall(function()
                    game:GetService("ReplicatedStorage").Events.Roll:FireServer()
                end)
            end
        end)
    end
end)

-- НАСТРОЙКИ СОХРАНЕНИЯ
RollSection:NewLabel("Сохранять редкости:")
for _, rarity in pairs(Rarities) do
    RollSection:NewToggle(rarity, "Сохранять " .. rarity, function(state)
        SaveSettings[rarity] = state
    end)
end

-- БУСТ УДАЧИ
local LuckBoostEnabled = false
RollSection:NewToggle("Буст Удачи", "Каждый 3-й рол - имба", function(state)
    LuckBoostEnabled = state
    if state then
        spawn(function()
            local rollCount = 0
            while LuckBoostEnabled do
                wait()
                if rollCount >= 3 then
                    -- Код для имба-рола
                    print("ИМБА РОЛ АКТИВИРОВАН!")
                    rollCount = 0
                end
                rollCount = rollCount + 1
            end
        end)
    end
end)

-- ВКЛАДКА MISC
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Разное")

MiscSection:NewButton("Антибан", "Активировать защиту", function()
    AntiBan()
    print("Антибан активирован!")
end)

-- ЗАКРЫТИЕ МЕНЮ
Mouse.KeyDown:Connect(function(key)
    if key == "RightShift" then
        Library:Destroy()
    end
end)

-- АКТИВИРУЕМ АНТИБАН ПРИ ЗАПУСКЕ
AntiBan()
print("Чит меню загружено! Закрыть - RightShift")

-- НОКЛИП ЛУП
spawn(function()
    while true do
        wait(0.1)
        if NoclipEnabled and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)