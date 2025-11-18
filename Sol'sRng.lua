-- СЕРАЯ ПОЛУПРОЗРАЧНАЯ МЕНЮШКА
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- СОЗДАЕМ ОКНО
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "GrayMenu"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.2 -- ПОЛУПРОЗРАЧНОСТЬ
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.Parent = ScreenGui

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BackgroundTransparency = 0.1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SOL'S RNG MENU (F9)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

-- ВКЛАДКИ
local Tabs = {"Main", "Rol", "Misc"}
local CurrentTab = "Main"

local TabButtons = {}
local TabFrames = {}

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ ВКЛАДКИ
local function CreateTabButton(text, index)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.32, 0, 0, 30)
    Button.Position = UDim2.new(0.01 + (index-1)*0.33, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.BackgroundTransparency = 0.2
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.Parent = MainFrame
    
    Button.MouseButton1Click:Connect(function()
        CurrentTab = text
        -- Скрываем все вкладки
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        -- Показываем текущую
        if TabFrames[text] then
            TabFrames[text].Visible = true
        end
        -- Подсвечиваем активную вкладку
        for tabName, btn in pairs(TabButtons) do
            if tabName == text then
                btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            else
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
        end
    end)
    
    TabButtons[text] = Button
    return Button
end

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
local function CreateButton(text, position, parent, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.BackgroundTransparency = 0.2
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.Parent = parent
    
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ
local function CreateToggle(text, position, parent, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0.9, 0, 0, 35)
    Toggle.Position = position
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.BackgroundTransparency = 0.2
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = text
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 12
    Toggle.Parent = parent
    
    local state = false
    
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Toggle.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
            Toggle.Text = text .. ": ON"
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Toggle.Text = text .. ": OFF"
        end
        callback(state)
    end)
    
    return Toggle
end

-- СОЗДАЕМ ВКЛАДКИ
for i, tabName in pairs(Tabs) do
    CreateTabButton(tabName, i)
    
    -- ФРЕЙМ ДЛЯ КАЖДОЙ ВКЛАДКИ
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 1, -70)
    TabFrame.Position = UDim2.new(0, 0, 0, 70)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = (tabName == "Main")
    TabFrame.Parent = MainFrame
    
    TabFrames[tabName] = TabFrame
end

-- === MAIN TAB ===
local MainTab = TabFrames["Main"]
local yPos = 10

CreateToggle("ESP", UDim2.new(0.05, 0, 0, yPos), MainTab, function(state)
    print("ESP: " .. tostring(state))
end)
yPos = yPos + 40

CreateToggle("Ноклип", UDim2.new(0.05, 0, 0, yPos), MainTab, function(state)
    print("Ноклип: " .. tostring(state))
end)
yPos = yPos + 40

CreateToggle("Флай", UDim2.new(0.05, 0, 0, yPos), MainTab, function(state)
    print("Флай: " .. tostring(state))
end)
yPos = yPos + 40

CreateButton("Скорость +10", UDim2.new(0.05, 0, 0, yPos), MainTab, function()
    print("Скорость увеличена")
end)
yPos = yPos + 40

CreateButton("Скорость -10", UDim2.new(0.05, 0, 0, yPos), MainTab, function()
    print("Скорость уменьшена")
end)

-- === ROL TAB ===
local RolTab = TabFrames["Rol"]
yPos = 10

CreateToggle("Авто Ролл", UDim2.new(0.05, 0, 0, yPos), RolTab, function(state)
    print("Авто Ролл: " .. tostring(state))
end)
yPos = yPos + 40

CreateToggle("Буст удачи", UDim2.new(0.05, 0, 0, yPos), RolTab, function(state)
    print("Буст удачи: " .. tostring(state))
end)
yPos = yPos + 40

CreateButton("Сохранять Common", UDim2.new(0.05, 0, 0, yPos), RolTab, function()
    print("Настройка Common")
end)
yPos = yPos + 40

CreateButton("Сохранять Rare", UDim2.new(0.05, 0, 0, yPos), RolTab, function()
    print("Настройка Rare")
end)
yPos = yPos + 40

CreateButton("Сохранять Legendary", UDim2.new(0.05, 0, 0, yPos), RolTab, function()
    print("Настройка Legendary")
end)

-- === MISC TAB ===
local MiscTab = TabFrames["Misc"]
yPos = 10

CreateButton("Антибан", UDim2.new(0.05, 0, 0, yPos), MiscTab, function()
    print("Антибан активирован")
end)
yPos = yPos + 40

CreateButton("Телепорт к спавну", UDim2.new(0.05, 0, 0, yPos), MiscTab, function()
    print("Телепорт к спавну")
end)
yPos = yPos + 40

CreateButton("Сброс настроек", UDim2.new(0.05, 0, 0, yPos), MiscTab, function()
    print("Настройки сброшены")
end)
yPos = yPos + 40

CreateButton("Закрыть меню", UDim2.new(0.05, 0, 0, yPos), MiscTab, function()
    ScreenGui:Destroy()
end)

-- ПЕРЕКЛЮЧЕНИЕ МЕНЮ НА F9
Mouse.KeyDown:Connect(function(key)
    if key == "f9" then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("Серая менюшка загружена! F9 - скрыть/показать")