local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "FTAP_FIXED_GOD"
sg.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 420)
main.Position = UDim2.new(0.8, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Parent = sg
Instance.new("UICorner", main)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Parent = main
Instance.new("UICorner", minBtn)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, 0)
content.BackgroundTransparency = 1
content.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "⚡ FTAP FIXED V3 ⚡"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = content

local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0.9, 0, 0, 100)
listFrame.Position = UDim2.new(0.05, 0, 0, 40)
listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
listFrame.BorderSizePixel = 0
listFrame.Parent = content
Instance.new("UIListLayout", listFrame)

local spamInput = Instance.new("TextBox")
spamInput.Size = UDim2.new(0.9, 0, 0, 35)
spamInput.Position = UDim2.new(0.05, 0, 0, 150)
spamInput.Text = "GET FLUNG! LOL"
spamInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spamInput.TextColor3 = Color3.new(1, 1, 1)
spamInput.Parent = content
Instance.new("UICorner", spamInput)

local flingActive, antiGrabEnabled, spamEnabled, bypassEnabled = false, false, false, true
local minimized = false
local currentTarget = nil

-- ドラッグ機能
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) dragging = false end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main:TweenSize(minimized and UDim2.new(0, 220, 0, 40) or UDim2.new(0, 220, 0, 420), "Out", "Quad", 0.3, true)
    content.Visible = not minimized
    minBtn.Text = minimized and "+" or "-"
end)

local function sayMessage(msg)
    if bypassEnabled then msg = msg .. " [" .. tostring(math.random(100,999)) .. "]" end
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

local function createToggle(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = text .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = content
    Instance.new("UICorner", b)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = text .. (active and ": ON" or ": OFF")
        b.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
        callback(active)
    end)
end

createToggle("ANTI-GRAB", 195, function(v) antiGrabEnabled = v end)
createToggle("FLING", 235, function(v) flingActive = v end)
createToggle("CHAT SPAM", 275, function(v) spamEnabled = v end)
createToggle("BYPASS", 315, function(v) bypassEnabled = v end)

local function updateList()
    for _, c in ipairs(listFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 25); b.Text = p.DisplayName; b.Parent = listFrame
            b.BackgroundColor3 = (currentTarget == p) and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(35, 35, 35)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.MouseButton1Click:Connect(function() currentTarget = p; updateList() end)
        end
    end
end
updateList()

task.spawn(function()
    while true do
        task.wait(1.5)
        if spamEnabled then sayMessage(spamInput.Text) end
    end
end)

RunService.PostSimulation:Connect(function()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart

    if antiGrabEnabled then
        for _, v in ipairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false end end
    end

    if flingActive and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local targetHrp = currentTarget.Character.HumanoidRootPart
        
        -- 自分の物理を相手にだけぶつける設定
        hrp.CFrame = targetHrp.CFrame
        hrp.Velocity = Vector3.new(20000, 20000, 20000) -- 極端な速度
        hrp.RotVelocity = Vector3.new(20000, 20000, 20000)
        
        -- 自分が吹き飛ばされないように速度を固定
        task.delay(0, function()
            if not flingActive then hrp.Velocity = Vector3.zero; hrp.RotVelocity = Vector3.zero end
        end)
    end
end)
