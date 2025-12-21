local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Scroll = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")
local MinBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "Universal_Bringer_V3"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
Title.Text = "FORCE BRINGER FULL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16

MinBtn.Parent = MainFrame
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -70, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1, 1, 1)

CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

Scroll.Parent = MainFrame
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 5)

local function GetSword()
    local locations = {game:GetService("ReplicatedStorage"), game:GetService("Lighting"), game:GetService("StarterPack")}
    for _, loc in pairs(locations) do
        for _, obj in pairs(loc:GetDescendants()) do
            if obj:IsA("Tool") then
                obj:Clone().Parent = LocalPlayer.Backpack
            end
        end
    end
end

local function ForceAction(target)
    if not (target and target.Character and LocalPlayer.Character) then return end
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    local mRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if tRoot and tHum and mRoot then
        tHum.Sit = false
        for _, v in pairs(target.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        local connection
        local tick = 0
        connection = RunService.Heartbeat:Connect(function()
            if tick < 120 and target.Character and LocalPlayer.Character then
                tRoot.Velocity = Vector3.new(0, 0, 0)
                tRoot.CFrame = mRoot.CFrame * CFrame.new(0, -3, -2)
                tHum.Health = 0 -- Client side kill attempt
                tick = tick + 1
            else
                connection:Disconnect()
            end
        end)
    end
end

local function refresh()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    
    local getSwordBtn = Instance.new("TextButton")
    getSwordBtn.Size = UDim2.new(1, 0, 0, 35)
    getSwordBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    getSwordBtn.Text = "[ GET ALL TOOLS ]"
    getSwordBtn.TextColor3 = Color3.new(1, 1, 1)
    getSwordBtn.Parent = Scroll
    getSwordBtn.MouseButton1Click:Connect(GetSword)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 30)
            b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            b.Text = "Kill/Bring: " .. p.DisplayName
            b.TextColor3 = Color3.new(1, 0.8, 0.8)
            b.Parent = Scroll
            b.MouseButton1Click:Connect(function() ForceAction(p) end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

local min = false
MinBtn.MouseButton1Click:Connect(function()
    min = not min
    Scroll.Visible = not min
    MainFrame:TweenSize(min and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 300), "Out", "Quad", 0.2, true)
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()
