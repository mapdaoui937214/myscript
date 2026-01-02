-- [[ Services ]]
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- [[ Constants ]]
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 既存のメニューを削除
if pgui:FindFirstChild("DebugMenu") then
    pgui.DebugMenu:Destroy()
end

-- [[ GUI Creation ]]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = pgui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 140)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "TitleBar"
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "   Doughan Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

local actionBtn = Instance.new("TextButton")
actionBtn.Name = "ActionBtn"
actionBtn.Size = UDim2.new(0, 180, 0, 50)
actionBtn.Position = UDim2.new(0.5, -90, 0.6, -10)
actionBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
actionBtn.Text = "Auto Steal: OFF"
actionBtn.TextColor3 = Color3.new(1, 1, 1)
actionBtn.TextSize = 16
actionBtn.Font = Enum.Font.GothamSemibold
actionBtn.AutoButtonColor = true
actionBtn.Parent = mainFrame

Instance.new("UICorner").Parent = actionBtn

--- [[ 高性能ドラッグ・ロジック ]] ---
local function makeDraggable(topBar, frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        -- TweenServiceを使って滑らかに動かす
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(title, mainFrame)

--- [[ 自動回収ロジック ]] ---
local active = false

local function startAutoSteal()
    while active do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            -- GetDescendantsは重いため、可能であれば範囲を絞ることを推奨
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if not active then break end
                
                if obj:IsA("ProximityPrompt") then
                    local target = obj.Parent
                    if target and target:IsA("BasePart") then
                        -- テレポート & 実行
                        root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                        -- Executor独自の関数(fireproximityprompt)を安全に呼び出し
                        if fireproximityprompt then
                            fireproximityprompt(obj)
                        end
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end

actionBtn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        actionBtn.Text = "Auto Steal: ON"
        -- グラデーションのように滑らかに色を変える
        TweenService:Create(actionBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 200, 60)}):Play()
        task.spawn(startAutoSteal)
    else
        actionBtn.Text = "Auto Steal: OFF"
        TweenService:Create(actionBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
    end
end)
