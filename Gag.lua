local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotGodMobile"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 270)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "BRAINROT GOD"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
title.Parent = mainFrame
Instance.new("UICorner", title)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn)

local list = Instance.new("UIListLayout")
list.Parent = mainFrame
list.Padding = UDim.new(0, 10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local spacer = Instance.new("Frame")
spacer.Size = UDim2.new(1, 0, 0, 40)
spacer.BackgroundTransparency = 1
spacer.Parent = mainFrame

local function createBtn(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = mainFrame
    Instance.new("UICorner", b)
    return b
end

local tpBtn = createBtn("TP Base: OFF", Color3.fromRGB(0, 80, 150))
local ahBtn = createBtn("Anti-Hit: OFF", Color3.fromRGB(120, 30, 30))
local gdBtn = createBtn("Anti-Potion: OFF", Color3.fromRGB(60, 60, 60))

local sLabel = Instance.new("TextLabel")
sLabel.Size = UDim2.new(0.9, 0, 0, 20)
sLabel.Text = "Reach: 2"
sLabel.TextColor3 = Color3.new(1, 1, 1)
sLabel.BackgroundTransparency = 1
sLabel.Parent = mainFrame

local sBack = Instance.new("Frame")
sBack.Size = UDim2.new(0.8, 0, 0, 10)
sBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sBack.Parent = mainFrame

local sBtn = Instance.new("TextButton")
sBtn.Size = UDim2.new(0, 20, 0, 20)
sBtn.Position = UDim2.new(0, 0, 0.5, -10)
sBtn.Text = ""
sBtn.Parent = sBack
Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)

local vars = {tp = false, ah = false, god = false, hb = 2}
local dragging = false

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
tpBtn.MouseButton1Click:Connect(function() vars.tp = not vars.tp tpBtn.Text = "TP Base: " .. (vars.tp and "ON" or "OFF") tpBtn.BackgroundColor3 = vars.tp and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(0, 80, 150) end)
ahBtn.MouseButton1Click:Connect(function() vars.ah = not vars.ah ahBtn.Text = "Anti-Hit: " .. (vars.ah and "ON" or "OFF") ahBtn.BackgroundColor3 = vars.ah and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(120, 30, 30) end)
gdBtn.MouseButton1Click:Connect(function() vars.god = not vars.god gdBtn.Text = "Anti-Potion: " .. (vars.god and "ON" or "OFF") gdBtn.BackgroundColor3 = vars.god and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(60, 60, 60) end)

local function updateSlider(input)
    local pos = math.clamp((input.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
    sBtn.Position = UDim2.new(pos, -10, 0.5, -10)
    vars.hb = 2 + (pos * 48)
    sLabel.Text = "Reach: " .. string.format("%.1f", vars.hb)
end

sBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i) end end)

RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if vars.tp and localPlayer.RespawnLocation then hrp.CFrame = localPlayer.RespawnLocation.CFrame + Vector3.new(0, 5, 0) end

    if vars.god then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanTouch = false end end
        if char:FindFirstChild("Humanoid") then char.Humanoid.Health = char.Humanoid.MaxHealth end
    else
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanTouch = true end end
    end

    if vars.ah then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        for _, p in pairs(tool:GetDescendants()) do
            if p:IsA("BasePart") then p.Size = Vector3.new(vars.hb, vars.hb, vars.hb) p.CanCollide = false p.CanTouch = true end
        end
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local r = v.Character.HumanoidRootPart
            r.Size = Vector3.new(vars.hb, vars.hb, vars.hb)
            r.Transparency = 0.95
            r.CanCollide = false
        end
    end
end)
