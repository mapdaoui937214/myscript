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

local TELEPORT_SPEED = 0
local DROP_DELAY = 0
local BACK_OFFSET = -4.5
local FALL_DISTANCE = 3.5
local VOID_Y = -1500
local FALL_TIME = 0.1

local multiTargets = {}
local currentIndex = 1
local multiMode = false
local lastNearTargets = {}
local lastFallTime = 0
local commanderName = nil

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
    if not kap then return end
    kap.Parent = player.Character
    local handle = kap:FindFirstChild("Handle")
    if handle then
        kap.Parent = workspace
        handle.CFrame = CFrame.new(pos)
        handle.Velocity = Vector3.new(0, -1000, 0)
        handle.CanCollide = true
    end
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

local function switchToNextTarget()
    if #multiTargets == 0 then return end
    currentIndex = (currentIndex % #multiTargets) + 1
    local nextTarget = Players:FindFirstChild(multiTargets[currentIndex])
    if nextTarget then
        targetName = nextTarget.Name
    end
end

RunService.Heartbeat:Connect(function()
    if autoEnabled and targetName and humanoidRoot and not falling then
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = target.Character.HumanoidRootPart
            local lookVec = targetRoot.CFrame.LookVector
            local dropPos = targetRoot.Position + (lookVec * BACK_OFFSET)

            humanoidRoot.CFrame = CFrame.new(dropPos, targetRoot.Position)
            dropotakuAt(targetRoot.Position)

            local distance = (targetRoot.Position - humanoidRoot.Position).Magnitude
            if distance <= FALL_DISTANCE and not fallen then
                fallen = true
                fallToVoid(VOID_Y, FALL_TIME)
            elseif targetRoot.Position.Y > -50 then
                fallen = false
            end
        end
    end
end)

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "otakuscript"
gui.ResetOnSpawn = false

local frame1 = Instance.new("Frame", gui)
frame1.Size = UDim2.new(0, 220, 0, 300)
frame1.Position = UDim2.new(0.75, 0, 0.3, 0)
frame1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame1.Active = true
frame1.Draggable = true

local title1 = Instance.new("TextLabel", frame1)
title1.Size = UDim2.new(1, 0, 0, 30)
title1.Text = "🎯 otakuscript TeleDrop"
title1.TextColor3 = Color3.new(1, 1, 1)
title1.BackgroundTransparency = 1

local playerList = Instance.new("ScrollingFrame", frame1)
playerList.Size = UDim2.new(1, 0, 0, 200)
playerList.Position = UDim2.new(0, 0, 0, 35)
playerList.BackgroundTransparency = 1

local autoButton = Instance.new("TextButton", frame1)
autoButton.Size = UDim2.new(1, -10, 0, 30)
autoButton.Position = UDim2.new(0, 5, 1, -40)
autoButton.Text = "Auto: OFF"
autoButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

autoButton.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    autoButton.Text = autoEnabled and "Auto: ON" or "Auto: OFF"
    autoButton.BackgroundColor3 = autoEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
end)

local function refreshList()
    for _, b in ipairs(playerList:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end
    local y = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton", playerList)
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.Text = plr.DisplayName
            btn.MouseButton1Click:Connect(function() targetName = plr.Name end)
            y = y + 28
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, y)
end
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()

player.Chatted:Connect(function(msg)
    local args = msg:lower():split(" ")
    if args[1] == "target" then
        if args[2] == "off" then
            multiMode = false
            autoEnabled = false
        else
            multiTargets = {}
            for i=2, #args do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower():find(args[i]) then table.insert(multiTargets, p.Name) end
                end
            end
            if #multiTargets > 0 then
                multiMode = true
                currentIndex = 1
                targetName = multiTargets[1]
                autoEnabled = true
            end
        end
    elseif args[1] == "skip" and multiMode then
        switchToNextTarget()
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)
