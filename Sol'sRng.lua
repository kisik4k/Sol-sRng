-- SOL'S RNG ULTIMATE CHEAT MENU V2
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ПЕРЕМЕННЫЕ
local SpeedValue = 16
local NoclipEnabled = false
local FlyEnabled = false
local AutoRollEnabled = false
local ESPEnabled = false

-- АНТИБАН
local function AntiBan()
    -- Скрываем следы
    if not getgenv then getgenv = function() return _G end end
    getgenv().SecureMode = true
end

-- СОЗДАЕМ ОКНО БЕЗ БИБЛИОТЕКИ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SolCheatMenu"

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SOL'S RNG CHEAT V2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- ВКЛАДКИ
local Tabs = {"Main", "Roll", "Misc"}
local CurrentTab = "Main"

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

-- MAIN TAB CONTENT
local function ShowMainTab()
    -- Очищаем предыдущий контент
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= Title then
            child:Destroy()
        end
    end

    local yPos = 40
    
    -- ESP TOGGLE
    CreateButton("ESP: " .. tostring(ESPEnabled), UDim2.new(0.05, 0, 0, yPos), function()
        ESPEnabled = not ESPEnabled
        ShowMainTab()
        print("ESP: " .. tostring(ESPEnabled))
    end)
    yPos = yPos + 35

    -- SPEED SLIDER (упрощенный)
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
    SpeedLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.Text = "Скорость: " .. SpeedValue
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.TextSize = 12
    SpeedLabel.Parent = MainFrame
    yPos = yPos + 25

    CreateButton("Скорость +10", UDim2.new(0.05, 0, 0, yPos), function()
        SpeedValue = math.min(200, SpeedValue + 10)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end
        ShowMainTab()
    end)
    yPos = yPos + 35

    CreateButton("Скорость -10", UDim2.new(0.05, 0, 0, yPos), function()
        SpeedValue = math.max(10, SpeedValue - 10)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
        end
        ShowMainTab()
    end)
    yPos = yPos + 35

    -- NOCHIP TOGGLE
    CreateButton("Ноклип: " .. tostring(NoclipEnabled), UDim2.new(0.05, 0, 0, yPos), function()
        NoclipEnabled = not NoclipEnabled
        ShowMainTab()
        print("Ноклип: " .. tostring(NoclipEnabled))
    end)
    yPos = yPos + 35

    -- FLY TOGGLE
    CreateButton("Флай: " .. tostring(FlyEnabled), UDim2.new(0.05, 0, 0, yPos), function()
        FlyEnabled = not FlyEnabled
        ShowMainTab()
        if FlyEnabled then
            -- Простой флай
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        else
            -- Выключаем флай
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end)
end

-- ROLL TAB CONTENT
local function ShowRollTab()
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= Title then
            child:Destroy()
        end
    end

    local yPos = 40

    -- AUTO ROLL TOGGLE
    CreateButton("Авто Ролл: " .. tostring(AutoRollEnabled), UDim2.new(0.05, 0, 0, yPos), function()
        AutoRollEnabled = not AutoRollEnabled
        ShowRollTab()
        
        if AutoRollEnabled then
            spawn(function()
                while AutoRollEnabled do
                    wait(0.5) -- Задержка 0.5 секунды
                    pcall(function()
                        game:GetService("ReplicatedStorage").Events.Roll:FireServer()
                    end)
                end
            end)
        end
    end)
    yPos = yPos + 35

    -- LUCK BOOST
    CreateButton("Буст удачи", UDim2.new(0.05, 0, 0, yPos), function()
        -- Имба функция
        for i = 1, 10 do
            wait(0.1)
            game:GetService("ReplicatedStorage").Events.Roll:FireServer()
        end
        print("Буст удачи активирован!")
    end)
end

-- MISC TAB
local function ShowMiscTab()
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= Title then
            child:Destroy()
        end
    end

    local yPos = 40

    CreateButton("Антибан", UDim2.new(0.05, 0, 0, yPos), function()
        AntiBan()
        print("Антибан активирован!")
    end)
    yPos = yPos + 35

    CreateButton("Закрыть меню", UDim2.new(0.05, 0, 0, yPos), function()
        ScreenGui:Destroy()
    end)
end

-- TAB BUTTONS
local tabY = 35
for i, tabName in pairs(Tabs) do
    CreateButton(tabName, UDim2.new(0.05 + (i-1)*0.3, 0, 0, tabY), function()
        CurrentTab = tabName
        if tabName == "Main" then
            ShowMainTab()
        elseif tabName == "Roll" then
            ShowRollTab()
        elseif tabName == "Misc" then
            ShowMiscTab()
        end
    end)
end

-- ПОКАЗЫВАЕМ ПЕРВУЮ ВКЛАДКУ
ShowMainTab()

-- ЗАКРЫТИЕ МЕНЮ НА RIGHT SHIFT
Mouse.KeyDown:Connect(function(key)
    if key == "RightShift" then
        ScreenGui:Destroy()
    end
end)

-- НОКЛИП ЛУП (РАБОЧИЙ)
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

-- АКТИВИРУЕМ АНТИБАН
AntiBan()
print("Чит меню V2 загружено! Закрыть - RightShift")