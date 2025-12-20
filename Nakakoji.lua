local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local SuccessLabel = Instance.new("TextLabel")

ScreenGui.Name = "MappHub_Final_Visual"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -80, 0.4, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 80)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "まっぷhub [Visual]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12

KillBtn.Parent = MainFrame
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
KillBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
KillBtn.Size = UDim2.new(0.8, 0, 0, 35)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Text = "READY"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", KillBtn)

SuccessLabel.Parent = ScreenGui
SuccessLabel.Size = UDim2.new(0, 400, 0, 60)
SuccessLabel.Position = UDim2.new(0.5, -200, 0.2, 0)
SuccessLabel.BackgroundTransparency = 1
SuccessLabel.Font = Enum.Font.GothamBlack
SuccessLabel.Text = "SUCCESS"
SuccessLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
SuccessLabel.TextSize = 45
SuccessLabel.TextStrokeTransparency = 0
SuccessLabel.Visible = false

local function showSuccess(name)
    print("Target: " .. name .. " - Command Sent (White Log)")
    SuccessLabel.Text = "SUCCESS: " .. name:sub(1, 15)
    SuccessLabel.Visible = true
    task.wait(1.5)
    SuccessLabel.Visible = false
end

local function getRemotes()
    local res = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("damage") or n:find("hit") or n:find("attack") or n:find("kill") then 
                table.insert(res, v) 
            end
        end
    end
    return res
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    KillBtn.Text = killMode and "SELECT" or "READY"
end)

mouse.Button1Down:Connect(function()
    if not killMode or not mouse.Target then return end
    local char = mouse.Target.Parent
    local targetPlayer = game.Players:GetPlayerFromCharacter(char) or game.Players:GetPlayerFromCharacter(char.Parent)

    if targetPlayer and targetPlayer ~= player then
        local tChar = targetPlayer.Character
        local tHrp = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        
        local remotes = getRemotes()
        for _, r in pairs(remotes) do
            pcall(function() 
                r:FireServer(tChar, math.huge) 
                r:FireServer(tHum, 100)
            end)
        end
        
        if tHrp then
            task.spawn(function()
                for i = 1, 40 do
                    tHrp.CFrame = CFrame.new(tHrp.Position.X, -10000, tHrp.Position.Z)
                    tHrp.Velocity = Vector3.new(0, -1000, 0)
                    tHrp.CanCollide = false
                    if tHum then tHum.Health = 0 end
                    task.wait(0.03)
                end
            end)
        end
        
        showSuccess(targetPlayer.Name)
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
