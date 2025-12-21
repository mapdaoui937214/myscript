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
local commanderName = nil

--=== 強制心中・奈落特化設定 ===--
local BACK_OFFSET = -4.0   -- さらに密着
local FALL_DISTANCE = 4.5  -- 判定を広く
local VOID_Y = -5000       -- 限界まで深く
local KILL_VELOCITY = Vector3.new(0, -3000, 0) -- 叩きつけ速度倍増
local TARGET_SAFE_Y = -60

local multiTargets = {}
local currentIndex = 1
local multiMode = false

local function getotaku()
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("otaku") then return tool end
    end
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("otaku") then return tool end
    end
    return nil
end

local function kamikazeDrop(pos)
    local tool = getotaku()
    if not tool then return end
    tool.Parent = player.Character
    local handle = tool:FindFirstChild("Handle")
    if handle then
        tool.Parent = workspace
        handle.CFrame = CFrame.new(pos)
        handle.CanCollide = true
        handle.Velocity = KILL_VELOCITY -- 相手を奈落へ固定する力
        handle.RotVelocity = Vector3.new(0, 50, 0)
    end
end

local function updateChar()
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRoot = character:WaitForChild("HumanoidRootPart")
    local hum = character:WaitForChild("Humanoid")
    hum.Died:Connect(function() fallen = true end)
    fallen = false
end
updateChar()
player.CharacterAdded:Connect(updateChar)

-- 🎯 必殺心中ループ
RunService.Heartbeat:Connect(function()
    if not autoEnabled or not targetName or not humanoidRoot then return end
    
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local targetRoot = target.Character.HumanoidRootPart
    
    -- 相手が地上付近にいるなら即座に背後へ
    if targetRoot.Position.Y > TARGET_SAFE_Y then
        fallen = false
        local dropPos = targetRoot.Position + (targetRoot.CFrame.LookVector * BACK_OFFSET)
        humanoidRoot.CFrame = CFrame.new(dropPos, targetRoot.Position)
        kamikazeDrop(targetRoot.Position)
    end

    -- 距離が近い＝道連れ成功。自分もろとも加速して逃がさない。
    local dist = (targetRoot.Position - humanoidRoot.Position).Magnitude
    if dist <= FALL_DISTANCE then
        humanoidRoot.Velocity = KILL_VELOCITY
        if not fallen then
            fallen = true
            -- 0.5秒間、強制的に奈落へ押し込み続ける
            task.spawn(function()
                local start = tick()
                while tick() - start < 0.5 do
                    if humanoidRoot then 
                        humanoidRoot.Velocity = KILL_VELOCITY 
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
end)

--=== GUI & ドラッグ設定 ===--
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "otakuscript"
gui.ResetOnSpawn = false

local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
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

-- 各フレームの作成
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 250); frame.Position = UDim2.new(0.8, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); frame.Active = true; frame.Draggable = true
makeDraggable(frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30); title.Text = "🔥 otakuscript 必殺心中"; title.TextColor3 = Color3.new(1, 0, 0)
title.BackgroundTransparency = 1; title.Font = Enum.Font.SourceSansBold

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 0, 170); scroll.Position = UDim2.new(0, 0, 0, 35); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,0,0)

local function refresh()
    for _, v in ipairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local y = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local b = Instance.new("TextButton", scroll)
            b.Size = UDim2.new(1, -10, 0, 25); b.Position = UDim2.new(0, 5, 0, y)
            b.Text = p.DisplayName; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1, 1, 1)
            b.MouseButton1Click:Connect(function() targetName = p.Name; fallen = false end)
            y = y + 28
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end
refresh(); Players.PlayerAdded:Connect(refresh); Players.PlayerRemoving:Connect(refresh)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -10, 0, 30); btn.Position = UDim2.new(0, 5, 1, -40); btn.Text = "自爆開始: OFF"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); btn.TextColor3 = Color3.new(1, 1, 1)
btn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    btn.Text = autoEnabled and "自爆開始: ON" or "自爆開始: OFF"
    btn.BackgroundColor3 = autoEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 椅子対策 & 強制立ち上がり
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Sit then hum.Sit = false end
    end
end)
