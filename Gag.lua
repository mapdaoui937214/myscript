local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotGhostSpawnFinal"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 310)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -155)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "GHOST & SPAWN MOD"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
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
list.Padding = UDim.new(0, 8)
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

local ghostBtn = createBtn("Ghost Mode: OFF", Color3.fromRGB(80, 80, 80))
local tpBtn = createBtn("TP Spawn: OFF", Color3.fromRGB(0, 80, 150))
local gdBtn = createBtn("Anti-Item: OFF", Color3.fromRGB(60, 60, 60))

local sLabel = Instance.new("TextLabel")
sLabel.Size = UDim2.new(0.9, 0, 0, 20)
sLabel.Text = "Ring Size: 2"
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

local vars = {ghost = false, tp = false, god = false, hb = 2}
local dragging = false

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
ghostBtn.MouseButton1Click:Connect(function() vars.ghost = not vars.ghost ghostBtn.Text = "Ghost: " .. (vars.ghost and "ON" or "OFF") ghostBtn.BackgroundColor3 = vars.ghost and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(80, 80, 80) end)
tpBtn.MouseButton1Click:Connect(function() vars.tp = not vars.tp tpBtn.Text = "TP Spawn: " .. (vars.tp and "ON" or "OFF") tpBtn.BackgroundColor3 = vars.tp and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(0, 80, 150) end)
gdBtn.MouseButton1Click:Connect(function() vars.god = not vars.god gdBtn.Text = "Anti-Item: " .. (vars.god and "ON" or "OFF") gdBtn.BackgroundColor3 = vars.god and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(60, 60, 60) end)

local function updateSlider(input)
    local pos = math.clamp((input.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
    sBtn.Position = UDim2.new(pos, -10, 0.5, -10)
    vars.hb = 2 + (pos * 58)
    sLabel.Text = "Ring Size: " .. string.format("%.1f", vars.hb)
end

sBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i) end end)

local function getSpawnPos()
    local team = localPlayer.Team
    if team then
        for _, s in pairs(workspace:GetDescendants()) do
            if s:IsA("SpawnLocation") and s.TeamColor == team.TeamColor then return s.CFrame + Vector3.new(0, 5, 0) end
        end
    end
    return (localPlayer.RespawnLocation and localPlayer.RespawnLocation.CFrame + Vector3.new(0, 5, 0)) or (workspace:FindFirstChildWhichIsA("SpawnLocation") and workspace:FindFirstChildWhichIsA("SpawnLocation").CFrame + Vector3.new(0, 5, 0))
end

RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if vars.tp then
        local target = getSpawnPos()
        if target then hrp.CFrame = target end
    end

    if vars.ghost then
        pcall(function() sethiddenproperty(localPlayer, "SimulationRadius", 0) end)
    end

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
        if handle then
            handle.Size = Vector3.new(vars.hb, 2, vars.hb)
            handle.CFrame = hrp.CFrame
            handle.CanCollide = false
            handle.Transparency = 0.8
            handle.CanTouch = true
        end
    end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(vars.hb/2, 10, vars.hb/2)
            v.Character.HumanoidRootPart.CanCollide = false
            v.Character.HumanoidRootPart.Transparency = 0.98
        end
    end

    if vars.god then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanTouch = false end end
        if char:FindFirstChild("Humanoid") then char.Humanoid.Health = char.Humanoid.MaxHealth end
    else
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanTouch = true end end
    end
end)
