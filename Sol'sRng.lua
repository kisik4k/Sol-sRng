-- ПРОСТОЙ ESP ДЛЯ SOL'S RNG
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ПЕРЕМЕННЫЕ
local ESPEnabled = false
local MenuVisible = true
local ESPFolders = {}

-- СОЗДАЕМ ОКНО
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SimpleESPMenu"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = MenuVisible
MainFrame.Parent = ScreenGui

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "ESP MENU (F9 - скрыть)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
local function CreateButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 30)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.Parent = MainFrame
    
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- ФУНКЦИЯ ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not head then return end
    
    -- Создаем BillBoardGui для ESP
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name .. "_ESP"
    espFolder.Parent = ScreenGui
    
    -- Фон для текста
    local background = Instance.new("Frame")
    background.Size = UDim2.new(0, 200, 0, 60)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0
    background.Parent = espFolder
    
    -- Имя игрока
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.Parent = background
    
    -- Здоровье
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0, 20)
    healthLabel.Position = UDim2.new(0, 0, 0, 20)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextSize = 11
    healthLabel.Parent = background
    
    -- Дистанция
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 0, 40)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    distanceLabel.Text = "Дистанция: 0m"
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 11
    distanceLabel.Parent = background
    
    -- Привязываем к голове игрока
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.Enabled = ESPEnabled
    billboard.Adornee = head
    billboard.Parent = background
    billboard.SizeOffset = Vector2.new(0, 2)
    
    ESPFolders[player] = espFolder
    
    -- ОБНОВЛЕНИЕ ДАННЫХ
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not character.Parent or not humanoid or not head then
            connection:Disconnect()
            if espFolder then
                espFolder:Destroy()
            end
            return
        end
        
        -- Обновляем здоровье
        healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
        
        -- Обновляем дистанцию
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
            or 0
        distanceLabel.Text = "Дистанция: " .. math.floor(distance) .. "m"
        
        -- Меняем цвет в зависимости от расстояния
        if distance < 10 then
            background.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        elseif distance < 20 then
            background.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        else
            background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        end
        
        -- Показываем/скрываем ESP
        billboard.Enabled = ESPEnabled
    end)
end

-- ВКЛЮЧЕНИЕ/ВЫКЛЮЧЕНИЕ ESP
local function ToggleESP()
    ESPEnabled = not ESPEnabled
    
    if ESPEnabled then
        -- Создаем ESP для всех игроков
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        
        -- Слушаем новых игроков
        Players.PlayerAdded:Connect(CreateESP)
    else
        -- Удаляем все ESP
        for _, folder in pairs(ESPFolders) do
            if folder then
                folder:Destroy()
            end
        end
        ESPFolders = {}
    end
end

-- СОЗДАЕМ ИНТЕРФЕЙС
local yPos = 40

-- КНОПКА ESP
CreateButton("ESP: " .. tostring(ESPEnabled), UDim2.new(0.05, 0, 0, yPos), function()
    ToggleESP()
    MainFrame:Destroy() -- Закрываем меню после нажатия
end)
yPos = yPos + 35

-- КНОПКА ЗАКРЫТИЯ
CreateButton("Закрыть меню", UDim2.new(0.05, 0, 0, yPos), function()
    ScreenGui:Destroy()
end)

-- ПЕРЕКЛЮЧЕНИЕ МЕНЮ НА F9
LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key == "f9" then
        MenuVisible = not MenuVisible
        MainFrame.Visible = MenuVisible
    end
end)

print("ESP меню загружено! F9 - скрыть/показать")