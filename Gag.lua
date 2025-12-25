local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteGhostMod"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ELITE MOD MENU"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
title.Parent = mainFrame
Instance.new("UICorner", title)

local list = Instance.new("UIListLayout")
list.Parent = mainFrame
list.Padding = UDim.new(0, 8)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local spacer = Instance.new("Frame")
spacer.Size = UDim2.new(1, 0, 0, 45)
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

local setZoneBtn = createBtn("Set Zone (位置保存)", Color3.fromRGB(0, 100, 200))
local jumpBtn = createBtn("Jump to Zone (ワープ)", Color3.fromRGB(200, 100, 0))
local lagBtn = createBtn("Lag Mode: OFF", Color3.fromRGB(80, 80, 80))

local sLabel = Instance.new("TextLabel")
sLabel.Size = UDim2.new(0.9, 0, 0, 20)
sLabel.Text = "Circle Size: 15"
sLabel.TextColor3 = Color3.new(1, 1, 1)
sLabel.BackgroundTransparency = 1
sLabel.Parent = mainFrame

local sBack = Instance.new("Frame")
sBack.Size = UDim2.new(0.8, 0, 0, 10)
sBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sBack.Parent = mainFrame

local sBtn = Instance.new("TextButton")
sBtn.Size = UDim2.new(0, 20, 0, 20)
sBtn.Position = UDim2.new(0.2, 0, 0.5, -10)
sBtn.Text = ""
sBtn.Parent = sBack
Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)

local vars = {lag = false, hb = 15, savedPos = nil}
local dragging = false

local visualCircle = Instance.new("Part")
visualCircle.Name = "ReachVisual"
visualCircle.Shape = Enum.PartType.Cylinder
visualCircle.Material = Enum.Material.Neon
visualCircle.Color = Color3.fromRGB(0, 255, 255)
visualCircle.Transparency = 0.75
visualCircle.CastShadow = false
visualCircle.CanCollide = false
visualCircle.CanTouch = false
visualCircle.Anchored = true
visualCircle.Parent = workspace

setZoneBtn.MouseButton1Click:Connect(function()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        vars.savedPos = hrp.CFrame
        setZoneBtn.Text = "SAVED"
        task.delay(1, function() setZoneBtn.Text = "Set Zone (位置保存)" end)
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and vars.savedPos then
        hrp.CFrame = vars.savedPos
    end
end)

lagBtn.MouseButton1Click:Connect(function()
    vars.lag = not vars.lag
    lagBtn.Text = "Lag Mode: " .. (vars.lag and "ON" or "OFF")
    lagBtn.BackgroundColor3 = vars.lag and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 80)
end)

local function updateSlider(input)
    local pos = math.clamp((input.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
    sBtn.Position = UDim2.new(pos, -10, 0.5, -10)
    vars.hb = 5 + (pos * 45)
    sLabel.Text = "Circle Size: " .. string.format("%.0f", vars.hb)
end

sBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(i) end end)

RunService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then 
        visualCircle.Transparency = 1 
        return 
    end
    
    local hrp = char.HumanoidRootPart
    visualCircle.Transparency = 0.75
    visualCircle.Size = Vector3.new(0.1, vars.hb * 2, vars.hb * 2)
    visualCircle.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(90))

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
        if handle then
            handle.Size = Vector3.new(vars.hb * 2, 2, vars.hb * 2)
            handle.CFrame = hrp.CFrame
            handle.CanTouch = true
            handle.Transparency = 1
        end
    end

    if vars.lag then
        pcall(function() sethiddenproperty(localPlayer, "SimulationRadius", 0) end)
    else
        pcall(function() sethiddenproperty(localPlayer, "SimulationRadius", 1000) end)
    end
end)
