local player = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

if coreGui:FindFirstChild("MapBrainrotHub") then
    coreGui.MapBrainrotHub:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "MapBrainrotHub"
sg.Parent = coreGui
sg.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
titleBar.Text = "  MAP BRAINROT HUB"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 14
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local dragDrop = {}
local dragging, dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = mainFrame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 220, 0, 40) or UDim2.new(0, 220, 0, 160)
    tweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
end)

local tpBtn = Instance.new("TextButton")
tpBtn.Name = "TeleportButton"
tpBtn.Size = UDim2.new(0, 180, 0, 45)
tpBtn.Position = UDim2.new(0.5, -90, 0, 60)
tpBtn.Text = "STEAL & RETURN"
tpBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 16
tpBtn.Parent = mainFrame
Instance.new("UICorner", tpBtn)

tpBtn.MouseButton1Click:Connect(function()
    local base = game.Workspace:FindFirstChild("BasePart")
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if base then
            char.HumanoidRootPart.CFrame = base.CFrame + Vector3.new(0, 5, 0)
        else
            local newBase = Instance.new("Part")
            newBase.Name = "BasePart"
            newBase.Size = Vector3.new(10, 1, 10)
            newBase.Position = char.HumanoidRootPart.Position
            newBase.Anchored = true
            newBase.Parent = game.Workspace
            print("Base Created at Current Position")
        end
    end
end)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0, 20)
info.Position = UDim2.new(0, 0, 1, -25)
info.BackgroundTransparency = 1
info.Text = "v1.0.0 | Mobile Ready"
info.TextColor3 = Color3.fromRGB(100, 100, 100)
info.Font = Enum.Font.SourceSansItalic
info.TextSize = 12
info.Parent = mainFrame
