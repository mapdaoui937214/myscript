local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

if CoreGui:FindFirstChild("MappuHub") then CoreGui.MappuHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MappuHub"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 500)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", Main)
TitleLabel.Size = UDim2.new(1, -60, 0, 35)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Text = "まっぷhub"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -55, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 750)
Scroll.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local flyEnabled, flySpeed, infJumpEnabled, noclipEnabled, clickTpEnabled = false, 2, false, false, false

RunService.Stepped:Connect(function()
    if player.Character then
        if noclipEnabled or flyEnabled then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local hum = player.Character:FindFirstChild("Humanoid")
        if flyEnabled and hrp and hum then
            hum.PlatformStand = true
            hrp.Velocity = Vector3.new(0, 0, 0)
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local direction = (camera.CFrame.LookVector * moveDir.Z) + (camera.CFrame.RightVector * moveDir.X)
                hrp.CFrame = hrp.CFrame + (direction * flySpeed)
            end
        elseif hum and hum.PlatformStand and not flyEnabled then
            hum.PlatformStand = false
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

mouse.Button1Down:Connect(function()
    if clickTpEnabled and player.Character and mouse.Target then
        player.Character:MoveTo(mouse.Hit.p)
    end
end)

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
end

local tpInput = Instance.new("TextBox", Scroll)
tpInput.Size = UDim2.new(0.9, 0, 0, 35)
tpInput.PlaceholderText = "Player Name..."
tpInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tpInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", tpInput)

local tpBtn = Instance.new("TextButton", Scroll)
tpBtn.Size = UDim2.new(0.9, 0, 0, 35)
tpBtn.Text = "TP to Player"
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", tpBtn)
tpBtn.MouseButton1Click:Connect(function()
    local targetName = tpInput.Text:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Name:lower():sub(1, #targetName) == targetName then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

createToggle("Click TP", function(s) clickTpEnabled = s end)
createToggle("FLY", function(s) flyEnabled = s end)
createToggle("Noclip", function(s) noclipEnabled = s end)
createToggle("Inf Jump", function(s) infJumpEnabled = s end)

local function createSlider(name, min, max, def, callback)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. def
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, 0, 0, 4)
    bar.Position = UDim2.new(0, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    local fill, dot = Instance.new("Frame", bar), Instance.new("TextButton", bar)
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    dot.Size, dot.Text = UDim2.new(0, 12, 0, 12), ""
    dot.Position = UDim2.new((def-min)/(max-min), -6, 0.5, -6)
    Instance.new("UICorner", dot)
    local dragging = false
    local function update()
        local pos = math.clamp((UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        fill.Size, dot.Position = UDim2.new(pos, 0, 1, 0), UDim2.new(pos, -6, 0.5, -6)
        label.Text = name .. ": " .. val
        callback(val)
    end
    dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputEnded:Connect(function() dragging = false end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update() end end)
end

createSlider("WalkSpeed", 16, 200, 16, function(v) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = v end end)
createSlider("JumpPower", 50, 500, 50, function(v) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.JumpPower = v end end)
createSlider("FlySpeed", 1, 10, 2, function(v) flySpeed = v end)

MinBtn.MouseButton1Click:Connect(function()
    local min = Scroll.Visible
    Scroll.Visible = not min
    Main:TweenSize(min and UDim2.new(0, 180, 0, 35) or UDim2.new(0, 180, 0, 500), "Out", "Quart", 0.3, true)
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
