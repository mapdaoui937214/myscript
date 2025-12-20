local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local KillBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "MappHub_Final_v2"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -80, 0.4, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 120)
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

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Position = UDim2.new(0.8, 0, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20

KillBtn.Parent = MainFrame
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
KillBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
KillBtn.Size = UDim2.new(0.8, 0, 0, 45)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Text = "OFF"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.TextSize = 14
Instance.new("UICorner", KillBtn)

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = "Scanner Idle"
StatusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
StatusLabel.TextSize = 10

local function scanRemotes(target, hum)
    local count = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("damage") or n:find("hit") or n:find("kill") or n:find("attack") or n:find("shoot") then
                pcall(function()
                    v:FireServer(target, math.huge)
                    v:FireServer(hum, 100)
                    v:FireServer(target.Head, 100)
                end)
                count = count + 1
            end
        end
    end
    return count
end

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    if not minimized then
        MainFrame:TweenSize(UDim2.new(0, 160, 0, 30), "Out", "Quad", 0.2, true)
        KillBtn.Visible = false
        StatusLabel.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 160, 0, 120), "Out", "Quad", 0.2, true)
        KillBtn.Visible = true
        StatusLabel.Visible = true
        MinimizeBtn.Text = "-"
    end
    minimized = not minimized
end)

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    KillBtn.Text = killMode and "ON (SELECT)" or "OFF"
    StatusLabel.Text = killMode and "Ready to Scan" or "Scanner Idle"
end)

mouse.Button1Down:Connect(function()
    if not killMode or not mouse.Target then return end
    
    local char = mouse.Target.Parent
    local targetPlayer = game.Players:GetPlayerFromCharacter(char) or game.Players:GetPlayerFromCharacter(char.Parent)

    if targetPlayer and targetPlayer ~= player then
        local tChar = targetPlayer.Character
        local tHum = tChar:FindFirstChild("Humanoid")
        
        local found = scanRemotes(tChar, tHum)
        StatusLabel.Text = "Exploited: " .. found .. " Remotes"

        for _, part in pairs(tChar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.new(0, -2000, 0)
                part.CFrame = CFrame.new(part.Position.X, -10000, part.Position.Z)
                part.CanCollide = false
            end
        end
        
        if tHum then tHum.Health = 0 end
        tChar:BreakJoints()
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if killMode and sethiddenproperty then
        pcall(function()
            sethiddenproperty(player, "SimulationRadius", 1e9)
            sethiddenproperty(player, "MaxSimulationRadius", 1e9)
        end)
    end
end)
