local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 古いGUIがあれば削除（重複防止）
if pgui:FindFirstChild("DebugMenu") then
    pgui.DebugMenu:Destroy()
end

-- [[ GUIの根幹作成 ]]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DebugMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- 画面いっぱいに表示可能にする
screenGui.Parent = pgui

-- メインフレーム
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 140)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, -70)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Active = true
mainFrame.Visible = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- タイトル（ドラッグ用）
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Text = "  Doughan Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame
Instance.new("UICorner").Parent = title

-- 自動回収ボタン
local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(0, 180, 0, 50)
actionBtn.Position = UDim2.new(0.5, -90, 0.6, -10)
actionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- 初期は赤(OFF)
actionBtn.Text = "Auto Steal: OFF"
actionBtn.TextColor3 = Color3.new(1, 1, 1)
actionBtn.TextSize = 18
actionBtn.ZIndex = 11
actionBtn.Parent = mainFrame
Instance.new("UICorner").Parent = actionBtn

--- [[ ドラッグ・最小化ロジック (モバイル対応) ]] ---
local dragging, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    dragging = false
end)

--- [[ 自動回収ロジック ]] ---
local active = false

local function startAutoSteal()
    while active do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            -- マップ内の全アイテムをスキャン
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if not active then break end
                
                -- ProximityPrompt(つかむボタン)を探す
                if obj:IsA("ProximityPrompt") then
                    local target = obj.Parent
                    if target and target:IsA("BasePart") then
                        -- 移動して実行
                        root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                        fireproximityprompt(obj) -- ツール（Executor）用
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
        actionBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        task.spawn(startAutoSteal)
    else
        actionBtn.Text = "Auto Steal: OFF"
        actionBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
