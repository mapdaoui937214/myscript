local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 既存のUIを削除
if pgui:FindFirstChild("DeltaBrainrot") then pgui.DeltaBrainrot:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "DeltaBrainrot"
sg.Parent = pgui
sg.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 150, 0, 100)
main.Position = UDim2.new(0.5, -75, 0.15, 0)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true
main.Parent = sg

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0.4, 0)
btn.Position = UDim2.new(0.05, 0, 0.1, 0)
btn.Text = "START"
btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Parent = main

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0.9, 0, 0.3, 0)
minBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
minBtn.Text = "HIDE"
minBtn.Parent = main

local enabled = false
local basePos = nil

btn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        basePos = player.Character.HumanoidRootPart.CFrame
        btn.Text = "STOP"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        btn.Text = "START"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    btn.Visible = not btn.Visible
    main.BackgroundTransparency = btn.Visible and 0 or 1
    minBtn.Text = btn.Visible and "HIDE" or "SHOW"
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if enabled and basePos then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if not enabled then break end
                    if v:IsA("ClickDetector") and v.Parent and v.Parent:IsA("BasePart") then
                        -- 盗む
                        root.CFrame = v.Parent.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.2)
                        fireclickdetector(v)
                        
                        -- 基地に戻る
                        task.wait(0.1)
                        root.CFrame = basePos
                        
                        -- Sellリモート
                        for _, r in pairs(game:GetDescendants()) do
                            if r:IsA("RemoteEvent") and (r.Name:lower():find("sell") or r.Name:lower():find("claim")) then
                                r:FireServer()
                            end
                        end
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end)
