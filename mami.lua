local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

if CoreGui:FindFirstChild("MappuHub") then CoreGui.MappuHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MappuHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 520)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)

local ConfirmFrame = Instance.new("Frame", ScreenGui)
ConfirmFrame.Size = UDim2.new(0, 220, 0, 120)
ConfirmFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 20
Instance.new("UICorner", ConfirmFrame)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1, 0, 0, 50)
ConfirmText.Position = UDim2.new(0, 0, 0, 15)
ConfirmText.Text = "消しますか？"
ConfirmText.TextColor3 = Color3.new(1, 1, 1)
ConfirmText.Font = Enum.Font.SourceSansBold
ConfirmText.TextSize = 22
ConfirmText.BackgroundTransparency = 1
ConfirmText.ZIndex = 21

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size = UDim2.new(0, 80, 0, 35)
YesBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
YesBtn.Text = "はい"
YesBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
YesBtn.TextColor3 = Color3.new(1, 1, 1)
YesBtn.ZIndex = 21
Instance.new("UICorner", YesBtn)

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size = UDim2.new(0, 80, 0, 35)
NoBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
NoBtn.Text = "いいえ"
NoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoBtn.TextColor3 = Color3.new(1, 1, 1)
NoBtn.ZIndex = 21
Instance.new("UICorner", NoBtn)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -60, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "まっぷhub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -55, 0, 7)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -25, 0, 7)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 950)
Scroll.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 12)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local states = {fly = false, noclip = false, infJump = false, clickTp = false, esp = false}
local values = {ws = 16, jp = 50, fs = 2}

local function applyStats(hum)
    hum.WalkSpeed = values.ws
    hum.JumpPower = values.jp
    hum.UseJumpPower = true
end

local function setupCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() hum.WalkSpeed = values.ws end)
    hum:GetPropertyChangedSignal("JumpPower"):Connect(function() hum.JumpPower = values.jp end)
    applyStats(hum)
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

RunService.Heartbeat:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if states.fly then
                hum.PlatformStand = true
                hrp.Velocity = Vector3.new(0, 0.1, 0)
                local moveDir = hum.MoveDirection
                local camCF = camera.CFrame
                if moveDir.Magnitude > 0 then
                    local relativeMove = camCF:VectorToObjectSpace(moveDir)
                    local flyDir = (camCF.LookVector * -relativeMove.Z) + (camCF.RightVector * relativeMove.X)
                    hrp.CFrame = hrp.CFrame + (flyDir * values.fs)
                end
            elseif not states.fly and hum.PlatformStand then 
                hum.PlatformStand = false 
            end
            if states.noclip or states.fly then
                for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end
    end
end)

local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hl = p.Character:FindFirstChild("ESPHighlight")
            if states.esp then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "ESPHighlight"
                    hl.FillColor = Color3.new(1, 0, 0)
                end
            elseif hl then hl:Destroy() end
        end
    end
end

RunService.RenderStepped:Connect(function() if states.esp then updateESP() end end)
UIS.JumpRequest:Connect(function() if states.infJump and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid:ChangeState("Jumping") end end)
mouse.Button1Down:Connect(function() if states.clickTp and player.Character then player.Character:MoveTo(mouse.Hit.p) end end)

local function createToggle(name, key)
    local frame = Instance.new("Frame", Scroll)
    frame.Size, frame.BackgroundTransparency = UDim2.new(0.9, 0, 0, 35), 1
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Text, label.TextColor3, label.BackgroundTransparency = UDim2.new(0.6, 0, 1, 0), name, Color3.new(1, 1, 1), 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    local bg = Instance.new("TextButton", frame)
    bg.Size, bg.Position, bg.BackgroundColor3, bg.Text = UDim2.new(0, 45, 0, 22), UDim2.new(1, -45, 0.5, -11), Color3.fromRGB(50, 50, 50), ""
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", bg)
    circle.Size, circle.Position, circle.BackgroundColor3 = UDim2.new(0, 18, 0, 18), UDim2.new(0, 2, 0.5, -9), Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    bg.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = states[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        TweenService:Create(bg, TweenInfo.new(0.2), {BackgroundColor3 = states[key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)}):Play()
    end)
end

local function createSlider(name, min, max, def, key)
    local frame = Instance.new("Frame", Scroll)
    frame.Size, frame.BackgroundTransparency = UDim2.new(0.9, 0, 0, 50), 1
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Text, label.TextColor3, label.BackgroundTransparency = UDim2.new(1, 0, 0, 20), name..": "..def, Color3.new(0.8,0.8,0.8), 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    local bar = Instance.new("Frame", frame)
    bar.Size, bar.Position, bar.BackgroundColor3 = UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 0, 30), Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", bar)
    local fill = Instance.new("Frame", bar)
    fill.Size, fill.BackgroundColor3 = UDim2.new((def-min)/(max-min), 0, 1, 0), Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", fill)
    local btn = Instance.new("TextButton", bar)
    btn.Size, btn.BackgroundTransparency, btn.Text = UDim2.new(1, 0, 1, 0), 1, ""
    local function update()
        local pos = math.clamp((UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        fill.Size, label.Text = UDim2.new(pos, 0, 1, 0), name..": "..val
        values[key] = val
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            applyStats(player.Character.Humanoid)
        end
    end
    local dragging = false
    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputEnded:Connect(function() dragging = false end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update() end end)
end

createToggle("Fly ", "fly")
createToggle("Noclip", "noclip")
createToggle("Infinite Jump", "infJump")
createToggle("Player ESP", "esp")
createToggle("Click Teleport", "clickTp")

createSlider("WalkSpeed", 16, 250, 16, "ws")
createSlider("JumpPower", 50, 500, 50, "jp")
createSlider("FlySpeed", 1, 20, 2, "fs")

MinBtn.MouseButton1Click:Connect(function()
    local isMin = Scroll.Visible
    Scroll.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 200, 0, 40) or UDim2.new(0, 200, 0, 520), "Out", "Quart", 0.3, true)
end)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
