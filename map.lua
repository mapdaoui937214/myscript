local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MapHub_V26_FlyReturn"
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
Title.Text = " 🚀 MAPHUB V26 (Fly Pro)"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -55)
Scroll.Position = UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1300)
Scroll.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

local flySpeed, walkSpeed, jumpPower = 60, 16, 50
local flying, noclip, infJump, tracerEnabled = false, false, false, false
local tracers = {}

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

-- Fly & Cheat Functions
createToggle("Fly (CFrame Hybrid)", function(s) 
    flying = s 
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = s
        if not s then player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end
    end
end)

createToggle("Noclip", function(s) noclip = s end)
createToggle("Infinite Jump", function(s) infJump = s end)
createToggle("Tracer ESP", function(s) tracerEnabled = s end)

createSlider("WalkSpeed", 16, 300, 16, function(v) walkSpeed = v end)
createSlider("JumpPower", 50, 500, 50, function(v) jumpPower = v end)
createSlider("FlySpeed", 10, 500, 60, function(v) flySpeed = v end)

-- Main Logic Loop
RunService.Stepped:Connect(function(dt)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        
        if flying then
            hrp.Velocity = Vector3.new(0,0,0) -- 物理的な落下を阻止
            
            local moveVec = Vector3.new(0,0,0)
            local look = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            
            -- PC入力 & モバイルジョイスティック入力の検知
            if UIS:IsKeyDown(Enum.KeyCode.W) or hum.MoveDirection.Magnitude > 0 then
                moveVec = hum.MoveDirection -- ジョイスティックの方向を優先
            end
            
            -- 上昇（Space / Mobile Jump）
            if UIS:IsKeyDown(Enum.KeyCode.Space) or (UIS.JumpTouchInput and not UIS:GetFocusedTextBox()) then
                moveVec = moveVec + Vector3.new(0, 1, 0)
            end
            
            -- 下降（LeftControl）
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVec = moveVec + Vector3.new(0, -1, 0)
            end
            
            if moveVec.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (moveVec * flySpeed * dt)
            end
        end
        
        if noclip then
            for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local h = player.Character.Humanoid
        if not flying then h.WalkSpeed = walkSpeed end
        h.JumpPower = jumpPower
    end
    
    if tracerEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, screen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if not tracers[v] then tracers[v] = Drawing.new("Line") tracers[v].Thickness = 1 tracers[v].Color = Color3.fromRGB(0, 255, 200) end
                if screen then
                    tracers[v].From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                    tracers[v].To = Vector2.new(pos.X, pos.Y)
                    tracers[v].Visible = true
                else tracers[v].Visible = false end
            elseif tracers[v] then tracers[v].Visible = false end
        end
    else for _, l in pairs(tracers) do l.Visible = false end end
end)

UIS.JumpRequest:Connect(function() if infJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end end)

-- UI Toggle
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundTransparency = 1
local closed = false
CloseBtn.MouseButton1Click:Connect(function()
    closed = not closed
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = closed and UDim2.new(0, 240, 0, 45) or UDim2.new(0, 240, 0, 420)}):Play()
    CloseBtn.Text = closed and "+" or "X"
end)
