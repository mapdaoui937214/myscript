local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local CORRECT_KEYS = {"maphub", "Maphub"}

if CoreGui:FindFirstChild("MappuHub") then CoreGui.MappuHub:Destroy() end
if CoreGui:FindFirstChild("KeySystem") then CoreGui.KeySystem:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MappuHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false

local KeyGui = Instance.new("ScreenGui", CoreGui)
KeyGui.Name = "KeySystem"

local KeyMain = Instance.new("Frame", KeyGui)
KeyMain.Size = UDim2.new(0, 300, 0, 150)
KeyMain.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyMain.Active = true
KeyMain.Draggable = true
Instance.new("UICorner", KeyMain)

local KeyTitle = Instance.new("TextLabel", KeyMain)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Text = "まっぷhub - Key System"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextSize = 20
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0, 220, 0, 35)
KeyInput.Position = UDim2.new(0.5, -110, 0.4, 0)
KeyInput.PlaceholderText = "Keyを入力してください"
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", KeyInput)

local KeySubmit = Instance.new("TextButton", KeyMain)
KeySubmit.Size = UDim2.new(0, 100, 0, 30)
KeySubmit.Position = UDim2.new(0.5, -50, 0.75, 0)
KeySubmit.Text = "送信"
KeySubmit.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
KeySubmit.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", KeySubmit)

KeySubmit.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    local found = false
    for _, k in pairs(CORRECT_KEYS) do
        if input == k then found = true break end
    end
    if found then
        KeyGui:Destroy()
        ScreenGui.Enabled = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Keyが違います。"
        KeyInput.PlaceholderColor3 = Color3.new(1, 0, 0)
        task.delay(1.5, function()
            if KeyInput then
                KeyInput.PlaceholderText = "Keyを入力してください"
                KeyInput.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
            end
        end)
    end
end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 520)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
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
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
Scroll.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 12)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local states = {fly = false, noclip = false, infJump = false, clickTp = false, esp = false, spam = false}
local values = {ws = 16, jp = 50, fs = 2, spamMsg = "まっぷhub top!"}

local function applyStats(hum)
    if not hum then return end
    hum.WalkSpeed = values.ws
    hum.UseJumpPower = true
    hum.JumpPower = values.jp
    hum.JumpHeight = values.jp * 0.1
end

local function setupCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() hum.WalkSpeed = values.ws end)
    hum:GetPropertyChangedSignal("JumpPower"):Connect(function() hum.JumpPower = values.jp end)
    hum:GetPropertyChangedSignal("JumpHeight"):Connect(function() hum.JumpHeight = values.jp * 0.1 end)
    hum:GetPropertyChangedSignal("UseJumpPower"):Connect(function() hum.UseJumpPower = true end)
    applyStats(hum)
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

local bv, bg
RunService.Heartbeat:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChild("Humanoid")
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if states.fly then
                hum.PlatformStand = true
                if not bv then bv = Instance.new("BodyVelocity", hrp) bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge) end
                if not bg then bg = Instance.new("BodyGyro", hrp) bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) end
                bg.CFrame = camera.CFrame
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local camCF = camera.CFrame
                    local relativeMove = camCF:VectorToObjectSpace(moveDir)
                    local flyDir = (camCF.LookVector * -relativeMove.Z) + (camCF.RightVector * relativeMove.X)
                    bv.Velocity = flyDir * (values.fs * 20)
                else
                    bv.Velocity = Vector3.zero
                end
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
    local bg_toggle = Instance.new("TextButton", frame)
    bg_toggle.Size, bg_toggle.Position, bg_toggle.BackgroundColor3, bg_toggle.Text = UDim2.new(0, 45, 0, 22), UDim2.new(1, -45, 0.5, -11), Color3.fromRGB(50, 50, 50), ""
    Instance.new("UICorner", bg_toggle).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", bg_toggle)
    circle.Size, circle.Position, circle.BackgroundColor3 = UDim2.new(0, 18, 0, 18), UDim2.new(0, 2, 0.5, -9), Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    bg_toggle.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = states[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        TweenService:Create(bg_toggle, TweenInfo.new(0.2), {BackgroundColor3 = states[key] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)}):Play()
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
        if player.Character then applyStats(player.Character:FindFirstChild("Humanoid")) end
    end
    local dragging = false
    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputEnded:Connect(function() dragging = false end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update() end end)
end

local function createSpamSection()
    local frame = Instance.new("Frame", Scroll)
    frame.Size, frame.BackgroundTransparency = UDim2.new(0.9, 0, 0, 75), 1
    local input = Instance.new("TextBox", frame)
    input.Size, input.PlaceholderText, input.Text = UDim2.new(1, 0, 0, 30), "スパム内容を入力", values.spamMsg
    input.BackgroundColor3, input.TextColor3, input.Font, input.TextSize = Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), Enum.Font.SourceSans, 14
    Instance.new("UICorner", input)
    input:GetPropertyChangedSignal("Text"):Connect(function() values.spamMsg = input.Text end)
    local btn = Instance.new("TextButton", frame)
    btn.Size, btn.Position, btn.Text = UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 40), "Chat Spam: OFF"
    btn.BackgroundColor3, btn.TextColor3, btn.Font, btn.TextSize = Color3.fromRGB(50, 50, 50), Color3.new(1, 1, 1), Enum.Font.SourceSansBold, 16
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        states.spam = not states.spam
        btn.Text = states.spam and "Chat Spam: ON" or "Chat Spam: OFF"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = states.spam and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 50, 50)}):Play()
        if states.spam then
            task.spawn(function()
                while states.spam do
                    local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("SayMessageRequest", true) 
                    if chatEvent then chatEvent:FireServer(values.spamMsg, "All") end
                    task.wait(1.2)
                end
            end)
        end
    end)
end

createToggle("Fly", "fly")
createToggle("Noclip", "noclip")
createToggle("Infinite Jump", "infJump")
createToggle("Player ESP", "esp")
createToggle("Click Teleport", "clickTp")
createSlider("WalkSpeed", 16, 250, 16, "ws")
createSlider("JumpPower", 50, 500, 50, "jp")
createSlider("FlySpeed", 1, 20, 2, "fs")
createSpamSection()

MinBtn.MouseButton1Click:Connect(function()
    local isMin = Scroll.Visible
    Scroll.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 200, 0, 40) or UDim2.new(0, 200, 0, 520), "Out", "Quart", 0.3, true)
end)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
YesBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
