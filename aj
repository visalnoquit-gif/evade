local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 60, 0, 30)
frame.Position = UDim2.new(0.5, -30, 0.5, -15)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BackgroundTransparency = 0.7

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

local outline = Instance.new("UIStroke", frame)
outline.Thickness = 2
outline.Color = Color3.fromRGB(255, 0, 0)

-- Drag handle (above button so touches work)
local dragHandle = Instance.new("TextButton", frame)
dragHandle.Size = UDim2.new(1, 0, 1, 0)
dragHandle.BackgroundTransparency = 1
dragHandle.Text = ""
dragHandle.TextTransparency = 1

-- Button (shows text)
local button = Instance.new("TextLabel", frame)
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundTransparency = 1
button.Text = "Evade Off"
button.TextColor3 = Color3.fromRGB(30, 30, 30)
button.TextScaled = true

-- State
local isOn = false
local function toggle()
    isOn = not isOn
    button.Text = isOn and "Evade On" or "Evade Off"
    outline.Color = isOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

-- Tap the dragHandle to toggle
dragHandle.MouseButton1Click:Connect(toggle)

-- Mobile dragging variables
local dragging = false
local dragStart = Vector2.new()
local startPos = UDim2.new()

dragHandle.InputBegan:Connect(function(input)
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

UserInputService.TouchMoved:Connect(function(touch)
    if dragging then
        local delta = touch.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Auto-jump mobile-friendly
RunService.Heartbeat:Connect(function()
    if isOn and humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
