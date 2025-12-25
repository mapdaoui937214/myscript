local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUltimateMobile"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 260)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "BRAINROT ULTIMATE"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.Parent = mainFrame
Instance.new("UICorner", title)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn)

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 30, 0, 30)
miniBtn.Position = UDim2.new(1, -70, 0, 2)
miniBtn.Text = "-"
miniBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Parent = mainFrame
Instance.new("UICorner", miniBtn)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = contentFrame
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createToggle(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = contentFrame
    Instance.new("UICorner", btn)
    return btn
end

local tpBtn = createToggle("TP Base: OFF", Color3.fromRGB(0, 80, 150))
local ahBtn = createToggle("Anti-Hit: OFF", Color3.fromRGB(120, 30, 30))
local gdBtn = createToggle("God Mode: OFF", Color3.fromRGB(60, 60, 60))

local sLabel = Instance.new("TextLabel")
sLabel.Size = UDim2.new(0.9, 0, 0, 20)
sLabel.Text = "Reach Size: 2"
sLabel.TextColor3 = Color3.new(1, 1, 1)
sLabel.BackgroundTransparency = 1
sLabel.Parent = contentFrame

local sBack = Instance.new("Frame")
sBack.Size = UDim2.new(0.8, 0, 0, 10)
sBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sBack.Parent = contentFrame

local sBtn = Instance.new("TextButton")
sBtn.Size = UDim2.new(0, 20, 0, 20)
sBtn.Position = UDim2.new(0, 0, 0.5, -10)
sBtn.BackgroundColor3 = Color3.new(1, 1, 1)
sBtn.Text = ""
sBtn.Parent = sBack
Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)

local states = {tp = false, ah = false, god = false, hb = 2, minimized = false}

miniBtn.MouseButton1Click:Connect(function()
    states.minimized = not states.minimized
    contentFrame.Visible = not states.minimized
    mainFrame.Size = states.minimized and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 260)
end)

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

tpBtn.MouseButton1Click:Connect(function()
    states.tp = not states.tp
    tpBtn.Text = "TP Base: " .. (states.tp and "ON" or "OFF")
    tpBtn.BackgroundColor3 = states.tp and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 80, 150)
end)

ahBtn.MouseButton1Click:Connect(function()
    states.ah = not states.ah
    ahBtn.Text = "Anti-Hit: " .. (states.ah and "ON" or "OFF")
    ahBtn.BackgroundColor3 = states.ah and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(120, 30, 30)
end)

gdBtn.MouseButton1Click:Connect(function()
    states.god = not states.god
    gdBtn.Text = "God Mode: " .. (states.god and "ON" or "OFF")
    gdBtn.BackgroundColor3 = states.god and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

local function updateSlider(input)
    local pos = math.clamp((input.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
    sBtn.Position = UDim2.new(pos, -10, 0.5, -10)
    states.hb = 2 + (pos * 28)
    sLabel.Text = "Reach Size: " .. string.format("%.1f", states.hb)
end

local dragging = false
sBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i) end end)

RunService.Heartbeat:Connect(function()
    local c = localPlayer.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    
    if states.tp and localPlayer.RespawnLocation then c.HumanoidRootPart.CFrame = localPlayer.RespawnLocation.CFrame + Vector3.new(0, 3, 0) end
    
    for _, p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            if states.ah then p.CanCollide = false end
            if states.god and p.Name ~= "HumanoidRootPart" then p.CanTouch = false end
        end
    end
    if states.god and c:FindFirstChild("Humanoid") then c.Humanoid.Health = c.Humanoid.MaxHealth end

    local tool = c:FindFirstChildOfClass("Tool")
    if tool then
        local h = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
        if h then h.Size = Vector3.new(states.hb, states.hb, states.hb) h.CanCollide = false h.Transparency = 0.7 end
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(states.hb, states.hb, states.hb)
            v.Character.HumanoidRootPart.Transparency = 0.9
            v.Character.HumanoidRootPart.CanCollide = false
        end
    end
end)
