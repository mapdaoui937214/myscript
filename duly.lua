local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("Brainrot_FixV2") then pgui.Brainrot_FixV2:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "Brainrot_FixV2"
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0, 140, 0, 70)
f.Position = UDim2.new(0.5, -70, 0.15, 0)
f.BackgroundColor3 = Color3.new(0,0,0)
f.Active = true
f.Draggable = true

local b = Instance.new("TextButton", f)
b.Size = UDim2.new(1, 0, 1, 0)
b.Text = "START STEAL"
b.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
b.TextColor3 = Color3.new(1, 1, 1)

local en = false
local base = nil

local function doSell()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("sell") or v.Name:lower():find("claim")) then
            v:FireServer()
        end
    end
end

b.MouseButton1Click:Connect(function()
    en = not en
    b.Text = en and "RUNNING" or "START STEAL"
    b.BackgroundColor3 = en and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
    if en then 
        base = player.Character.HumanoidRootPart.CFrame 
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if en and base then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if not en then break end
                    if v:IsA("ClickDetector") and v.Parent and v.Parent:IsA("BasePart") then
                        root.CFrame = v.Parent.CFrame
                        task.wait(0.05)
                        fireclickdetector(v)
                        task.wait(0.05)
                        root.CFrame = base
                        doSell()
                        task.wait(0.1)
                    end
                end
            end
        end
    end
end)
