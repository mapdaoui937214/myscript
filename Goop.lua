local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "FTAP_ULTIMATE_FINAL"
sg.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 420)
main.Position = UDim2.new(0.8, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Parent = sg
local corner = Instance.new("UICorner", main)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = main
Instance.new("UICorner", minBtn)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, 0)
content.BackgroundTransparency = 1
content.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "⚡ FTAP GOD V3 ⚡"
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
local uiList = Instance.new("UIListLayout", listFrame)

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

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main:TweenSize(UDim2.new(0, 220, 0, 40), "Out", "Quad", 0.3, true)
        content.Visible = false
        minBtn.Text = "+"
    else
        main:TweenSize(UDim2.new(0, 220, 0, 420), "Out", "Quad", 0.3, true)
        content.Visible = true
        minBtn.Text = "-"
    end
end)

local function sayMessage(msg)
    if bypassEnabled then msg = msg .. " [" .. tostring(math.random(100,999)) .. "]" end
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels.RBXGeneral
        channel:SendAsync(msg)
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
    b.Font = Enum.Font.SourceSansBold
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
            b.Size = UDim2.new(1, 0, 0, 25)
            b.Text = p.DisplayName
            b.BackgroundColor3 = (currentTarget == p) and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(35, 35, 35)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Parent = listFrame
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

RunService.Stepped:Connect(function()
    if not player.Character then return end
    if antiGrabEnabled then
        for _, v in ipairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false end end
    end
    if flingActive and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = currentTarget.Character.HumanoidRootPart.CFrame
            hrp.Velocity = Vector3.new(0, 9999, 0)
            hrp.RotVelocity = Vector3.new(15000, 15000, 15000)
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end
end)
