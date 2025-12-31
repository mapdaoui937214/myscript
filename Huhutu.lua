local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

-- GUI作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PS99_Ultimate"
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Main.Position = UDim2.new(0.5, -110, 0.2, 0)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Active = true
Main.Draggable = true -- モバイルドラッグ有効

-- タイトル
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "PS99 ULTIMATE HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(80, 40, 200)
Title.Parent = Main

-- 最小化ボタン
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 35)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
MinBtn.Parent = Main

-- スクロールエリア
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, -35)
Scroll.Position = UDim2.new(0, 0, 0, 35)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
Scroll.BackgroundTransparency = 1
Scroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 共通ボタン作成関数
local function CreateButton(name, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = Scroll
    return btn
end

local clickBtn = CreateButton("AUTO CLICK", Color3.fromRGB(60, 60, 60))
local followBtn = CreateButton("AUTO FOLLOW", Color3.fromRGB(60, 60, 60))
local hatchBtn = CreateButton("AUTO HATCH", Color3.fromRGB(60, 60, 60))

-- スライダー (クリック速度用)
local SLabel = Instance.new("TextLabel")
SLabel.Size = UDim2.new(0.9, 0, 0, 20)
SLabel.Text = "Click Speed: 0.1s"
SLabel.TextColor3 = Color3.new(1, 1, 1)
SLabel.BackgroundTransparency = 1
SLabel.Parent = Scroll

local SBack = Instance.new("Frame")
SBack.Size = UDim2.new(0.8, 0, 0, 10)
SBack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SBack.Parent = Scroll

local SBtn = Instance.new("TextButton")
SBtn.Size = UDim2.new(0, 20, 0, 20)
SBtn.Position = UDim2.new(0.1, 0, -0.5, 0)
SBtn.Text = ""
SBtn.Parent = SBack

-- テレポート用セクション
local TTitle = Instance.new("TextLabel")
TTitle.Size = UDim2.new(1, 0, 0, 30)
TTitle.Text = "--- TELEPORT TO EGG ---"
TTitle.TextColor3 = Color3.new(1, 1, 0)
TTitle.BackgroundTransparency = 1
TTitle.Parent = Scroll

local function CreateTP(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = Scroll
    btn.MouseButton1Click:Connect(function()
        if lp.Character then 
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end)
end

-- 座標は自身の進捗に合わせて調整してください
CreateTP("Spawn Eggs", Vector3.new(185, 8, 15))
CreateTP("Desert Eggs", Vector3.new(500, 8, 15))
CreateTP("Snow Eggs", Vector3.new(1200, 8, 15))

-- ロジック変数
local clicking = false
local following = false
local hatching = false
local waitTime = 0.1

-- ボタン機能
clickBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
    clickBtn.Text = clicking and "AUTO CLICK: ON" or "AUTO CLICK: OFF"
    clickBtn.BackgroundColor3 = clicking and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

followBtn.MouseButton1Click:Connect(function()
    following = not following
    followBtn.Text = following and "FOLLOW: ON" or "FOLLOW: OFF"
    followBtn.BackgroundColor3 = following and Color3.fromRGB(0, 120, 180) or Color3.fromRGB(60, 60, 60)
end)

hatchBtn.MouseButton1Click:Connect(function()
    hatching = not hatching
    hatchBtn.Text = hatching and "HATCH: ON" or "HATCH: OFF"
    hatchBtn.BackgroundColor3 = hatching and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(60, 60, 60)
end)

-- スライダーロジック (タッチ対応)
local drag = false
SBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
UserInputService.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local p = math.clamp((i.Position.X - SBack.AbsolutePosition.X) / SBack.AbsoluteSize.X, 0, 1)
        SBtn.Position = UDim2.new(p, -10, -0.5, 0)
        waitTime = 0.01 + (p * 0.5)
        SLabel.Text = string.format("Click Speed: %.2fs", waitTime)
    end
end)

-- 最小化ロジック
MinBtn.MouseButton1Click:Connect(function()
    local isMin = Main.Size.Y.Offset < 50
    Main:TweenSize(isMin and UDim2.new(0, 220, 0, 320) or UDim2.new(0, 220, 0, 35), "Out", "Quad", 0.2, true)
    Scroll.Visible = isMin
    MinBtn.Text = isMin and "-" or "+"
end)

-- メインループ
task.spawn(function()
    while true do
        if clicking then VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(9999, 9999)) end
        if hatching then VirtualUser:TypeKey("e") end
        task.wait(waitTime)
    end
end)

task.spawn(function()
    while true do
        if following and lp.Character then
            local root = lp.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetChildren()) do
                if (v.Name:find("Coin") or v.Name:find("Loot")) and v:IsA("BasePart") then
                    if (v.Position - root.Position).Magnitude < 50 then
                        lp.Character.Humanoid:MoveTo(v.Position)
                        break
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- Anti-AFK
lp.Idled:Connect(function() VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame); task.wait(1); VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
