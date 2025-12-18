local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MapHub_V29_FTAP_Final"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 450)
Main.Position = UDim2.new(0.5, -125, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 200)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = " 🚀 FTAP HUB 🚀"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -60)
Scroll.Position = UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
Scroll.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 8)

local flingEnabled = false
local flingForce = 5000

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(40, 60, 50) or Color3.fromRGB(30, 30, 40)}):Play()
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.new(0.8, 0.8, 0.8)
    end)
end

local function createSlider(name, min, max, def, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(0.95, 0, 0, 50)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. def
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0.9, 0, 0, 4)
    bar.Position = UDim2.new(0.05, 0, 0, 35)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    local dot = Instance.new("TextButton", bar)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new((def-min)/(max-min), -7, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    dot.Text = ""
    Instance.new("UICorner", dot)
    local dragging = false
    local function update()
        local pos = math.clamp((UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        dot.Position = UDim2.new(pos, -7, 0.5, -7)
        label.Text = name .. ": " .. val
        callback(val)
    end
    dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputEnded:Connect(function() dragging = false end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update() end end)
end

createToggle("Click Fling Mode", function(s) flingEnabled = s end)
createSlider("Fling Power", 1000, 30000, 5000, function(v) flingForce = v end)

local bringBtn = Instance.new("TextButton", Scroll)
bringBtn.Size = UDim2.new(0.95, 0, 0, 40)
bringBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
bringBtn.Text = "🚨 BRING ALL TO SPAWN"
bringBtn.TextColor3 = Color3.new(1,1,1)
bringBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", bringBtn)

bringBtn.MouseButton1Click:Connect(function()
    local spawnPos = Vector3.new(0, 10, 0)
    local spawnLoc = workspace:FindFirstChildOfClass("SpawnLocation")
    if spawnLoc then spawnPos = spawnLoc.Position + Vector3.new(0, 5, 0) end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPos)
        end
    end
end)

mouse.Button1Down:Connect(function()
    if flingEnabled and mouse.Target then
        local t = mouse.Target
        if t:IsA("BasePart") then
            if t.Parent:FindFirstChild("Humanoid") then t = t.Parent:FindFirstChild("HumanoidRootPart") or t end
            local bv = Instance.new("BodyVelocity", t)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = camera.CFrame.LookVector * flingForce
            local bav = Instance.new("BodyAngularVelocity", t)
            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bav.AngularVelocity = Vector3.new(100, 100, 100)
            Debris:AddItem(bv, 0.4)
            Debris:AddItem(bav, 0.4)
        end
    end
end)

local close = Instance.new("TextButton", Main)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 7)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundTransparency = 1
local closed = false
close.MouseButton1Click:Connect(function()
    closed = not closed
    Main:TweenSize(closed and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 450), "Out", "Quart", 0.3, true)
    close.Text = closed and "+" or "X"
end)
