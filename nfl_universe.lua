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
    JumpPower = Humanoid.JumpPower or 50,
    JumpHeight = Humanoid.JumpHeight or 7.2,
    UseJumpPower = Humanoid.UseJumpPower,
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
MainFrame.Visible = true -- Start visible
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

-- Hook to keep WalkSpeed consistent
local walkSpeedConnection = nil

local function UpdateWalkSpeed()
    if not Humanoid then return end

    if Config.WalkSpeedEnabled then
        Humanoid.WalkSpeed = Config.CustomWalkSpeed

        -- Hook Changed event to keep it consistent
        if not walkSpeedConnection then
            walkSpeedConnection = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if Config.WalkSpeedEnabled and Humanoid.WalkSpeed ~= Config.CustomWalkSpeed then
                    Humanoid.WalkSpeed = Config.CustomWalkSpeed
                end
            end)
        end
    else
        -- Disconnect hook when disabled
        if walkSpeedConnection then
            walkSpeedConnection:Disconnect()
            walkSpeedConnection = nil
        end

        if not Config.AutoFollowBall and not Config.AutoRush then
            Humanoid.WalkSpeed = OriginalValues.WalkSpeed
        end
    end
end

-- Hook to keep JumpPower consistent
local jumpPowerConnection = nil

local function UpdateJumpPower()
    if not Humanoid then return end

    if Config.JumpPowerEnabled then
        -- Force UseJumpPower to true
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = Config.CustomJumpPower

        -- Also set JumpHeight for compatibility
        pcall(function()
            Humanoid.JumpHeight = Config.CustomJumpPower / 6.5
        end)

        -- Hook the Changed event to prevent resets
        if not jumpPowerConnection then
            jumpPowerConnection = Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                if Config.JumpPowerEnabled and Humanoid.JumpPower ~= Config.CustomJumpPower then
                    Humanoid.JumpPower = Config.CustomJumpPower
                end
            end)
        end
    else
        -- Restore original values
        if jumpPowerConnection then
            jumpPowerConnection:Disconnect()
            jumpPowerConnection = nil
        end

        Humanoid.UseJumpPower = OriginalValues.UseJumpPower
        if OriginalValues.UseJumpPower then
            Humanoid.JumpPower = OriginalValues.JumpPower
        else
            Humanoid.JumpHeight = OriginalValues.JumpHeight
        end
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
        -- Check multiple possible stamina locations

        -- 1. Character stamina values
        if Character then
            for _, obj in ipairs(Character:GetDescendants()) do
                if obj.Name == "Stamina" or obj.Name == "Sprinting" or obj.Name == "Energy" then
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        obj.Value = 100
                    end
                end
            end
        end

        -- 2. ReplicatedStorage paths
        for _, path in ipairs({
            {"Games", "Replicated", "MiniGames", "Mechanics"},
            {"Games", "Replicated", "Mechanics"},
            {"MiniGames", "Mechanics"},
            {"Mechanics"}
        }) do
            local current = ReplicatedStorage
            for _, part in ipairs(path) do
                current = current:FindFirstChild(part)
                if not current then break end
            end
            if current then
                for _, obj in ipairs(current:GetChildren()) do
                    if obj.Name == "Stamina" or obj.Name == "Sprinting" or obj.Name == "Energy" then
                        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                            obj.Value = 100
                        end
                    end
                end
            end
        end

        -- 3. Player-specific stamina
        local playerData = ReplicatedStorage:FindFirstChild(LocalPlayer.Name)
        if playerData then
            for _, obj in ipairs(playerData:GetDescendants()) do
                if obj.Name == "Stamina" or obj.Name == "Sprinting" or obj.Name == "Energy" then
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        obj.Value = 100
                    end
                end
            end
        end
    end)
end

local function UpdateBighead()
    if not Character or not Character.Head then return end

    if Config.BigheadEnabled then
        Character.Head.Size = Vector3.new(Config.HeadSize, Config.HeadSize, Config.HeadSize)
        Character.Head.Transparency = 0.7
        Character.Head.CanCollide = true
    else
        -- Immediately restore original
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
        -- Move to carrier WITHOUT changing WalkSpeed
        Humanoid:MoveTo(carrier.HumanoidRootPart.Position)
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

-- Auto Rush state tracking
local rushTarget = nil
local rushMoveConnection = nil

local function AutoRush()
    if not Config.AutoRush then
        -- Clean up when disabled
        if rushMoveConnection then
            rushMoveConnection:Disconnect()
            rushMoveConnection = nil
        end
        rushTarget = nil
        return
    end

    -- Only rush ball carrier / QB (not random enemies)
    local target = GetBallCarrier()

    if target and target:FindFirstChild("HumanoidRootPart") then
        local targetRoot = target.HumanoidRootPart
        rushTarget = targetRoot

        -- Continuously move to target (like auto follow but more aggressive)
        Humanoid:MoveTo(targetRoot.Position)

        -- Face the target directly for more blatant following
        local direction = (targetRoot.Position - HumanoidRootPart.Position).Unit
        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + direction)

        -- Keep refreshing the MoveTo command when target moves
        if not rushMoveConnection then
            rushMoveConnection = Humanoid.MoveToFinished:Connect(function(reached)
                if Config.AutoRush and rushTarget then
                    -- Immediately move to target again
                    Humanoid:MoveTo(rushTarget.Position)
                end
            end)
        end
    else
        rushTarget = nil
    end
end

-- Store original hitbox sizes
local OriginalHitboxes = {}
local OriginalCharacterSizes = {}

local function UpdateHitboxes()
    -- Method 1: Try ReplicatedStorage paths
    pcall(function()
        local paths = {
            {"Games", "Replicated", "Hitboxes"},
            {"Replicated", "Hitboxes"},
            {"Hitboxes"},
            {"Games", "Hitboxes"}
        }

        for _, path in ipairs(paths) do
            local current = ReplicatedStorage
            for _, part in ipairs(path) do
                current = current:FindFirstChild(part)
                if not current then break end
            end

            if current then
                for _, hitbox in ipairs(current:GetChildren()) do
                    if hitbox:IsA("BasePart") then
                        if not OriginalHitboxes[hitbox] then
                            OriginalHitboxes[hitbox] = {
                                Size = hitbox.Size,
                                Transparency = hitbox.Transparency,
                                CanCollide = hitbox.CanCollide
                            }
                        end

                        if Config.TackleReachEnabled then
                            hitbox.Size = Vector3.new(Config.TackleReachDistance, Config.TackleReachDistance, Config.TackleReachDistance)
                            hitbox.Transparency = 0.9
                            hitbox.CanCollide = false
                        elseif Config.BlockReachEnabled then
                            hitbox.Size = Vector3.new(Config.BlockReachSize, Config.BlockReachSize, Config.BlockReachSize)
                            hitbox.Transparency = 0.9
                            hitbox.CanCollide = false
                        else
                            local original = OriginalHitboxes[hitbox]
                            if original then
                                hitbox.Size = original.Size
                                hitbox.Transparency = original.Transparency
                                hitbox.CanCollide = original.CanCollide
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Method 2: Modify character parts directly for tackle/block reach
    pcall(function()
        if not Character then return end

        local partsToExpand = {"HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso"}

        for _, partName in ipairs(partsToExpand) do
            local part = Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                -- Store original size
                if not OriginalCharacterSizes[part] then
                    OriginalCharacterSizes[part] = {
                        Size = part.Size,
                        Transparency = part.Transparency
                    }
                end

                if Config.TackleReachEnabled then
                    -- Expand hitbox for tackling
                    local expandSize = Config.TackleReachDistance / 5
                    part.Size = OriginalCharacterSizes[part].Size + Vector3.new(expandSize, expandSize, expandSize)
                    part.Transparency = math.min(part.Transparency + 0.3, 0.9)
                elseif Config.BlockReachEnabled then
                    -- Expand hitbox for blocking
                    local expandSize = Config.BlockReachSize / 5
                    part.Size = OriginalCharacterSizes[part].Size + Vector3.new(expandSize, expandSize, expandSize)
                    part.Transparency = math.min(part.Transparency + 0.3, 0.9)
                else
                    -- Restore original
                    local original = OriginalCharacterSizes[part]
                    if original then
                        part.Size = original.Size
                        part.Transparency = original.Transparency
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

    -- Reset original values
    OriginalValues.WalkSpeed = Humanoid.WalkSpeed
    OriginalValues.JumpPower = Humanoid.JumpPower or 50
    OriginalValues.JumpHeight = Humanoid.JumpHeight or 7.2
    OriginalValues.UseJumpPower = Humanoid.UseJumpPower
    OriginalValues.HeadSize = Character.Head.Size

    -- Clear character hitbox tracking
    OriginalCharacterSizes = {}

    -- Disconnect old connections
    if walkSpeedConnection then
        walkSpeedConnection:Disconnect()
        walkSpeedConnection = nil
    end
    if jumpPowerConnection then
        jumpPowerConnection:Disconnect()
        jumpPowerConnection = nil
    end
    if rushMoveConnection then
        rushMoveConnection:Disconnect()
        rushMoveConnection = nil
    end

    -- Stop fly if enabled
    if Config.FlyEnabled then
        StopFly()
        Config.FlyEnabled = false
    end

    -- Reapply settings if they were enabled
    task.wait(0.5)
    UpdateWalkSpeed()
    UpdateJumpPower()
end)

-- Wait a moment to ensure everything is loaded
task.wait(0.5)

print("==============================================")
print("NFL Universe Script Loaded!")
print("==============================================")
print("Press one of these keys to toggle GUI:")
print("  - INSERT")
print("  - RIGHT CTRL")
print("  - LEFT CTRL")
print("  - DELETE")
print("==============================================")

-- Toggle GUI visibility with multiple key options
local function toggleGUI()
    if MainFrame then
        MainFrame.Visible = not MainFrame.Visible
        print("[NFL GUI] " .. (MainFrame.Visible and "SHOWN" or "HIDDEN"))
    else
        warn("[NFL GUI ERROR] MainFrame not found!")
    end
end

-- Listen for toggle keys (multiple options for compatibility)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Don't check gameProcessed - we want it to work always
    local keyCode = input.KeyCode

    if keyCode == Enum.KeyCode.Insert then
        print("[NFL] INSERT pressed - toggling GUI")
        toggleGUI()
    elseif keyCode == Enum.KeyCode.RightControl then
        print("[NFL] RIGHT CTRL pressed - toggling GUI")
        toggleGUI()
    elseif keyCode == Enum.KeyCode.LeftControl then
        print("[NFL] LEFT CTRL pressed - toggling GUI")
        toggleGUI()
    elseif keyCode == Enum.KeyCode.Delete then
        print("[NFL] DELETE pressed - toggling GUI")
        toggleGUI()
    end
end)
