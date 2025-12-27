local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local root = player.Character:WaitForChild("HumanoidRootPart")

if pgui:FindFirstChild("Brainrot_Final") then pgui.Brainrot_Final:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "Brainrot_Final"
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0, 140, 0, 70)
f.Position = UDim2.new(0.5, -70, 0.1, 0)
f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
f.Active = true
f.Draggable = true

local b = Instance.new("TextButton", f)
b.Size = UDim2.new(1, 0, 1, 0)
b.Text = "AUTO STEAL"
b.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
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
    b.Text = en and "RUNNING" or "AUTO STEAL"
    b.BackgroundColor3 = en and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    if en then base = root.CFrame end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if en and base then
            local items = {}
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("ClickDetector") and v.Parent and v.Parent:IsA("BasePart") then
                    table.insert(items, v)
                end
            end
            
            for i, v in ipairs(items) do
                if not en then break end
                root.CFrame = v.Parent.CFrame
                task.wait(0.05)
                fireclickdetector(v)
                
                if i % 3 == 0 then
                    root.CFrame = base
                    task.wait(0.1)
                    sell()
                end
                task.wait(0.02)
            end
        end
    end
end)
