local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local CORRECT_KEYS = {"China", "china", "CHINA"}

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

local ThemeRed = Color3.fromRGB(170, 0, 0)
local ThemeDarkRed = Color3.fromRGB(100, 0, 0)
local ThemeGold = Color3.fromRGB(255, 215, 0)
local ThemeBlack = Color3.fromRGB(15, 15, 15)

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

if CoreGui:FindFirstChild("ChinaHubGui") then CoreGui.ChinaHubGui:Destroy() end
if CoreGui:FindFirstChild("KeySystem") then CoreGui.KeySystem:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ChinaHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false

local KeyGui = Instance.new("ScreenGui", CoreGui)
KeyGui.Name = "KeySystem"

local KeyMain = Instance.new("Frame", KeyGui)
KeyMain.Size = UDim2.new(0, 300, 0, 160)
KeyMain.Position = UDim2.new(0.5, -150, 0.5, -80)
KeyMain.BackgroundColor3 = ThemeRed
KeyMain.Active = true
KeyMain.Draggable = true
Instance.new("UICorner", KeyMain)
Instance.new("UIStroke", KeyMain).Color = ThemeGold

local KeyTitle = Instance.new("TextLabel", KeyMain)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "China hub - キーシステム"
KeyTitle.TextColor3 = ThemeGold
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 20
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyMain)
KeyInput.Size = UDim2.new(0, 240, 0, 35)
KeyInput.Position = UDim2.new(0.5, -120, 0.45, 0)
KeyInput.PlaceholderText = "キーを入力してください"
KeyInput.Text = ""
KeyInput.BackgroundColor3 = ThemeDarkRed
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.PlaceholderColor3 = Color3.fromRGB(200, 150, 150)
Instance.new("UICorner", KeyInput)

local KeySubmit = Instance.new("TextButton", KeyMain)
KeySubmit.Size = UDim2.new(0, 120, 0, 35)
KeySubmit.Position = UDim2.new(0.5, -60, 0.75, 5)
KeySubmit.Text = "ログイン"
KeySubmit.BackgroundColor3 = ThemeGold
KeySubmit.TextColor3 = ThemeRed
KeySubmit.Font = Enum.Font.GothamBold
Instance.new("UICorner", KeySubmit)

KeySubmit.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    local found = false
    for _, k in pairs(CORRECT_KEYS) do if input == k then found = true break end end
    if found then
        KeyGui:Destroy()
        ScreenGui.Enabled = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "キーが違います"
        task.delay(1.5, function() if KeyInput then KeyInput.PlaceholderText = "キーを入力してください" end end)
    end
end)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 520)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = ThemeBlack
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = ThemeRed

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = ThemeRed
Instance.new("UICorner", TopBar)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "CHINA HUB ★"
Title.TextColor3 = ThemeGold
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -60, 0.5, -12)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = ThemeDarkRed
MinBtn.TextColor3 = ThemeGold
Instance.new("UICorner", MinBtn)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseBtn.TextColor3 = ThemeGold
Instance.new("UICorner", CloseBtn)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = ThemeGold

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function applyStats(hum)
    if not hum then return end
    hum.WalkSpeed = values.ws
    hum.JumpPower = values.jp
    hum.UseJumpPower = true
end

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    applyStats(hum)
end)

local function getMoveDirection()
    local dir = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
    return dir.Unit
end

RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid

        if states.fly then
            hum.PlatformStand = true
            local bv = hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", hrp)
            local bg = hrp:FindFirstChild("FlyBG") or Instance.new("BodyGyro", hrp)
            bv.Name = "FlyBV"
            bg.Name = "FlyBG"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            bg.CFrame = camera.CFrame
            
            local dir = getMoveDirection()
            if dir.Magnitude > 0 then
                bv.Velocity = dir * (values.fs * 50)
            else
                bv.Velocity = Vector3.zero
            end
        else
            if hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
            if hrp:FindFirstChild("FlyBG") then hrp.FlyBG:Destroy() end
            hum.PlatformStand = false
        end

        if states.noclip or states.fly then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
end)

local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hl = p.Character:FindFirstChild("ChinaESP")
            if states.esp then
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "ChinaESP"
                    hl.FillColor = ThemeRed
                    hl.OutlineColor = ThemeGold
                end
            elseif hl then hl:Destroy() end
        end
    end
end

RunService.RenderStepped:Connect(function() 
    if states.esp then updateESP() end 
end)

UIS.JumpRequest:Connect(function() 
    if states.infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then 
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") 
    end 
end)

mouse.Button1Down:Connect(function() 
    if states.clickTp and player.Character then 
        player.Character:MoveTo(mouse.Hit.p) 
    end 
end)

local function createToggle(name, key)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    Instance.new("UIStroke", btn).Color = ThemeDarkRed

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 10, 0, 10)
    indicator.Position = UDim2.new(1, -20, 0.5, -5)
    indicator.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    Instance.new("UICorner", indicator)

    btn.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = states[key] and ThemeGold or Color3.fromRGB(200, 200, 200)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = states[key] and ThemeGold or Color3.fromRGB(60, 0, 0)}):Play()
    end)
end

local function createSlider(name, min, max, def, key)
    local frame = Instance.new("Frame", Scroll)
    frame.Size, frame.BackgroundTransparency = UDim2.new(0.9, 0, 0, 50), 1
    local label = Instance.new("TextLabel", frame)
    label.Size, label.Text, label.TextColor3 = UDim2.new(1, 0, 0, 20), name..": "..def, ThemeGold
    label.Font, label.TextSize, label.BackgroundTransparency = Enum.Font.Gotham, 12, 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local bar = Instance.new("Frame", frame)
    bar.Size, bar.Position, bar.BackgroundColor3 = UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 0, 30), Color3.fromRGB(50, 0, 0)
    Instance.new("UICorner", bar)
    
    local fill = Instance.new("Frame", bar)
    fill.Size, fill.BackgroundColor3 = UDim2.new((def-min)/(max-min), 0, 1, 0), ThemeGold
    Instance.new("UICorner", fill)
    
    local btn = Instance.new("TextButton", bar)
    btn.Size, btn.BackgroundTransparency, btn.Text = UDim2.new(1, 0, 1, 0), 1, ""
    
    local dragging = false
    local function update()
        local mousePos = UIS:GetMouseLocation().X
        local barPos = bar.AbsolutePosition.X
        local barSize = bar.AbsoluteSize.X
        local relativePos = math.clamp((mousePos - barPos) / barSize, 0, 1)
        local val = math.floor(min + (relativePos * (max - min)))
        
        fill.Size = UDim2.new(relativePos, 0, 1, 0)
        label.Text = name..": "..val
        values[key] = val
        if player.Character then applyStats(player.Character:FindFirstChildOfClass("Humanoid")) end
    end
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
    end)
end

createToggle("キック防止", "antiKick")
createToggle("放置防止", "antiAfk")
createToggle("飛行 (Fly)", "fly")
createToggle("壁抜け (Noclip)", "noclip")
createToggle("無限ジャンプ", "infJump")
createToggle("プレイヤー透視 (ESP)", "esp")
createToggle("クリックテレポート", "clickTp")
createSlider("歩行速度", 16, 250, 16, "ws")
createSlider("ジャンプ力", 50, 500, 50, "jp")
createSlider("飛行速度", 1, 20, 2, "fs")

local tpF = Instance.new("Frame", Scroll)
tpF.Size, tpF.BackgroundTransparency = UDim2.new(0.9, 0, 0, 70), 1
local tpinp = Instance.new("TextBox", tpF)
tpinp.Size, tpinp.PlaceholderText = UDim2.new(1, 0, 0, 30), "プレイヤー名..."
tpinp.BackgroundColor3, tpinp.TextColor3 = Color3.fromRGB(40, 0, 0), Color3.new(1, 1, 1)
Instance.new("UICorner", tpinp)
local tpb = Instance.new("TextButton", tpF)
tpb.Size, tpb.Position, tpb.Text = UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 35), "テレポート"
tpb.BackgroundColor3, tpb.TextColor3 = ThemeRed, ThemeGold
Instance.new("UICorner", tpb)
tpb.MouseButton1Click:Connect(function()
    local t = tpinp.Text:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1,#t) == t or p.DisplayName:lower():sub(1,#t) == t then
            if p.Character and player.Character then player.Character:MoveTo(p.Character:GetPrimaryPartCFrame().p) end
            break
        end
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    local isMin = Scroll.Visible
    Scroll.Visible = not isMin
    Main:TweenSize(isMin and UDim2.new(0, 220, 0, 40) or UDim2.new(0, 220, 0, 520), "Out", "Quart", 0.3, true)
end)

local Conf = Instance.new("Frame", ScreenGui)
Conf.Size, Conf.Position, Conf.BackgroundColor3, Conf.Visible = UDim2.new(0, 200, 0, 100), UDim2.new(0.5, -100, 0.5, -50), ThemeBlack, false
Instance.new("UICorner", Conf)
Instance.new("UIStroke", Conf).Color = ThemeRed
local ConfT = Instance.new("TextLabel", Conf)
ConfT.Size, ConfT.Text, ConfT.TextColor3, ConfT.BackgroundTransparency = UDim2.new(1, 0, 0.6, 0), "終了しますか？", Color3.new(1, 1, 1), 1
local Y = Instance.new("TextButton", Conf)
Y.Size, Y.Position, Y.Text, Y.BackgroundColor3 = UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0.08, 0, 0.6, 0), "はい", ThemeRed
local N = Instance.new("TextButton", Conf)
N.Size, N.Position, N.Text, N.BackgroundColor3 = UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0.52, 0, 0.6, 0), "いいえ", Color3.fromRGB(50, 50, 50)
CloseBtn.MouseButton1Click:Connect(function() Conf.Visible = true end)
Y.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
N.MouseButton1Click:Connect(function() Conf.Visible = false end)
