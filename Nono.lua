-- [[ FE Bypass Experimental Admin - ぬいちhp / まっぷhub ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FEBypass_Hub"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0.5, -125, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
Title.Text = "FE BYPASS EXPERIMENTAL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
Scroll.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 5)

-- 1. 物理ネットワーク所有権の悪用 (Fling/Kill)
-- 自分を高速回転させ、相手に触れることでサーバーの物理演算をバグらせて飛ばす
local function Fling(target)
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and tHrp then
        local originalPos = hrp.CFrame
        local vel = hrp.Velocity
        
        -- 高速回転による物理干渉
        local bV = Instance.new("BodyAngularVelocity")
        bV.AngularVelocity = Vector3.new(0, 99999, 0)
        bV.MaxTorque = Vector3.new(0, math.huge, 0)
        bV.P = 1250
        bV.Parent = hrp
        
        -- 相手の場所に一瞬で重なる（物理衝突を発生させる）
        for i = 1, 50 do
            hrp.CFrame = tHrp.CFrame
            RunService.Heartbeat:Wait()
        end
        
        bV:Destroy()
        hrp.CFrame = originalPos
        hrp.Velocity = vel
    end
end

-- 2. クリックテレポート (Click TP)
-- サーバーが位置修正を行う前に座標を確定させる
Mouse.Button1Down:Connect(function()
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local pos = Mouse.Hit.p
        LocalPlayer.Character:MoveTo(pos + Vector3.new(0, 3, 0))
    end
end)

-- 3. UIボタン作成
local function AddBtn(txt, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = Scroll
    b.MouseButton1Click:Connect(func)
end

AddBtn("Ctrl + Click to Teleport", function() end)
AddBtn("Fling All (Experimental)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then Fling(p) end
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        AddBtn("Fling: "..p.DisplayName, function() Fling(p) end)
    end
end
