local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

-- GUI作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Brainrot_Hub"
ScreenGui.Parent = lp:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(50, 0, 80) -- Brainrotっぽい紫
Main.Position = UDim2.new(0.5, -110, 0.2, 0)
Main.Size = UDim2.new(0, 220, 0, 300)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "BRAINROT STEALER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
Title.Parent = Main

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 35)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MinBtn.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, -35)
Scroll.Position = UDim2.new(0, 0, 0, 35)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
Scroll.BackgroundTransparency = 1
Scroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- フラグ
local clicking = false
local stealing = false
local speedEnabled = false
local waitTime = 0.01

-- 1. 超高速クリック (Steal/Click用)
local clickBtn = Instance.new("TextButton")
clickBtn.Size = UDim2.new(0.9, 0, 0, 40)
clickBtn.Text = "AUTO CLICK: OFF"
clickBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
clickBtn.TextColor3 = Color3.new(1, 1, 1)
clickBtn.Parent = Scroll

clickBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
    clickBtn.Text = clicking and "AUTO CLICK: ON" or "AUTO CLICK: OFF"
    clickBtn.BackgroundColor3 = clicking and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
end)

-- 2. 近隣アイテム自動取得 (Steal用)
local stealBtn = Instance.new("TextButton")
stealBtn.Size = UDim2.new(0.9, 0, 0, 40)
stealBtn.Text = "AUTO STEAL: OFF"
stealBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
stealBtn.TextColor3 = Color3.new(1, 1, 1)
stealBtn.Parent = Scroll

stealBtn.MouseButton1Click:Connect(function()
    stealing = not stealing
    stealBtn.Text = stealing and "AUTO STEAL: ON" or "AUTO STEAL: OFF"
    stealBtn.BackgroundColor3 = stealing and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(80, 80, 80)
end)

-- 3. スピードブースト (逃げる/奪う用)
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.9, 0, 0, 40)
speedBtn.Text = "SPEED BOOST: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedBtn.TextColor3 = Color3.new(1, 1, 1)
speedBtn.Parent = Scroll

speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "SPEED: ON (100)" or "SPEED: OFF"
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(80, 80, 80)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = speedEnabled and 100 or 16
    end
end)

-- 連打ループ
task.spawn(function()
    while true do
        if clicking then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(9999, 9999))
            -- ツールを装備している場合も考慮
            local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
        task.wait(waitTime)
    end
end)

-- 自動回収 (Steal) ループ
task.spawn(function()
    while true do
        if stealing and lp.Character then
            -- 周囲にある触れるだけで盗める/拾えるアイテムをスキャン
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and v.Parent then
                    local part = v.Parent
                    if (part.Position - lp.Character.HumanoidRootPart.Position).Magnitude < 20 then
                        firetouchinterest(lp.Character.HumanoidRootPart, part, 0)
                        firetouchinterest(lp.Character.HumanoidRootPart, part, 1)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- 最小化
MinBtn.MouseButton1Click:Connect(function()
    local isMin = Main.Size.Y.Offset < 50
    Main:TweenSize(isMin and UDim2.new(0, 220, 0, 300) or UDim2.new(0, 220, 0, 35), "Out", "Quad", 0.2, true)
    Scroll.Visible = isMin
    MinBtn.Text = isMin and "-" or "+"
end)

-- Anti-AFK (切断防止)
lp.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new(0,0)) end)
