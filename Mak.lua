local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local CORRECT_KEYS = {"maphub", "Maphub"}

local states = {
    fly = false, 
    noclip = false, 
    infJump = false, 
    clickTp = false, 
    esp = false,
    antiAfk = false,
    antiKick = false
}
local values = {ws = 16, jp = 50, fs = 2}

player.Idled:Connect(function()
    if states.antiAfk then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if (method == "Kick" or method == "kick") and states.antiKick then
        return nil
    end
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
KeyMain.Size = UDim2.new(0, 320, 0, 180)
KeyMain.Position = UDim2.new(0.5, -160, 0.5, -90)
KeyMain.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyMain.Active = true
KeyMain.Draggable = true
Instance.new("UICorner", KeyMain).CornerRadius = UDim.new(0, 12)

local KeyTitle = Instance.new("TextLabel", KeyMain)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "まっぷhub"
KeyTitle.TextColor3 = Color3.fromRGB(0, 180, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 22
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0, 240, 0, 40)
KeyInput.Position = UDim2.new(0.5, -120, 0.45, -20)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

local KeySubmit = Instance.new("TextButton", KeyMain)
KeySubmit.Size = UDim2.new(0, 120, 0, 35)
KeySubmit.Position = UDim2.new(0.5, -60, 0.75, 0)
KeySubmit.Text = "LOGIN"
KeySubmit.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
KeySubmit.TextColor3 = Color3.new(1, 1, 1)
KeySubmit.Font = Enum.Font.GothamBold
Instance.new("UICorner", KeySubmit).CornerRadius = UDim.new(0, 8)

KeySubmit.MouseButton1Click:Connect(function()
    local found = false
    for _, k in pairs(CORRECT_KEYS) do if KeyInput.Text == k then found = true break end end
    if found then
        KeyGui:Destroy()
        ScreenGui.Enabled = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Invalid Key"
        task.delay(1.5, function() if KeyInput then KeyInput.PlaceholderText = "Enter Key..." end end)
    end
end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 480)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Glow = Instance.new("Frame", Main)
Glow.Size = UDim2.new(1, 4, 1, 4)
Glow.Position = UDim2.new(0, -2, 0, -2)
Glow.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
Glow.ZIndex = 0
Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "MAPPU HUB"
Title.TextColor3 = Color3.fromRGB(0, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0.5, -15)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -55)
Scroll.Position = UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 900)
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function applyStats(hum)
    if not hum then return end
    hum.WalkSpeed = values.ws
    hum.UseJumpPower = true
    hum.JumpPower = values.jp
end

local function setupCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    applyStats(hum)
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function() hum.WalkSpeed = values.ws end)
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

local bv, bg
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
        local hum, hrp = player.Character.Humanoid, player.Character.HumanoidRootPart
        if states.fly then
            hum.PlatformStand = true
            if not bv then bv = Instance.new("BodyVelocity", hrp) bv.MaxForce = Vector3.new(1e6,1e6,1e6) end
            if not bg then bg = Instance.new("BodyGyro", hrp) bg.MaxTorque = Vector3.new(1e6,1e6,1e6) end
            bg.CFrame = camera.CFrame
            bv.Velocity = (hum.MoveDirection.Magnitude > 0) and (camera.CFrame:VectorToWorldSpace(camera.CFrame:VectorToObjectSpace(hum.MoveDirection)) * (values.fs * 25)) or Vector3.zero
        else
            if bv then bv:Destroy() bv = nil end
            if bg then bg:Destroy() bg = nil end
            hum.PlatformStand = false
        end
        if states.noclip or states.fly then
            for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hl = p.Character:FindFirstChild("HubESP")
            if states.esp then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "HubESP"
                    hl.FillColor = Color3.fromRGB(0, 180, 255)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                end
            elseif hl then hl:Destroy() end
        end
    end
end

RunService.RenderStepped:Connect(function() if states.esp then updateESP() end end)
UIS.JumpRequest:Connect(function() if states.infJump and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid:ChangeState("Jumping") end end)
mouse.Button1Down:Connect(function() if states.clickTp and player.Character then player.Character:MoveTo(mouse.Hit.p) end end)

local function createToggle(name, key)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 4, 0.6, 0)
    indicator.Position = UDim2.new(1, -8, 0.2, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Instance.new("UICorner", indicator)

    btn.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = states[key] and Color3.new(1, 1, 1) or Color3.fromRGB(180, 180, 180)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = states[key] and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(50, 50, 55)}):Play()
    end)
end

local function createSlider(name, min, max, def, key)
    local frame = Instance.new("Frame", Scroll)
    frame.Size = UDim2.new(0.9, 0, 0, 55)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = name .. ": " .. def
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, 0, 0, 6)
    container.Position = UDim2.new(0, 0, 0, 30)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", container)

    local fill = Instance.new("Frame", container)
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    Instance.new("UICorner", fill)

    local drag = Instance.new("TextButton", container)
    drag.Size = UDim2.new(1, 0, 1, 0)
    drag.BackgroundTransparency = 1
    drag.Text = ""

    local function update()
        local pos = math.clamp((UIS:GetMouseLocation().X - container.AbsolutePosition.X) / container.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = name .. ": " .. val
        values[key] = val
        if player.Character then applyStats(player.Character:FindFirstChild("Humanoid")) end
    end
    
    local active = false
    drag.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then active = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then active = false end end)
    UIS.InputChanged:Connect(function(i) if active and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update() end end)
end

createToggle("Anti-Kick", "antiKick")
createToggle("Anti-AFK", "antiAfk")
createToggle("fly", "fly")
createToggle("Noclip", "noclip")
createToggle("Infinite Jump", "infJump")
createToggle("Visual ESP", "esp")
createToggle("Click Teleport", "clickTp")
createSlider("WalkSpeed", 16, 300, 16, "ws")
createSlider("JumpPower", 50, 600, 50, "jp")
createSlider("FlySpeed", 1, 50, 2, "fs")

local TpFrame = Instance.new("Frame", Scroll)
TpFrame.Size = UDim2.new(0.9, 0, 0, 80)
TpFrame.BackgroundTransparency = 1
local Inp = Instance.new("TextBox", TpFrame)
Inp.Size = UDim2.new(1, 0, 0, 35)
Inp.PlaceholderText = "Player Name..."
Inp.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Inp.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Inp)
local TpBtn = Instance.new("TextButton", TpFrame)
TpBtn.Size = UDim2.new(1, 0, 0, 35)
TpBtn.Position = UDim2.new(0, 0, 0, 42)
TpBtn.Text = "TELEPORT"
TpBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
TpBtn.TextColor3 = Color3.new(1, 1, 1)
TpBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", TpBtn)

TpBtn.MouseButton1Click:Connect(function()
    local target = Inp.Text:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1,#target) == target or p.DisplayName:lower():sub(1,#target) == target then
            if p.Character and player.Character then player.Character:MoveTo(p.Character:GetPrimaryPartCFrame().p) end
            break
        end
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    local isMin = Scroll.Visible
    Scroll.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 240, 0, 45) or UDim2.new(0, 240, 0, 480), "Out", "Quart", 0.3, true)
end)

local Conf = Instance.new("Frame", ScreenGui)
Conf.Size = UDim2.new(0, 200, 0, 100)
Conf.Position = UDim2.new(0.5, -100, 0.5, -50)
Conf.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Conf.Visible = false
Instance.new("UICorner", Conf)
local ConfT = Instance.new("TextLabel", Conf)
ConfT.Size = UDim2.new(1, 0, 0.6, 0)
ConfT.Text = "Close Hub?"
ConfT.TextColor3 = Color3.new(1, 1, 1)
ConfT.BackgroundTransparency = 1
local Y = Instance.new("TextButton", Conf)
Y.Size = UDim2.new(0.4, 0, 0.3, 0)
Y.Position = UDim2.new(0.08, 0, 0.6, 0)
Y.Text = "Yes"
Y.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Y.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Y)
local N = Instance.new("TextButton", Conf)
N.Size = UDim2.new(0.4, 0, 0.3, 0)
N.Position = UDim2.new(0.52, 0, 0.6, 0)
N.Text = "No"
N.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
N.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", N)

CloseBtn.MouseButton1Click:Connect(function() Conf.Visible = true end)
Y.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
N.MouseButton1Click:Connect(function() Conf.Visible = false end)
