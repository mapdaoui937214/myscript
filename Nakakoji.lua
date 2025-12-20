local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "MappHub_Final_Sync"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 160, 0, 70)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -35)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "まっぷhub [Bring]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 11

KillBtn.Parent = MainFrame
KillBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
KillBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Text = "BRING KILL"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.TextSize = 12
Instance.new("UICorner", KillBtn)

local function syncKill(target)
    local char = player.Character
    local tChar = target.Character
    local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local myHrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if tHrp and myHrp then
        local originalPos = myHrp.CFrame
        local connection
        
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not tHrp or not myHrp or not char:FindFirstChild("Humanoid") then 
                connection:Disconnect() 
                return 
            end
            tHrp.CFrame = myHrp.CFrame
            tHrp.Velocity = Vector3.new(0, -500, 0)
            myHrp.CFrame = CFrame.new(myHrp.Position.X, -1000, myHrp.Position.Z)
        end)
        
        task.wait(1)
        if char:FindFirstChild("Humanoid") then
            char:BreakJoints()
        end
        task.wait(0.5)
        if connection then connection:Disconnect() end
    end
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    KillBtn.Text = killMode and "READY: TAP" or "BRING KILL"
end)

mouse.Button1Down:Connect(function()
    if not killMode or not mouse.Target then return end
    local char = mouse.Target.Parent
    local tPlayer = game.Players:GetPlayerFromCharacter(char) or game.Players:GetPlayerFromCharacter(char.Parent)
    
    if tPlayer and tPlayer ~= player then
        syncKill(tPlayer)
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if killMode then
        pcall(function()
            settings().Physics.AllowSleep = false
            sethiddenproperty(player, "SimulationRadius", 1e9)
            sethiddenproperty(player, "MaxSimulationRadius", 1e9)
        end)
    end
end)
