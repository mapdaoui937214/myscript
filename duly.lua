local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local root = player.Character:WaitForChild("HumanoidRootPart")

if pgui:FindFirstChild("Brainrot_Extreme_V2") then pgui.Brainrot_Extreme_V2:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "Brainrot_Extreme_V2"
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0, 150, 0, 70)
f.Position = UDim2.new(0.5, -75, 0.1, 0)
f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
f.Active = true
f.Draggable = true

local b = Instance.new("TextButton", f)
b.Size = UDim2.new(1, 0, 1, 0)
b.Text = "ULTIMATE STEAL"
b.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
b.TextColor3 = Color3.new(1, 1, 1)

local en = false
local base = nil

local function autoSell()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("sell") or v.Name:lower():find("claim")) then
            v:FireServer()
        end
    end
end

local function getClosestItem()
    local closestDist = math.huge
    local target = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent and v.Parent:IsA("BasePart") then
            local dist = (root.Position - v.Parent.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                target = v
            end
        end
    end
    return target
end

b.MouseButton1Click:Connect(function()
    en = not en
    b.Text = en and "RUNNING..." or "ULTIMATE STEAL"
    b.BackgroundColor3 = en and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    if en then base = root.CFrame end
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if en and base then
            local targetDetector = getClosestItem()
            if targetDetector then
                root.CFrame = targetDetector.Parent.CFrame
                task.wait(0.02)
                fireclickdetector(targetDetector)
                root.CFrame = base
                autoSell()
                task.wait(0.03)
            end
        end
    end
end)
