local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MapHub_V11_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 230, 0, 350)
Main.Position = UDim2.new(0.5, -115, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "📍 MapHub V11 [Final]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
Instance.new("UICorner", Title)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.Parent = Main

local flySpeed, walkSpeed, jumpPower = 60, 16, 50
local clickDelay = 0.05
local flying, noclip, infJump, tracerEnabled, autoClick, autoCollect, fullBright = false, false, false, false, false, false, false
local tracers = {}

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
        callback(state)
    end)
end

local function createSlider(text, yPos, minVal, maxVal, defaultVal, callback)
    local label = Instance.new("TextLabel", ScrollFrame)
    label.Size = UDim2.new(0.85, 0, 0, 20)
    label.Position = UDim2.new(0.075, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    local frame = Instance.new("Frame", ScrollFrame)
    frame.Size = UDim2.new(0.85, 0, 0, 6)
    frame.Position = UDim2.new(0.075, 0, 0, yPos + 25)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local dot = Instance.new("TextButton", frame)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new((defaultVal-minVal)/(maxVal-minVal), -7, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.Text = ""
    Instance.new("UICorner", dot)
    local drag = false
    dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local x = math.clamp((i.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
            dot.Position = UDim2.new(x, -7, 0.5, -7)
            local val = minVal + (x * (maxVal - minVal))
            if maxVal > 10 then val = math.floor(val) end
            label.Text = text .. ": " .. string.format("%.2f", val)
            callback(val)
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
end

createToggle("Auto Collect Items", 10, function(s)
    autoCollect = s
    task.spawn(function()
        while autoCollect do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchInterest") and v.Parent and v.Parent:IsA("BasePart") then
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

local hopBtn = Instance.new("TextButton", ScrollFrame)
hopBtn.Size = UDim2.new(0.85, 0, 0, 30)
hopBtn.Position = UDim2.new(0.075, 0, 0, 50)
hopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
hopBtn.Text = "Server Hop"
hopBtn.TextColor3 = Color3.new(1, 1, 1)
hopBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", hopBtn)
hopBtn.MouseButton1Click:Connect(function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(x.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)

createToggle("Auto Clicker", 90, function(s)
    autoClick = s
    task.spawn(function()
        while autoClick do
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0,0))
            task.wait(clickDelay)
        end
    end)
end)
createSlider("Click Delay", 130, 0.01, 1.0, 0.05, function(v) clickDelay = v end)

createToggle("Fullbright", 180, function(s)
    fullBright = s
    if s then Lighting.Ambient = Color3.new(1,1,1) Lighting.OutdoorAmbient = Color3.new(1,1,1) Lighting.Brightness = 2 end
end)

local tpInput = Instance.new("TextBox", ScrollFrame)
tpInput.Size = UDim2.new(0.85, 0, 0, 30)
tpInput.Position = UDim2.new(0.075, 0, 0, 220)
tpInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tpInput.PlaceholderText = "Target Player Name..."
tpInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", tpInput)

local tpBtn = Instance.new("TextButton", ScrollFrame)
tpBtn.Size = UDim2.new(0.85, 0, 0, 25)
tpBtn.Position = UDim2.new(0.075, 0, 0, 255)
tpBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 30)
tpBtn.Text = "Go to Player"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", tpBtn)
tpBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Name:lower():find(tpInput.Text:lower()) then
            player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
        end
    end
end)

createToggle("Fly (Camera)", 300, function(s)
    flying = s
    local char = player.Character
    if flying and char then
        local hrp, hum = char.HumanoidRootPart, char.Humanoid
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        hum.PlatformStand = true
        task.spawn(function()
            while flying do
                bv.Velocity = camera.CFrame.LookVector * (hum.MoveDirection.Magnitude * flySpeed)
                bg.CFrame = camera.CFrame
                task.wait()
            end
            bv:Destroy() bg:Destroy() hum.PlatformStand = false
        end)
    end
end)
createToggle("Noclip", 340, function(s) noclip = s end)
createToggle("Inf Jump", 380, function(s) infJump = s end)
createToggle("ESP Tracers", 420, function(s) tracerEnabled = s end)

createSlider("WalkSpeed", 470, 16, 300, 16, function(v) walkSpeed = v end)
createSlider("JumpPower", 520, 50, 500, 50, function(v) jumpPower = v end)
createSlider("FlySpeed", 570, 10, 500, 60, function(v) flySpeed = v end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if fullBright then Lighting.ClockTime = 14 end
end)

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local h = player.Character.Humanoid
        if not flying then h.WalkSpeed = walkSpeed end
        h.JumpPower = jumpPower
        h.UseJumpPower = true
    end
    if tracerEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if not tracers[v] then 
                    local l = Drawing.new("Line")
                    l.Color = Color3.new(1,1,1)
                    l.Thickness = 1
                    tracers[v] = l 
                end
                if onScreen then
                    tracers[v].From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    tracers[v].To = Vector2.new(pos.X, pos.Y)
                    tracers[v].Visible = true
                else tracers[v].Visible = false end
            elseif tracers[v] then tracers[v].Visible = false end
        end
    else
        for _, l in pairs(tracers) do l.Visible = false end
    end
end)

UIS.JumpRequest:Connect(function() if infJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end end)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.85, 0, 0, 5)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.BackgroundTransparency = 1
local min = false
MinBtn.MouseButton1Click:Connect(function()
    min = not min
    ScrollFrame.Visible = not min
    Main:TweenSize(min and UDim2.new(0, 230, 0, 40) or UDim2.new(0, 230, 0, 350), "Out", "Quad", 0.3, true)
    MinBtn.Text = min and "+" or "-"
end)
