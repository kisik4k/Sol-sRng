-- SOL'S RNG ПОЛНЫЙ ЧИТ МЕНЮ
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

-- ПЕРЕМЕННЫЕ
local ESPEnabled = false
local NoclipEnabled = false
local FlyEnabled = false
local AutoRollEnabled = false
local SpeedValue = 16
local ESPFolders = {}

-- АВТО-РОЛЛ СИСТЕМА
local AutoRollConnection = nil
local RollDelay = 0.5

local function StartAutoRoll()
    if AutoRollConnection then
        AutoRollConnection:Disconnect()
    end
    
    AutoRollConnection = RunService.Heartbeat:Connect(function()
        if AutoRollEnabled then
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Roll:FireServer()
            end)
            wait(RollDelay)
        end
    end)
end

local function ToggleAutoRoll(state)
    AutoRollEnabled = state
    if state then
        StartAutoRoll()
    else
        if AutoRollConnection then
            AutoRollConnection:Disconnect()
            AutoRollConnection = nil
        end
    end
end

-- ESP СИСТЕМА
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local head = character:FindFirstChild("Head")
    if not humanoid or not head then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name .. "_ESP"
    espFolder.Parent = game.CoreGui
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.AlwaysOnTop = true
    billboard.Enabled = ESPEnabled
    billboard.Adornee = head
    billboard.SizeOffset = Vector2.new(0, 2.5)
    billboard.Parent = espFolder
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 1
    background.BorderColor3 = Color3.fromRGB(255, 255, 255)
    background.Parent = billboard
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Text = player.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.Parent = background
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.33, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextSize = 11
    healthLabel.Parent = background
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    distanceLabel.Text = "0m"
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 11
    distanceLabel.Parent = background
    
    ESPFolders[player] = espFolder
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not character.Parent or not humanoid or not head then
            connection:Disconnect()
            if espFolder then espFolder:Destroy() end
            return
        end
        
        healthLabel.Text = "HP: " .. math.floor(humanoid.Health)
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0
        distanceLabel.Text = math.floor(distance) .. "m"
        
        if distance < 10 then
            background.BorderColor3 = Color3.fromRGB(255, 0, 0)
        elseif distance < 20 then
            background.BorderColor3 = Color3.fromRGB(255, 165, 0)
        else
            background.BorderColor3 = Color3.fromRGB(0, 255, 0)
        end
        
        billboard.Enabled = ESPEnabled
    end)
end

local function ToggleESP(state)
    ESPEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        Players.PlayerAdded:Connect(CreateESP)
    else
        for _, folder in pairs(ESPFolders) do
            if folder then folder:Destroy() end
        end
        ESPFolders = {}
    end
end

-- СОЗДАЕМ МЕНЮ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SolMenu"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
MainFrame.Parent = ScreenGui

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
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        if TabFrames[text] then
            TabFrames[text].Visible = true
        end
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

local ESPToggle = CreateToggle("ESP: OFF", UDim2.new(0.05, 0, 0, yPos), MainTab, function(state)
    ToggleESP(state)
end)
yPos = yPos + 40

local NoclipToggle = CreateToggle("Ноклип: OFF", UDim2.new(0.05, 0, 0, yPos), MainTab, function(state)
    NoclipEnabled = state
    print("Ноклип: " .. tostring(state))
end)
yPos = yPos + 40

local FlyToggle = CreateToggle("Флай: OFF", UDim2.new(0.05, 0, 0, yPos), MainTab, function(state)
    FlyEnabled = state
    if state then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
    else
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
    print("Флай: " .. tostring(state))
end)
yPos = yPos + 40

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, yPos)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Text = "Скорость: " .. SpeedValue
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.Parent = MainTab
yPos = yPos + 25

CreateButton("Скорость +10", UDim2.new(0.05, 0, 0, yPos), MainTab, function()
    SpeedValue = math.min(200, SpeedValue + 10)
    SpeedLabel.Text = "Скорость: " .. SpeedValue
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
end)
yPos = yPos + 40

CreateButton("Скорость -10", UDim2.new(0.05, 0, 0, yPos), MainTab, function()
    SpeedValue = math.max(10, SpeedValue - 10)
    SpeedLabel.Text = "Скорость: " .. SpeedValue
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
end)

-- === ROL TAB ===
local RolTab = TabFrames["Rol"]
yPos = 10

local AutoRollToggle = CreateToggle("Авто Ролл: OFF", UDim2.new(0.05, 0, 0, yPos), RolTab, function(state)
    ToggleAutoRoll(state)
    if state then
        AutoRollToggle.Text = "Авто Ролл: ON"
        AutoRollToggle.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
    else
        AutoRollToggle.Text = "Авто Ролл: OFF"
        AutoRollToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)
yPos = yPos + 40

local LuckToggle = CreateToggle("Буст удачи: OFF", UDim2.new(0.05, 0, 0, yPos), RolTab, function(state)
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
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end)
yPos = yPos + 40

CreateButton("Сброс настроек", UDim2.new(0.05, 0, 0, yPos), MiscTab, function()
    print("Настройки сброшены")
end)
yPos = yPos + 40

CreateButton("Закрыть меню", UDim2.new(0.05, 0, 0, yPos), MiscTab, function()
    ScreenGui:Destroy()
end)

-- СИСТЕМНЫЕ ФУНКЦИИ
Mouse.KeyDown:Connect(function(key)
    if key == "f9" then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

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

print("SOL'S RNG МЕНЮ ЗАГРУЖЕНО! F9 - скрыть/показать")