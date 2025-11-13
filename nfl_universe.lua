--[[
    NFL UNIVERSE - CLEAN REBUILD WITH GUI
    No key system, readable code, simple GUI
    For personal use only
]]

print("Loading NFL Universe Script with GUI...")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Config (values from original script)
local Config = {
    PullVectorEnabled = false,
    PullDistance = 23, -- Default mid-range (max 46)
    PullSmooth = 0.95, -- Original: 0.9-1.0 range
    WalkSpeedEnabled = false,
    CustomWalkSpeed = 51, -- Original default
    JumpPowerEnabled = false,
    CustomJumpPower = 45, -- Original default
    FlyEnabled = false,
    FlySpeed = 50, -- Original default
    InfiniteStamina = false,
    BigheadEnabled = false,
    HeadSize = 5, -- Original default
    TackleReachEnabled = false,
    TackleReachDistance = 25, -- Original default
    BlockReachEnabled = false,
    BlockReachSize = 25, -- Original default
    KickAimbot = false,
    AutoFollowBall = false,
    AutoRush = false,
    RushAggression = 5
}

-- Original values
local OriginalValues = {
    WalkSpeed = Humanoid.WalkSpeed,
    JumpPower = Humanoid.JumpPower,
    HeadSize = Character.Head.Size
}

-- Connections
local Connections = {}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NFLUniverseGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Add corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "NFL Universe - Clean"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Scroll Frame for toggles
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Helper function to create toggles
local function CreateToggle(name, configKey, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, -10, 0, 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Toggle.Text = name .. ": OFF"
    Toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
    Toggle.TextSize = 14
    Toggle.Font = Enum.Font.Gotham
    Toggle.Parent = ScrollFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle

    Toggle.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]

        if Config[configKey] then
            Toggle.Text = name .. ": ON"
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Toggle.Text = name .. ": OFF"
            Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
        end

        if callback then callback(Config[configKey]) end
    end)

    return Toggle
end

-- Helper function to create sliders
local function CreateSlider(name, configKey, min, max, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderFrame.Parent = ScrollFrame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 5, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. Config[configKey]
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, -10, 0, 20)
    SliderButton.Position = UDim2.new(0, 5, 0, 25)
    SliderButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderButton.Text = ""
    SliderButton.Parent = SliderFrame

    local SliderBtnCorner = Instance.new("UICorner")
    SliderBtnCorner.CornerRadius = UDim.new(0, 4)
    SliderBtnCorner.Parent = SliderButton

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderButton

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = Fill

    local dragging = false

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - SliderButton.AbsolutePosition.X) / SliderButton.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            Config[configKey] = value
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Label.Text = name .. ": " .. value
            if callback then callback(value) end
        end
    end)
end

-- Create Toggles and Sliders (ranges from original)
CreateToggle("Ball Magnet", "PullVectorEnabled")
CreateSlider("Pull Distance", "PullDistance", 0, 46) -- Original max

CreateToggle("Custom Walk Speed", "WalkSpeedEnabled")
CreateSlider("Walk Speed", "CustomWalkSpeed", 0, 100) -- Original range

CreateToggle("Custom Jump Power", "JumpPowerEnabled")
CreateSlider("Jump Power", "CustomJumpPower", 0, 150) -- Original range

CreateToggle("Fly Mode", "FlyEnabled", function(enabled)
    if enabled then StartFly() else StopFly() end
end)
CreateSlider("Fly Speed", "FlySpeed", 20, 150)

CreateToggle("Infinite Stamina", "InfiniteStamina")

CreateToggle("Bighead Collision", "BigheadEnabled")
CreateSlider("Head Size", "HeadSize", 2, 15)

CreateToggle("Tackle Reach", "TackleReachEnabled")
CreateSlider("Tackle Distance", "TackleReachDistance", 1, 50) -- Original range

CreateToggle("Block Reach", "BlockReachEnabled")
CreateSlider("Block Size", "BlockReachSize", 1, 50) -- Original range

CreateToggle("Kick Aimbot", "KickAimbot")
CreateToggle("Auto Follow Ball", "AutoFollowBall")

CreateToggle("Auto Rush", "AutoRush")
CreateSlider("Rush Aggression", "RushAggression", 1, 10)

-- Update canvas size
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Feature Implementations
local function GetFootball()
    local football = Workspace:FindFirstChild("Football")
    if football then return football end

    for _, location in ipairs({"ParkMap", "Games", "MiniGames"}) do
        local area = Workspace:FindFirstChild(location)
        if area then
            for _, desc in ipairs(area:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Name:lower():find("football") then
                    return desc
                end
            end
        end
    end
    return nil
end

local function PullVector()
    if not Config.PullVectorEnabled then return end
    local football = GetFootball()
    if not football then return end

    local distance = (HumanoidRootPart.Position - football.Position).Magnitude
    if distance > 100 then return end

    local direction = (HumanoidRootPart.Position - football.Position).Unit
    local pullPosition = HumanoidRootPart.Position + (direction * Config.PullDistance)
    football.CFrame = football.CFrame:Lerp(CFrame.new(pullPosition), 0.1 * Config.PullSmooth)
end

local function UpdateWalkSpeed()
    if Config.WalkSpeedEnabled and Humanoid then
        Humanoid.WalkSpeed = Config.CustomWalkSpeed
    end
end

local function UpdateJumpPower()
    if Config.JumpPowerEnabled and Humanoid then
        Humanoid.JumpPower = Config.CustomJumpPower
    end
end

-- Fly Mode
local Flying = false
local FlyBodyVelocity, FlyBodyGyro

function StartFly()
    if Flying then return end
    Flying = true

    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.Parent = HumanoidRootPart

    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.P = 9000 -- Original value
    FlyBodyGyro.D = 50 -- Original damping
    FlyBodyGyro.Parent = HumanoidRootPart

    Connections.FlyLoop = RunService.Heartbeat:Connect(function()
        if not Config.FlyEnabled then StopFly() return end

        local camera = Workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

        FlyBodyVelocity.Velocity = moveDirection * Config.FlySpeed
        FlyBodyGyro.CFrame = camera.CFrame
    end)
end

function StopFly()
    Flying = false
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    if Connections.FlyLoop then Connections.FlyLoop:Disconnect() end
end

local function InfiniteStamina()
    if not Config.InfiniteStamina then return end
    pcall(function()
        -- Original path: ReplicatedStorage.Games.Replicated.MiniGames.Mechanics.Sprinting
        local mechanics = ReplicatedStorage:FindFirstChild("Games")
        if mechanics then
            mechanics = mechanics:FindFirstChild("Replicated")
            if mechanics then
                mechanics = mechanics:FindFirstChild("MiniGames")
                if mechanics then
                    mechanics = mechanics:FindFirstChild("Mechanics")
                    if mechanics then
                        local stamina = mechanics:FindFirstChild("Sprinting") or mechanics:FindFirstChild("Stamina")
                        if stamina and stamina:IsA("NumberValue") then
                            stamina.Value = 100 -- Max stamina
                        end
                    end
                end
            end
        end

        -- Also check character mechanics
        local charMech = Character:FindFirstChild("Mechanics")
        if charMech then
            local stam = charMech:FindFirstChild("Stamina") or charMech:FindFirstChild("Sprinting")
            if stam and stam:IsA("NumberValue") then
                stam.Value = 100
            end
        end
    end)
end

local function UpdateBighead()
    if Config.BigheadEnabled and Character.Head then
        Character.Head.Size = Vector3.new(Config.HeadSize, Config.HeadSize, Config.HeadSize)
        Character.Head.Transparency = 0.7
        Character.Head.CanCollide = true
    else
        Character.Head.Size = OriginalValues.HeadSize
        Character.Head.Transparency = 0
        Character.Head.CanCollide = false
    end
end

local function KickAimbot()
    if not Config.KickAimbot then return end
    pcall(function()
        -- Original path: ReplicatedStorage.Games.ReEvent
        local reEvent = ReplicatedStorage:FindFirstChild("Games")
        if reEvent then
            reEvent = reEvent:FindFirstChild("ReEvent")
            if reEvent and reEvent:IsA("RemoteEvent") then
                -- Fire with original values: Power=100, Accuracy=78
                reEvent:FireServer("KickPowerSet", 100)
                reEvent:FireServer("KickAccuracySet", 78) -- Original accuracy
            end
        end
    end)
end

local function GetBallCarrier()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if player.Character:FindFirstChild("Football") or player.Character:FindFirstChild("FootballGrip") then
                return player.Character
            end
        end
    end
    return nil
end

local function AutoFollow()
    if not Config.AutoFollowBall then return end
    local carrier = GetBallCarrier()
    if carrier and carrier:FindFirstChild("HumanoidRootPart") then
        -- Original sets WalkSpeed to 48 when auto-following
        Humanoid.WalkSpeed = 48
        Humanoid:MoveTo(carrier.HumanoidRootPart.Position)
    else
        -- Restore original speed when not following
        if not Config.WalkSpeedEnabled then
            Humanoid.WalkSpeed = OriginalValues.WalkSpeed
        end
    end
end

local function GetClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (HumanoidRootPart.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player.Character
                end
            end
        end
    end

    return closestPlayer, shortestDistance
end

local function AutoRush()
    if not Config.AutoRush then return end

    -- Only rush ball carrier / QB (not random enemies)
    local target = GetBallCarrier()

    if target and target:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.HumanoidRootPart.Position

        -- Move to target (aggression = how direct/blatant the movement is)
        -- Lower aggression = smoother, less obvious
        -- Higher aggression = more direct, blatant
        local moveWeight = Config.RushAggression / 10  -- Convert 1-10 to 0.1-1.0

        -- Smooth movement toward target
        Humanoid:MoveTo(targetPos)

        -- Face target with smoothness based on aggression
        local direction = (targetPos - HumanoidRootPart.Position).Unit
        local currentCFrame = HumanoidRootPart.CFrame
        local targetCFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + direction)
        HumanoidRootPart.CFrame = currentCFrame:Lerp(targetCFrame, moveWeight)
    end
end

local function UpdateHitboxes()
    -- Original path: ReplicatedStorage.Games.Replicated.Hitboxes
    pcall(function()
        local hitboxFolder = ReplicatedStorage:FindFirstChild("Games")
        if hitboxFolder then
            hitboxFolder = hitboxFolder:FindFirstChild("Replicated")
            if hitboxFolder then
                hitboxFolder = hitboxFolder:FindFirstChild("Hitboxes")
                if hitboxFolder then
                    for _, hitbox in ipairs(hitboxFolder:GetChildren()) do
                        if hitbox:IsA("BasePart") then
                            if Config.TackleReachEnabled then
                                hitbox.Size = Vector3.new(Config.TackleReachDistance, Config.TackleReachDistance, Config.TackleReachDistance)
                                hitbox.Transparency = 0.9
                                hitbox.CanCollide = false
                            elseif Config.BlockReachEnabled then
                                hitbox.Size = Vector3.new(Config.BlockReachSize, Config.BlockReachSize, Config.BlockReachSize)
                                hitbox.Transparency = 0.9
                                hitbox.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Main Loop
Connections.MainLoop = RunService.Heartbeat:Connect(function()
    PullVector()
    UpdateWalkSpeed()
    UpdateJumpPower()
    InfiniteStamina()
    UpdateBighead()
    UpdateHitboxes()
    AutoFollow()
    AutoRush()
    KickAimbot()
end)

-- Cleanup on death
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    OriginalValues.WalkSpeed = Humanoid.WalkSpeed
    OriginalValues.JumpPower = Humanoid.JumpPower
    OriginalValues.HeadSize = Character.Head.Size

    if Config.FlyEnabled then StopFly() Config.FlyEnabled = false end
end)

print("NFL Universe Script loaded! Press RIGHT CTRL to toggle GUI")

-- Toggle GUI visibility with RIGHT CTRL
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
