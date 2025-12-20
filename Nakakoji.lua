local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local Status = Instance.new("TextLabel")

ScreenGui.Name = "MappHub_V3"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -80, 0.4, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "まっぷhub [Final]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12

KillBtn.Parent = MainFrame
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
KillBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
KillBtn.Size = UDim2.new(0.8, 0, 0, 40)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Text = "TP VOID: OFF"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.TextSize = 13
Instance.new("UICorner", KillBtn)

Status.Parent = MainFrame
Status.Position = UDim2.new(0, 0, 0.8, 0)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code
Status.Text = "Ready"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 10

local function getRemotes()
    local found = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("damage") or n:find("hit") or n:find("attack") or n:find("kill") then
                table.insert(found, v)
            end
        end
    end
    return found
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    KillBtn.Text = killMode and "SELECT TARGET" or "TP VOID: OFF"
    Status.Text = killMode and "Waiting for tap..." or "Ready"
end)

mouse.Button1Down:Connect(function()
    if not killMode or not mouse.Target then return end
    
    local char = mouse.Target.Parent
    local targetPlayer = game.Players:GetPlayerFromCharacter(char) or game.Players:GetPlayerFromCharacter(char.Parent)

    if targetPlayer and targetPlayer ~= player then
        local tChar = targetPlayer.Character
        local tHrp = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        
        Status.Text = "Target: " .. targetPlayer.Name
        print("Target: " .. targetPlayer.Name .. " を奈落へ送ります")

        local remotes = getRemotes()
        for _, r in pairs(remotes) do
            pcall(function()
                r:FireServer(tChar, math.huge)
                r:FireServer(tHum, 100)
            end)
        end

        task.spawn(function()
            for i = 1, 30 do
                if tHrp then
                    tHrp.CFrame = CFrame.new(tHrp.Position.X, -5000, tHrp.Position.Z)
                    tHrp.Velocity = Vector3.new(0, -1000, 0)
                    tHrp.CanCollide = false
                end
                if tHum then tHum.Health = 0 end
                task.wait(0.05)
            end
            Status.Text = "Sent to Void"
        end)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if killMode then
        pcall(function()
            settings().Physics.AllowSleep = false
            sethiddenproperty(player, "SimulationRadius", 1e9)
            sethiddenproperty(player, "MaxSimulationRadius", 1e9)
        end)
    end
end)
