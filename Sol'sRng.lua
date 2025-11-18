-- АВТОМАТИЧЕСКИЙ КЛИКЕР ДЛЯ АВТО-РОЛЛА
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ПЕРЕМЕННЫЕ
local AutoClickEnabled = false
local AutoRollConnection = nil

-- ФУНКЦИЯ ПОИСКА И НАЖАТИЯ КНОПКИ АВТО-РОЛЛ
local function ClickAutoRollButton()
    -- Ищем кнопку "Автоматический" в GUI
    local gui = LocalPlayer.PlayerGui:FindFirstChild("MainGui")
    if gui then
        -- Ищем кнопку по тексту "Автоматический"
        local foundButton = FindButtonByText(gui, "Автоматический")
        if foundButton then
            foundButton:FireServer() -- Или :Fire() в зависимости от типа кнопки
            print("Нажата кнопка Автоматический ролл!")
            return true
        end
    end
    return false
end

-- ФУНКЦИЯ ПОИСКА КНОПКИ ПО ТЕКСТУ
local function FindButtonByText(gui, text)
    for _, element in pairs(gui:GetDescendants()) do
        if element:IsA("TextButton") or element:IsA("TextLabel") then
            if string.find(element.Text, text) then
                -- Возвращаем родительскую кнопку если это текст
                if element:IsA("TextLabel") then
                    return element.Parent
                else
                    return element
                end
            end
        end
    end
    return nil
end

-- ФУНКЦИЯ ВКЛЮЧЕНИЯ/ВЫКЛЮЧЕНИЯ АВТО-КЛИКЕРА
local function ToggleAutoClick()
    AutoClickEnabled = not AutoClickEnabled
    
    if AutoClickEnabled then
        print("Авто-кликер включен! Ищу кнопку...")
        
        -- Запускаем поиск кнопки каждую секунду
        AutoRollConnection = RunService.Heartbeat:Connect(function()
            if AutoClickEnabled then
                local success = ClickAutoRollButton()
                if success then
                    wait(5) -- Ждем 5 секунд после успешного нажатия
                else
                    wait(1) -- Ждем 1 секунду если кнопка не найдена
                end
            end
        end)
        
    else
        print("Авто-кликер выключен")
        if AutoRollConnection then
            AutoRollConnection:Disconnect()
            AutoRollConnection = nil
        end
    end
end

-- ДОБАВЬ ЭТО В СВОЕ МЕНЮ (в раздел Rol):
-- Создай кнопку переключатель:

--[[
CreateToggle("Авто-клик ролл", UDim2.new(0.05, 0, 0, yPos), RolTab, function(state)
    ToggleAutoClick()
end)
]]--

-- АЛЬТЕРНАТИВНЫЙ ВАРИАНТ ЕСЛИ НЕ РАБОТАЕТ:
local function AdvancedAutoClick()
    -- Поиск по разным вариантам названий
    local buttonNames = {
        "Автоматический",
        "Авто ролл", 
        "Auto Roll",
        "Автоматический ролл",
        "Automatic"
    }
    
    local gui = LocalPlayer.PlayerGui:FindFirstChild("MainGui") or LocalPlayer.PlayerGui:FindFirstChild("GameGui")
    if gui then
        for _, buttonName in pairs(buttonNames) do
            local button = FindButtonByText(gui, buttonName)
            if button then
                -- Пробуем разные методы нажатия
                pcall(function() button:FireServer() end)
                pcall(function() button:Fire() end)
                pcall(function() 
                    if button:IsA("TextButton") then
                        button.MouseButton1Click:Fire()
                    end
                end)
                print("Нажата кнопка: " .. buttonName)
                return true
            end
        end
    end
    return false
end

-- ЗАПУСК АВТО-КЛИКЕРА
print("Авто-кликер загружен! Используй ToggleAutoClick() чтобы включить")

-- ДЛЯ ТЕСТА - РАСКОММЕНТИРУЙ:
-- ToggleAutoClick()