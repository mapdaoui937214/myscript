local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

ScreenGui.Name = "まっぷhub_Final_Absolute"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 160, 0, 70)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -35)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

KillBtn.Parent = MainFrame
KillBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
KillBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
KillBtn.Font = Enum.Font.GothamBlack
KillBtn.Text = "FORCE VOID"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.TextSize = 12
Instance.new("UICorner", KillBtn)

Status.Parent = MainFrame
Status.Size = UDim2.new(1, 0, 0, 20)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code
Status.Text = "READY"
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.TextSize = 10

local function getKillZones()
    local zones = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("TouchTransmitter") and v.Parent then
            local p = v.Parent
            if p.Name:lower():find("kill") or p.Name:lower():find("lava") or p.Name:lower():find("dead") then
                table.insert(zones, p)
            end
        end
    end
    return zones
end

local function absoluteKill(target)
    local char = player.Character
    local tChar = target.Character
    local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    local tHum = tChar and tChar:FindFirstChild("Humanoid")
    
    if tHrp and myHrp then
        Status.Text = "KILLING: " .. target.Name:sub(1,10)
        local oldPos = myHrp.CFrame
        local zones = getKillZones()
        
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not tHrp or not myHrp or not tHum or tHum.Health <= 0 then 
                connection:Disconnect() 
                return 
            end
            
            sethiddenproperty(player, "SimulationRadius", 1e9)
            
            myHrp.CFrame = tHrp.CFrame
            myHrp.Velocity = Vector3.new(0, 10000, 0)
            
            tHrp.Velocity = Vector3.new(0, -10000, 0)
            if #zones > 0 then
                tHrp.CFrame = zones[1].CFrame
            else
                tHrp.CFrame = CFrame.new(tHrp.Position.X, -1000, tHrp.Position.Z)
            end
        end)
        
        task.wait(2)
        if connection then connection:Disconnect() end
        myHrp.CFrame = oldPos
        Status.Text = "DONE"
    end
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    Status.Text = killMode and "SELECT TARGET" or "READY"
end)

mouse.Button1Down:Connect(function()
    if killMode and mouse.Target then
        local tChar = mouse.Target.Parent
        local tPlayer = game.Players:GetPlayerFromCharacter(tChar) or game.Players:GetPlayerFromCharacter(tChar.Parent)
        if tPlayer and tPlayer ~= player then
            absoluteKill(tPlayer)
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if killMode then
        pcall(function()
            sethiddenproperty(player, "SimulationRadius", 1e9)
            sethiddenproperty(player, "MaxSimulationRadius", 1e9)
            settings().Physics.AllowSleep = false
        end)
    end
end)
