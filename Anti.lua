local ITEM_NAME = "otaku"
local VOID_Y = -1000
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidControl_v2"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "OTAKU VOID SYSTEM"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "STATUS: IDLE"
statusLabel.TextColor3 = Color3.new(0.6, 0.6, 0.6)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 18
statusLabel.Parent = mainFrame

local isEnabled = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -105, 0, 85)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "START"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn)

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0, 100, 0, 40)
cancelBtn.Position = UDim2.new(0.5, 5, 0, 85)
cancelBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
cancelBtn.Text = "EXIT"
cancelBtn.TextColor3 = Color3.new(1, 1, 1)
cancelBtn.Parent = mainFrame
Instance.new("UICorner", cancelBtn)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 0)
minBtn.BackgroundTransparency = 1
minBtn.Text = "_"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.TextSize = 20
minBtn.Parent = mainFrame

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 150), "Out", "Quart", 0.3, true)
    statusLabel.Visible, toggleBtn.Visible, cancelBtn.Visible = not minimized, not minimized, not minimized
end)

local function findItem()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == ITEM_NAME and (v:IsA("Tool") or v:IsA("Part")) then return v end
    end
end

local function execute(targetPart)
    if not isEnabled then return end
    local char = targetPart.Parent
    if not char:FindFirstChildOfClass("Humanoid") then char = char.Parent end
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if root and char ~= player.Character then
        local item = findItem()
        if item then
            local targetPos = item:IsA("Tool") and (item:FindFirstChild("Handle") or item).CFrame or item.CFrame
            root.CFrame = targetPos
            task.wait(0.2)
            root.CFrame = CFrame.new(root.Position.X, VOID_Y, root.Position.Z)
        end
    end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe or not isEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local ray = mouse.UnitRay
        local result = game.Workspace:Raycast(ray.Origin, ray.Direction * 1000)
        if result and result.Instance then execute(result.Instance) end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    statusLabel.Text = isEnabled and "STATUS: ACTIVE" or "STATUS: IDLE"
    statusLabel.TextColor3 = isEnabled and Color3.new(0, 1, 0) or Color3.new(0.6, 0.6, 0.6)
    toggleBtn.Text = isEnabled and "STOP" or "START"
end)

cancelBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
