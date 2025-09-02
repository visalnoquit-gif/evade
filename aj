local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 60, 0, 30) -- small like your thumb
frame.Position = UDim2.new(0.5, -30, 0.5, -15)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BackgroundTransparency = 0.7

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

local outline = Instance.new("UIStroke", frame)
outline.Thickness = 2
outline.Color = Color3.fromRGB(255, 0, 0)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundTransparency = 1
button.Text = "Evade Off"
button.TextColor3 = Color3.fromRGB(30, 30, 30)
button.TextScaled = true

-- State
local isOn = false

-- Toggle function
local function toggleEvade()
    isOn = not isOn
    button.Text = isOn and "Evade On" or "Evade Off"
    if isOn then
        outline.Color = Color3.fromRGB(0, 255, 0)
    else
        outline.Color = Color3.fromRGB(255, 0, 0)
    end
end

button.MouseButton1Click:Connect(toggleEvade)

-- Draggable (mobile-friendly)
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Auto-jump
local tickAcc = 0
RunService.Heartbeat:Connect(function(dt)
    if isOn then
        tickAcc = tickAcc + dt
        if tickAcc >= 0.05 then
            tickAcc = 0
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid.Jump = true
            end
        end
    end
end)
