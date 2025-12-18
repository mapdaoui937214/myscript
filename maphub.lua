local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MapHub_V19_Ultimate"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 230, 0, 400)
Main.Position = UDim2.new(0.5, -115, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "📍 MapHub V19 Ultimate"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -40)
Scroll.Position = UDim2.new(0, 0, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
Scroll.ScrollBarThickness = 3

local flySpeed, walkSpeed, jumpPower = 60, 16, 50
local flying, noclip, infJump, tracerEnabled, autoCollect, fullBright, chatSpy = false, false, false, false, false, false, false
local tracers = {}

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton", Scroll)
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
    local label = Instance.new("TextLabel", Scroll)
    label.Size = UDim2.new(0.85, 0, 0, 20)
    label.Position = UDim2.new(0.075, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.new(1, 1, 1)
    local frame = Instance.new("Frame", Scroll)
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
        if drag then
            local x = math.clamp((i.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
            dot.Position = UDim2.new(x, -7, 0.5, -7)
            local val = math.floor(minVal + (x * (maxVal - minVal)))
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
    UIS.InputEnded:Connect(function() drag = false end)
end

local Browser = Instance.new("Frame", ScreenGui)
Browser.Size = UDim2.new(0, 250, 0, 300)
Browser.Position = UDim2.new(0.5, 120, 0.4, 0)
Browser.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Browser.Visible = false
Instance.new("UICorner", Browser)

local BScroll = Instance.new("ScrollingFrame", Browser)
BScroll.Size = UDim2.new(1, -10, 1, -40)
BScroll.Position = UDim2.new(0, 5, 0, 35)
BScroll.BackgroundTransparency = 1
BScroll.ScrollBarThickness = 3

local function UpdateServers()
    for _, v in pairs(BScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local s = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=15"))
    local y = 0
    for _, v in pairs(s.data) do
        local region = (v.ping and v.ping < 50) and "🇯🇵 Japan/Asia" or "🌎 Overseas"
        local b = Instance.new("TextButton", BScroll)
        b.Size = UDim2.new(1, -5, 0, 45)
        b.Position = UDim2.new(0, 0, 0, y)
        b.Text = region .. "\nPing: " .. (v.ping or "??") .. " | Players: " .. v.playing .. "/" .. v.maxPlayers
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.MouseButton1Click:Connect(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id) end)
        y = y + 50
    end
    BScroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

local browserToggle = Instance.new("TextButton", Scroll)
browserToggle.Size = UDim2.new(0.85, 0, 0, 30)
browserToggle.Position = UDim2.new(0.075, 0, 0, 10)
browserToggle.Text = "🌐 Server Browser"
browserToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
browserToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", browserToggle)
browserToggle.MouseButton1Click:Connect(function() Browser.Visible = not Browser.Visible if Browser.Visible then UpdateServers() end end)

createToggle("Chat Spy (Private)", 50, function(s) chatSpy = s end)
local function spy(p, m)
    if chatSpy and p ~= player then
        StarterGui:SetCore("ChatMakeSystemMessage", {Text = "[SPY] "..p.DisplayName..": "..m, Color = Color3.new(1, 0.2, 0.2), Font = Enum.Font.SourceSansBold})
    end
end
for _, v in pairs(Players:GetPlayers()) do v.Chatted:Connect(function(m) spy(v, m) end) end
Players.PlayerAdded:Connect(function(v) v.Chatted:Connect(function(m) spy(v, m) end) end)

local bpIn = Instance.new("TextBox", Scroll)
bpIn.Size = UDim2.new(0.85, 0, 0, 30)
bpIn.Position = UDim2.new(0.075, 0, 0, 90)
bpIn.PlaceholderText = "Bypass Text..."
bpIn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bpIn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", bpIn)

local bpBtn = Instance.new("TextButton", Scroll)
bpBtn.Size = UDim2.new(0.85, 0, 0, 25)
bpBtn.Position = UDim2.new(0.075, 0, 0, 125)
bpBtn.Text = "Send Bypassed"
bpBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
bpBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", bpBtn)
bpBtn.MouseButton1Click:Connect(function()
    local t = ""
    for i=1, #bpIn.Text do t = t .. bpIn.Text:sub(i,i) .. " " end
    local r = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if r and r:FindFirstChild("SayMessageRequest") then
        r.SayMessageRequest:FireServer(t, "All")
    end
end)

createToggle("Fly (Full Movement)", 160, function(s)
    flying = s
    local char = player.Character
    if flying and char then
        local hrp, hum = char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("Humanoid")
        if hrp and hum then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            hum.PlatformStand = true
            task.spawn(function()
                while flying do
                    bv.Velocity = hum.MoveDirection * flySpeed + Vector3.new(0, 0.1, 0)
                    bg.CFrame = camera.CFrame
                    task.wait()
                end
                bv:Destroy() bg:Destroy() hum.PlatformStand = false
            end)
        end
    end
end)

createToggle("Auto Collect", 200, function(s)
    autoCollect = s
    task.spawn(function()
        while autoCollect do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchInterest") and v.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
            task.wait(0.5)
        end
    end)
end)

createToggle("Noclip", 240, function(s) noclip = s end)
createToggle("Inf Jump", 280, function(s) infJump = s end)
createToggle("Fullbright", 320, function(s) fullBright = s if s then Lighting.Ambient = Color3.new(1,1,1) end end)
createToggle("ESP Tracers", 360, function(s) tracerEnabled = s end)

local tpIn = Instance.new("TextBox", Scroll)
tpIn.Size = UDim2.new(0.85, 0, 0, 30)
tpIn.Position = UDim2.new(0.075, 0, 0, 400)
tpIn.PlaceholderText = "TP Target Player..."
tpIn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tpIn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", tpIn)

local tpBtn = Instance.new("TextButton", Scroll)
tpBtn.Size = UDim2.new(0.85, 0, 0, 25)
tpBtn.Position = UDim2.new(0.075, 0, 0, 435)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 30)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", tpBtn)
tpBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do 
        if v.Name:lower():find(tpIn.Text:lower()) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then 
            player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame 
        end 
    end
end)

createSlider("WalkSpeed", 480, 16, 300, 16, function(v) walkSpeed = v end)
createSlider("JumpPower", 530, 50, 500, 50, function(v) jumpPower = v end)
createSlider("FlySpeed", 580, 10, 500, 60, function(v) flySpeed = v end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    if fullBright then Lighting.ClockTime = 14 end
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
    Scroll.Visible = not min
    Main:TweenSize(min and UDim2.new(0, 230, 0, 40) or UDim2.new(0, 230, 0, 400), "Out", "Quad", 0.3, true)
    MinBtn.Text = min and "+" or "-"
end)
