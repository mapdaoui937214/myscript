--[[
    Name: ぬいちhp
    Version: 1.2
    Features: Infinite HP, Void Rescue, Anti-Die, Mobile Support, Minimizable
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui")
sg.Name = "NuichiHP_UI"
sg.ResetOnSpawn = false
sg.Parent = pgui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = sg
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "  ぬいちhp"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Parent = frame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 180, 0, 50)
toggle.Position = UDim2.new(0.5, -90, 0, 65)
toggle.Text = "完全無敵: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamMedium
toggle.TextSize = 14
toggle.Parent = frame
Instance.new("UICorner", toggle)

local godMode = false
local isMinimized = false
local lastSafePos = Vector3.new(0, 50, 0)

RunService.Heartbeat:Connect(function()
    if godMode then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp then
                hum.Health = hum.MaxHealth
                
                local voidThreshold = game.Workspace.FallenPartsDestroyHeight + 15
                if hrp.Position.Y < voidThreshold then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.CFrame = CFrame.new(lastSafePos + Vector3.new(0, 5, 0))
                else
                    if hum.FloorMaterial ~= Enum.Material.Air then
                        lastSafePos = hrp.Position
                    end
                end
                
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        end
    end
end)

toggle.MouseButton1Click:Connect(function()
    godMode = not godMode
    toggle.Text = godMode and "完全無敵: ON" or "完全無敵: OFF"
    toggle.BackgroundColor3 = godMode and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(70, 70, 70)
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, not godMode) end
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    frame:TweenSize(isMinimized and UDim2.new(0, 220, 0, 40) or UDim2.new(0, 220, 0, 140), "Out", "Quart", 0.3, true)
    toggle.Visible = not isMinimized
end)

closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
