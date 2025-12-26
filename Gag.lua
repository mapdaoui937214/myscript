local MyAuraRank = 10
local StealDelay = 0.5
local SearchRadius = 300
local AuraConfig = {dist = 60, color = Color3.fromRGB(255, 0, 0)}

local lplr = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local StealEnabled = false
local AuraEnabled = false

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
local TitleBar = Instance.new("Frame", MainFrame)
local TitleLabel = Instance.new("TextLabel", TitleBar)
local MinButton = Instance.new("TextButton", TitleBar)
local ContentFrame = Instance.new("Frame", MainFrame)
local StealToggle = Instance.new("TextButton", ContentFrame)
local AuraToggle = Instance.new("TextButton", ContentFrame)

MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.BorderSizePixel = 0

TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Text = "Brainrot Stealer"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14

MinButton.Size = UDim2.new(0.2, 0, 1, 0)
MinButton.Position = UDim2.new(0.8, 0, 0, 0)
MinButton.Text = "-"
MinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinButton.TextColor3 = Color3.new(1, 1, 1)
MinButton.BorderSizePixel = 0

ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1

local function styleBtn(btn, text, pos)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
end

styleBtn(StealToggle, "Auto Steal", UDim2.new(0.05, 0, 0.1, 0))
styleBtn(AuraToggle, "Freeze Aura", UDim2.new(0.05, 0, 0.55, 0))

local minimized = false
MinButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentFrame.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 150)
    MinButton.Text = minimized and "+" or "-"
end)

StealToggle.MouseButton1Click:Connect(function()
    StealEnabled = not StealEnabled
    StealToggle.Text = "Auto Steal: " .. (StealEnabled and "ON" or "OFF")
    StealToggle.BackgroundColor3 = StealEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

AuraToggle.MouseButton1Click:Connect(function()
    AuraEnabled = not AuraEnabled
    AuraToggle.Text = "Freeze Aura: " .. (AuraEnabled and "ON" or "OFF")
    AuraToggle.BackgroundColor3 = AuraEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local function getMyCollector()
    local plots = game.Workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            local o = plot:FindFirstChild("Owner")
            if o and o.Value == lplr.Name then
                return plot:FindFirstChild("Collector") or plot:FindFirstChild("TouchPart")
            end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        if StealEnabled then
            local char = lplr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local collector = getMyCollector()
            if root and collector then
                for _, obj in pairs(game.Workspace:GetDescendants()) do
                    if obj:IsA("Humanoid") and obj.Parent ~= char and not game.Players:GetPlayerFromCharacter(obj.Parent) then
                        local npcRoot = obj.Parent:FindFirstChild("HumanoidRootPart")
                        if npcRoot and (root.Position - npcRoot.Position).Magnitude < SearchRadius then
                            root.CFrame = npcRoot.CFrame
                            if firetouchinterest then firetouchinterest(root, npcRoot, 0); firetouchinterest(root, npcRoot, 1) end
                            task.wait(StealDelay)
                            root.CFrame = collector.CFrame
                            if firetouchinterest then firetouchinterest(root, collector, 0); firetouchinterest(root, collector, 1) end
                            task.wait(StealDelay)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

runService.Heartbeat:Connect(function()
    if not AuraEnabled then return end
    local char = lplr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= lplr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local tRoot = plr.Character.HumanoidRootPart
            if (root.Position - tRoot.Position).Magnitude < AuraConfig.dist then
                tRoot.Anchored = true
            else
                tRoot.Anchored = false
            end
        end
    end
end)
