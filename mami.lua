local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local CORRECT_KEYS = {"maphub", "Maphub"}

local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then return nil end
    return old(self, ...)
end)
setreadonly(mt, true)

if CoreGui:FindFirstChild("MappuHub") then CoreGui.MappuHub:Destroy() end
if CoreGui:FindFirstChild("KeySystem") then CoreGui.KeySystem:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MappuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false

local KeyGui = Instance.new("ScreenGui", CoreGui)
KeyGui.Name = "KeySystem"

local KeyMain = Instance.new("Frame", KeyGui)
KeyMain.Size, KeyMain.Position, KeyMain.BackgroundColor3 = UDim2.new(0, 300, 0, 180), UDim2.new(0.5, -150, 0.5, -90), Color3.fromRGB(30, 30, 30)
KeyMain.Active, KeyMain.Draggable = true, true
Instance.new("UICorner", KeyMain)

local KeyTitle = Instance.new("TextLabel", KeyMain)
KeyTitle.Size, KeyTitle.Text, KeyTitle.TextColor3 = UDim2.new(1, 0, 0, 40), "まっぷhub - Mobile Key", Color3.new(1, 1, 1)
KeyTitle.Font, KeyTitle.TextSize, KeyTitle.BackgroundTransparency = Enum.Font.SourceSansBold, 20, 1

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size, KeyInput.Position, KeyInput.PlaceholderText = UDim2.new(0, 240, 0, 45), UDim2.new(0.5, -120, 0.4, 0), "Keyを入力"
KeyInput.BackgroundColor3, KeyInput.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1)
Instance.new("UICorner", KeyInput)

local KeySubmit = Instance.new("TextButton", KeyMain)
KeySubmit.Size, KeySubmit.Position, KeySubmit.Text = UDim2.new(0, 120, 0, 40), UDim2.new(0.5, -60, 0.75, 0), "認証"
KeySubmit.BackgroundColor3, KeySubmit.TextColor3 = Color3.fromRGB(0, 150, 255), Color3.new(1, 1, 1)
Instance.new("UICorner", KeySubmit)

KeySubmit.MouseButton1Click:Connect(function()
    if KeyInput.Text == "maphub" or KeyInput.Text == "Maphub" then KeyGui:Destroy() ScreenGui.Enabled = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Keyが違います"
        task.delay(1.5, function() if KeyInput then KeyInput.PlaceholderText = "Keyを入力" end end)
    end
end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 220, 0, 500), UDim2.new(0.05, 0, 0.2, 0), Color3.fromRGB(20, 20, 20)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)

local ConfirmFrame = Instance.new("Frame", ScreenGui)
ConfirmFrame.Size, ConfirmFrame.Position, ConfirmFrame.BackgroundColor3 = UDim2.new(0, 220, 0, 120), UDim2.new(0.5, -110, 0.5, -60), Color3.fromRGB(30, 30, 30)
ConfirmFrame.Visible, ConfirmFrame.ZIndex = false, 20
Instance.new("UICorner", ConfirmFrame)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size, ConfirmText.Position, ConfirmText.Text = UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 15), "消しますか？"
ConfirmText.TextColor3, ConfirmText.Font, ConfirmText.TextSize, ConfirmText.BackgroundTransparency, ConfirmText.ZIndex = Color3.new(1, 1, 1), Enum.Font.SourceSansBold, 20, 1, 21

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size, YesBtn.Position, YesBtn.Text = UDim2.new(0, 80, 0, 35), UDim2.new(0.1, 0, 0.6, 0), "はい"
YesBtn.BackgroundColor3, YesBtn.TextColor3, YesBtn.ZIndex = Color3.fromRGB(180, 50, 50), Color3.new(1, 1, 1), 21
Instance.new("UICorner", YesBtn)

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size, NoBtn.Position, NoBtn.Text = UDim2.new(0, 80, 0, 35), UDim2.new(0.55, 0, 0.6, 0), "いいえ"
NoBtn.BackgroundColor3, NoBtn.TextColor3, NoBtn.ZIndex = Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), 21
Instance.new("UICorner", NoBtn)

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Position, Title.Text = UDim2.new(1, -70, 0, 40), UDim2.new(0, 10, 0, 0), "まっぷhub"
Title.TextColor3, Title.Font, Title.TextSize, Title.BackgroundTransparency, Title.TextXAlignment = Color3.new(1, 1, 1), Enum.Font.SourceSansBold, 18, 1, Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size, MinBtn.Position, MinBtn.Text = UDim2.new(0, 25, 0, 25), UDim2.new(1, -60, 0, 7), "-"
MinBtn.BackgroundColor3, MinBtn.TextColor3 = Color3.fromRGB(40, 40, 40), Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size, CloseBtn.Position, CloseBtn.Text = UDim2.new(0, 25, 0, 25), UDim2.new(1, -30, 0, 7), "X"
CloseBtn.BackgroundColor3, CloseBtn.TextColor3 = Color3.fromRGB(80, 20, 20), Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size, Scroll.Position, Scroll.BackgroundTransparency = UDim2.new(1, -10, 1, -50), UDim2.new(0, 5, 0, 45), 1
Scroll.CanvasSize, Scroll.ScrollBarThickness = UDim2.new(0, 0, 0, 1300), 5

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding, UIList.HorizontalAlignment = UDim.new(0, 15), Enum.HorizontalAlignment.Center

local states = {fly = false, noclip = false, infJump = false, clickTp = false, esp = false, aimbot = false}
local values = {ws = 16, jp = 50, fs = 2}

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then dist, closest = mag, head end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if states.aimbot then
        local target = getClosestPlayer()
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
    end
end)

local function applyStats(hum)
    if not hum then return end
    hum.WalkSpeed, hum.UseJumpPower, hum.JumpPower, hum.JumpHeight = values.ws, true, values.jp, values.jp * 0.1
end

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    applyStats(hum)
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() hum.WalkSpeed = values.ws end)
end)

local bv, bg
RunService.Heartbeat:Connect(function()
    if player.Character then
        local hum, hrp = player.Character:FindFirstChild("Humanoid"), player.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if states.fly then
                hum.PlatformStand = true
                if not bv then bv = Instance.new("BodyVelocity", hrp) bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge) end
                if not bg then bg = Instance.new("BodyGyro", hrp) bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) end
                bg.CFrame = camera.CFrame
                bv.Velocity = (hum.MoveDirection.Magnitude > 0) and (camera.CFrame.LookVector * (values.fs * 20)) or Vector3.zero
            else
                if bv then bv:Destroy() bv = nil end
                if bg then bg:Destroy() bg = nil end
                if hum.PlatformStand then hum.PlatformStand = false end
            end
            if states.noclip or states.fly then
                for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end
    end
end)

local function createToggle(name, key)
    local frame = Instance.new("Frame", Scroll)
    frame.Size, frame.BackgroundTransparency = UDim2.new(0.9, 0, 0, 45), 1
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Text, label.TextColor3, label.BackgroundTransparency, label.TextXAlignment = UDim2.new(0.6, 0, 1, 0), name, Color3.new(1, 1, 1), 1, Enum.TextXAlignment.Left
    local bg_toggle = Instance.new("TextButton", frame)
    bg_toggle.Size, bg_toggle.Position, bg_toggle.BackgroundColor3, bg_toggle.Text = UDim2.new(0, 55, 0, 28), UDim2.new(1, -55, 0.5, -14), Color3.fromRGB(50, 50, 50), ""
    Instance.new("UICorner", bg_toggle).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", bg_toggle)
    circle.Size, circle.Position, circle.BackgroundColor3 = UDim2.new(0, 24, 0, 24), UDim2.new(0, 2, 0.5, -12), Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    bg_toggle.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = states[key] and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)}):Play()
        TweenService:Create(bg_toggle, TweenInfo.new(0.2), {BackgroundColor3 = states[key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)}):Play()
    end)
end

local function createSlider(name, min, max, def, key)
    local frame = Instance.new("Frame", Scroll)
    frame.Size, frame.BackgroundTransparency = UDim2.new(0.9, 0, 0, 60), 1
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Text, label.TextColor3, label.BackgroundTransparency = UDim2.new(1, 0, 0, 25), name..": "..def, Color3.new(0.8,0.8,0.8), 1
    local bar = Instance.new("Frame", frame)
    bar.Size, bar.Position, bar.BackgroundColor3 = UDim2.new(1, 0, 0, 10), UDim2.new(0, 0, 0, 35), Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", bar)
    local fill = Instance.new("Frame", bar)
    fill.Size, fill.BackgroundColor3 = UDim2.new((def-min)/(max-min), 0, 1, 0), Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", fill)
    local btn = Instance.new("TextButton", bar)
    btn.Size, btn.BackgroundTransparency, btn.Text = UDim2.new(1, 0, 1, 0), 1, ""
    local function update()
        local pos = math.clamp((UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        fill.Size, label.Text, values[key] = UDim2.new(pos, 0, 1, 0), name..": "..val, val
        if player.Character then applyStats(player.Character:FindFirstChild("Humanoid")) end
    end
    local dragging = false
    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputEnded:Connect(function() dragging = false end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update() end end)
end

local function createTPSection()
    local frame = Instance.new("Frame", Scroll)
    frame.Size, frame.BackgroundTransparency = UDim2.new(0.9, 0, 0, 85), 1
    local input = Instance.new("TextBox", frame)
    input.Size, input.PlaceholderText, input.Text = UDim2.new(1, 0, 0, 35), "プレイヤー名", ""
    input.BackgroundColor3, input.TextColor3 = Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1)
    Instance.new("UICorner", input)
    local btn = Instance.new("TextButton", frame)
    btn.Size, btn.Position, btn.Text = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 45), "Teleport"
    btn.BackgroundColor3, btn.TextColor3 = Color3.fromRGB(0, 120, 200), Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        local tName = input.Text:lower()
        if tName == "" then return end
        for _, p in pairs(Players:GetPlayers()) do
            if (p.Name:lower():sub(1, #tName) == tName or p.DisplayName:lower():sub(1, #tName) == tName) and p.Character then
                player.Character:MoveTo(p.Character:GetPrimaryPartCFrame().p)
                break
            end
        end
    end)
end

createToggle("Aimbot (Auto)", "aimbot")
createToggle("Fly", "fly")
createToggle("Noclip", "noclip")
createToggle("Infinite Jump", "infJump")
createToggle("Player ESP", "esp")
createSlider("WalkSpeed", 16, 200, 16, "ws")
createSlider("JumpPower", 50, 400, 50, "jp")
createSlider("FlySpeed", 1, 20, 2, "fs")
createTPSection()

MinBtn.MouseButton1Click:Connect(function()
    local isMin = Scroll.Visible
    Scroll.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 220, 0, 40) or UDim2.new(0, 220, 0, 500), "Out", "Quart", 0.3, true)
end)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)

RunService.RenderStepped:Connect(function()
    if states.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hl = p.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", p.Character)
                hl.Name, hl.FillColor, hl.Enabled = "ESPHighlight", Color3.new(1, 0, 0), true
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight.Enabled = false end end
    end
end)
UIS.JumpRequest:Connect(function() if states.infJump and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid:ChangeState("Jumping") end end)
