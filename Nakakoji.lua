local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 160, 0, 80)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -40)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "まっぷhub [Void]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12

KillBtn.Parent = MainFrame
KillBtn.Size = UDim2.new(0.8, 0, 0, 40)
KillBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
KillBtn.Text = "READY"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", KillBtn)

local function fling(target)
    local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if hrp and myHrp then
        local oldPos = myHrp.CFrame
        local vel = Instance.new("BodyVelocity")
        vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        vel.Velocity = Vector3.new(0, -5000, 0)
        vel.Parent = hrp
        
        myHrp.CFrame = hrp.CFrame
        task.wait(0.1)
        myHrp.CFrame = oldPos
        task.wait(0.1)
        vel:Destroy()
    end
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.Text = killMode and "TARGETING" or "READY"
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

mouse.Button1Down:Connect(function()
    if not killMode or not mouse.Target then return end
    local char = mouse.Target.Parent
    local tPlayer = game.Players:GetPlayerFromCharacter(char) or game.Players:GetPlayerFromCharacter(char.Parent)
    
    if tPlayer and tPlayer ~= player then
        fling(tPlayer)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if killMode then
        settings().Physics.AllowSleep = false
        pcall(function()
            sethiddenproperty(player, "SimulationRadius", 1e9)
            sethiddenproperty(player, "MaxSimulationRadius", 1e9)
        end)
    end
end)
