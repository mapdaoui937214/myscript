local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Scroll = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")
local MinBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "BringerExecutor"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.ClipsDescendants = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Player Bringer"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14

MinBtn.Parent = MainFrame
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1, 1, 1)

CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

Scroll.Parent = MainFrame
Scroll.Size = UDim2.new(1, -10, 1, -40)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 4)

local function Bring(target)
    if target and target.Character and LocalPlayer.Character then
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local tHum = target.Character:FindFirstChildOfClass("Humanoid")
        local mRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if tRoot and tHum and mRoot then
            tHum.Sit = false
            task.wait(0.05)
            tRoot.CFrame = mRoot.CFrame * CFrame.new(0, 0, -4)
            tRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end
end

local function refresh()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -5, 0, 30)
            b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            b.Text = p.DisplayName
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Parent = Scroll
            b.MouseButton1Click:Connect(function() Bring(p) end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 250), "Out", "Quad", 0.2, true)
    Scroll.Visible = not minimized
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local dragStart, startPos, dragging
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()
