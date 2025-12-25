local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Lighting = game.Lighting
local RunService = game:GetService("RunService")

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
    sg.Name = "StressToolMobile"
    sg.ResetOnSpawn = false

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 180, 0, 130)
    main.Position = UDim2.new(0, 50, 0.5, -65)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.Active = true
    main.Draggable = true

    local minBtn = Instance.new("TextButton", sg)
    minBtn.Size = UDim2.new(0, 40, 0, 40)
    minBtn.Position = UDim2.new(0, 50, 0.5, -110)
    minBtn.Text = "-"
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minBtn.TextColor3 = Color3.new(1, 1, 1)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1

    local list = Instance.new("UIListLayout", content)
    list.Padding = UDim.new(0, 5)

    local function createBtn(text, color)
        local b = Instance.new("TextButton", content)
        b.Size = UDim2.new(1, 0, 0, 60)
        b.Text = text
        b.BackgroundColor3 = color
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 14
        return b
    end

    local lagBtn = createBtn("STRESS: OFF", Color3.fromRGB(120, 30, 30))
    local antiBtn = createBtn("ANTI-LAG: OFF", Color3.fromRGB(30, 80, 120))

    minBtn.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
        minBtn.Text = main.Visible and "-" or "+"
    end)

    local lagOn, antiOn = false, false
    lagBtn.MouseButton1Click:Connect(function()
        lagOn = not lagOn
        lagBtn.Text = lagOn and "STRESS: ON" or "STRESS: OFF"
        LagEvent:FireServer(lagOn)
    end)

    antiBtn.MouseButton1Click:Connect(function()
        antiOn = not antiOn
        antiBtn.Text = antiOn and "ANTI-LAG: ON" or "ANTI-LAG: OFF"
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
    for _, p in pairs(Players:GetPlayers()) do setupGui(p) end
end
