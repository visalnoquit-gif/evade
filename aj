local p=game:GetService("Players").LocalPlayer
local r=game:GetService("RunService")
local t=game:GetService("TweenService")
local g=Instance.new("ScreenGui",p:WaitForChild("PlayerGui"))

-- Frame
local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,80,0,40)
f.Position=UDim2.new(0.5,-40,0.5,-20)
f.BackgroundColor3=Color3.fromRGB(50,50,50)
f.BackgroundTransparency=0.7
Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)

-- Outline
local o=Instance.new("UIStroke",f)
o.Thickness=3
o.Color=Color3.fromRGB(255,0,0)

-- Button
local b=Instance.new("TextButton",f)
b.Size=UDim2.new(1,0,1,0)
b.Position=UDim2.new(0,0,0,0)
b.BackgroundTransparency=1
b.Text="Evade"
b.TextColor3=Color3.fromRGB(30,30,30)
b.TextScaled=true

-- Toggle state
local e=false
local onTween=t:Create(o,TweenInfo.new(0.1),"Out",{Color=Color3.fromRGB(0,255,0)})
local offTween=t:Create(o,TweenInfo.new(0.1),"Out",{Color=Color3.fromRGB(255,0,0)})

b.MouseButton1Click:Connect(function()
    e=not e
    if e then onTween:Play() else offTween:Play() end
    b:TweenSize(UDim2.new(1,-4,1,-4),"Out","Quad",0.05,true)
    wait(0.05)
    b:TweenSize(UDim2.new(1,0,1,0),"Out","Quad",0.05,true)
end)

-- **Draggable mobile-friendly**
local dragging=false
local dragStart
local startPos

f.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=f.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then
                dragging=false
            end
        end)
    end
end)

f.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch and dragging then
        local delta=input.Position - dragStart
        f.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Auto-jump
local c=p.Character or p.CharacterAdded:Wait()
local h=c:WaitForChild("Humanoid")
local a=0

r.Heartbeat:Connect(function(dt)
    if e then
        a=a+dt
        if a>=0.05 then
            a=0
            if h.FloorMaterial~=Enum.Material.Air then h.Jump=true end
        end
        local pulse=math.sin(tick()*10)*0.1
        o.Color=Color3.fromRGB(0,255*(0.9+pulse),0)
    end
end)
