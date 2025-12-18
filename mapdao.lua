local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MapHub_V27_Ultimate"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 420)
Main.Position = UDim2.new(0.5, -120, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 200)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.Text = " 🚀 MAPHUB V27 (Fixed Fly)"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -55)
Scroll.Position = UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
Scroll.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

local flySpeed, walkSpeed = 60, 16
local flying, noclip, infJump = false, false, false

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    local Ind = Instance.new("Frame", btn)
    Ind.Size = UDim2.new(0, 8, 0, 8)
    Ind.Position = UDim2.new(1, -20, 0.5, -4)
    Ind.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
    local s = false
    btn.MouseButton1Click:Connect(function()
        s = not s
        callback(s)
        TweenService:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(80, 20, 20)}):Play()
    end)
end

local function createSlider(name, min, max, def, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(0.95, 0, 0, 45)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = "  " .. name .. ": " .. def
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0.9, 0, 0, 4)
    bar.Position = UDim2.new(0.05, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    local dot = Instance.new("TextButton", bar)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new((def - min) / (max - min), -6, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.Text = ""
    Instance.new("UICorner", dot)
    local drag = false
    local function update()
        local percent = math.clamp((UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (percent * (max - min)))
        fill.Size = UDim2.new(percent, 0, 1, 0)
        dot.Position = UDim2.new(percent, -6, 0.5, -6)
        label.Text = "  " .. name .. ": " .. val
        callback(val)
    end
    dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    UIS.InputEnded:Connect(function() drag = false end)
    UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update() end end)
end

-- Fly Logic (BodyVelocity & BodyGyro Bypassing)
local bv, bg
createToggle("Ultimate Fly", function(s)
    flying = s
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if s then
        char.Humanoid.PlatformStand = true
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = char.HumanoidRootPart
        
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 15000
        bg.CFrame = char.HumanoidRootPart.CFrame
        bg.Parent = char.HumanoidRootPart
    else
        char.Humanoid.PlatformStand = false
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

createToggle("Noclip", function(s) noclip = s end)
createToggle("Inf Jump", function(s) infJump = s end)
createSlider("FlySpeed", 10, 500, 60, function(v) flySpeed = v end)

-- Main Loop
RunService.RenderStepped:Connect(function(dt)
    local char = player.Character
    if flying and char and char:FindFirstChild("HumanoidRootPart") and bv and bg then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        local moveVec = hum.MoveDirection
        local upVec = Vector3.new(0, 0, 0)
        
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS.JumpTouchInput then
            upVec = Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            upVec = Vector3.new(0, -1, 0)
        end
        
        bv.Velocity = (moveVec + upVec).Unit * flySpeed
        if (moveVec + upVec).Magnitude == 0 then
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        bg.CFrame = camera.CFrame
    end
    
    if char and char:FindFirstChild("Humanoid") then
        if not flying then char.Humanoid.WalkSpeed = walkSpeed end
    end
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UIS.JumpRequest:Connect(function() if infJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end end)

-- UI Close
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundTransparency = 1
local closed = false
CloseBtn.MouseButton1Click:Connect(function()
    closed = not closed
    TweenService:Create(Main, TweenInfo.new(0.3), {Size = closed and UDim2.new(0, 240, 0, 45) or UDim2.new(0, 240, 0, 420)}):Play()
    CloseBtn.Text = closed and "+" or "X"
end)
