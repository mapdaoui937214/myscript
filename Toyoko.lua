--[[
    ⚡ まっぷhub - 🧊 Minimalist Compact Edition
    Features: Multi-TeleDrop, AutoCollect, Commander, Minimize System
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--=== 共通状態 ===--
local autoEnabled = false
local targetName = nil
local character, humanoidRoot
local fallen, running, falling = false, true, false
local multiTargets, currentIndex, multiMode = {}, 1, false
local lastNearTargets, lastFallTime = {}, 0
local commanderName = nil

--=== 設定値 ===--
local TELEPORT_SPEED = 0.005
local DROP_DELAY = 0.006
local BACK_OFFSET = -7.5
local FALL_DISTANCE = 2.5
local VOID_Y = -500
local FALL_TIME = 0.15
local NEAR_DISTANCE = 2.5
local NEAR_REQUIRED = 2

--- 🛠️ ユーティリティ関数 ---
local function getotaku()
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("otaku") then return tool end
    end
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("otaku") then return tool end
    end
    return nil
end

local function dropotakuAt(pos)
    local kap = getotaku()
    if not kap then return false end
    kap.Parent = player.Character
    task.wait(0.05)
    local handle = kap:FindFirstChild("Handle")
    if not handle then return false end
    kap.Parent = workspace
    handle.Anchored, handle.CanCollide = false, true
    handle.Velocity = Vector3.zero
    handle.CFrame = CFrame.new(pos + Vector3.new(0,0.5,0))
    return true
end

local function fallToVoid(y, fallTime)
    if falling or not humanoidRoot then return end
    falling = true
    local startPos = humanoidRoot.Position
    local startTime = tick()
    while tick()-startTime < fallTime do
        local alpha = (tick()-startTime)/fallTime
        humanoidRoot.CFrame = CFrame.new(startPos:Lerp(Vector3.new(startPos.X, y, startPos.Z), alpha))
        task.wait()
    end
    falling = false
end

--- 🎨 GUI構築 (最小化対応) ---
local gui = Instance.new("ScreenGui")
gui.Name = "MapHub_Compact"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- メインコンテナ
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 420)
mainFrame.Position = UDim2.new(0.8, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

-- 最小化ボタン
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -30, 0, 5)
minBtn.Text = "_"
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

minBtn.MouseButton1Click:Connect(function()
    contentFrame.Visible = not contentFrame.Visible
    mainFrame.Size = contentFrame.Visible and UDim2.new(0, 200, 0, 420) or UDim2.new(0, 200, 0, 35)
    minBtn.Text = contentFrame.Visible and "_" or "+"
end)

-- 1. Target List
local title1 = Instance.new("TextLabel")
title1.Size = UDim2.new(1, 0, 0, 25)
title1.Text = "🎯 まっぷhub"
title1.TextColor3 = Color3.new(1, 1, 1)
title1.BackgroundTransparency = 1
title1.Parent = mainFrame

local pList = Instance.new("ScrollingFrame")
pList.Size = UDim2.new(1, -10, 0, 150)
pList.Position = UDim2.new(0, 5, 0, 5)
pList.CanvasSize = UDim2.new(0, 0, 0, 0)
pList.ScrollBarThickness = 4
pList.BackgroundTransparency = 0.8
pList.Parent = contentFrame

-- 2. Auto Status & Buttons
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 160)
statusLabel.Text = "Target: None"
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Parent = contentFrame

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1, -20, 0, 30)
autoBtn.Position = UDim2.new(0, 10, 0, 185)
autoBtn.Text = "Auto: OFF"
autoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoBtn.TextColor3 = Color3.new(1, 1, 1)
autoBtn.Parent = contentFrame
Instance.new("UICorner", autoBtn)

-- 3. Commander Section
local cmdTitle = Instance.new("TextLabel")
cmdTitle.Size = UDim2.new(1, 0, 0, 20)
cmdTitle.Position = UDim2.new(0, 0, 0, 225)
cmdTitle.Text = "🗣️ Commander"
cmdTitle.TextColor3 = Color3.new(1, 1, 1)
cmdTitle.BackgroundTransparency = 1
cmdTitle.Parent = contentFrame

local cList = Instance.new("ScrollingFrame")
cList.Size = UDim2.new(1, -10, 0, 100)
cList.Position = UDim2.new(0, 5, 0, 245)
cList.CanvasSize = UDim2.new(0, 0, 0, 0)
cList.ScrollBarThickness = 4
cList.BackgroundTransparency = 0.8
cList.Parent = contentFrame

--- ⚙️ ロジック実装 ---
local function updateButtons()
    autoBtn.Text = autoEnabled and "Auto: ON" or "Auto: OFF"
    autoBtn.BackgroundColor3 = autoEnabled and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(60, 60, 60)
end

autoBtn.MouseButton1Click:Connect(function() autoEnabled = not autoEnabled; updateButtons() end)

local function refreshLists()
    for _, s in ipairs({pList, cList}) do
        for _, b in ipairs(s:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end
    end
    local py, cy = 0, 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            -- Player Button
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -5, 0, 22)
            b.Position = UDim2.new(0, 0, 0, py)
            b.Text = plr.DisplayName
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.TextSize = 12
            b.Parent = pList
            b.MouseButton1Click:Connect(function() targetName = plr.Name; fallen = false end)
            py += 24
            
            -- Commander Button
            local cb = b:Clone()
            cb.Position = UDim2.new(0, 0, 0, cy)
            cb.Parent = cList
            cb.MouseButton1Click:Connect(function() commanderName = plr.Name; print("Commander: "..plr.Name) end)
            cy += 24
        end
    end
    pList.CanvasSize = UDim2.new(0, 0, 0, py)
    cList.CanvasSize = UDim2.new(0, 0, 0, cy)
end

Players.PlayerAdded:Connect(refreshLists)
Players.PlayerRemoving:Connect(refreshLists)
refreshLists()

-- TeleDrop Loop
task.spawn(function()
    while running do
        task.wait(TELEPORT_SPEED)
        if autoEnabled and targetName and humanoidRoot and not fallen then
            local target = Players:FindFirstChild(targetName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = target.Character.HumanoidRootPart
                if (tRoot.Position - humanoidRoot.Position).Magnitude <= FALL_DISTANCE then
                    fallen = true
                    fallToVoid(VOID_Y, FALL_TIME)
                else
                    local dPos = tRoot.Position + (tRoot.CFrame.LookVector * BACK_OFFSET)
                    humanoidRoot.CFrame = CFrame.new(dPos, tRoot.Position)
                    task.spawn(function() task.wait(DROP_DELAY); dropotakuAt(dPos) end)
                end
            end
        end
    end
end)

-- Status Update Loop (Color Management)
RunService.Heartbeat:Connect(function()
    if not autoEnabled or not targetName then return end
    local t = Players:FindFirstChild(targetName)
    if t and t.Character then
        local hum = t.Character:FindFirstChildOfClass("Humanoid")
        statusLabel.Text = "Target: " .. t.DisplayName
        if hum and hum.SeatPart then 
            statusLabel.TextColor3 = Color3.new(1, 0.2, 0.2)
            local myHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if myHum and myHum.Health > 0 then myHum:TakeDamage(999) end
        else
            statusLabel.TextColor3 = Color3.new(0, 1, 0.5)
        end
    end
    -- Self Sit Prevent
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h and h.SeatPart then h.Sit = false end
    end
end)

-- Character Handle
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRoot = char:WaitForChild("HumanoidRootPart")
    fallen = false
    char:WaitForChild("Humanoid").Died:Connect(function()
        autoEnabled = false
        updateButtons()
    end)
end)

-- Chat Commands
player.Chatted:Connect(function(msg)
    if msg:lower():sub(1,7) == "target " then
        local arg = msg:lower():sub(8)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and (p.Name:lower():find(arg) or p.DisplayName:lower():find(arg)) then
                targetName = p.Name; autoEnabled = true; updateButtons(); break
            end
        end
    end
end)

print("--- まっぷhub Loaded ---")
