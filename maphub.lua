local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "MapHub_V21_Final_Neon"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 380)
Main.Position = UDim2.new(0.5, -120, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 200)
Stroke.Thickness = 2
Stroke.Transparency = 0.5

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = " 🚀 MAPHUB V21"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -55)
Scroll.Position = UDim2.new(0, 5, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)

local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)

local flySpeed, walkSpeed, jumpPower = 60, 16, 50
local flying, noclip, infJump, tracerEnabled, chatSpy, autoCollect, fullBright = false, false, false, false, false, false, false
local tracers = {}

local function createToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    local Ind = Instance.new("Frame", btn)
    Ind.Size = UDim2.new(0, 10, 0, 10)
    Ind.Position = UDim2.new(1, -25, 0.5, -5)
    Ind.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
    local s = false
    btn.MouseButton1Click:Connect(function()
        s = not s
        callback(s)
        TweenService:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 30, 30)}):Play()
    end)
end

local Browser = Instance.new("Frame", ScreenGui)
Browser.Size = UDim2.new(0, 250, 0, 300)
Browser.Position = UDim2.new(0.5, 130, 0.4, 0)
Browser.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Browser.Visible = false
Instance.new("UICorner", Browser)
local BTitle = Instance.new("TextLabel", Browser)
BTitle.Size = UDim2.new(1,0,0,30)
BTitle.Text = "Server Browser"
BTitle.TextColor3 = Color3.new(1,1,1)
BTitle.BackgroundColor3 = Color3.fromRGB(40,40,40)
local BScroll = Instance.new("ScrollingFrame", Browser)
BScroll.Size = UDim2.new(1, -10, 1, -40)
BScroll.Position = UDim2.new(0, 5, 0, 35)
BScroll.BackgroundTransparency = 1
BScroll.CanvasSize = UDim2.new(0,0,0,0)

local function UpdateServers()
    for _, v in pairs(BScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local s = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=15"))
    local y = 0
    for _, v in pairs(s.data) do
        local reg = (v.ping and v.ping < 50) and "🇯🇵 Japan" or "🌎 Int"
        local b = Instance.new("TextButton", BScroll)
        b.Size = UDim2.new(1, -5, 0, 40)
        b.Position = UDim2.new(0, 0, 0, y)
        b.Text = reg .. " | " .. v.playing .. "/" .. v.maxPlayers .. " | Ping: " .. (v.ping or "?")
        b.BackgroundColor3 = Color3.fromRGB(50,50,50)
        b.TextColor3 = Color3.new(1,1,1)
        b.MouseButton1Click:Connect(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id) end)
        y = y + 45
    end
    BScroll.CanvasSize = UDim2.new(0,0,0,y)
end

createToggle("Server Browser", function(s) Browser.Visible = s if s then UpdateServers() end end)
createToggle("Mobile Fly (CFrame)", function(s) flying = s if player.Character then player.Character.Humanoid.PlatformStand = s end end)
createToggle("Noclip", function(s) noclip = s end)
createToggle("Inf Jump", function(s) infJump = s end)
createToggle("Auto Collect", function(s) 
    autoCollect = s 
    task.spawn(function()
        while autoCollect do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchInterest") and player.Character then
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
            task.wait(0.5)
        end
    end)
end)
createToggle("ESP Tracers", function(s) tracerEnabled = s end)
createToggle("Fullbright", function(s) fullBright = s end)
createToggle("Chat Spy", function(s) chatSpy = s end)

local bpIn = Instance.new("TextBox", Scroll)
bpIn.Size = UDim2.new(0.95, 0, 0, 30)
bpIn.PlaceholderText = "Bypass Chat..."
bpIn.BackgroundColor3 = Color3.fromRGB(40,40,40)
bpIn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", bpIn)

local bpBtn = Instance.new("TextButton", Scroll)
bpBtn.Size = UDim2.new(0.95, 0, 0, 30)
bpBtn.Text = "Send Bypass"
bpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 80)
bpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", bpBtn)
bpBtn.MouseButton1Click:Connect(function()
    local t = ""
    for i=1, #bpIn.Text do t = t .. bpIn.Text:sub(i,i) .. " " end
    local r = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if r then r.SayMessageRequest:FireServer(t, "All") end
end)

RunService.Stepped:Connect(function(dt)
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        local vel = hum.MoveDirection * flySpeed
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:GetFocusedTextBox() == nil and UIS.JumpTouchInput then
            vel = vel + Vector3.new(0, flySpeed, 0)
        end
        hrp.CFrame = hrp.CFrame + (vel * dt)
        hrp.Velocity = Vector3.new(0, 0.1, 0)
    end
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
    if fullBright then Lighting.Ambient = Color3.new(1,1,1) Lighting.ClockTime = 14 end
end)

RunService.RenderStepped:Connect(function()
    if tracerEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, screen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if not tracers[v] then tracers[v] = Drawing.new("Line") tracers[v].Thickness = 1 tracers[v].Color = Color3.new(1,1,1) end
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

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundTransparency = 1
local closed = false
CloseBtn.MouseButton1Click:Connect(function()
    closed = not closed
    TweenService:Create(Main, TweenInfo.new(0.3), {Size = closed and UDim2.new(0, 240, 0, 45) or UDim2.new(0, 240, 0, 380)}):Play()
    CloseBtn.Text = closed and "+" or "X"
end)

local function onChat(p, m) if chatSpy and p ~= player then StarterGui:SetCore("ChatMakeSystemMessage", {Text = "[🕵️] "..p.DisplayName..": "..m, Color = Color3.fromRGB(0, 255, 200)}) end end
Players.PlayerAdded:Connect(function(v) v.Chatted:Connect(function(m) onChat(v, m) end) end)
for _, v in pairs(Players:GetPlayers()) do v.Chatted:Connect(function(m) onChat(v, m) end) end
