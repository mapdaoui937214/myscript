local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Lighting = game.Lighting

local LagEvent = ReplicatedStorage:FindFirstChild("LagEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
LagEvent.Name = "LagEvent"

local function setupServer()
    local activeLags = {}
    LagEvent.OnServerEvent:Connect(function(player, active)
        activeLags[player.UserId] = active
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        if active then
            for i = 1, 20 do
                local att = Instance.new("Attachment", hrp)
                att.Name = "AuraAtt"
                local p = Instance.new("ParticleEmitter", att)
                p.Name = "AuraPart"
                p.Texture = "rbxassetid://244221448"
                p.Rate = 100
                p.Lifetime = NumberRange.new(1, 2)
            end
            task.spawn(function()
                while activeLags[player.UserId] do
                    for i = 1, 10^6 do local _ = math.sqrt(i) end
                    task.wait(0.1)
                end
            end)
        else
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "AuraAtt" then v:Destroy() end
            end
        end
    end)
end

local function setupGui(player)
    local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    sg.Name = "StressTool"
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 200, 0, 100)
    f.Position = UDim2.new(0, 20, 0.5, -50)
    f.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    local l = Instance.new("UIListLayout", f)
    
    local b1 = Instance.new("TextButton", f)
    b1.Size = UDim2.new(1, 0, 0, 45)
    b1.Text = "LAG: OFF"
    b1.BackgroundColor3 = Color3.new(0.4, 0.1, 0.1)
    
    local b2 = Instance.new("TextButton", f)
    b2.Size = UDim2.new(1, 0, 0, 45)
    b2.Text = "ANTI-LAG: OFF"
    b2.BackgroundColor3 = Color3.new(0.1, 0.3, 0.5)

    local lagOn, antiOn = false, false
    b1.MouseButton1Click:Connect(function()
        lagOn = not lagOn
        b1.Text = lagOn and "LAG: ON" or "LAG: OFF"
        LagEvent:FireServer(lagOn)
    end)

    b2.MouseButton1Click:Connect(function()
        antiOn = not antiOn
        b2.Text = antiOn and "ANTI-LAG: ON" or "ANTI-LAG: OFF"
        Lighting.GlobalShadows = not antiOn
        if player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v.Name == "AuraPart" then v.Enabled = not antiOn end
            end
        end
    end)
end

if RunService:IsServer() then
    setupServer()
    Players.PlayerAdded:Connect(setupGui)
end
