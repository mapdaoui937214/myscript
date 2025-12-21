local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--=== 状態変数 ===--
local autoEnabled = false
local targetName = nil
local character, humanoidRoot
local fallen = false
local running = true
local falling = false
local commanderName = nil

--=== 追撃・道連れ設定 ===--
local TELEPORT_SPEED = 0
local DROP_DELAY = 0
local BACK_OFFSET = -4.5
local FALL_DISTANCE = 3.5
local VOID_Y = -2000
local FALL_TIME = 0.05
local TARGET_SAFE_Y = -50
local NEAR_DISTANCE = 3.0
local NEAR_REQUIRED = 2

local multiTargets = {}
local currentIndex = 1
local multiMode = false

--=== 関数群 ===--

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
    local handle = kap:FindFirstChild("Handle")
    if not handle then return false end
    kap.Parent = workspace
    handle.Anchored = false
    handle.CanCollide = true
    handle.Velocity = Vector3.new(0, -1500, 0) -- 下方向へ叩きつける
    handle.CFrame = CFrame.new(pos)
    return true
end

local function fallToVoid(y, fallTime)
    if falling or not humanoidRoot then return end
    falling = true
    local startPos = humanoidRoot.Position
    local endPos = Vector3.new(startPos.X, y, startPos.Z)
    local startTime = tick()
    while tick()-startTime < fallTime do
        local alpha = (tick()-startTime)/fallTime
        humanoidRoot.CFrame = CFrame.new(startPos:Lerp(endPos, alpha))
        humanoidRoot.Velocity = Vector3.new(0, -1000, 0)
        task.wait()
    end
    humanoidRoot.CFrame = CFrame.new(endPos)
    falling = false
end

local function updateCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRoot = character:WaitForChild("HumanoidRootPart")
    local hum = character:WaitForChild("Humanoid")
    hum.Died:Connect(function()
        autoEnabled = false
        fallen = true
        targetName = nil
    end)
    fallen = false
end
updateCharacter()
player.CharacterAdded:Connect(updateCharacter)

--=== メインループ ===--
local function startTeleDropLoop()
    task.spawn(function()
        while running do
            RunService.Heartbeat:Wait()
            if autoEnabled and targetName and humanoidRoot then
                local target = Players:FindFirstChild(targetName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.Character.HumanoidRootPart
                    
                    -- 地上にいるなら即座に背後に張り付く
                    if targetRoot.Position.Y > TARGET_SAFE_Y then
                        fallen = false
                        local lookVec = targetRoot.CFrame.LookVector
                        local dropPos = targetRoot.Position + (lookVec*BACK_OFFSET)
                        humanoidRoot.CFrame = CFrame.new(dropPos, targetRoot.Position)
                        task.spawn(function() dropotakuAt(targetRoot.Position) end)
                    end

                    -- 近距離なら道連れ実行
                    local distance = (targetRoot.Position - humanoidRoot.Position).Magnitude
                    if distance <= FALL_DISTANCE and not fallen then
                        fallen = true
                        fallToVoid(VOID_Y, FALL_TIME)
                    end
                end
            end
        end
    end)
end
startTeleDropLoop()

--=== GUI作成 ===--
local gui = Instance.new("ScreenGui")
gui.Name = "otakuscript"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ドラッグ機能付与関数
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- 1. Main Frame
local frame1 = Instance.new("Frame")
frame1.Size = UDim2.new(0, 220, 0, 300)
frame1.Position = UDim2.new(0.75, 0, 0.3, 0)
frame1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame1.BackgroundTransparency = 0.1
frame1.Active = true
frame1.Draggable = true -- 簡易ドラッグ
frame1.Parent = gui

local title1 = Instance.new("TextLabel")
title1.Size = UDim2.new(1, 0, 0, 30)
title1.BackgroundTransparency = 1
title1.TextColor3 = Color3.fromRGB(255, 255, 255)
title1.Text = "🎯 otakuscript TeleDrop"
title1.Font = Enum.Font.SourceSansBold
title1.TextSize = 18
title1.Parent = frame1

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 200)
playerList.Position = UDim2.new(0, 0, 0, 35)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 6
playerList.BackgroundTransparency = 1
playerList.Parent = frame1

local autoButton1 = Instance.new("TextButton")
autoButton1.Size = UDim2.new(1, -10, 0, 30)
autoButton1.Position = UDim2.new(0, 5, 1, -40)
autoButton1.Text = "Auto: OFF"
autoButton1.TextColor3 = Color3.fromRGB(255, 255, 255)
autoButton1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoButton1.Font = Enum.Font.SourceSansBold
autoButton1.TextSize = 16
autoButton1.Parent = frame1

local function refreshPlayerList()
    for _, b in ipairs(playerList:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end
    local y = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.Text = plr.DisplayName
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 15
            btn.MouseButton1Click:Connect(function() 
                targetName = plr.Name
                title1.Text = "🎯 Target: " .. plr.DisplayName
                fallen = false 
            end)
            btn.Parent = playerList
            y += 28
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, y)
end
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- 2. AutoCollect Frame
local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(0, 200, 0, 120)
frame2.Position = UDim2.new(0, 100, 1, -220)
frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame2.Visible = false
frame2.Active = true
frame2.Draggable = true -- 簡易ドラッグ
frame2.Parent = gui
Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 10)

local title2 = Instance.new("TextLabel")
title2.Text = "AutoCollect Target"
title2.Size = UDim2.new(1, 0, 0, 30)
title2.BackgroundTransparency = 1
title2.TextColor3 = Color3.fromRGB(255, 255, 255)
title2.Font = Enum.Font.GothamBold
title2.TextSize = 18
title2.Parent = frame2

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "ターゲット: なし"
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 16
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame2

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 70)
toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Parent = frame2
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

-- 3. Gear Button (Custom Dragging)
local gearButton = Instance.new("ImageButton")
gearButton.Size = UDim2.new(0, 45, 0, 45)
gearButton.Position = UDim2.new(0, 40, 1, -120)
gearButton.BackgroundTransparency = 1
gearButton.Image = "rbxassetid://6034509993"
gearButton.Parent = gui
gearButton.MouseButton1Click:Connect(function() frame2.Visible = not frame2.Visible end)
makeDraggable(gearButton) -- カスタムドラッグ適用

-- ボタン更新関数
local function updateButtons()
    if autoEnabled then
        autoButton1.Text = "Auto: ON"
        autoButton1.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        autoButton1.Text = "Auto: OFF"
        autoButton1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end
end
autoButton1.MouseButton1Click:Connect(function() autoEnabled = not autoEnabled; updateButtons() end)
toggleButton.MouseButton1Click:Connect(function() autoEnabled = not autoEnabled; updateButtons() end)

-- AutoCollectクリックロジック
local targetClick = nil
mouse.Button1Down:Connect(function()
    if mouse.Target and mouse.Target:FindFirstChildOfClass("ClickDetector") then
        targetClick = mouse.Target:FindFirstChildOfClass("ClickDetector")
        statusLabel.Text = "ターゲット: " .. mouse.Target.Name
    end
end)
task.spawn(function()
    while true do
        task.wait(0.3)
        if autoEnabled and targetClick then pcall(function() fireclickdetector(targetClick) end) end
    end
end)

-- マルチターゲット & チャット制御
local function switchToNextTarget()
    if #multiTargets == 0 then return end
    currentIndex = (currentIndex % #multiTargets) + 1
    local nextTarget = Players:FindFirstChild(multiTargets[currentIndex])
    if nextTarget then
        targetName = nextTarget.Name
        title1.Text = "🎯 skip to: " .. nextTarget.DisplayName
        statusLabel.Text = "ターゲット: " .. nextTarget.DisplayName
        updateButtons()
    end
end

player.Chatted:Connect(function(msg)
    msg = msg:lower()
    if msg:sub(1, 7) == "target " then
        local args = msg:split(" ")
        table.remove(args, 1)
        if args[1] == "off" then
            multiTargets = {}
            multiMode = false
            autoEnabled = false
            updateButtons()
            return
        end
        multiTargets = {}
        for _, arg in ipairs(args) do
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and (plr.Name:lower():find(arg) or plr.DisplayName:lower():find(arg)) then
                    table.insert(multiTargets, plr.Name)
                    break
                end
            end
        end
        if #multiTargets > 0 then
            multiMode = true
            currentIndex = 1
            targetName = multiTargets[1]
            autoEnabled = true
            updateButtons()
        end
    end
    if msg == "skip" and multiMode then switchToNextTarget() end
end)

-- 4. Commander Frame
local commanderFrame = Instance.new("Frame")
commanderFrame.Size = UDim2.new(0, 220, 0, 120)
commanderFrame.Position = UDim2.new(0.75, 0, 0.65, 0)
commanderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
commanderFrame.BackgroundTransparency = 0.1
commanderFrame.Active = true
commanderFrame.Draggable = true -- 簡易ドラッグ
commanderFrame.Parent = gui

local titleC = Instance.new("TextLabel")
titleC.Size = UDim2.new(1, 0, 0, 25)
titleC.Text = "🗣️ Commander Control"
titleC.Font = Enum.Font.SourceSansBold
titleC.TextSize = 18
titleC.TextColor3 = Color3.fromRGB(255, 255, 255)
titleC.BackgroundTransparency = 1
titleC.Parent = commanderFrame

local commanderList = Instance.new("ScrollingFrame")
commanderList.Size = UDim2.new(1, 0, 0, 70)
commanderList.Position = UDim2.new(0, 0, 0, 30)
commanderList.CanvasSize = UDim2.new(0, 0, 0, 0)
commanderList.ScrollBarThickness = 6
commanderList.BackgroundTransparency = 1
commanderList.Parent = commanderFrame

local function refreshCommanderList()
    for _, b in ipairs(commanderList:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end
    local y = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.Text = plr.DisplayName
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.MouseButton1Click:Connect(function() commanderName = plr.Name end)
            btn.Parent = commanderList
            y = y + 28
        end
    end
    commanderList.CanvasSize = UDim2.new(0, 0, 0, y)
end
Players.PlayerAdded:Connect(refreshCommanderList)
Players.PlayerRemoving:Connect(refreshCommanderList)
refreshCommanderList()

local function handleCmd(plr, msg)
    if commanderName and plr.Name == commanderName then
        local text = msg:lower()
        if text == "off" then autoEnabled = false; updateButtons(); return end
        for _, t in ipairs(Players:GetPlayers()) do 
            if t ~= player and (t.Name:lower():find(text) or t.DisplayName:lower():find(text)) then 
                targetName = t.Name; autoEnabled = true; updateButtons(); break
            end 
        end 
    end
end
Players.PlayerAdded:Connect(function(plr) plr.Chatted:Connect(function(msg) handleCmd(plr, msg) end) end)
for _, plr in ipairs(Players:GetPlayers()) do plr.Chatted:Connect(function(msg) handleCmd(plr, msg) end) end

-- 座席即死対策 & 自分用座席解除
RunService.Heartbeat:Connect(function()
    if autoEnabled and targetName then
        local t = Players:FindFirstChild(targetName)
        if t and t.Character then
            local hum = t.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.SeatPart then
                local myHum = character:FindFirstChildOfClass("Humanoid")
                if myHum then myHum.Health = 0 end
            end
        end
    end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then hum.Sit = false; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)
