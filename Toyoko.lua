local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoEnabled = false
local targetName = nil
local character, humanoidRoot
local fallen = false
local running = true
local falling = false

local BACK_OFFSET = -4.5
local FALL_DISTANCE = 3.5
local VOID_Y = -2000
local FALL_TIME = 0.05
local TARGET_SAFE_Y = -50

local multiTargets = {}
local currentIndex = 1
local multiMode = false
local commanderName = nil

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
    handle.Velocity = Vector3.new(0, -1500, 0)
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

local function startTeleDropLoop()
    task.spawn(function()
        while running do
            RunService.Heartbeat:Wait()
            if autoEnabled and targetName and humanoidRoot then
                local target = Players:FindFirstChild(targetName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.Character.HumanoidRootPart
                    if targetRoot.Position.Y > TARGET_SAFE_Y then
                        fallen = false
                        local lookVec = targetRoot.CFrame.LookVector
                        local dropPos = targetRoot.Position + (lookVec*BACK_OFFSET)
                        humanoidRoot.CFrame = CFrame.new(dropPos, targetRoot.Position)
                        task.spawn(function() dropotakuAt(targetRoot.Position) end)
                    end
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

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "まっぷhub"
gui.ResetOnSpawn = false

local frame1 = Instance.new("Frame", gui)
frame1.Size = UDim2.new(0, 220, 0, 300)
frame1.Position = UDim2.new(0.75, 0, 0.3, 0)
frame1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame1.Active = true
makeDraggable(frame1)

local title1 = Instance.new("TextLabel", frame1)
title1.Size = UDim2.new(1, 0, 0, 30)
title1.Text = "🎯 まっぷhub TeleDrop"
title1.TextColor3 = Color3.new(1, 1, 1)
title1.BackgroundTransparency = 1

local playerList = Instance.new("ScrollingFrame", frame1)
playerList.Size = UDim2.new(1, 0, 0, 200)
playerList.Position = UDim2.new(0, 0, 0, 35)
playerList.BackgroundTransparency = 1

local autoButton1 = Instance.new("TextButton", frame1)
autoButton1.Size = UDim2.new(1, -10, 0, 30)
autoButton1.Position = UDim2.new(0, 5, 1, -40)
autoButton1.Text = "Auto: OFF"
autoButton1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local frame2 = Instance.new("Frame", gui)
frame2.Size = UDim2.new(0, 200, 0, 120)
frame2.Position = UDim2.new(0.1, 0, 0.5, 0)
frame2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame2.Visible = false
frame2.Active = true
makeDraggable(frame2)

local statusLabel = Instance.new("TextLabel", frame2)
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 35)
statusLabel.Text = "ターゲット: なし"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundTransparency = 1

local toggleButton = Instance.new("TextButton", frame2)
toggleButton.Size = UDim2.new(1, -20, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 70)
toggleButton.Text = "OFF"

local gearButton = Instance.new("ImageButton", gui)
gearButton.Size = UDim2.new(0, 45, 0, 45)
gearButton.Position = UDim2.new(0, 40, 1, -120)
gearButton.Image = "rbxassetid://6034509993"
gearButton.BackgroundTransparency = 1
makeDraggable(gearButton)
gearButton.MouseButton1Click:Connect(function() frame2.Visible = not frame2.Visible end)

local commanderFrame = Instance.new("Frame", gui)
commanderFrame.Size = UDim2.new(0, 220, 0, 120)
commanderFrame.Position = UDim2.new(0.75, 0, 0.65, 0)
commanderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
commanderFrame.Active = true
makeDraggable(commanderFrame)

local function updateButtons()
    local color = autoEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
    local txt = autoEnabled and "ON" or "OFF"
    autoButton1.BackgroundColor3 = color
    autoButton1.Text = "Auto: "..txt
    toggleButton.BackgroundColor3 = color
    toggleButton.Text = txt
end

autoButton1.MouseButton1Click:Connect(function() autoEnabled = not autoEnabled; updateButtons() end)
toggleButton.MouseButton1Click:Connect(function() autoEnabled = not autoEnabled; updateButtons() end)

local function refresh()
    for _, b in ipairs(playerList:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end
    local y = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.Text = plr.DisplayName
            btn.MouseButton1Click:Connect(function() targetName = plr.Name; fallen = false end)
            y = y + 28
        end
    end
end
refresh()
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)

local targetClick = nil
mouse.Button1Down:Connect(function()
    if mouse.Target and mouse.Target:FindFirstChildOfClass("ClickDetector") then
        targetClick = mouse.Target:FindFirstChildOfClass("ClickDetector")
        statusLabel.Text = "ターゲット: "..mouse.Target.Name
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if autoEnabled and targetClick then pcall(function() fireclickdetector(targetClick) end) end
    end
end)

RunService.Heartbeat:Connect(function()
    if autoEnabled and targetName then
        local t = Players:FindFirstChild(targetName)
        if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then
            if t.Character.Humanoid.SeatPart and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.Health = 0
            end
        end
    end
    if character and character:FindFirstChildOfClass("Humanoid") then
        local hum = character.Humanoid
        if hum.Sit then hum.Sit = false; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)
