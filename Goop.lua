local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "FTAP_GOD_MENU"
sg.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 220, 0, 450)
main.Position = UDim2.new(0.8, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active, main.Draggable = true, true
main.Parent = sg
Instance.new("UICorner", main)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "⚡ FTAP GOD MODE ⚡"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main

local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0.9, 0, 0, 110)
listFrame.Position = UDim2.new(0.05, 0, 0, 40)
listFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
listFrame.BorderSizePixel = 0
listFrame.Parent = main
local uiList = Instance.new("UIListLayout", listFrame)

local spamInput = Instance.new("TextBox")
spamInput.Size = UDim2.new(0.9, 0, 0, 35)
spamInput.Position = UDim2.new(0.05, 0, 0, 160)
spamInput.Text = "GET FLUNG! LOL"
spamInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
spamInput.TextColor3 = Color3.new(1, 1, 1)
spamInput.Font = Enum.Font.SourceSans
spamInput.Parent = main
Instance.new("UICorner", spamInput)

local flingActive, antiGrabEnabled, spamEnabled, bypassEnabled = false, false, false, true
local currentTarget = nil

local function sayMessage(msg)
    if bypassEnabled then
        local s = {"!","?","*","^","."}
        msg = msg .. " [" .. s[math.random(1,#s)] .. tostring(math.random(10,99)) .. "]"
    end
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
    b.Font = Enum.Font.SourceSansBold
    b.Parent = main
    Instance.new("UICorner", b)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = text .. (active and ": ON" or ": OFF")
        b.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
        callback(active)
    end)
end

createToggle("ANTI-GRAB", 205, function(v) antiGrabEnabled = v end)
createToggle("FLING", 245, function(v) flingActive = v end)
createToggle("CHAT SPAM", 285, function(v) spamEnabled = v end)
createToggle("BYPASS", 325, function(v) bypassEnabled = v end)

local rBtn = Instance.new("TextButton")
rBtn.Size = UDim2.new(0.9, 0, 0, 35)
rBtn.Position = UDim2.new(0.05, 0, 0, 370)
rBtn.Text = "RELOAD LIST / RESET"
rBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
rBtn.TextColor3 = Color3.new(1, 1, 1)
rBtn.Parent = main
Instance.new("UICorner", rBtn)

local function updateList()
    for _, c in ipairs(listFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 22)
            b.Text = p.DisplayName
            b.BackgroundColor3 = (currentTarget == p) and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(35, 35, 35)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.BorderSizePixel = 0
            b.Parent = listFrame
            b.MouseButton1Click:Connect(function() currentTarget = p; updateList() end)
        end
    end
end

rBtn.MouseButton1Click:Connect(updateList)
updateList()

task.spawn(function()
    while true do
        task.wait(1.5)
        if spamEnabled and spamInput.Text ~= "" then sayMessage(spamInput.Text) end
    end
end)

RunService.Stepped:Connect(function()
    local char = player.Character
    if not char then return end
    if antiGrabEnabled then
        for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false end end
    end
    if flingActive and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = currentTarget.Character.HumanoidRootPart.CFrame
            hrp.Velocity = Vector3.new(0, 9000, 0)
            hrp.RotVelocity = Vector3.new(15000, 15000, 15000)
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
    end
end)
