local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local root = player.Character:WaitForChild("HumanoidRootPart")

if pgui:FindFirstChild("InstantV5") then pgui.InstantV5:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "InstantV5"
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0, 150, 0, 70)
f.Position = UDim2.new(0.5, -75, 0.2, 0)
f.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
f.Active = true
f.Draggable = true

local b = Instance.new("TextButton", f)
b.Size = UDim2.new(1, 0, 1, 0)
b.Text = "INSTANT STEAL"
b.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
b.TextColor3 = Color3.new(1, 1, 1)

local en = false
local base = nil

local function sell()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("sell") or v.Name:lower():find("claim")) then
            v:FireServer()
        end
    end
end

b.MouseButton1Click:Connect(function()
    en = not en
    b.Text = en and "RUNNING" or "INSTANT STEAL"
    b.BackgroundColor3 = en and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(130, 0, 0)
    if en then base = root.CFrame end
end)

task.spawn(function()
    while true do
        task.wait()
        if en and base then
            local items = {}
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and v.Parent and v.Parent:IsA("BasePart") then
                    table.insert(items, v)
                end
            end
            
            for _, v in pairs(items) do
                if not en then break end
                root.CFrame = v.Parent.CFrame
                fireclickdetector(v)
                root.CFrame = base
                sell()
                task.wait(0.02)
            end
        end
    end
end)
